@echo off
echo ========================================
echo DevFlow ALYA - Iniciando Frontend
echo ========================================
echo.

cd frontend

echo [1/2] Verificando dependencias...
if not exist "node_modules" (
    echo Instalando dependencias...
    call npm install
)

echo [2/2] Iniciando servidor de desenvolvimento...
echo.
echo Frontend disponivel em: http://localhost:5173
echo.
call npm run dev

pause
