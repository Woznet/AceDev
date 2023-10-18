if ($Conn.State -ne 'Open') {
    try {
        $SConn2.Open()
    }
    catch {
        Write-Warning -Message 'Something went wrong opening the ODBC Connection'
        [System.Management.Automation.ErrorRecord]$e = $_
        [PSCustomObject]@{
            Type      = $e.Exception.GetType().FullName
            Exception = $e.Exception.Message
            Reason    = $e.CategoryInfo.Reason
            Target    = $e.CategoryInfo.TargetName
            Script    = $e.InvocationInfo.ScriptName
            Message   = $e.InvocationInfo.PositionMessage
        }
        throw $_
    }
}

$sqlcmd = "select Job JobNumber,Description JobName,'' JobShortName,Address_1 JobAddress1,Address_2 JobAddress2,City JobCity,State JobState,ZIP_Code JobZipcode,Site_Phone JobPhone,Fax_Phone JobFax,'TRUE' JobActive,Material_Tax_Group MaterialTaxGroup,Job SOURCE_KEY from JCM_MASTER__JOB where Status <> 'Closed'"
$OdbcCommand3 = [System.Data.Odbc.OdbcCommand]::new($sqlcmd, $Conn)

$ExeReader3 = $OdbcCommand3.ExecuteReader()
# Assuming you've already executed the SQL command and have the $ExeReader object

# Create an array to store the results
$results4 = @()

# Get the schema of the result set
$schemaTable = $ExeReader3.GetSchemaTable()

# Extract the column names from the schema
$columns = $schemaTable | ForEach-Object { $_['ColumnName'] }

# Loop through the rows in the result set
while ($ExeReader3.Read()) {
    # Create a custom object to store the current row's data
    $row = [PSCustomObject]@{}

    # Loop through each column and add its data to the custom object
    foreach ($column in $columns) {
        $row | Add-Member -MemberType NoteProperty -Name $column -Value $ExeReader3[$column]
    }

    # Add the current row's data to the results array
    $results4 += $row
}

# Close the reader and connection
$ExeReader3.Close()
# $Conn.Close()

# Display the results
# $results4 | Format-Table
$Jobs = $results4
$results4 | Export-Csv -Path C:\temp\Sage-to-csv\JCM_MASTER__JOB-SYNC_Jobs.csv -NoTypeInformation -Verbose