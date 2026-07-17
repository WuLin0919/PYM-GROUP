param(
    [string]$InputFile = (Join-Path $PSScriptRoot '..\_data\news.yml')
)

$ErrorActionPreference = 'Stop'
$resolvedInput = [System.IO.Path]::GetFullPath($InputFile)
$content = [System.IO.File]::ReadAllText($resolvedInput, [System.Text.Encoding]::UTF8)
$blocks = [System.Text.RegularExpressions.Regex]::Split($content, '(?m)(?=^- number:)') | Where-Object { $_ -match '\S' }
$cache = @{}
$changes = 0
$failures = New-Object System.Collections.Generic.List[string]
$officialOverrides = @{
    'Applied Mathematics and Mechanics' = 'Applied Mathematics and Mechanics (English Edition)'
    'Materials & Design (1980-2015)' = 'Materials & Design'
}
$manualJournalTitles = @{
    'ACTA METALLURGICA SINICA' = 'Acta Metallurgica Sinica'
    'CHINESE PHYSICS LETTERS' = 'Chinese Physics Letters'
}

for ($index = 0; $index -lt $blocks.Count; $index++) {
    $block = $blocks[$index]
    $doiMatch = [regex]::Match($block, '(?m)^  doi: "([^"]+)"(?=\r?$)')
    $journalMatch = [regex]::Match($block, '(?m)^  journal: "([^"]+)"(?=\r?$)')

    if (-not $journalMatch.Success) {
        continue
    }

    if (-not $doiMatch.Success) {
        $currentTitle = $journalMatch.Groups[1].Value
        if ($manualJournalTitles.ContainsKey($currentTitle)) {
            $officialTitle = $manualJournalTitles[$currentTitle]
            $blocks[$index] = $block.Substring(0, $journalMatch.Index) +
                "  journal: `"$officialTitle`"" +
                $block.Substring($journalMatch.Index + $journalMatch.Length)
            $changes++
        }
        continue
    }

    $doi = $doiMatch.Groups[1].Value.Trim()
    if (-not $cache.ContainsKey($doi)) {
        $encodedDoi = [System.Uri]::EscapeDataString($doi)
        $uri = "https://api.crossref.org/works/$encodedDoi"
        $officialTitle = $null

        for ($attempt = 1; $attempt -le 3 -and -not $officialTitle; $attempt++) {
            try {
                $response = Invoke-RestMethod -Uri $uri -Headers @{
                    'User-Agent' = 'PYM-Group-metadata-check/1.0 (mailto:peiym@pku.edu.cn)'
                } -TimeoutSec 30
                $officialTitle = @($response.message.'container-title')[0]
            }
            catch {
                if ($attempt -lt 3) {
                    Start-Sleep -Milliseconds (500 * $attempt)
                }
            }
        }

        $cache[$doi] = $officialTitle
        Start-Sleep -Milliseconds 75
    }

    $officialTitle = $cache[$doi]
    if (-not $officialTitle) {
        $failures.Add($doi)
        continue
    }

    $officialTitle = [System.Net.WebUtility]::HtmlDecode($officialTitle.Trim())
    if ($officialOverrides.ContainsKey($officialTitle)) {
        $officialTitle = $officialOverrides[$officialTitle]
    }
    $officialTitle = $officialTitle.Replace('"', '\"')
    $currentTitle = $journalMatch.Groups[1].Value
    if ($currentTitle -cne $officialTitle) {
        $blocks[$index] = $block.Substring(0, $journalMatch.Index) +
            "  journal: `"$officialTitle`"" +
            $block.Substring($journalMatch.Index + $journalMatch.Length)
        $changes++
    }
}

$updatedContent = [string]::Join('', $blocks)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($resolvedInput, $updatedContent, $utf8NoBom)

Write-Output "Updated journal titles: $changes"
Write-Output "Crossref records checked: $($cache.Count)"
if ($failures.Count -gt 0) {
    Write-Output "Unresolved DOI records: $($failures.Count)"
    $failures | Sort-Object -Unique | ForEach-Object { Write-Output "  $_" }
}
