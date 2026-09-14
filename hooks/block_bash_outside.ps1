$j = [Console]::In.ReadToEnd() | ConvertFrom-Json
$cmd = $j.tool_input.command
if (-not $cmd) { exit 0 }

$allowed = @(
    "D:\hnk\scripts",
    "D:\codeWork",
    "G:\",
    "C:\Users\hnk12\Documents\maya\scripts",
    "C:\Users\hnk12\.claude\projects\D--hnk-scripts\memory",
    "C:\Users\hnk12\.claude\CLAUDE.md",
    "C:\Users\hnk12\.claude\settings.json",
    "C:\Users\hnk12\.claude\access-attempts.log"
)

$pattern = '[A-Za-z]:[\\/][^\s"<>|]+'
$found = [regex]::Matches($cmd, $pattern)
$blocked = New-Object System.Collections.ArrayList

foreach ($m in $found) {
    $p = $m.Value
    $pNorm = $p.ToLower().Replace("/", "\")
    $isAllowed = $false
    foreach ($root in $allowed) {
        if ($pNorm.StartsWith($root.ToLower())) { $isAllowed = $true; break }
    }
    if (-not $isAllowed) { [void]$blocked.Add($p) }
}

if ($blocked.Count -gt 0) {
    $reason = "Blocked: path outside allowed working directories detected in command: " + ($blocked -join ", ")
    $result = @{
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            permissionDecision = "deny"
            permissionDecisionReason = $reason
        }
    }
    $result | ConvertTo-Json -Depth 5 -Compress
}

exit 0
