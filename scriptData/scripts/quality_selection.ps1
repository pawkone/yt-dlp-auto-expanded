$selected = 0
$options = @("Best available","1080p","720p","480p","360p","240p","144p")
$outputopt = @("BEST","1080","720","480","360","240","144")
$menuStart = [System.Console]::CursorTop
for ($i = 0; $i -lt $options.Count; $i++) {
    Write-Host "$($options[$i])"
}
do {
    [System.Console]::SetCursorPosition(0, $menuStart)
    for ($i = 0; $i -lt $options.Count; $i++) {
        if ($i -eq $selected) {
            Write-Host "$($options[$i]) <-- Selected".PadRight(40)
        } else {
            Write-Host "$($options[$i])".PadRight(40)
        }
    }
    $key = [System.Console]::ReadKey($true).Key
    if ($key -eq 'UpArrow' -and $selected -gt 0) {
        $selected--
    } elseif ($key -eq 'DownArrow' -and $selected -lt $options.Count - 1) {
        $selected++
    } elseif ($key -eq 'Enter') {
        break
    }
} while ($true)
"$($outputopt[$selected])" | Out-File "scriptData/settings/tempquality.cfg" -NoNewline -Encoding ASCII
