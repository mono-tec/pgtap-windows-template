@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM  pgTAP Installer for Windows (version-agnostic)
REM  - Copies pgTAP extension files into share\extension
REM  - Requires: pgtap.control + pgtap--<version>.sql (any version)
REM  Author: mono-tec   Last Update: 2025-10-31
REM ============================================================

:: 管理者権限チェック
net session >nul 2>&1
if %errorLevel% neq 0 (
  echo [ERROR] 管理者権限で実行してください。右クリック→「管理者として実行」
  pause & exit /b 1
)

echo =============================================================
echo  pgTAP Installer for Windows
echo  - pgtap.control と pgtap--*.sql を PostgreSQL へ配置します
echo =============================================================
choice /c YN /m "続行しますか？"
if errorlevel 2 ( echo キャンセルしました。 & pause & exit /b 0 )
echo.

REM ★必要に応じて手動で変更
set "PGROOT=C:\Program Files\PostgreSQL\17"

if not exist "%PGROOT%\share\extension" (
  echo [ERROR] share\extension が見つかりません: "%PGROOT%\share\extension"
  echo [HINT] PostgreSQL のインストール先/版を確認して PGROOT を修正してください。
  pause & exit /b 1
)

REM 配置（バージョンはファイル名で任意に対応）
copy /Y "%~dp0pgtap.control" "%PGROOT%\share\extension\" >nul
copy /Y "%~dp0pgtap--*.sql"   "%PGROOT%\share\extension\" >nul

echo [INFO] Installed into: "%PGROOT%\share\extension"
for %%F in ("%~dp0pgtap--*.sql") do echo [INFO] Copied: %%~nxF
echo.

echo [NEXT STEP]
echo   psql / pgAdmin で対象DBに接続し、次を実行:
echo     CREATE EXTENSION IF NOT EXISTS pgtap^;
echo.
echo [INFO] 完了しました。Enterキーで閉じます。
pause
exit /b 0