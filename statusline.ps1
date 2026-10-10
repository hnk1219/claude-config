$hostname = $env:COMPUTERNAME

switch ($hostname) {
    "DESKTOP-9DFEGBP" { Write-Output "🏠 自宅" }
    "DESKTOP-JMG505U" { Write-Output "🏢 会社" }
    default { Write-Output $hostname }
}
