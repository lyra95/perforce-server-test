$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version Latest

function Load-DotEnv {
  Get-Content -Path .\.env | ForEach-Object {
    $name, $value = $_ -split '=', 2
    Write-Output "Setting environment variable: $name=$value"
    Set-Content env:$name -Value $value
  }
}

Load-DotEnv

if ($null -eq $env:OTHER_P4_SERVER_ADDRESS) {
  Write-Error "Environment variable 'OTHER_P4_SERVER_ADDRESS' is not set."
  exit 1
}

if ($null -eq $env:DEPOT_MAP) {
  Write-Error "Environment variable 'DEPOT_MAP' is not set."
  exit 1
}

$append=@"
Address:        $env:OTHER_P4_SERVER_ADDRESS

DepotMap:
        $env:DEPOT_MAP
"@

$append | Out-File -FilePath .\specs\test.remote.txt -Encoding utf8 -Append

Get-Content .\specs\test.remote.txt | p4 remote -i
