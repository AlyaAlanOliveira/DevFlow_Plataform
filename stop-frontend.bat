@echo off
REM ============================================
REM DevFlow ALYA - Stop Frontend
REM Para o servidor frontend (Vite/Vue.js)
REM ============================================

echo.
echo ============================================
echo   DevFlow ALYA - Parando Frontend
echo ============================================
echo.

REM Procurar e matar processos do Node.js rodando o frontend
echo [1/3] Procurando processos do frontend...

REM Matar processos Node.js
for /f "tokens=2" %%a in ('tasklist ^| findstr /i "node.exe"') do (
    echo Verificando processo Node.js %%a...
    taskkill /F /PID %%a >nul 2>&1
)

REM Matar processos na porta 5173 (porta padrão do Vite)
echo.
echo [2/3] Liberando porta 5173...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :5173 ^| findstr LISTENING') do (
    echo Matando processo na porta 5173 (PID: %%a)...
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo [3/3] Verificando se o frontend foi parado...
timeout /t 2 >nul

REM Verificar se ainda há processos rodando
netstat -aon | findstr :5173 | findstr LISTENING >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo [AVISO] Ainda há processos rodando na porta 5173
    echo Execute manualmente: taskkill /F /IM node.exe
) else (
    echo.
    echo ============================================
    echo   Frontend parado com sucesso!
    echo ============================================
)

echo.
pause
