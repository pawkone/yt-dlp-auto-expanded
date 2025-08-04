
@echo off

:: Created by Taco_PC aka TacoYummers on github
:: I hope you love my tools!! <3

set "VERSION=1.0.3"
set "SCRIPT_DIR=%~dp0"
set "SAVE_PATH=%SCRIPT_DIR%saved"
setlocal enabledelayedexpansion
title YT-DLP AUTO (%VERSION%) - Taco_PC



echo LOADING...
timeout /t 1 > nul



if not exist "%SAVE_PATH%" mkdir "%SAVE_PATH%"
if not exist "scriptData/settings" mkdir "scriptData/settings"
if exist "scriptData/settings/tempoption.cfg" powershell -Command "Remove-Item -Path 'scriptData/settings/tempoption.cfg' -Force"
if exist "scriptData/settings/warningskip.cfg" (
	goto MENU
) else (
	goto WARNING
)



:WARNING
cls
echo PLEASE BE MINDFUL THAT VIDEOS   ** MIGHT **   USE AV1
echo WHICH WINDOWS NEW MEDIA PLAYER DOES NOT SUPPORT.
echo.
echo.
echo GET VLC PLAYER OR GET THE AV1 EXTENSION ON MICROSOFT STORE INSTEAD!
echo.
echo.
timeout /t 10
echo. > "scriptData/settings/warningskip.cfg"
goto MENU



:MENU
cls
echo =========================================
echo Welcome to YTDLP AUTO - Taco_PC - V%VERSION%
echo =========================================
echo.
echo Enter a YouTube link:
set /p URL=YT URL: 
goto CHOOSE



:CHOOSE
cls
echo =========================================
echo Welcome to YTDLP AUTO - Taco_PC - V%VERSION%
echo =========================================
echo.
powershell -ExecutionPolicy Bypass -File scriptData/scripts/selection.ps1 -Version "%VERSION%"
if %ERRORLEVEL% neq 0 (
    echo PowerShell script failed with error code %ERRORLEVEL%.
    pause
    goto CHOOSE
)
cls
if exist "scriptData/settings/tempoption.cfg" (
	set /p selected=<scriptData/settings/tempoption.cfg
	if "!selected!"=="" (
		echo Error: The selected option is empty!
		pause
		goto CHOOSE
	)
	powershell -Command "Remove-Item -Path 'scriptData/settings/tempoption.cfg' -Force"
	cls
	if /i "!selected!"=="A" goto DOWNLOAD_VIDEO
	if /i "!selected!"=="B" goto DOWNLOAD_PLAYLIST
	if /i "!selected!"=="C" goto DOWNLOAD_OGG
	if /i "!selected!"=="D" goto DOWNLOAD_PLAYLIST_OGG
	if /i "!selected!"=="E" goto DOWNLOAD_MP3
	if /i "!selected!"=="F" goto DOWNLOAD_PLAYLIST_MP3
	echo Unknown error... Data not processed correctly
	pause
	goto CHOOSE
) else (
	echo Couldn't read file in time, disk speed low or interrupting application...
	pause
	goto CHOOSE
)



:DOWNLOAD_VIDEO
echo Downloading MP4
echo.
echo.
"scriptData/yt-dlp.exe" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --no-playlist --audio-multistreams --video-multistreams -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "%SAVE_PATH%\videos\%%(title)s [%%(id)s] [%%(id)s].mp4" "%URL%" || (
	echo Download failed! Please check the URL or internet connection.
	pause
	goto MENU
)
cls
echo Video Downloaded Successfully!
echo Thanks for using YTDLPAUTO by Taco_PC!
echo Press any key or wait 3 seconds to open the location of your video(s)!
timeout /t 3 > nul
start "" "%SAVE_PATH%\videos"
goto MENU



:DOWNLOAD_PLAYLIST
echo Downloading MP4 (Playlist)
echo.
echo.
"scriptData/yt-dlp" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --yes-playlist --audio-multistreams --video-multistreams -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "%SAVE_PATH%\playlists\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s].mp4" "%URL%" || (
	echo Download failed! Please check the URL or internet connection.
	pause
	goto MENU
)
cls
echo Playlist Downloaded Successfully!
echo Thanks for using YTDLPAUTO by Taco_PC!
echo Press any key or wait 3 seconds to open the location of your playlist!
timeout /t 3 > nul
start "" "%SAVE_PATH%\playlists"
goto MENU



:DOWNLOAD_OGG
echo Downloading OGG
echo.
echo.
"scriptData/yt-dlp" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --no-playlist --audio-multistreams --audio-quality 2 -f "bestaudio/best" --extract-audio --audio-format vorbis -o "%SAVE_PATH%\videos_audio\%%(title)s [%%(id)s]" "%URL%" || (
	echo Download failed! Please check the URL or internet connection.
	pause
	goto MENU
)
cls
echo Audio Downloaded Successfully!
echo Thanks for using YTDLPAUTO by Taco_PC!
echo Press any key or wait 3 seconds to open the location of your audio!
timeout /t 3 > nul
start "" "%SAVE_PATH%\videos_audio"
goto MENU



:DOWNLOAD_PLAYLIST_OGG
echo Downloading OGG (Playlist)
echo.
echo.
"scriptData/yt-dlp" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --yes-playlist --audio-multistreams --audio-quality 2 -f "bestaudio/best" --extract-audio --audio-format vorbis -o "%SAVE_PATH%\playlists_audio\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s]" "%URL%" || (
	echo Download failed! Please check the URL or internet connection.
	pause
	goto MENU
)
cls
echo Playlist Audio Downloaded Successfully!
echo Thanks for using YTDLPAUTO by Taco_PC!
echo Press any key or wait 3 seconds to open the location of your playlist audio(s)!
timeout /t 3 > nul
start "" "%SAVE_PATH%\playlists_audio"
goto MENU



:DOWNLOAD_MP3
echo Downloading MP3
echo.
echo.
"scriptData/yt-dlp" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --no-playlist --audio-multistreams --audio-quality 2 -f "bestaudio/best" --extract-audio --audio-format mp3 -o "%SAVE_PATH%\videos_audio\%%(title)s [%%(id)s]" "%URL%" || (
	echo Download failed! Please check the URL or internet connection.
	pause
	goto MENU
)
cls
echo Audio Downloaded Successfully!
echo Thanks for using YTDLPAUTO by Taco_PC!
echo Press any key or wait 3 seconds to open the location of your audio!
timeout /t 3 > nul
start "" "%SAVE_PATH%\videos_audio"
goto MENU



:DOWNLOAD_PLAYLIST_MP3
echo Downloading MP3 (Playlist)
echo.
echo.
"scriptData/yt-dlp" --no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --yes-playlist --audio-multistreams --audio-quality 2 -f "bestaudio/best" --extract-audio --audio-format mp3 -o "%SAVE_PATH%\playlists_audio\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s]" "%URL%" || (
	echo Download failed! Please check the URL or internet connection.
	pause
	goto MENU
)
cls
echo Playlist Audio Downloaded Successfully!
echo Thanks for using YTDLPAUTO by Taco_PC!
echo Press any key or wait 3 seconds to open the location of your playlist audio(s)!
timeout /t 3 > nul
start "" "%SAVE_PATH%\playlists_audio"
goto MENU