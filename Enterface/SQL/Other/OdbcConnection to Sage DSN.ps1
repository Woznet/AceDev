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

$global:SageConn = [System.Data.Odbc.OdbcConnection]::new($ConnectionString)
