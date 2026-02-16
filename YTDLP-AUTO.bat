@echo off

:: Created by @pawkone aka TacoYummers/Taco_PC on github
:: I hope you love my tools!! <3

:: Now forked by Pawkone on GitHub the new account of the original creator
:: I will continue to update and maintain this project as best as I can :)
:: 

set "VERSION=1.0.5"
set "SCRIPT_DIR=%~dp0"
set "SAVE_PATH=%SCRIPT_DIR%saved"
setlocal enabledelayedexpansion
title YTDLPAUTO-EXPANDED (%VERSION%) - Pawkone

if not exist "%SAVE_PATH%" mkdir "%SAVE_PATH%"
if not exist "scriptData/settings" mkdir "scriptData/settings"
if exist "scriptData/settings/tempoption.cfg" powershell -Command "Remove-Item -Path 'scriptData/settings/tempoption.cfg' -Force"
goto MENU

:MENU
cls
echo =========================================
echo Welcome to YTDLPAUTO-EXPANDED - Pawkone - V%VERSION%
echo =========================================
echo.
echo Enter a YouTube link:
set /p URL=MEDIA URL:
goto CHOOSE

:CHOOSE
cls
echo =========================================
echo Welcome to YTDLPAUTO-EXPANDED - Pawkone - V%VERSION%
echo =========================================
echo.
echo Use UP and DOWN arrow keys to select an option
echo Press Enter to confirm your selection
echo.
echo Mode Selection
echo.
powershell -ExecutionPolicy Bypass -File scriptData/scripts/selection.ps1
cls
if %ERRORLEVEL% neq 0 (
	echo PowerShell script failed - error code %ERRORLEVEL%.
	pause
	goto CHOOSE
)
if exist "scriptData/settings/tempoption.cfg" (
	set /p selected=<scriptData/settings/tempoption.cfg
	powershell -Command "Remove-Item -Path 'scriptData/settings/tempoption.cfg' -Force"
	if /i "!selected!"=="A" (
		set NEXT_STEP=DOWNLOAD_VIDEO
		goto QUALITY_SELECT
	)
	if /i "!selected!"=="B" (
		set NEXT_STEP=DOWNLOAD_PLAYLIST
		goto QUALITY_SELECT
	)
	if /i "!selected!"=="C" goto DOWNLOAD_OGG
	if /i "!selected!"=="D" goto DOWNLOAD_PLAYLIST_OGG
	if /i "!selected!"=="E" goto DOWNLOAD_MP3
	if /i "!selected!"=="F" goto DOWNLOAD_PLAYLIST_MP3
	echo Unknown error
	pause
	goto CHOOSE
) else (
 echo Couldn't read file
 pause
 goto CHOOSE
)

:QUALITY_SELECT
cls
echo =========================================
echo Welcome to YTDLPAUTO-EXPANDED - Pawkone - V%VERSION%
echo =========================================
echo.
echo Use UP and DOWN arrow keys to select quality
echo Press Enter to confirm
echo.
powershell -ExecutionPolicy Bypass -File scriptData/scripts/quality_selection.ps1

if exist "scriptData/settings/tempquality.cfg" (
 set /p QUALITY=<scriptData/settings/tempquality.cfg
 powershell -Command "Remove-Item -Path 'scriptData/settings/tempquality.cfg' -Force"
) else (
 echo Failed to read quality selection
 pause
 goto MENU
)

if /i "%QUALITY%"=="BEST" set "FORMAT=bestvideo+bestaudio/best"
if /i "%QUALITY%"=="1080" set "FORMAT=bestvideo[height<=1080]+bestaudio/best"
if /i "%QUALITY%"=="720" set "FORMAT=bestvideo[height<=720]+bestaudio/best"
if /i "%QUALITY%"=="480" set "FORMAT=bestvideo[height<=480]+bestaudio/best"
if /i "%QUALITY%"=="360" set "FORMAT=bestvideo[height<=360]+bestaudio/best"
if /i "%QUALITY%"=="240" set "FORMAT=bestvideo[height<=240]+bestaudio/best"
if /i "%QUALITY%"=="144" set "FORMAT=bestvideo[height<=144]+bestaudio/best"

goto %NEXT_STEP%

:DOWNLOAD_VIDEO
echo Downloading MP4
echo.
"scriptData/yt-dlp.exe" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --no-playlist --audio-multistreams --video-multistreams -f "%FORMAT%" --merge-output-format mp4 -o "%SAVE_PATH%\videos\%%(title)s [%%(id)s].mp4" "%URL%" || (
	echo Download failed!
	pause
	goto MENU
)
cls
echo Video Downloaded Successfully!
echo Opening folder with file selected!
timeout /t 3 > nul
start "" "%SAVE_PATH%\videos"
goto MENU

:DOWNLOAD_PLAYLIST
echo Downloading MP4 Playlist
echo.
"scriptData/yt-dlp.exe" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --yes-playlist --audio-multistreams --video-multistreams -f "%FORMAT%" --merge-output-format mp4 -o "%SAVE_PATH%\playlists\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s].mp4" "%URL%" || (
	echo Download failed!
	pause
	goto MENU
)
cls
echo Playlist Downloaded Successfully!
echo Opening folder with file selected!
timeout /t 3 > nul
start "" "%SAVE_PATH%\playlists"
goto MENU

:DOWNLOAD_OGG
echo Downloading OGG
echo.
"scriptData/yt-dlp.exe" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --no-playlist --audio-multistreams --audio-quality 2 -f "bestaudio/best" --extract-audio --audio-format vorbis -o "%SAVE_PATH%\videos_audio\%%(title)s [%%(id)s]" "%URL%" || (
	echo Download failed!
	pause
	goto MENU
)
cls
echo Audio Downloaded Successfully!
echo Opening folder with file selected!
timeout /t 3 > nul
start "" "%SAVE_PATH%\videos_audio"
goto MENU

:DOWNLOAD_PLAYLIST_OGG
echo Downloading OGG Playlist
echo.
"scriptData/yt-dlp.exe" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --yes-playlist --audio-multistreams --audio-quality 2 -f "bestaudio/best" --extract-audio --audio-format vorbis -o "%SAVE_PATH%\playlists_audio\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s]" "%URL%" || (
	echo Download failed!
	pause
	goto MENU
)
cls
echo Playlist Audio Downloaded Successfully!
echo Opening folder with file selected!
timeout /t 3 > nul
start "" "%SAVE_PATH%\playlists_audio"
goto MENU

:DOWNLOAD_MP3
echo Downloading MP3
echo.
"scriptData/yt-dlp.exe" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --no-playlist --audio-multistreams --audio-quality 2 -f "bestaudio/best" --extract-audio --audio-format mp3 -o "%SAVE_PATH%\videos_audio\%%(title)s [%%(id)s]" "%URL%" || (
	echo Download failed!
	pause
	goto MENU
)
cls
echo Audio Downloaded Successfully!
echo Opening folder with file selected!
timeout /t 3 > nul
start "" "%SAVE_PATH%\videos_audio"
goto MENU

:DOWNLOAD_PLAYLIST_MP3
echo Downloading MP3 Playlist
echo.
	"scriptData/yt-dlp.exe" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --yes-playlist --audio-multistreams --audio-quality 2 -f "bestaudio/best" --extract-audio --audio-format mp3 -o "%SAVE_PATH%\playlists_audio\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s]" "%URL%" || (
	echo Download failed!
	pause
	goto MENU
)
cls
echo Playlist Audio Downloaded Successfully!
echo Opening folder with file selected!
timeout /t 3 > nul
start "" "%SAVE_PATH%\playlists_audio"
goto MENU
