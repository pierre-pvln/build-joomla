:: Name:     _build_extension_zip.cmd
:: Purpose:  Create the extension zip file which can be installed in a Joomla! website
:: Author:   pierre@pvln.nl
::
:: Required environment variables
:: ==============================
::
:: NONE
::
:: struc_utils_folder        ..\struc\utils\
:: global_settings_folder    ..\_set\
:: source_code_folder        ..\code\src\
:: update_server_folder      ..\code\src\update_server
::
@ECHO off
SETLOCAL ENABLEEXTENSIONS

:: BASIC SETTINGS
:: ==============
:: Setting the name of the script
SET me=%~n0
:: Setting the name of the directory with this script
SET parent=%~p0
:: Setting the drive of this commandfile
SET drive=%~d0
:: Setting the directory and drive of this commandfile
SET cmd_dir=%~dp0
::
:: (re)set environment variables
::
SET VERBOSE=YES
::
:: Setting for Error messages
::
SET ERROR_MESSAGE=errorfree

:: STATIC VARIABLES
:: ================

ECHO %cmd_dir%

CD "%cmd_dir%"
:: struc_utils_folder
CD ..\struc\utils\
IF EXIST name.cmd (
   CALL name.cmd
) ELSE (
   SET ERROR_MESSAGE=[ERROR] [%~n0 ] file with extension name settings doesn't exist ...
   GOTO ERROR_EXIT
)

CD "%cmd_dir%"
:: struc_utils_folder
CD ..\struc\utils\
IF EXIST version.cmd (
   CALL version.cmd
) ELSE (
   SET ERROR_MESSAGE=[ERROR] [%~n0 ] file with version info settings doesn't exist ...
   GOTO ERROR_EXIT
)

CD "%cmd_dir%"
:: global_settings_folder
CD ..\_set\
IF EXIST folders.cmd (
   CALL folders.cmd
) ELSE (
   SET ERROR_MESSAGE=[ERROR] [%~n0 ] file with folder settings doesn't exist ...
   GOTO ERROR_EXIT
)

:: STATIC VARIABLES
:: ================

:: Check if required environment variables are set correctly
::
IF "%extension%"=="" (
   SET ERROR_MESSAGE=[ERROR] [%~n0 ] extension not defined in ..\struc\utils\name.cmd ...
   GOTO ERROR_EXIT
   )

IF "%version%"=="" (
   SET ERROR_MESSAGE=[ERROR] [%~n0 ] version not defined in ..\struc\utils\version.cmd ...
   GOTO ERROR_EXIT
   )

IF "%output_dir%"=="" (
   SET ERROR_MESSAGE=[ERROR] [%~n0 ] output_dir not defined in ..\_set\folders.cmd ...
   GOTO ERROR_EXIT
   )

IF "%backup_dir%"=="" (
   SET ERROR_MESSAGE=[ERROR] [%~n0 ] backup_dir not defined in ..\_set\folders.cmd ...
   GOTO ERROR_EXIT
   )
   
CD "%cmd_dir%"

:: Sets the proper date and time stamp with 24Hr Time for log file naming convention
:: source http://stackoverflow.com/questions/1192476/format-date-and-time-in-a-windows-batch-script
::
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~9,4%%date:~6,2%%date:~3,2%_0%time:~1,1%%time:~3,2%%time:~6,2%
SET dtStamp24=%date:~9,4%%date:~6,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%
IF "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) ELSE (SET dtStamp=%dtStamp24%)

:: Als er al extension bestand bestaat copieer het dan naar de back-up directory en geef het dan een nieuwe naam.
:: Dat zorgt ervoor dat er altijd een correct module bestand gemaakt wordt.
:: Indien het zip bestand namelijk al bestaat worden alleen bestanden/mappen toegevoegd maar niet verwijderd als ze niet meer nodig zijn
::
IF EXIST "%output_dir%\%extensionprefix%%extension%_%version%.zip" (
	:: check if back_up directory exists
	IF NOT EXIST "%backup_dir%" (md "%backup_dir%")
	COPY "%output_dir%\%extensionprefix%%extension%_%version%.zip" "%backup_dir%\%extensionprefix%%extension%_%version%_%dtStamp%.zip"
	DEL  "%output_dir%\%extensionprefix%%extension%_%version%.zip"
)

:: Copy files for update server
:: /y = don't prompt when overwriting files from source that already exist in destination.
::
:: update_server_folder
xcopy ..\code\src\update_server\* "%output_dir%\" /y

ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Start creating the %extensionprefix%%extension%_%version%.zip extension file
ECHO %me%: **************************************
ECHO.

:: Create the installable extension zip file
:: 
"C:\Program Files\7-Zip\7z.exe" a -tzip "%output_dir%\%extensionprefix%%extension%_%version%.zip" "..\code\src\*" -xr@"..\code\set\files_to_exclude_in_zip.txt"

ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Done creating the %extensionprefix%%extension%_%version%.zip extension file
ECHO %me%: **************************************
ECHO.

GOTO CLEAN_EXIT

:ERROR_EXIT
cd "%cmd_dir%" 
ECHO *******************
ECHO %ERROR_MESSAGE%
ECHO *******************

   
:CLEAN_EXIT   
:: Wait some time and exit the script
::
timeout /T 10
