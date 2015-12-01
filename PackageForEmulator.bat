@echo off

:: AIR application packaging
:: More information:
:: http://livedocs.adobe.com/flex/3/html/help.html?content=CommandLineTools_5.html#1035959

:: Path to Flex SDK and ANDROID binaries
set PATH=%PATH%;C:\dev\Flex4.5.0.19\bin
set PATH=%PATH%;D:\dev\android\tools

:: Signature (see 'CreateCertificate.bat')
set CERTIFICATE=SelfSigned.pfx
set SIGNING_OPTIONS=-storetype pkcs12 -keystore %CERTIFICATE%
if not exist %CERTIFICATE% goto certificate

:: Output APK
if not exist apk md apk
set APK_FILE=apk/OTimeSuite.apk

:: Input
set APP_XML=application.xml
set FILE_OR_DIR=-C bin .

echo Signing APK setup using certificate %CERTIFICATE%.
call adt -package -target apk-emulator %SIGNING_OPTIONS% %APK_FILE% %APP_XML% %FILE_OR_DIR%
if errorlevel 1 goto failed

echo.
echo APK setup created: %APK_FILE%
echo.

:: APK INSTALL
echo Installing package... %APK_FILE%
call adb install -r %APK_FILE%
if errorlevel 1 goto failed2

echo.
echo Android setup installed: %APK_FILE%
echo.
goto end

:certificate
echo Certificate not found: %CERTIFICATE%
echo.
echo Troubleshotting:
echo A certificate is required, generate one using 'CreateCertificate.bat'
echo.
goto end

:failed
echo AIR setup creation FAILED.
echo.
echo Troubleshotting:
echo did you configure the Air SDK path in this Batch file?
echo %PATH%
echo.

:failed2
echo Android install FAILED.
echo.

:end
pause