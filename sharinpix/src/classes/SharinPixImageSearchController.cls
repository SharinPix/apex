public with sharing class SharinPixImageSearchController { // to global if needed
    //static Client clientInstance = new Client('sharinpix://34edb5d0-4dbf-47e5-a11d-9ddc34a285da:qpk0XHmupySkCsIfPXw1QXsSyNm8i7tu-baS7JzmZSdufQQ@azhar.ngrok.io/api/v1'); // Remove !
    //static Client clientInstance = new Client('sharinpix://c655c99a-ea8d-4ffe-a772-78707668f89d:hNKW9Mx3gKdsSCcn-fmCp_hEOY5-BCOVoZ3w7rXfpwmZ3kw@scpix-pr-1224.herokuapp.com/api/v1'); // Remove !
    static sharinpix.Client clientInstance = sharinpix.Client.getInstance();

    @AuraEnabled
    public static Map<String, List<Report>> getReports() {
        List<Report> allReports = [SELECT Id, Name, FolderName FROM Report WHERE Format = 'Tabular' ORDER BY FolderName, Name];
        String currentFolderName = null, previousFolderName = null;
        Map<String, List<Report>> reportFolders = new Map<String, List<Report>>();
        for (Report rep : allReports) {
            currentFolderName = rep.FolderName;
            if (currentFolderName != previousFolderName) {
                reportFolders.put(currentFolderName, new List<Report> { rep });
            } else {
                reportFolders.get(currentFolderName).add(rep);
            }
            previousFolderName = currentFolderName;
        }
        return reportFolders;
    }

    @AuraEnabled
    public static List<String> getAllTags() {
        Map<String, Object> params = new Map<String, Object> { 'admin' => true };
        Integer page = 1;
        List<Object> tagsPage = new List<Object>();
        List<Object> allTags = new List<Object>();
        do {
            tagsPage = (List<Object>)clientInstance.get('/tags' + '?page=' + page++, params);
            allTags.addAll(tagsPage);
        } while (tagsPage.size() != 0);
        List<String> tagNames = new List<String>();
        for (Object o : allTags) {
            tagNames.add((String)((Map<String, Object>)o).get('name'));
        }
        return tagNames;
    }

    @AuraEnabled
    public static Map<String, Object> generateUrlAndTokens(Id reportId, List<Object> reportParameters, String tagOperator, List<String> tagNames, Integer pageSize) {
        System.debug('reportId : ' + reportId);
        System.debug('reportParameters : ' + reportParameters);
        System.debug('tagOperator : ' + tagOperator);
        System.debug('tagNames : ' + tagNames);
        System.debug('pageSize : ' + pageSize);
        pageSize = Integer.valueOf(pageSize); // WTF ??

        List<String> tokens = new List<String>();
        Map<String, Object> response = new Map<String, Object> {
            'baseUrl' => 'https://app.sharinpix.com/search?search_bar=false&token=',
            'tokens' => tokens
        };

        List<String> albumIds = getAlbumIdsFromReport(reportId, reportParameters);
        if (pageSize == 0) {
            pageSize = albumIds.size();
        }
        Map<String, String> query;
        String queryStr;
        for (Integer i = 0; i < i + pageSize && i < albumIds.size(); i += pageSize) {
            queryStr = generateQueryString(slice(albumIds, i, Math.min(i + pageSize, albumIds.size())), tagNames, tagOperator);
            query = new Map<String, String> { 'q' => queryStr };
            tokens.add(clientInstance.token(query));
        }
        System.debug('response: ' + JSON.serialize(response));
        return response;
    }

    private static List<String> getAlbumIdsFromReport(Id reportId, List<Object> reportParameters) {
        try {
            System.debug('reportParameters : ' + reportParameters);
            System.debug('reportParameters.size() : ' + reportParameters.size());
            Reports.ReportResults results;
            if (reportParameters != null && reportParameters.size() != 0) {
                Reports.ReportDescribeResult reportDescribe = Reports.ReportManager.describeReport(reportId);
                Reports.ReportMetadata reportMetadata = reportDescribe.getReportMetadata();
                Reports.ReportFilter filter;
                String reportParameter;
                for (Integer i = 0; i < reportParameters.size(); i++) {
                    filter = reportMetadata.getReportFilters()[i];
                    reportParameter = String.valueOf(reportParameters[i]);
                    if (reportParameter.trim() InstanceOf Id) {
                        reportParameter = (Id)reportParameter.trim();
                    }
                    filter.setValue(reportParameter);
                }
                results = Reports.ReportManager.runReport(reportId, reportMetadata, true);
            } else {
                results = Reports.ReportManager.runReport(reportId, true);
            }
            Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');

            List<String> albumIds = new List<String>();
            Integer columnIndex = 0;
            List<Reports.ReportDataCell> dataCells;

            for (Reports.ReportDetailRow detailRow : factDetails.getRows()) {
                dataCells = detailRow.getDataCells();
                albumIds.add((String)dataCells[columnIndex].getValue());
            }
            return albumIds;
        } catch (Exception e) {
            throw new SharinPixException('Error in generating report - ' + e.getCause() + '[' + e.getLineNumber() + ']: ' + e.getMessage());
        }
    }

    private static String generateQueryString(List<String> albumIds, List<String> tagNames, String tagOperator) {
        if (albumIds == null) albumIds = new List<String>();
        if (tagNames == null) tagNames = new List<String>();
        if (albumIds.size() == 0) return '';
        if (tagOperator == null || tagOperator == '') tagOperator = 'OR';
        if (tagOperator != 'AND' && tagOperator != 'OR') throw new SharinPixException('Invalid parameters.');

        String albumIdsString = '';
        albumIdsString = '"' + String.join(albumIds, '" "') + '"';
        if (tagNames.size() == 0) return albumIdsString;

        String tagNamesString = '"' + String.join(tagNames, '" ' + tagOperator + ' "') + '"';
        return 'tags:(+(' + albumIdsString + ') +(' + tagNamesString + '))';
    }

    private static List<String> slice(List<String> original, Integer startIndex, Integer endIndex) {
        if (startIndex == 0 && endIndex == original.size()) {
            return original;
        }
        List<String> sliced = new List<String>();
        for (Integer i = startIndex; i < endIndex && i < original.size(); i++) {
            sliced.add(original[i]);
        }
        return sliced;
    }
}