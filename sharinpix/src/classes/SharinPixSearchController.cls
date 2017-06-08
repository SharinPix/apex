public with sharing class SharinPixSearchController {
    private static Client clientInstance = Client.getInstance();
    private static final Integer TOKEN_SIZE = Integer.valueOf(Label.Token_Size);

    @AuraEnabled
    public static Map<String, Object> generateUrlAndTokens(Id reportId, List<Object> reportParameters, String tagOperator, List<String> tagNames) {
        List<String> tokens = new List<String>();
        Map<String, Object> response = new Map<String, Object> {
            'baseUrl' => clientInstance.getAppHost() + '?token=' + clientInstance.token(new Map<String, Object> { 'path' => '/search?search_bar=false' }),
            'tokens' => tokens
        };

        List<String> albumIds;
        try {
            albumIds = getAlbumIdsFromReport(reportId, reportParameters);
        } catch (Exception e) {
            return new Map<String, String> { 'error' => e.getMessage() };
        }
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
                /*
                // Code when report parameters passed in next version
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
                results = Reports.ReportManager.runReport(reportId, reportMetadata, true);*/
            } else {
                results = Reports.ReportManager.runReport(reportId, true);
            }
            Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');

            List<String> albumIds = new List<String>();
            Integer columnIndex = -1;
            List<Reports.ReportDetailRow> detailRows = factDetails.getRows();
            List<Reports.ReportDataCell> dataCells;

            if (detailRows.isEmpty()) {
                return albumIds;
            }

            Reports.ReportDetailRow firstRow = detailRows[0];
            dataCells = firstRow.getDataCells();
            for (Integer i = 0; i < dataCells.size() && columnIndex == -1; i++) {
                if (dataCells[i].getLabel() InstanceOf ID) {
                    columnIndex = i;
                }
            }
            if (columnIndex == -1) {
                throw new SharinPixException('Report contains no ID column.');
            }

            for (Reports.ReportDetailRow detailRow : detailRows) {
                dataCells = detailRow.getDataCells();
                albumIds.add((String)dataCells[columnIndex].getValue());
            }

            return albumIds;
        } catch (SharinPixException spe) {
            throw spe;
        } catch (Exception e) {
            throw new SharinPixException('Error in generating report - ' + e.getCause() + '[' + e.getLineNumber() + ']: ' + e.getMessage());
        }
    }

    @TestVisible
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