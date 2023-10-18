# Install Assembly - System.Data.Odbc
if (-not (Get-Package System.Data.Odbc)) {
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
  if (-not (Get-PackageSource -ProviderName NuGet)) {
    Register-PackageSource -Name NuGet -Trusted -Location 'https://api.nuget.org/v3/index.json' -ProviderName NuGet
    # Register-PackageSource -Name NuGetv2 -Location 'https://www.nuget.org/api/v2' -Trusted -ProviderName NuGet
  }
  Install-Package -Name System.Data.Odbc -Source NuGet -ProviderName NuGet -SkipDependencies
}

# Install Assembly - System.Data.SqlClient
if (-not (Get-Package System.Data.SqlClient)) {
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
  if (-not (Get-PackageSource -ProviderName NuGet)) {
    Register-PackageSource -Name NuGet -Trusted -Location 'https://api.nuget.org/v3/index.json' -ProviderName NuGet
    # Register-PackageSource -Name NuGetv2 -Location 'https://www.nuget.org/api/v2' -Trusted -ProviderName NuGet
  }
  Install-Package -Name System.Data.SqlClient -Source NuGet -ProviderName NuGet -SkipDependencies
}

$DllPath = Join-Path -Path ((Get-Package System.Data.Odbc).Source | Split-Path -Parent) 'lib\netstandard2.0\System.Data.Odbc.dll' -Resolve
$DllPath2 = Join-Path -Path ((Get-Package System.Data.SqlClient).Source | Split-Path -Parent) 'lib\netstandard2.0\System.Data.SqlClient.dll' -Resolve

try {
  Add-Type -Path $DllPath -PassThru -ErrorAction Stop
  # $a = [System.Reflection.Assembly]::LoadFile($DllPath)

  Add-Type -Path $DllPath2 -PassThru -ErrorAction Stop
  # $a2 = [System.Reflection.Assembly]::LoadFile($DllPath2)
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

