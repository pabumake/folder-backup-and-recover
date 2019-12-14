@echo off
echo ******************************
echo Backup Folder and Recover 
echo Written by Patrick Mayer 2019
echo ******************************

:echo User: %username%

set folderDate=%date:~-4%-%date:~-7,2%-%date:~-10,2%
set backupLocationBase=P:\folder-backup-and-recover
:set backupTarget=C:\Users\%username%\Favorites

:echo Location: %backupLocation%
:echo Target: %backupTarget%

:: Check for Arguments. If not given => getAction is called.
:: Arguments:   b => Backup
::              r => Recover

if ["%~1"]==[] goto getAction
if ["%~1"]==["b"] goto backup_job
if ["%~1"]==["r"] goto recover_job

goto getType

:: Select Type of Job
:getType
set /p type="(o)utlook signature, (f)avourites:"

if "%type%" == "o" ( 
    set backupTarget = C:\Users\%username%\Favorites 
    set backupLocation = %backupLocationBase%\outlook
)
if "%type%" == "f" ( 
    set backupTarget = C:\Users\%username%\Favorites 
    set backupLocation = %backupLocationBase%\outlook
)
if "%type%" == "q" ( goto EOF )
if "%type%" == "exit" ( goto EOF ) else ( goto wrong_input )
goto getAction

:: Select if backup or recovery
:getAction
set /p action="(b)ackup or (r)ecover - (q)uit:"

if "%action%" == "b" ( goto backup_job )
if "%action%" == "r" ( goto recover_job )
if "%action%" == "q" ( goto EOF )
if "%action%" == "exit" ( goto EOF ) else ( goto wrong_input )

:: Backup Job
:backup_job
mkdir %backupLocation%
xcopy "%backupTarget%\*" "%backupLocation%\" /SY
echo Backup done.
goto EOF

:: Recover Job
:recover_job
xcopy "%backupLocation%\*" "%backupTarget%\" /SY
echo Recover done.
goto EOF

:: Chatch all other Inputs. 
:wrong_input
echo Unrecognized input. Please check for a valid input.
goto getAction

:EOF
echo --EOF--
ping 127.0.0.1 -n 3 > nul
exit