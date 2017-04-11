public with sharing class ImageSearchController {
    public Id reportId { get; set; }

    public List<Report> allReports { get; private set; }
    public Map<String, List<Report>> reportFolders { get; private set; }

    public String parameters { get; private set; }
    public Boolean queryRendered { get; private set; }
    public Boolean resultsRendered { get; private set; }

    public Integer pageSize { get; private set; }
    public Integer page { get; set; }
    public Integer totalSize { get; private set; }

    public String allTags { get; set; }
    public String tagFilter { get; private set; }
    public List<String> selectedTags { get; private set; }

    public String jsonParams { get; set; }

    private Client clientInstance = Client.getInstance();

    private List<Id> albumIds;

    public ImageSearchController() {
        queryRendered = true;
        resultsRendered = false;
        if (String.isNotBlank(ApexPages.currentPage().getParameters().get('reportId'))) {
            reportId = ApexPages.currentPage().getParameters().get('reportId');
            queryRendered = false;
            jsonParams = '{"reportId":"' + reportId + '","tagFilter":"","selectedTags":[]}';
            search();
        }
        allReports = [SELECT Id, Name, FolderName FROM Report WHERE Format = 'Tabular' ORDER BY FolderName, Name];
        String currentFolderName = null, previousFolderName = null;
        reportFolders = new Map<String, List<Report>>();
        for (Report rep : allReports) {
            currentFolderName = rep.FolderName;
            if (currentFolderName != previousFolderName) {
                reportFolders.put(currentFolderName, new List<Report> { rep });
            } else {
                reportFolders.get(currentFolderName).add(rep);
            }
            previousFolderName = currentFolderName;
        }
        List<String> allTagsUnsorted = fetchAllTags();
        allTagsUnsorted.sort();
        allTags = JSON.serialize(allTagsUnsorted);
    }

    public void search() {
        reportId = (Id)((Map<String, Object>)JSON.deserializeUntyped(jsonParams)).get('reportId');
        tagFilter = (String)((Map<String, Object>)JSON.deserializeUntyped(jsonParams)).get('tagFilter');
        List<Object> selectedTagsObj = (List<Object>)((Map<String, Object>)JSON.deserializeUntyped(jsonParams)).get('selectedTags');
        selectedTags = new List<String>();
        for (Object o : selectedTagsObj) {
            selectedTags.add(String.valueOf(o));
        }
        if (String.isNotEmpty(reportId)) {
            albumIds = getIdsFromReport(reportId);
            if (albumIds != null) {
                startPagination();
            } else {
                resultsRendered = false;
            }
        } else {
            resultsRendered = false;
        }
    }

    private List<Id> getIdsFromReport(Id reportId) {
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
        Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');
        List<Id> albumIds = new List<Id>();
        Integer idColumnIndex = -1;

        if (factDetails.getRows().size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Specified report (' + reportId + ') contains no rows.'));
            return null;
        }

        Reports.ReportDetailRow firstRow = factDetails.getRows()[0];
        List<Reports.ReportDataCell> dataCells = firstRow.getDataCells();
        for (Integer i = 0; i < dataCells.size() && idColumnIndex == -1; i++) {
            if (dataCells[i].getLabel() InstanceOf ID) {
                idColumnIndex = i;
            }
        }

        if (idColumnIndex == -1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Specified report (' + reportId + ') contains no ID column.'));
            return null;
        }

        for (Reports.ReportDetailRow detailRow : factDetails.getRows()) {
            dataCells = detailRow.getDataCells();
            albumIds.add((Id)detailRow.getDataCells()[idColumnIndex].getValue());
        }
        return albumIds;
    }

    private void startPagination() {
        page = 1;
        if (ApexPages.currentPage().getParameters().get('pageSize') != null) {
            pageSize = Integer.valueOf(ApexPages.currentPage().getParameters().get('pageSize'));
        } else {
            pageSize = 25;
        }
        totalSize = albumIds.size();
        paginate();
    }

    public void paginate() {
        if (albumIds != null) {
            Integer startIndex = (page-1) * pageSize, endIndex = page * pageSize;
            Map<String, String> params = new Map<String, String> {
                'path' => '/search?search_bar=false&q=' + generateQueryToken(slice(albumIds, startIndex, endIndex))
            };
            parameters = JSON.serialize(params);
            resultsRendered = true;
        }
    }

    private String generateQueryToken(List<Id> albumIds) {
        String tags = '';
        if (selectedTags != null && selectedTags.size() != 0) {
            String tagOp = tagFilter == 'allTags' ? 'AND' : tagFilter == 'anyTag' ? 'OR' : '';
            tags = '"' + String.join(selectedTags, '" ' + tagOp + ' "') + '"';
        }

        String albums = '"' + String.join(albumIds, '" "') + '"';

        String q;
        if (tags != '') {
            q = 'tags:(+(' + albums + ') +(' + tags + '))';
        } else {
            q = albums;
        }
        Map<String, String> query = new Map<String, String> {
            'q' => q
        };
        return clientInstance.token(query);
    }

    private List<Id> slice(List<Id> original, Integer startIndex, Integer endIndex) {
        List<Id> sliced = new List<Id>();
        for (Integer i = startIndex; i < endIndex && i < original.size(); i++) {
            sliced.add(original[i]);
        }
        return sliced;
    }

    private List<String> fetchAllTags() {
        Map<String, Object> params = new Map<String, Object> { 'admin' => true };
        Integer page = 1;
        List<Object> tagsPage = new List<Object>();
        List<Object> allTagObj = new List<Object>();
        do {
            tagsPage = (List<Object>)clientInstance.get('/tags' + '?page=' + page++, params);
            allTagObj.addAll(tagsPage);
        } while (tagsPage.size() != 0);
        List<String> tagNames = new List<String>();
        for (Object o : allTagObj) {
            tagNames.add((String)((Map<String, Object>)o).get('name'));
        }
        return tagNames;
    }
}