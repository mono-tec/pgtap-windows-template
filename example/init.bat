@echo off
setlocal ENABLEDELAYEDEXPANSION

REM ============================================================
REM  init.bat - pgTAP 初期構築スクリプト
REM    - template\*.bat.tmpl  -> ルート直下 *.bat
REM    - template\*.sql.tmpl  -> sql\*.sql
REM    - 置換は tools\InnoReplacer.exe（1ペアずつ）
REM ============================================================

echo =============================================================
echo  pgTAP Test Environment Setup Tool
echo -------------------------------------------------------------
echo  1) 接続情報の入力
echo  2) テンプレをコピーして .bat / .sql を生成
echo  3) InnoReplacer でプレースホルダ置換
echo  ※生成物はリポジトリにコミットしないでください（.gitignore推奨）
echo =============================================================
echo.
pause

REM --- ツール/パス ---------------------------------------------
set "BASE=%~dp0"
if "%BASE:~-1%"=="\" set "BASE=%BASE:~0,-1%"
set "TPL=%BASE%\template"
set "OUT_ROOT=%BASE%"
set "OUT_SQL=%BASE%\sql"
set "REPLACER=%BASE%\tools\InnoReplacer.exe"

if not exist "%REPLACER%" (
  echo [ERROR] InnoReplacer.exe が見つかりません: %REPLACER%
  pause & exit /b 1
)
if not exist "%TPL%" (
  echo [ERROR] template フォルダが見つかりません: %TPL%
  pause & exit /b 1
)
if not exist "%OUT_SQL%" mkdir "%OUT_SQL%"

REM --- 既定値 ---------------------------------------------------
set "PGHOST=127.0.0.1"
set "PGPORT=5432"
set "PGUSER=postgres"
set "PGDATABASE=appdb_test"   REM ★テスト対象DB名
set "PGPASSWORD=postgres"

REM --- 入力 -----------------------------------------------------
set /p PGHOST=Host [default: %PGHOST%] ?:
if "%PGHOST%"=="" set "PGHOST=127.0.0.1"

set /p PGPORT=Port [default: %PGPORT%] ?:
if "%PGPORT%"=="" set "PGPORT=5432"

set /p PGUSER=User [default: %PGUSER%] ?:
if "%PGUSER%"=="" set "PGUSER=postgres"

set /p PGDATABASE=Test DB [default: %PGDATABASE%] ?:
if "%PGDATABASE%"=="" set "PGDATABASE=appdb_test"

set /p PGPASSWORD=Password [default: %PGPASSWORD%] ?:
if "%PGPASSWORD%"=="" set "PGPASSWORD=postgres"

echo.
echo [INFO] 入力内容:
echo   Host:  %PGHOST%
echo   Port:  %PGPORT%
echo   User:  %PGUSER%
echo   Test DB: %PGDATABASE%
echo   Password: (非表示)
echo.
choice /c YN /m "この内容でテンプレ展開しますか？"
if errorlevel 2 ( echo キャンセルしました。 & pause & exit /b 0 )
echo.

REM ============================================================
REM  1) BAT テンプレート -> ルート直下（出力: Shift-JIS）
REM    - *.bat.tmpl -> *.bat
REM ============================================================
for %%F in ("%TPL%\*.bat.tmpl") do (
  set "SRC=%%~fF"
  set "DST=%OUT_ROOT%\%%~nF"

  echo [COPY]  %%~nxF  ->  !DST!
  copy /Y "!SRC!" "!DST!" >nul || (echo [ERROR] コピー失敗 & pause & exit /b 1)

  echo [REPLACE][SJIS] !DST!
  "%REPLACER%" "!DST!" "#PGHOST#"     "%PGHOST%"     sjis || (echo [ERROR] PGHOST置換失敗 & pause & exit /b 1)
  "%REPLACER%" "!DST!" "#PGPORT#"     "%PGPORT%"     sjis || (echo [ERROR] PGPORT置換失敗 & pause & exit /b 1)
  "%REPLACER%" "!DST!" "#PGUSER#"     "%PGUSER%"     sjis || (echo [ERROR] PGUSER置換失敗 & pause & exit /b 1)
  "%REPLACER%" "!DST!" "#PGDATABASE#" "%PGDATABASE%" sjis || (echo [ERROR] PGDATABASE置換失敗 & pause & exit /b 1)
  "%REPLACER%" "!DST!" "#PGPASSWORD#" "%PGPASSWORD%" sjis || (echo [ERROR] PGPASSWORD置換失敗 & pause & exit /b 1)
  echo [OK]    !DST!
)

REM ============================================================
REM  2) SQL テンプレート -> sql\ 配下（出力: UTF-8(無BOM)）
REM    - *.sql.tmpl -> *.sql
REM ============================================================
for %%F in ("%TPL%\*.sql.tmpl") do (
  set "SRC=%%~fF"
  set "DST=%OUT_SQL%\%%~nF"

  echo [COPY]  %%~nxF  ->  !DST!
  copy /Y "!SRC!" "!DST!" >nul || (echo [ERROR] コピー失敗 & pause & exit /b 1)

  echo [REPLACE][UTF-8] !DST!
  "%REPLACER%" "!DST!" "#PGDATABASE#" "%PGDATABASE%" utf8 || (echo [ERROR] PGDATABASE置換失敗 & pause & exit /b 1)
  "%REPLACER%" "!DST!" "#PGUSER#"     "%PGUSER%"     utf8 >nul 2>&1
  "%REPLACER%" "!DST!" "#PGHOST#"     "%PGHOST%"     utf8 >nul 2>&1
  "%REPLACER%" "!DST!" "#PGPORT#"     "%PGPORT%"     utf8 >nul 2>&1
  echo [OK]    !DST!
)

echo.
echo =============================================================
echo [DONE] 初期構築が完了しました。
echo  - ルート直下: *.bat 生成
echo  - sql\ 配下: *.sql 生成
echo =============================================================
pause
exit /b 0
