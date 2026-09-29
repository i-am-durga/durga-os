@echo off
setlocal enabledelayedexpansion

echo ======================================================
echo       BUILDING DURGA OS ISO VIA DOCKER DESKTOP       
echo ======================================================

where docker >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Docker is not installed or not running.
    echo Please install and start Docker Desktop: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

echo [1/2] Building Docker build container...
docker build -f Dockerfile.build -t durga-builder .

if %ERRORLEVEL% neq 0 (
    echo [ERROR] Docker build image creation failed.
    pause
    exit /b 1
)

echo [2/2] Running build inside container (requires privileged mode for live-build)...
docker run --privileged --rm -v "%CD%":/workspace durga-builder

if exist "%CD%\durgaos-amd64.iso" (
    echo.
    echo ======================================================
    echo  SUCCESS! Durga OS ISO built at:
    echo  %CD%\durgaos-amd64.iso
    echo ======================================================
) else (
    echo [ERROR] ISO build did not complete successfully.
)

pause
