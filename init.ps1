$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version Latest

Get-Content .\specs\sandbox.depot.txt | p4 depot -i

Get-Content .\specs\main.stream.txt | p4 stream -i

$append=@"

Host:   $(hostname)

Root:   $($(Get-Location).Path)
"@

$append | Out-File -FilePath .\specs\test.workspace.txt -Encoding utf8 -Append

Get-Content .\specs\test.workspace.txt | p4 client -i
