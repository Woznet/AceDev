select (
        select 1 ID,
            'replace_me' LinkDocumentID,
            100002 DocumentTypeID,
            1 VaultID
        from PO Document
        where Document.PO_ID = ImporterDataSet.PO_ID for xml auto,
            type,
            elements
    ),
    (
        select 1 ID,
            'PO' FilePath,
            1 Sequence
        from PO DocumentFiles
        where DocumentFiles.PO_ID = ImporterDataSet.PO_ID for xml auto,
            type,
            elements
    ),
    (
        select 100003 IndexTypeID,
            POComments IndexValue
        from PO DocumentIndex
        where DocumentIndex.PO_ID = ImporterDataSet.PO_ID for xml auto,
            type,
            elements
    ),
    (
        select 100001 IndexTypeID,
            VendorCode IndexValue
        from AP_VENDOR DocumentIndex
        where DocumentIndex.AP_VENDOR_KEY = ImporterDataSet.AP_VENDOR_KEY for xml auto,
            type,
            elements
    ),
    (
        select 100018 IndexTypeID,
            Vendor_Name IndexValue
        from AP_VENDOR DocumentIndex
        where DocumentIndex.AP_VENDOR_KEY = ImporterDataSet.AP_VENDOR_KEY for xml auto,
            type,
            elements
    ),
    (
        select 100062 IndexTypeID,
            cast(DatePosted as date) IndexValue
        from PO DocumentIndex
        where DocumentIndex.PO_ID = ImporterDataSet.PO_ID for xml auto,
            type,
            elements
    ),
    (
        select 100147 IndexTypeID,
            GrandTotal IndexValue
        from PO DocumentIndex
        where DocumentIndex.PO_ID = ImporterDataSet.PO_ID for xml auto,
            type,
            elements
    ),
    (
        select 100011 IndexTypeID,
            JobID IndexValue
        from POJobs DocumentIndex
        where DocumentIndex.POJobs_ID = ImporterDataSet.POJobs_ID for xml auto,
            type,
            elements
    ),
    (
        select 100051 IndexTypeID,
            Name IndexValue
        from Jobs DocumentIndex
        where DocumentIndex.JobNumber = (
                select j.JobID
                from POJobs j
                where j.POJobs_ID = ImporterDataSet.POJobs_ID
            ) for xml auto,
            type,
            elements
    )
from PO ImporterDataSet
order by PO_ID for xml auto,
    type