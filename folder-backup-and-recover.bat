@echo off
echo ******************************
echo Backup Folder and Recover 
echo Written by Patrick Mayer 2019
echo ******************************

set folderDate=%date:~-4%-%date:~-7,2%-%date:~-10,2%
set backupLocationBase=P:\folder-backup-and-recover\%folderDate%

goto getType

:: Select Type of Job
:getType
set /p type="(o)utlook signature, (f)avorites, (e)xcel macros:"

if "%type%" == "o" ( 
    set backupTarget = C:\Users\%username%\Favorites 
    set backupLocation = %backupLocationBase%\outlook
)
if "%type%" == "f" ( 
    set backupTarget = C:\Users\%username%\Favorites 
    set backupLocation = %backupLocationBase%\favorites
)
if "%type%" == "e" ( 
    set backupTarget = C:\Users\%username%\Favorites 
    set backupLocation = %backupLocationBase%\excel
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
if exist %backupLocation% (
    echo %backupLocation% already exists.
) else (
    echo %backupLocation% not existent. Creating now..
    mkdir %backupLocation%
)
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