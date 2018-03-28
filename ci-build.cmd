@echo off
cd %~dp0
SETLOCAL

SET DIST_DIR=%APPVEYOR_BUILD_FOLDER%\dist\
SET DIST_SRC_DIR=%DIST_DIR%Source\
SET REPO_URL=https://github.com/%APPVEYOR_REPO_NAME%.git

:: Do normal build
ECHO
ECHO ## Build dist
ECHO
CALL npm run dist

:: Build sources for reviewers
ECHO
ECHO ## Build sources
ECHO
CALL git clone --branch=%APPVEYOR_REPO_BRANCH% %REPO_URL% %DIST_SRC_DIR%
cd %DIST_SRC_DIR%
CALL git checkout %APPVEYOR_REPO_COMMIT%
CALL git submodule update --init --recursive
DEL /S %DIST_SRC_DIR%.git\objects\pack\*
cd %DIST_DIR%
CALL 7z a browser-source-%APPVEYOR_BUILD_NUMBER%.zip %DIST_SRC_DIR%\*
cd %APPVEYOR_BUILD_FOLDER%