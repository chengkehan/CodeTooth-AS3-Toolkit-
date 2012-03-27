@echo off
@echo 开始打包 codeTooth
compc -output %~dp0\codeTooth.swc -source-path %~dp0\..\src -include-sources %~dp0\..\src -external-library-path %~dp0\airglobal.swc %~dp0\framework.swc %~dp0\rpc.swc -define=CONFIG::DEBUG,true
@echo 打包 codeTooth 完成
pause