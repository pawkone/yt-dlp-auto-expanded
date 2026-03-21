$selected = 0
$options = @("Yes","No")
$outputopt = @("y","n")
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
"$($outputopt[$selected])" | Out-File "scriptData/tempoption.cfg" -NoNewline -Encoding ASCII
