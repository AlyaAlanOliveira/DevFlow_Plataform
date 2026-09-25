@echo off
REM ============================================
REM DevFlow ALYA - Restart Backend
REM Para e reinicia o servidor backend
REM ============================================

echo.
echo ============================================
echo   DevFlow ALYA - Reiniciando Backend
echo ============================================
echo.

REM Parar backend atual
echo [1/2] Parando backend atual...
echo ----------------------------------------

REM Matar processos Python
for /f "tokens=2" %%a in ('tasklist ^| findstr /i "python.exe"') do (
    taskkill /F /PID %%a >nul 2>&1
)

REM Liberar porta 8000
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo Backend parado!
echo.
echo Aguardando 3 segundos...
timeout /t 3 >nul

REM Iniciar backend novamente
echo.
echo [2/2] Iniciando backend...
echo ----------------------------------------
echo.

cd backend

REM Verificar se venv existe
if not exist "venv\Scripts\activate.bat" (
    echo [ERRO] Ambiente virtual nao encontrado!
    echo Execute primeiro: python -m venv venv
    echo.
    pause
    exit /b 1
)

REM Ativar venv e iniciar
echo Ativando ambiente virtual...
call venv\Scripts\activate.bat

echo Iniciando servidor backend...
echo.
echo ============================================
echo   Backend rodando em http://localhost:8000
echo   Pressione Ctrl+C para parar
echo ============================================
echo.

python run.py

REM Se o script chegar aqui, o backend foi parado
echo.
echo Backend foi parado.
pause
