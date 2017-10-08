@echo off

::用途：能够通过zabbix监控windows的防火墙状态
::编写人：温永鑫
::职位: 运维监控&运维开发主管
::编写日期：2017-10-8


set save_name="C:\zabbix\tmp\firewall_info.txt"

::将注册表制定项目导入到临时文件中
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" | find "EnableFirewall" > %save_name%

::读取临时文件的值，做字符分割
::关闭状态 0
::开启状态 1
for /f "tokens=3" %%a in ('type %save_name%') do set info=%%a
echo %info:~-1%
