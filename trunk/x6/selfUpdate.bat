::先转入当前盘(以前不需要的)
%~d0

cd %~dp0

if exist assets\LuaHostWin32.exe ( copy /y assets\LuaHostWin32.exe LuaHostWin32.exe )
if exist assets\libquickcocos2dx.dll ( copy /y assets\libquickcocos2dx.dll libquickcocos2dx.dll )
if exist assets\LuaHostWin32.exe ( del /s /q assets\LuaHostWin32.exe )
if exist assets\libquickcocos2dx.dll ( del /s /q assets\libquickcocos2dx.dll )

start LuaHostWin32

exit
::pause