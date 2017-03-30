@echo off
color 0a
title 开启IE代理
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d "http://0.0.0.0/proxy.pac" /f
