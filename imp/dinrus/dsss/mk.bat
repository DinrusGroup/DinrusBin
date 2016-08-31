:again
dinrus
del *.exe
ls2 -d .\*.d>>objs.rsp
dmd  -O -release -ofdsss.exe build.d clean.d conf.d genconfig.d install.d main.d net.d platform.d system.d uninstall.d ..\base\exe\Resources\dinrus.res import.lib
upx dsss.exe
::copy dsss.exe %DINRUS%
pause
:goto again