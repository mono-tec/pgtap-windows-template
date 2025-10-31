@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM  pgTAP Uninstaller (version-aware by filename)
REM  - Looks for pgtap--*.sql in this folder, and deletes the
REM    same-named file under %PGROOT%\share\extension
REM  - Does NOT remove pgtap.control (shared by all versions)
REM ============================================================

:: 管理者権限チェック
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo [ERROR] 管理者権限で実行してください。右クリック→「管理者として実行」
  pause & exit /b 1
)

echo =============================================================
echo  pgTAP Uninstaller for Windows
echo  - pgtap--*.sql(フォルダに含まれるもの) を PostgreSQL から削除します
echo =============================================================
choice /c YN /m "続行しますか？"
if errorlevel 2 ( echo キャンセルしました。 & pause & exit /b 0 )
echo.


:: ★環境に合わせて変更
set "PGROOT=C:\Program Files\PostgreSQL\17"
set "EXTDIR=%PGROOT%\share\extension"

if not exist "%EXTDIR%" (
  echo [ERROR] share\extension が見つかりません: "%EXTDIR%"
  pause & exit /b 1
)

:: pgtap--*.sql を検出
set "TARGET="
for %%F in ("%~dp0pgtap--*.sql") do set "TARGET=%%~nxF"

if not defined TARGET (
  echo [ERROR] カレントフォルダに pgtap--*.sql が見つかりません。
  echo        対象バージョンのファイルを置いてから再実行してください。
  pause & exit /b 1
)

echo.
echo [CONFIRM] 次のファイルを削除します:
echo   "%EXTDIR%\%TARGET%"
choice /c YN /m "よろしいですか？"
if errorlevel 2 ( echo キャンセルしました。 & pause & exit /b 0 )

:: 削除実行
if exist "%EXTDIR%\%TARGET%" (
  del "%EXTDIR%\%TARGET%" >nul 2>&1
  if errorlevel 1 (
    echo [ERROR] 削除に失敗しました。権限/ロック状態を確認してください。
    pause & exit /b 1
  ) else (
    echo [INFO] 削除完了: %TARGET%
  )
) else (
  echo [WARN] 既に存在しません: %TARGET%
)

echo.
echo [NOTE] pgtap.control は他バージョン共通のため削除していません。
echo        全バージョンを完全に削除する場合のみ手動で削除してください。
pause
exit /b 0
