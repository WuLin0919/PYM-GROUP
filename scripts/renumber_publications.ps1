param(
    [string]$InputFile = (Join-Path $PSScriptRoot '..\_data\publications.yml')
)

$ErrorActionPreference = 'Stop'
$resolvedInput = [System.IO.Path]::GetFullPath($InputFile)
$content = [System.IO.File]::ReadAllText($resolvedInput, [System.Text.Encoding]::UTF8)
$blocks = [System.Text.RegularExpressions.Regex]::Split($content, '(?m)(?=^- number:)') |
    Where-Object { $_ -match '\S' }

$records = for ($index = 0; $index -lt $blocks.Count; $index++) {
    $dateMatch = [regex]::Match($blocks[$index], '(?m)^  date: (\d{4}-\d{2}-\d{2})(?=\r?$)')
    if (-not $dateMatch.Success) {
        throw "Publication block $($index + 1) has no valid YYYY-MM-DD date."
    }

    $date = [datetime]::ParseExact(
        $dateMatch.Groups[1].Value,
        'yyyy-MM-dd',
        [System.Globalization.CultureInfo]::InvariantCulture
    )

    [pscustomobject]@{
        Index = $index
        Date = $date
        Year = $date.Year
    }
}

$changes = 0
foreach ($yearGroup in ($records | Group-Object Year)) {
    $ordered = $yearGroup.Group | Sort-Object Date, Index
    for ($number = 1; $number -le $ordered.Count; $number++) {
        $blockIndex = $ordered[$number - 1].Index
        $updatedBlock = [regex]::Replace(
            $blocks[$blockIndex],
            '(?m)^- number: \d+(?=\r?$)',
            "- number: $number",
            1
        )

        if ($updatedBlock -cne $blocks[$blockIndex]) {
            $blocks[$blockIndex] = $updatedBlock
            $changes++
        }
    }
}

$updatedContent = [string]::Join('', $blocks)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($resolvedInput, $updatedContent, $utf8NoBom)

Write-Output "Publication numbers updated: $changes"
Write-Output "Publication records checked: $($records.Count)"

