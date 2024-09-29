@echo off
setlocal

:: Nome do arquivo Python a ser compilado
set SCRIPT_NAME=print_preguica.py

:: Verifica se o PyInstaller está instalado
python -c "import PyInstaller" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo PyInstaller não está instalado. Instalando...
    pip install pyinstaller
)

echo Compilando o script %SCRIPT_NAME%...
pyinstaller --onefile --distpath . %SCRIPT_NAME%

if %ERRORLEVEL% NEQ 0 (
    echo Erro na compilação.
    exit /b %ERRORLEVEL%
)

echo Limpando arquivos desnecessários...
if exist build (
    rmdir /S /Q build
)
if exist __pycache__ (
    rmdir /S /Q __pycache__
)

if exist print_preguica.spec (
    del print_preguica.spec
)

echo Limpeza concluída.
echo Compilação e limpeza concluídas com sucesso.

endlocal
