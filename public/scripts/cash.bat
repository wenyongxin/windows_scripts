@echo off
dir /a /s d:\dumps\|find "crash.txt" > nul
if %ERRORLEVEL% EQU 0 goto error
if %ERRORLEVEL% EQU 1 goto ok
:error
echo CRITICAL: find crash.txt please check it!
:ok
echo OK: no find crash.txt 
