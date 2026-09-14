$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$username = Split-Path -Leaf $env:USERPROFILE

$targets = @(
    @{ Template = Join-Path $root "settings.template.json"; Output = Join-Path $root "settings.json" },
    @{ Template = Join-Path $root "hooks\block_bash_outside.template.ps1"; Output = Join-Path $root "hooks\block_bash_outside.ps1" },
    @{ Template = Join-Path $root "hooks\log_access.template.ps1"; Output = Join-Path $root "hooks\log_access.ps1" }
)

$utf8Bom = New-Object System.Text.UTF8Encoding($true)

foreach ($t in $targets) {
    if (-not (Test-Path $t.Template)) {
        Write-Warning "Template not found: $($t.Template)"
        continue
    }
    $content = [System.IO.File]::ReadAllText($t.Template, [System.Text.Encoding]::UTF8)
    $content = $content -replace '__USERNAME__', $username
    [System.IO.File]::WriteAllText($t.Output, $content, $utf8Bom)
    Write-Output "Generated: $($t.Output)"
}
