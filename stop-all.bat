@echo off
REM ============================================
REM DevFlow ALYA - Stop All Services
REM Para backend e frontend simultaneamente
REM ============================================

echo.
echo ============================================
echo   DevFlow ALYA - Parando Todos os Servicos
echo ============================================
echo.

REM Parar Backend
echo [1/2] Parando Backend...
echo ----------------------------------------

REM Matar processos Python (backend)
for /f "tokens=2" %%a in ('tasklist ^| findstr /i "python.exe"') do (
    taskkill /F /PID %%a >nul 2>&1
)

REM Liberar porta 8000
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo Backend parado!
echo.

REM Parar Frontend
echo [2/2] Parando Frontend...
echo ----------------------------------------

REM Matar processos Node.js (frontend)
for /f "tokens=2" %%a in ('tasklist ^| findstr /i "node.exe"') do (
    taskkill /F /PID %%a >nul 2>&1
)

REM Liberar porta 5173
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :5173 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo Frontend parado!
echo.

REM Aguardar e verificar
timeout /t 2 >nul

echo.
echo ============================================
echo   Verificando portas...
echo ============================================

REM Verificar porta 8000 (backend)
netstat -aon | findstr :8000 | findstr LISTENING >nul 2>&1
if %errorlevel% equ 0 (
    echo [AVISO] Porta 8000 ainda em uso
) else (
    echo [OK] Porta 8000 liberada
)

REM Verificar porta 5173 (frontend)
netstat -aon | findstr :5173 | findstr LISTENING >nul 2>&1
if %errorlevel% equ 0 (
    echo [AVISO] Porta 5173 ainda em uso
) else (
    echo [OK] Porta 5173 liberada
)

echo.
echo ============================================
echo   Todos os servicos foram parados!
echo ============================================
echo.

pause
