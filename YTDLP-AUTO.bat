@echo off
setlocal enabledelayedexpansion

:: Created by @pawkone aka TacoYummers/Taco_PC on github
:: I hope you love my tools!! <3

:: Now forked by Pawkone on GitHub the new account of the original creator
:: I will continue to update and maintain this project as best as I can :)

set "VERSION=1.0.7"
set "TITLE=YTDLPAUTO-EXPANDED - Pawkone - V%VERSION%"
set "HEADER==========================================="
set "SCRIPT_DIR=%~dp0"
set "SAVE_PATH=%SCRIPT_DIR%saved"
title %TITLE%
if not exist "%SAVE_PATH%" mkdir "%SAVE_PATH%"
if exist "scriptData/tempoption.cfg" (
	powershell -Command "Remove-Item -Path 'scriptData/tempoption.cfg' -Force"
)
call :CHECKFILE "ds.ps1"
call :CHECKFILE "ms.ps1"
call :CHECKFILE "qs.ps1"
call :CHECKFILE "yt-dlp.exe"
call :CHECKFILE "ffmpeg.exe"
call :CHECKFILE "node.exe"
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
:METADATACHOOSE
cls
echo %HEADER%
echo %TITLE%
echo %HEADER%
echo.
echo Use UP and DOWN arrow keys to select an option
echo Press Enter to confirm your selection
echo.
echo Do you want metadata (Author, Thumbnail and more in your downloaded media?)
echo.
echo.
powershell -ExecutionPolicy Bypass -File scriptData/ds.ps1
cls
if %ERRORLEVEL% neq 0 (
	echo PowerShell script failed - error code %ERRORLEVEL%.
	pause
	goto CHOOSE
)
if exist "scriptData/tempoption.cfg" (
	set /p META=<scriptData/tempoption.cfg
	powershell -Command "Remove-Item -Path 'scriptData/tempoption.cfg' -Force"
	if /i "!META!"=="y" (
		set "META_FLAGS=--embed-metadata --embed-thumbnail"
	) else (
		set "META_FLAGS="
	)
) else (
	echo Couldn't read file, continuing with no metadata
	set "META_FLAGS="
	pause
)
goto :EOF
:CHOOSE
set "META_FLAGS="
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
		set NEXT_STEP=DOWNLOAD_VIDEO
		goto QUALITY_SELECT
	)
	if /i "!selected!"=="B" (
		set NEXT_STEP=DOWNLOAD_PLAYLIST
		goto QUALITY_SELECT
	)
	if /i "!selected!"=="C" goto DOWNLOAD_MP3
	if /i "!selected!"=="D" goto DOWNLOAD_PLAYLIST_MP3
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
if exist "scriptData/tempoption.cfg" (
	set /p QUALITY=<scriptData/tempoption.cfg
	powershell -Command "Remove-Item -Path 'scriptData/tempoption.cfg' -Force"
) else (
	echo Failed to read quality selection
	pause
	goto MENU
)
if /i "%QUALITY%"=="1080" set "FORMAT=bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]/best[height<=1080]"
if /i "%QUALITY%"=="720"  set "FORMAT=bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best[height<=720]"
if /i "%QUALITY%"=="480"  set "FORMAT=bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]/best[height<=480][ext=mp4]/best[height<=480]"
if /i "%QUALITY%"=="360"  set "FORMAT=bestvideo[height<=360][ext=mp4]+bestaudio[ext=m4a]/best[height<=360][ext=mp4]/best[height<=360]"
if /i "%QUALITY%"=="240"  set "FORMAT=bestvideo[height<=240][ext=mp4]+bestaudio[ext=m4a]/best[height<=240][ext=mp4]/best[height<=240]"
if /i "%QUALITY%"=="144"  set "FORMAT=bestvideo[height<=144][ext=mp4]+bestaudio[ext=m4a]/best[height<=144][ext=mp4]/best[height<=144]"
goto %NEXT_STEP%
:DOWNLOAD_VIDEO
set "DL_FLAGS=--no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --no-playlist -f \"%FORMAT%\" --merge-output-format mp4"
set "DL_OUTPUT=%SAVE_PATH%\videos\%%(title)s [%%(id)s].mp4"
set "DL_DEST=%SAVE_PATH%\videos"
call :DO_DOWNLOAD "MP4"
call :CONVERT_WEBM "%DL_DEST%"
call :COUNTDOWN "%DL_DEST%"
goto MENU
:DOWNLOAD_PLAYLIST
set "DL_FLAGS=--no-mtime --no-post-overwrites --no-overwrites --no-abort-on-error --yes-playlist -f \"%FORMAT%\" --merge-output-format mp4"
set "DL_OUTPUT=%SAVE_PATH%\playlists\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s].mp4"
set "DL_DEST=%SAVE_PATH%\playlists"
call :DO_DOWNLOAD "MP4 Playlist"
call :CONVERT_WEBM "%DL_DEST%"
call :COUNTDOWN "%DL_DEST%"
goto MENU
:DOWNLOAD_MP3
call :METADATACHOOSE
set "DL_FLAGS=--no-mtime --no-overwrites --no-post-overwrites --no-abort-on-error --no-playlist -f bestaudio/best -x --audio-format mp3 --audio-quality 0"
set "DL_OUTPUT=%SAVE_PATH%\videos_audio\%%(title)s [%%(id)s]"
set "DL_DEST=%SAVE_PATH%\videos_audio"
call :DO_DOWNLOAD "MP3"
call :COUNTDOWN "%DL_DEST%"
goto MENU
:DOWNLOAD_PLAYLIST_MP3
call :METADATACHOOSE
set "DL_FLAGS=--no-mtime --no-overwrites --no-post-overwrites --no-abort-on-error --yes-playlist -f bestaudio/best -x --audio-format mp3 --audio-quality 0"
set "DL_OUTPUT=%SAVE_PATH%\playlists_audio\%%(playlist_title)s [%%(playlist_id)s]\%%(title)s [%%(id)s]"
set "DL_DEST=%SAVE_PATH%\playlists_audio"
call :DO_DOWNLOAD "MP3 Playlist"
call :COUNTDOWN "%DL_DEST%"
goto MENU
:DO_DOWNLOAD
echo %DL_FLAGS% > nul 2>&1
echo %DL_OUTPUT% > nul 2>&1
cls
echo Starting to download, %~1...
echo.
"scriptData/yt-dlp.exe" %DL_FLAGS% %META_FLAGS% --no-js-runtimes --js-runtimes node:"scriptData" --ffmpeg-location "scriptData" -o "%DL_OUTPUT%" "%URL%"
if ERRORLEVEL 1 (
	echo Download failed!
	pause
	goto MENU
)
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
	exit /b
)
:CONVERT_WEBM
for /r "%~1" %%f in (*.webm) do (
	set "webm_file=%%f"
	set "mp4_file=%%~dpf%%~nf.mp4"
	echo Converting %%~nf to MP4...
	"scriptData/ffmpeg.exe" -i "!webm_file!" -c copy -y "!mp4_file!" >nul 2>&1
	if exist "!mp4_file!" (
		del "!webm_file!"
	)
)
exit /b