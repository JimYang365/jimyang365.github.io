@echo off

rem *********************************************************************************
rem A stable network environment, this is a must. Need python2, not py3, and LLVM
rem https://skia.org/docs/
rem https://skia.org/docs/user/build/

rem ninja
rem git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
rem add depot_tools to PATH

rem get source code
rem git clone https://skia.googlesource.com/skia.git
rem add skia\bin to PATH

rem cd skia and start building
rem git-sync-deps
rem c:\Python27\python.exe tools/git-sync-deps
rem *********************************************************************************

rem MY_PY_PATH=c:\Users\DELL\AppData\Local\Programs\Python\Python39
rem MY_PY_PATH=c:\Python27
rem c:\Users\DELL\AppData\Local\Programs\Python\Python39\Scripts
rem c:\Users\DELL\AppData\Local\Programs\Python\Python39
rem c:\Python27\Scripts
rem c:\Python27


SET PY_PATH="c:\Python27\python.exe"

rem create output folder
SET OUTPUT_FOLDER=outWin32
echo [32m----create ouput folder %OUTPUT_FOLDER%----[0m

rd /s /Q %OUTPUT_FOLDER%
md %OUTPUT_FOLDER% && cd %OUTPUT_FOLDER%
md lib && cd lib
md debugx64 && md debugx86 && md releasex64 && md releasex86
cd ..\..\

rem generate temp py
SET TEMP_PY_FILE=buildWin32.py
del /Q %TEMP_PY_FILE%
echo import re >> %TEMP_PY_FILE%
echo import sys >> %TEMP_PY_FILE%
echo fileName = sys.argv[1] >> %TEMP_PY_FILE%
echo f=open(fileName,"r+") >> %TEMP_PY_FILE%
echo s=f.read() >> %TEMP_PY_FILE%
echo f.seek(0, 0) >> %TEMP_PY_FILE%
echo f.truncate() >> %TEMP_PY_FILE%
echo f.write(s.replace("cmd.exe /c  C:/Program Files (x86)/Windows Kits/10/bin/SetEnv.cmd /x86 &&"," ")) >> %TEMP_PY_FILE%

rem build
echo [32m----building debugx86----[0m
bin\gn gen %OUTPUT_FOLDER%/debugx86 --args=" is_debug=true  target_cpu=\"x86\" clang_win=\"C:\Program Files\LLVM\"  extra_cflags=[\"/MDd\"]"
call %PY_PATH% %TEMP_PY_FILE% %OUTPUT_FOLDER%/debugx86/toolchain.ninja
ninja -C %OUTPUT_FOLDER%/debugx86

echo [32m----building releasex86----[0m
bin\gn gen %OUTPUT_FOLDER%/releasex86 --args=" is_debug=false  target_cpu=\"x86\" clang_win=\"C:\Program Files\LLVM\"  extra_cflags=[\"/MD\"]"
call %PY_PATH% %TEMP_PY_FILE% %OUTPUT_FOLDER%/releasex86/toolchain.ninja
ninja -C %OUTPUT_FOLDER%/releasex86

echo [32m----building debugx64----[0m
bin\gn gen %OUTPUT_FOLDER%/debugx64 --args="is_debug=true target_cpu=\"x64\"  clang_win=\"C:\Program Files\LLVM\" extra_cflags=[\"/MDd\"]"
ninja -C %OUTPUT_FOLDER%/debugx64

echo [32m----building releasex64----[0m
bin\gn gen %OUTPUT_FOLDER%/releasex64 --args="is_debug=false target_cpu=\"x64\" clang_win=\"C:\Program Files\LLVM\"  extra_cflags=[\"/MD\"]"
ninja -C %OUTPUT_FOLDER%/releasex64

rem copy libs
echo [32m----copy libs to %OUTPUT_FOLDER%\lib\----[0m
copy /Y %OUTPUT_FOLDER%\debugx86\*.lib %OUTPUT_FOLDER%\lib\debugx86\
copy /Y %OUTPUT_FOLDER%\releasex86\*.lib %OUTPUT_FOLDER%\lib\releasex86\
copy /Y %OUTPUT_FOLDER%\debugx64\*.lib %OUTPUT_FOLDER%\lib\debugx64\
copy /Y %OUTPUT_FOLDER%\releasex64\*.lib %OUTPUT_FOLDER%\lib\releasex64\

rem remove temp py
del /Q %TEMP_PY_FILE%

echo [32m----done----[0m
