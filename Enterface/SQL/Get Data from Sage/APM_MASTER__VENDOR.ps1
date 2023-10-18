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

$sqlcmd = "select Vendor VendorNumber,Name VendorName,'' VendorShortName,Contact_1_Name VendorContactName,Contact_1_Email_Address VendorEmail,Telephone VendorPrimaryPhone,Contact_1_Telephone VendorMobilePhone,Fax_Number VendorFaxNumber,Address_1 VendorAddress1,Address_2 VendorAddress2,City VendorCity,State VendorState,ZIP VendorZipcode,Vendor SOURCE_KEY from APM_MASTER__VENDOR"
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
$results4 | Format-Table

$results4 | Export-Csv -Path C:\temp\Sage-to-csv\APM_MASTER__VENDOR.csv -NoTypeInformation -Verbose