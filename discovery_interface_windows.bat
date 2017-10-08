@echo off

::用途：能够通过zabbix能够通过snmp协议自动区分内外网网卡
::编写人：温永鑫
::职位: 运维监控&运维开发主管
::编写日期：2016-5-10


set IP=%1
set Lo=127.0.0.1
set snmpwalk=C:\usr\bin\snmpwalk.exe

for /f "tokens=4 delims= " %%o in ('%snmpwalk% -v 2c -c efun %Lo% .1.3.6.1.2.1.4.20.1.2^|find /i "%IP%"') do for /f "tokens=3 delims=:" %%a in ('%snmpwalk% -v 2c -c efun %Lo% .1.3.6.1.2.1.2.2.1.2.%%o') do set out=%%a

for /f "tokens=4 delims= " %%i in ('%snmpwalk% -v 2c -c efun %Lo% .1.3.6.1.2.1.4.20.1.2^|find /v "%IP%"^|find /v "%Lo%"') do for /f "tokens=3 delims=:" %%b in ('%snmpwalk% -v 2c -c efun %Lo% .1.3.6.1.2.1.2.2.1.2.%%i') do set in=%%b


for /f "tokens=4 delims= " %%a in ('wmic os get Caption^|findstr "[0-9]"') do set sys=%%a

if %sys:~0,4%==2012 goto change
if %sys:~0,4%==2008 goto default
if %sys:~0,4%==2003 goto default



:default
echo {"data":[{"{#IFNAME_IN}":"%in:~1%","{#IFNAME_OUT}":"%out:~1%"}]}
exit


:change
echo {"data":[{"{#IFNAME_IN}":"%in:~1%","{#IFNAME_OUT}":"%out:~1%"}]} > c:\zabbix\tmp\info.txt
C:\zabbix\scripts\iconv.exe -f GBK -t UTF-8 c:\zabbix\tmp\info.txt > c:\zabbix\tmp\info2.txt
set /p info=<c:\zabbix\tmp\info2.txt
echo %info%
exit
