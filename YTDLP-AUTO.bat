@echo off
setlocal enabledelayedexpansion

:: Created by @pawkone aka TacoYummers/Taco_PC on github
:: I hope you love my tools!! <3

:: Now forked by Pawkone on GitHub the new account of the original creator
:: I will continue to update and maintain this project as best as I can :)

set "VERSION=1.0.6.1"
set "TITLE=YTDLPAUTO-EXPANDED - Pawkone - V%VERSION%"
set "HEADER==========================================="
set "SCRIPT_DIR=%~dp0"
set "SAVE_PATH=%SCRIPT_DIR%saved"
set "YTDLP_GLOBAL_FLAGS=--no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error "
title %TITLE%
if not exist "%SAVE_PATH%" mkdir "%SAVE_PATH%"
if exist "scriptData/tempoption.cfg" (
	powershell -Command "Remove-Item -Path 'scriptData/tempoption.cfg' -Force"
)
for %%F in (
ms.ps1
qs.ps1
yt-dlp.exe
ffmpeg.exe
avcodec-62.dll
avdevice-62.dll
avfilter-11.dll
avformat-62.dll
avutil-60.dll
swresample-6.dll
swscale-9.dll
) do call :CHECKFILE "%%F"
call :ASK_UPDATE
goto MENU
:MENU
cls
echo %HEADER%
echo %TITLE%
echo %HEADER%
echo.
echo Enter a Media link:
set /p URL=
goto CHOOSE
:CHOOSE
cls
echo %HEADER%
echo %TITLE%
echo %HEADER%
echo.
echo Use UP and DOWN arrow keys to select an option
echo Press Enter to confirm your selection
echo.
echo Mode Selection
echo.
echo.
powershell -ExecutionPolicy Bypass -File scriptData/ms.ps1
cls
if %ERRORLEVEL% neq 0 (
	echo PowerShell script failed - error code %ERRORLEVEL%.
	pause
	goto CHOOSE
)
if exist "scriptData/tempoption.cfg" (
	set /p selected=<scriptData/tempoption.cfg
	powershell -Command "Remove-Item -Path 'scriptData/tempoption.cfg' -Force"
	if /i "!selected!"=="A" (
		call :QUALITY_SELECT
		goto DOWNLOAD_VIDEO
	)
	if /i "!selected!"=="B" (
		call :QUALITY_SELECT
		goto DOWNLOAD_PLAYLIST
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
echo %HEADER%
echo %TITLE%
echo %HEADER%
echo.
echo Use UP and DOWN arrow keys to select quality
echo Press Enter to confirm
echo.
echo Video Quality Selection
echo.
echo.
powershell -ExecutionPolicy Bypass -File scriptData/qs.ps1
if exist "scriptData/tempquality.cfg" (
	set /p QUALITY=<scriptData/tempquality.cfg
	powershell -Command "Remove-Item -Path 'scriptData/tempquality.cfg' -Force"
) else (
	echo Failed to read quality selection
	pause
)
set "FORMAT=bestvideo[height<=%QUALITY%][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=%QUALITY%][vcodec^=avc1]+bestaudio/best[ext=mp4]"
if /i "%QUALITY%"=="1080" set "FORMAT=bestvideo[height<=1080][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=1080][vcodec^=avc1]+bestaudio/best[ext=mp4]"
if /i "%QUALITY%"=="720" set "FORMAT=bestvideo[height<=720][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=720][vcodec^=avc1]+bestaudio/best[ext=mp4]"
if /i "%QUALITY%"=="480" set "FORMAT=bestvideo[height<=480][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=480][vcodec^=avc1]+bestaudio/best[ext=mp4]"
if /i "%QUALITY%"=="360" set "FORMAT=bestvideo[height<=360][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=360][vcodec^=avc1]+bestaudio/best[ext=mp4]"
if /i "%QUALITY%"=="240" set "FORMAT=bestvideo[height<=240][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=240][vcodec^=avc1]+bestaudio/best[ext=mp4]"
if /i "%QUALITY%"=="144" set "FORMAT=bestvideo[height<=144][vcodec^=avc1]+bestaudio[ext=m4a]/bestvideo[height<=144][vcodec^=avc1]+bestaudio/best[ext=mp4]"
:DOWNLOAD_VIDEO
set "URL=%URL:&list=%"
set "URL=%URL:&start_radio=%"
set "URL=%URL:&feature=%"
set "URL=%URL:&ab_channel=%"
set "URL=%URL:&si=%"
set "URL=%URL:&pp=%"
set "URL=%URL:&t=%"
set "DL_FLAGS=--no-playlist -f "%FORMAT%" --merge-output-format mp4 --remux-video mp4"
set "DL_OUTPUT=%SAVE_PATH%\videos\%%(title)s [%%(id)s]"
set "DL_DEST=%SAVE_PATH%\videos"
call :DO_DOWNLOAD "MP4"
goto MENU
:DOWNLOAD_PLAYLIST
set "DL_FLAGS=--yes-playlist -f "%FORMAT%" --merge-output-format mp4 --remux-video mp4"
set "DL_OUTPUT=%SAVE_PATH%\playlists\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s]"
set "DL_DEST=%SAVE_PATH%\playlists"
call :DO_DOWNLOAD "MP4 Playlist"
goto MENU
:DOWNLOAD_OGG
set "URL=%URL:&list=%"
set "URL=%URL:&start_radio=%"
set "URL=%URL:&feature=%"
set "URL=%URL:&ab_channel=%"
set "URL=%URL:&si=%"
set "URL=%URL:&pp=%"
set "URL=%URL:&t=%"
set "DL_FLAGS=--no-playlist --audio-quality 3 -f "bestaudio/best" --extract-audio --audio-format vorbis"
set "DL_OUTPUT=%SAVE_PATH%\videos_audio\%%(title)s [%%(id)s]"
set "DL_DEST=%SAVE_PATH%\videos_audio"
call :DO_DOWNLOAD "OGG"
goto MENU
:DOWNLOAD_PLAYLIST_OGG
set "DL_FLAGS=--yes-playlist --audio-quality 3 -f "bestaudio/best" --extract-audio --audio-format vorbis"
set "DL_OUTPUT=%SAVE_PATH%\playlists_audio\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s]"
set "DL_DEST=%SAVE_PATH%\playlists_audio"
call :DO_DOWNLOAD "OGG Playlist"
goto MENU
:DOWNLOAD_MP3
set "URL=%URL:&list=%"
set "URL=%URL:&start_radio=%"
set "URL=%URL:&feature=%"
set "URL=%URL:&ab_channel=%"
set "URL=%URL:&si=%"
set "URL=%URL:&pp=%"
set "URL=%URL:&t=%"
set "DL_FLAGS=--no-playlist --audio-quality 3 -f "bestaudio/best" --extract-audio --audio-format mp3"
set "DL_OUTPUT=%SAVE_PATH%\videos_audio\%%(title)s [%%(id)s]"
set "DL_DEST=%SAVE_PATH%\videos_audio"
call :DO_DOWNLOAD "MP3"
goto MENU
:DOWNLOAD_PLAYLIST_MP3
set "DL_FLAGS=--yes-playlist --audio-quality 3 -f "bestaudio/best" --extract-audio --audio-format mp3"
set "DL_OUTPUT=%SAVE_PATH%\playlists_audio\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s]"
set "DL_DEST=%SAVE_PATH%\playlists_audio"
call :DO_DOWNLOAD "MP3 Playlist"
goto MENU
:DO_DOWNLOAD
echo %DL_FLAGS% > nul 2>&1
echo %DL_OUTPUT% > nul 2>&1
cls
echo Starting to download, %~1...
echo.
"scriptData/yt-dlp.exe" %YTDLP_GLOBAL_FLAGS% %DL_FLAGS% -o "%DL_OUTPUT%" "%URL%"
if ERRORLEVEL 1 (
	echo Download failed!
	pause
	goto MENU
)
for %%F in ("%DL_DEST%\*.webm") do (
	if exist "%%F" if /i not "%%~xF"=="" (
		echo converting: %%F
		"scriptData/ffmpeg.exe" -y -i "%%F" -c:v copy -c:a aac "%%~dpnF.mp4"
		if not errorlevel 1 del "%%F"
	)
)
for %%F in ("%DL_DEST%\*.mkv") do (
	if exist "%%F" if /i not "%%~xF"=="" (
		echo converting: %%F
		"scriptData/ffmpeg.exe" -y -i "%%F" -c:v copy -c:a aac "%%~dpnF.mp4"
		if not errorlevel 1 del "%%F"
	)
)
call :COUNTDOWN "%DL_DEST%"
exit /b
:COUNTDOWN
set "SECONDS=3"
for /l %%i in (%SECONDS%,-1,1) do (
	cls
	echo Thank you for using YTDLPAUTO-EXPANDED - Pawkone
	echo.
	echo Downloaded Successfully!
	echo Opening folder in %%i...
	timeout /t 1 > nul
)
powershell -Command "Get-ChildItem '%~1' -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { explorer.exe /select,$_.FullName }"
exit /b
:CHECKFILE
if not exist "scriptData/%~1" (
	echo Error: scriptData/%~1 not found!
	pause >nul
	exit /b 1
)
exit /b
:ASK_UPDATE
cls
echo %HEADER%
echo %TITLE%
echo %HEADER%
echo.
set /p "ans=Check for yt-dlp updates? (Y/N, leave empty to skip): "
if /i "%ans%"=="y" (
	echo.
	echo Updating yt-dlp.exe...
) else (
	echo.
	echo Skipping update...
	timeout /t 1 >nul
	exit /b
)
echo.
"scriptData/yt-dlp.exe" -U
if errorlevel 1 (
	echo.
	echo Failed to update yt-dlp.exe
	pause
) else (
	echo.
	echo yt-dlp.exe updated successfully!
	timeout /t 2 >nul
)
exit /b