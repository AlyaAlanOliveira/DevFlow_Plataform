@echo off
echo ========================================
echo DevFlow ALYA - Iniciando Backend
echo ========================================
echo.

cd backend

echo [1/3] Ativando ambiente virtual...
call venv\Scripts\activate.bat

echo [2/3] Verificando dependencias...
pip list | findstr fastapi >nul
if errorlevel 1 (
    echo Instalando dependencias...
    pip install -r requirements.txt
)

echo [3/3] Iniciando servidor...
echo.
echo Backend disponivel em: http://localhost:8000
echo Swagger UI: http://localhost:8000/docs
echo.
python run.py

pause
