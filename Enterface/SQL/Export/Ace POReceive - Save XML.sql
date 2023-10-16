select (
        select 1 ID,
            'replace_me' LinkDocumentID,
            100005 DocumentTypeID,
            1 VaultID
        from POReceive Document
        where Document.POReceive_ID = ImporterDataSet.POReceive_ID for xml auto,
            type,
            elements
    ),
    (
        select 1 ID,
            'POReceive' FilePath,
            1 Sequence
        from POReceive DocumentFiles
        where DocumentFiles.POReceive_ID = ImporterDataSet.POReceive_ID for xml auto,
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
        select 100003 IndexTypeID,
            PO_ID IndexValue
        from POReceive DocumentIndex
        where DocumentIndex.POReceive_ID = ImporterDataSet.POReceive_ID for xml auto,
            type,
            elements
    ),
    (
        select 100004 IndexTypeID,
            POReceive_ID IndexValue
        from POReceive DocumentIndex
        where DocumentIndex.POReceive_ID = ImporterDataSet.POReceive_ID for xml auto,
            type,
            elements
    ),
    (
        select 100073 IndexTypeID,
            cast(DatePosted as date) IndexValue
        from POReceive DocumentIndex
        where DocumentIndex.POReceive_ID = ImporterDataSet.POReceive_ID for xml auto,
            type,
            elements
    ),
    (
        select 100136 IndexTypeID,
            PO_ID IndexValue
        from POReceive DocumentIndex
        where DocumentIndex.POReceive_ID = ImporterDataSet.POReceive_ID for xml auto,
            type,
            elements
    )
from POReceive ImporterDataSet
order by POReceive_ID for xml auto,
    type