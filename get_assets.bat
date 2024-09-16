@echo off
setlocal

REM Define variables
set REPO_OWNER=crisarbebvc
set REPO_NAME=vericlear
set RELEASE_TAG=16.09.2024
set ASSET_NAME=".jar"

REM GitHub API URL for the release
set API_URL=https://api.github.com/repos/%REPO_OWNER%/%REPO_NAME%/releases/tags/%RELEASE_TAG%

REM Fetch release information
curl -s -H "Accept: application/vnd.github.v3+json" %API_URL% > release.json

REM Extract the asset download URL using jq
for /f "tokens=*" %%i in ('jq -r ".assets[] | select(.name==\"%ASSET_NAME%\").browser_download_url" release.json') do set ASSET_URL=%%i

REM Check if ASSET_URL is set
if "%ASSET_URL%"=="" (
    echo Asset not found.
    exit /b 1
)

REM Download the asset
curl -L -o %ASSET_NAME% %ASSET_URL%

REM Clean up
del release.json

echo Download complete.

endlocal
pause