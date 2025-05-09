@echo off
echo === Starting compilation for x64 and ARM64 ===

echo.
echo === x64 Configuration ===
cmake -B build-x64 -A x64 -DOUTPUT_DIR="..\..\..\knotify\src\jvmMain\resources\win32-x86-64" .
if %ERRORLEVEL% neq 0 (
    echo Error during x64 configuration
    exit /b %ERRORLEVEL%
)

echo.
echo === x64 Compilation ===
cmake --build build-x64 --config Release
if %ERRORLEVEL% neq 0 (
    echo Error during x64 compilation
    exit /b %ERRORLEVEL%
)

echo.
echo === ARM64 Configuration ===
cmake -B build-arm64 -A ARM64 -DOUTPUT_DIR="..\..\..\knotify\src\jvmMain\resources\win32-arm64" .
if %ERRORLEVEL% neq 0 (
    echo Error during ARM64 configuration
    exit /b %ERRORLEVEL%
)

echo.
echo === ARM64 Compilation ===
cmake --build build-arm64 --config Release
if %ERRORLEVEL% neq 0 (
    echo Error during ARM64 compilation
    exit /b %ERRORLEVEL%
)

echo.
echo === Compilation completed successfully for both architectures ===
echo.
echo x64 DLL: ..\knotify\src\jvmMain\resources\win32-x86-64\wintoastlibc.dll
echo ARM64 DLL: ..\knotify\src\jvmMain\resources\win32-arm64\wintoastlibc.dll
