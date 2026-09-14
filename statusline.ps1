$hostname = $env:COMPUTERNAME

switch ($hostname) {
    "DESKTOP-VBKT10N" { Write-Output "🏠 自宅" }
    "DESKTOP-JMG505U" { Write-Output "🏢 会社" }
    default { Write-Output $hostname }
}
