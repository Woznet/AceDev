function New-ODBCConnection {
  [CmdletBinding()]
  param(
    [Parameter()]
    [string]$DSNName = 'Sage3002',
    [Parameter(Mandatory, ParameterSetName = 'pscred')]
    [System.Management.Automation.Credential()]
    [pscredential]$Credential,
    [Parameter(Mandatory, ParameterSetName = 'text')]
    [string]$User,
    [Parameter(Mandatory, ParameterSetName = 'text')]
    [string]$Password
  )

  if ([environment]::Is64BitProcess){ throw 'Sage ODBC Driver "Timberline Data" is 32-bit. Try using - Windows PowerShell (x86)' }

  try {

    $DllPath = Join-Path -Path ((Get-Package System.Data.Odbc -ErrorAction Stop).Source | Split-Path -Parent) 'lib\netstandard2.0\System.Data.Odbc.dll' -Resolve -ErrorAction Stop
    Add-Type -Path $DllPath -ErrorAction Stop

  }
  catch {
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

  switch ($PSCmdlet.ParameterSetName) {
    'pscred' {
      $ConnectionString = ('DSN={0};UID={1};PWD={2};' -f $DSNName, $Credential.UserName,
      [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::GetStringFromSecureString($Credential.Password))
      break
    }
    'text' {
      $ConnectionString = ('DSN={0};UID={1};PWD={2};' -f $DSNName, $User, $Password) ; break
    }
  }

  $SageConn = [System.Data.Odbc.OdbcConnection]::new($ConnectionString)
  
  return $SageConn
}
