$hostName = $env:COMPUTERNAME
$emoji = $null
if ($hostName -eq "DESKTOP-VBKT10N") { $emoji = [char]::ConvertFromUtf32(0x1F3E0) }
elseif ($hostName -eq "DESKTOP-JMG505U") { $emoji = [char]::ConvertFromUtf32(0x1F3E2) }

if ($null -eq $emoji) {
    exit 0
}

$context = @"
[セッションタイトル端末アイコン自動付与]
現在のホスト名は $hostName のため、付与する絵文字は「$emoji」です。ユーザーへの確認は不要なので、以下を自動的に実行してください。

1. mcp__ccd_session_mgmt__get_session (session_id: "self") で現在のセッションタイトルを取得する。
2. タイトル先頭に(自宅アイコン)または(会社アイコン)のいずれかが既に付いていれば何もしない。付いていなければ mcp__ccd_session_mgmt__set_session_title (session_id: "self", title: "$emoji " + 現在のタイトル) でタイトル先頭に付与する。
3. 続けて mcp__ccd_session_mgmt__list_sessions (include_archived: true) で同一端末上の他セッション一覧を取得し、タイトル先頭に端末アイコンが付いていないセッションがあれば、同様に mcp__ccd_session_mgmt__set_session_title で先頭に「$emoji 」を付与する（未タグ付けセッションのバックフィル）。
4. これらの処理はセッション開始時のセットアップとして実行し、結果を長々と報告する必要はない（一言で触れる程度で良い）。応答本文・コード中には絵文字を使わないこと（これはセッションタイトル付与のみの例外）。
"@

$output = @{
    hookSpecificOutput = @{
        hookEventName = "SessionStart"
        additionalContext = $context
    }
} | ConvertTo-Json -Depth 5 -Compress

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Output $output
