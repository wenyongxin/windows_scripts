@echo off

::用途：执行该脚本能够自动在windows上安装zabbix-agent客户端与snmp
::注意：需要建立一个源站（网络磁盘），实现异地数据的拷贝
::efun-monitor-instal-win2008 public 会在单独目录中展示
::编写人：温永鑫
::职位: 运维监控&运维开发主管
::编写日期：2015-3-12

color 9f
set url=\\tsclient\myshare\efun-monitor-instal-win2008
set pub=\\tsclient\myshare\public
::zabbix server的ip地址等
set proxy_ips=127.0.0.1
for /f "tokens=2 delims=:" %%i in ('ipconfig^|find "IPv4"') do (set /p a=%%i <nul && set ip=%a%) >> 1.txt
set /p ip=< 1.txt
echo %ip%
del 1.txt
mkdir c:\zabbix
mkdir c:\zabbix\zabbix_agentd.conf.d\
mkdir c:\zabbix\scripts\
mkdir c:\zabbix\tmp\
copy /y %pub%\Efun.conf c:\zabbix\zabbix_agentd.conf.d\
copy /y %pub%\scripts c:\zabbix\scripts\
copy /y %pub%\WinRAR.exe c:\
copy /y %pub%\usr.zip c:\
copy /y %pub%\iconv.exe c:\zabbix\scripts\
c:\WinRAR.exe x c:\usr.zip c:\
del c:\WinRAR.exe
del c:\usr.zip
echo Server=%proxy_ips% >> c:\zabbix\zabbix_agentd.win.conf
echo LogFile=c:\zabbix\zabbix_agentd.log >> c:\zabbix\zabbix_agentd.win.conf
echo StartAgents=10>> c:\zabbix\zabbix_agentd.win.conf
echo Include=c:\zabbix\zabbix_agentd.conf.d\ >> c:\zabbix\zabbix_agentd.win.conf
echo UnsafeUserParameters=1 >> c:\zabbix\zabbix_agentd.win.conf
echo Timeout=30 >> c:\zabbix\zabbix_agentd.win.conf
echo Hostname=%ip:~0,15% >> c:\zabbix\zabbix_agentd.win.conf
echo ServerActive=%1:10928 >> c:\zabbix\zabbix_agentd.win.conf
echo HostMetadataItem=system.uname >> c:\zabbix\zabbix_agentd.win.conf
if %processor_architecture% EQU x86 copy /y %pub%\bin\win32 C:\zabbix\
if %processor_architecture% EQU AMD64 copy /y %pub%\bin\win64 C:\zabbix\
C:\zabbix\zabbix_agentd.exe -i -c C:\zabbix\zabbix_agentd.win.conf
net start "Zabbix Agent"
sc config "Zabbix Agent" start= auto
echo ==================== Install SNMP for win2008 ====================
copy /y %url%\install-snmp.ps1 c:\
for /f "tokens=4 delims= " %%a in ('wmic os get Caption^|findstr "[0-9]"') do set sys=%%a
if %sys:~0,4%==2008 servermanagercmd -install "SNMP-Services"
if %sys:~0,4%==2012 C:\Windows\System32\WindowsPowerShell\v1.0\powershell -executionPolicy unrestricted c:\install-snmp.ps1
del c:\install-snmp.ps1
net stop SNMP
reg import %url%\snmp.reg
net start SNMP

::配置防火墙
echo ==================== Check Friewall =====================
netsh advfirewall firewall add rule name="zabbix_port10050_from_EFUN" dir=in protocol=tcp localport=10050 remoteip=%proxy_ips% action=allow
netsh advfirewall firewall add rule name="snmp_port161_from_EFUN" dir=in protocol=udp localport=161 remoteip=%proxy_ips% action=allow
netsh firewall set icmpsetting all enable

::注销当前登录用户
echo ================== exit Remote desktop ===================
for /f "tokens=3 delims= " %%b in ('query session^|find /i "Administrator"^|find /i "rdp-tcp"') do set pid=%%b
logoff %pid%
