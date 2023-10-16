SELECT TOP (1000) [DataSync_Log_KEY],
    [LogDate],
    [LogType],
    [Notes]
FROM [AceCarpentry].[dbo].[DataSync_Log]
order by LogDate desc