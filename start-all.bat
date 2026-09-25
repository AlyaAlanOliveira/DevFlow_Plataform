@echo off
echo ========================================
echo DevFlow ALYA - Iniciando Sistema Completo
echo ========================================
echo.
echo Este script ira abrir 2 janelas:
echo 1. Backend (Python/FastAPI)
echo 2. Frontend (Vue 3/Vite)
echo.
echo Aguarde alguns segundos...
echo.

start "DevFlow Backend" cmd /k "cd backend && venv\Scripts\activate && python run.py"
timeout /t 5 /nobreak >nul

start "DevFlow Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo ========================================
echo Sistema iniciado!
echo ========================================
echo.
echo Backend: http://localhost:8000/docs
echo Frontend: http://localhost:5173
echo.
echo Pressione qualquer tecla para fechar esta janela...
pause >nul
