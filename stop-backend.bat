@echo off
REM ============================================
REM DevFlow ALYA - Stop Backend
REM Para o servidor backend (uvicorn/FastAPI)
REM ============================================

echo.
echo ============================================
echo   DevFlow ALYA - Parando Backend
echo ============================================
echo.

REM Procurar e matar processos do uvicorn/python rodando o backend
echo [1/3] Procurando processos do backend...

REM Matar processos Python que estão rodando uvicorn
for /f "tokens=2" %%a in ('tasklist ^| findstr /i "python.exe"') do (
    echo Verificando processo %%a...
    taskkill /F /PID %%a >nul 2>&1
)

REM Matar processos uvicorn especificamente
taskkill /F /IM "uvicorn.exe" >nul 2>&1

REM Matar processos na porta 8000 (porta padrão do backend)
echo.
echo [2/3] Liberando porta 8000...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING') do (
    echo Matando processo na porta 8000 (PID: %%a)...
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo [3/3] Verificando se o backend foi parado...
timeout /t 2 >nul

REM Verificar se ainda há processos rodando
netstat -aon | findstr :8000 | findstr LISTENING >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo [AVISO] Ainda há processos rodando na porta 8000
    echo Execute manualmente: taskkill /F /IM python.exe
) else (
    echo.
    echo ============================================
    echo   Backend parado com sucesso!
    echo ============================================
)

echo.
pause
