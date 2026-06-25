param(
    [string]$Path = (Join-Path (Split-Path -Parent $PSScriptRoot) "archive.html"),
    [string]$SourcePath = $Path
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "Archive source file not found: $SourcePath"
}

$html = Get-Content -LiteralPath $SourcePath -Raw -Encoding UTF8

$names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
[regex]::Matches($html, '<div class="archive-meta"><a href="#m(\d+)">#\1</a><span>[^<]+</span><strong>([^<]+)</strong></div>') |
    ForEach-Object {
        $name = [System.Net.WebUtility]::HtmlDecode($_.Groups[2].Value).Trim()
        if ($name.Length -ge 4 -and
            $name -notmatch '^(system|None)$' -and
            $name -notmatch '^(účastník|komunitní zdroj) #\d+$' -and
            $name -notmatch '^\[redigované jméno\]$' -and
            $name -notmatch 'Jagelka|Fero|Ferko|Ojeb') {
            [void]$names.Add($name)
        }
    }

$html = [regex]::Replace(
    $html,
    '<div class="archive-meta"><a href="#m(\d+)">#\1</a><span>([^<]+)</span><strong>([^<]+)</strong></div>',
    {
        param($match)

        $id = $match.Groups[1].Value
        $date = $match.Groups[2].Value
        $name = [System.Net.WebUtility]::HtmlDecode($match.Groups[3].Value).Trim()
        $label = if ($name -match '^(system|None)$') {
            'system'
        }
        elseif ($name -match 'Jagelka|Fero|Ferko|Ojeb') {
            "komunitní zdroj #$id"
        }
        else {
            "účastník #$id"
        }

        return "<div class=""archive-meta""><a href=""#m$id"">#$id</a><span>$date</span><strong>$label</strong></div>"
    }
)

$html = [regex]::Replace($html, '<p>(invite_members|remove_members|migrate_from_group): .*?</p>', '<p>$1: [redigováno]</p>')
$html = [regex]::Replace($html, '<a href="https://(?:www\.)?(?:m\.)?youtube\.com/[^"]*"[^>]*>.*?</a>', '[redigovaný veřejný odkaz]', [System.Text.RegularExpressions.RegexOptions]::Singleline)
$html = [regex]::Replace($html, '(?<![\w])@[A-Za-z0-9_.-]{3,}', '[redigovaný účet]')
$html = $html -replace 'Ojebávač František Jagelka', 'Komunitní varování'
$html = $html -replace 'Fero Jagelka - podvodnik', 'Komunitní varování'
$html = $html -replace 'RobStark', '[redigovaný veřejný kanál]'
$html = $html -replace 'robstarkcz', '[redigovany-verejny-kanal]'
$html = $html -replace 'https://jagelka.cz/assets/jagelka-profile-redacted\.jpg', 'https://jagelka.cz/assets/jagelka-profile-neutral.jpg'
$html = $html -replace 'Redigovaná profilová fotografie osoby označované jako František Jagelka', 'Neutralizovaný výřez profilové fotografie osoby označované jako František Jagelka'
$html = $html -replace '<meta property="og:image:width" content="613">', '<meta property="og:image:width" content="800">'
$html = $html -replace '<meta property="og:image:height" content="960">', '<meta property="og:image:height" content="800">'

foreach ($name in ($names | Sort-Object Length -Descending)) {
    $escaped = [regex]::Escape($name)
    $html = [regex]::Replace($html, "(?<![\p{L}\p{N}_])$escaped(?![\p{L}\p{N}_])", '[redigované jméno]')
}

$sensitiveIds = @(
    '47',
    '51',
    '55',
    '249',
    '250',
    '645',
    '1072',
    '1323',
    '1615',
    '1652'
)

foreach ($id in $sensitiveIds) {
    $html = [regex]::Replace(
        $html,
        "(<article class=""archive-item"" id=""m$id"">.*?</div>)\s*<p>.*?</p>",
        "`$1`n  <p>[Redigováno: citlivé rodinné nebo třetí-osobní detaily ponechané mimo veřejný archiv.]</p>",
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )
}

Set-Content -LiteralPath $Path -Value $html -Encoding UTF8 -NoNewline
