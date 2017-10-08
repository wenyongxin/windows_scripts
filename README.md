说明：

该目录中的脚本一切围绕这zabbix监控实现。因为windows默认支持的脚本编写只有bat与vb相对比较好些。如果要使用其它的编程语言要进行安装配置。使用bat能够提高效率减少不必要的重复性操作


check_firewall.bat

zabbix可以通过该脚本获取当前windows主机的防火墙的状态。
返回值 0 关闭
返回值 1 开启



discovery_interface_windows.bat

zabbix可以通过该脚本获取windows的网卡事情，结合snmpwalk工具能够自动的区分内/外网卡名称标记，实现网卡的分离



欢迎各位技术人员共同交流：
QQ号：576147914
