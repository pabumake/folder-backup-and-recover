@echo off
setlocal enabledelayedexpansion
echo ******************************
echo Backup Folder and Recover 
echo Written by Patrick Mayer 2019
echo ******************************

set folderDate=%date:~-4%-%date:~-7,2%-%date:~-10,2%
set backupLocationBase=P:\folder-backup-and-recover\%folderDate%

goto getType

:: Select Type of Job
:getType
set /p type="(o)utlook signature, (f)avorites, (e)xcel macros or (all) for everything:"

if "%type%" == "o" ( 
    set backupTarget=C:\Users\%username%\AppData\Roaming\Microsoft\Signatures
    set backupLocation=%backupLocationBase%\outlook
)
if "%type%" == "f" ( 
    set backupTarget=C:\Users\%username%\Favorites
    set backupLocation=%backupLocationBase%\favorites
)
if "%type%" == "e" ( 
    set backupTarget=C:\Users\%username%\AppData\Roaming\Microsoft\Excel\XLSTART
    set backupLocation=%backupLocationBase%\office\XLSTART
)
if "%type%" == "all" (
    set len=6
    set backup[0].Target=C:\Users\%username%\AppData\Roaming\Microsoft\Signatures
    set backup[0].Location=%backupLocationBase%\outlook
    set backup[1].Target=C:\Users\%username%\Favorites
    set backup[1].Location=%backupLocationBase%\favorites
    set backup[2].Target=C:\Users\%username%\AppData\Roaming\Microsoft\Excel\XLSTART
    set backup[2].Location=%backupLocationBase%\office\XLSTART
	set backup[3].Target=C:\Users\%username%\Desktop
	set backup[3].Location=%backupLocationBase%\desktop
	set backup[4].Target=C:\Users\%username%\Documents
	set backup[4].Location=%backupLocationBase%\documents
	set backup[5].Target=C:\Users\%username%\Pictures
	set backup[5].Location=%backupLocationBase%\pictures
    set i=0
    goto looperman
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

echo BackupTarget "%backupTarget%\*"

xcopy "%backupTarget%\*" "%backupLocation%\" /SY
echo Backup done.
goto EOF

:: Recover Job
:recover_job
xcopy "%backupLocation%\" "%backupTarget%\" /SY
echo Recover done.
goto EOF

:looperman
set /p loop_action="(b)ackup or (r)ecover - (q)uit:"
if "%loop_action%" == "b" ( 
    goto looperman_b
)
if "%loop_action%" == "r" (
    goto looperman_r
)
if "%loop_action%" == "q" ( goto EOF )
if "%loop_action%" == "exit" ( goto EOF ) else ( goto wrong_input )

:looperman_b
if %i% equ %len% goto :EOF
set cur.Target=""
set cur.Location=""

for /f "usebackq delims==. tokens=1-3" %%j in (`set backup[%i%]`) do ( 
   set cur.%%k=%%l
) 
echo =================================================================

if exist %cur.Location% (
    echo %cur.Location% already exists.
) else (
    echo %cur.Location% not existent. Creating now..
    mkdir %cur.Location%
)

echo BackupTarget "%cur.Target%\*"

xcopy "%cur.Target%\*" "%cur.Location%\" /SY
echo Backup done.

echo =================================================================

set /a i = %i%+1
goto looperman_b

:looperman_r
if %i% equ %len% goto :EOF
set cur.Target=""
set cur.Location=""

for /f "usebackq delims==. tokens=1-3" %%j in (`set backup[%i%]`) do ( 
   set cur.%%k=%%l
) 
echo =================================================================

echo RestoreLocation "%cur.Location%\*"

xcopy "%cur.Location%\*" "%cur.Target%\" /SY
echo Backup done.

echo =================================================================

set /a i = %i%+1
goto looperman_r

:: Chatch all other Inputs. 
:wrong_input
echo Unrecognized input. Please check for a valid input.
goto getAction

:EOF
echo --EOF--
ping 127.0.0.1 -n 3 > nul
exit