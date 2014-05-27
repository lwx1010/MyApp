::先转入当前盘(以前不需要的)
%~d0

cd %~dp0

if not "%1"=="" ant -buildfile %1
if "%1"=="" ant