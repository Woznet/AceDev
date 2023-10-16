select *
from (
        select 'C' record_id,
            '"' + CAST(POComments as nvarchar) + '"' po_id,
            '2' po_type,
            '"' + SUBSTRING(isnull(REPLACE(POComments, '"', ''), ''), 1, 30) + '"' po_desc,
            (
                select VendorCode
                from AP_VENDOR
                where AP_VENDOR.AP_VENDOR_KEY = PO.AP_VENDOR_KEY
            ) vendor_id,
            convert(varchar(10), PODeliveryDate, 101) po_date,
            null blank1,
            null jobnum,
            null extra,
            null costcode,
            null category,
            null taxgroup,
            null blank7,
            null quantity,
            null unitcost,
            null unittype,
            null blank11,
            null boughtout,
            null blank13,
            null blank14,
            null blank15
        from PO
        union
        select 'CI' record_id,
            '"' +(
                SELECT POComments
                from PO
                WHERE PO_ID = LinePO_ID
            ) + '"' po_id,
            null po_type,
            '"' + SUBSTRING(
                REPLACE(replace(MaterialName, ',', ' '), '"', ''),
                1,
                30
            ) + '"' po_desc,
            null vendor_id,
            null po_date,
            null blank1,
            (
                select '"' + JobID + '"'
                from POJobs
                where POJobs_ID = (
                        select PO.POJobs_ID
                        from PO
                        where PO_ID = POItemsByMatlJCPhaseExtra.LinePO_ID
                    )
            ) jobnum,
            '"' + CAST(Extra as nvarchar) + '"' extra,
            '"' + CAST(JCPhase as nvarchar) + '"' costcode,
            case
                when JCPhase in ('25-0100') then 'HDW'
                when JCPhase in ('25-0200') then 'HWS'
                else 'M'
            end as category,
            (
                select PO.Tax_Group
                from PO
                where PO_ID = POItemsByMatlJCPhaseExtra.LinePO_ID
            ) taxgroup,
            null blank7,
            CAST(Quantity as nvarchar) quantity,
            CAST(Unit_Cost as nvarchar) unitcost,
            '"' + Unit + '"' unittype,
            null blank11,
            'NO' boughtout,
            null blank13,
            null blank14,
            null blank15
        from POItemsByMatlJCPhaseExtra
    ) pocsv