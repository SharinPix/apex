public with sharing class SharinPixSearchController {
    private static Client clientInstance = Client.getInstance();
    private static String baseUrl = 'https://app.sharinpix.com/search?search_bar=false&token=';
    //private static Client clientInstance = new Client('sharinpix://34edb5d0-4dbf-47e5-a11d-9ddc34a285da:qpk0XHmupySkCsIfPXw1QXsSyNm8i7tu-baS7JzmZSdufQQ@azhar.ngrok.io/api/v1'); // secret !
    //private static String baseUrl = 'https://azhar.ngrok.io/search?search_bar=false&token=';
    private static final Integer TOKEN_SIZE = 25;

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
        Utils u = new Utils(clientInstance);
        List<Object> allTags;
        if (!Test.isRunningTest()) {
            allTags = u.getOrgTags();
        } else {
            allTags = new List<Object> { new Map<String, Object> { 'name' => 'Tag 1' } };
        }
        List<String> tagNames = new List<String>();
        for (Object o : allTags) {
            tagNames.add((String)((Map<String, Object>)o).get('name'));
        }
        return tagNames;
    }

    @AuraEnabled
    public static Map<String, Object> generateUrlAndTokens(Id reportId, List<Object> reportParameters, String tagOperator, List<String> tagNames) {
        List<String> tokens = new List<String>();
        Map<String, Object> response = new Map<String, Object> {
            'baseUrl' => baseUrl,
            'tokens' => tokens
        };

        List<String> albumIds = getAlbumIdsFromReport(reportId, reportParameters);
        Map<String, String> query;
        String queryStr;

        for (Integer i = 0; i < albumIds.size(); i += TOKEN_SIZE) {
            queryStr = generateQueryString(slice(albumIds, i, i + TOKEN_SIZE), tagNames, tagOperator);
            query = new Map<String, String> { 'q' => queryStr };
            tokens.add(clientInstance.token(query));
        }

        return response;
    }

    private static List<String> getAlbumIdsFromReport(Id reportId, List<Object> reportParameters) {
        try {
            Reports.ReportResults results;
            if (reportParameters != null && reportParameters.size() != 0) {
                /*Reports.ReportDescribeResult reportDescribe = Reports.ReportManager.describeReport(reportId);
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
                results = Reports.ReportManager.runReport(reportId, reportMetadata, true);*/
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