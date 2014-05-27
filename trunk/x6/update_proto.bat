::先转入当前盘(以前不需要的)
%~d0

cd %~dp0

set PROTO_PATH=proto
set PBC_PATH=pbc

svn update %PBC_PATH%
rd /s /q scripts\protocol\pbc
mkdir scripts\protocol\pbc
xcopy /y /s /q %PBC_PATH% scripts\protocol\pbc

svn update %PROTO_PATH%
xcopy /y /s /q %PROTO_PATH%\proto.conf scripts\protocol\proto.conf

pause
