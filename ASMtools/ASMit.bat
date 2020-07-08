@echo off
:: GB 2312
:: %1Ϊ��Ҫ�������ļ� %2Ϊѡ��ִ������ķ�ʽ %3Ϊ��๤�ߺ�dosbox�����ļ��� 
::���������Ϣ
if "%~f1" NEQ "" goto SetValues
    echo "asmit.bat <file> [<mode>] [<toolsdir>]"
    echo "<file> file to be used "
    echo "<mode> choose mode the way display default is 1"
    echo "0 copy the files open dosbox add path"
    echo "1 tasm run output in shell"
    echo "2 tasm run output in dosbox"
    echo "3 tasm run pause exit"
    echo "4 tasm run and td"
    echo "5 masm run ouput in shell"
    echo "6 masm run output in dosbox"
    echo "7 masm run pause exit"
    echo "8 masm and debug"
    echo "A open turbo debugger at test folder"
    echo "B open masm debug at test folder"
    echo "<toolsdir> the tools folder with subdir masm,tasm,test"
    goto end
:SetValues
set "cdo=%CD%"
set "file=%~f1"
set "mode=1"
set "tool=%~dp0"
    :: �����в������ļ���ŵ�λ��**�������޸�**
    set "test=%tool%test\"
    if not exist %test% mkdir %test%
    ::dosboxʹ�õ����resolution�������ļ�
    set "bigboxconf=%tool%dosbox\bigbox.conf" 
    ::TASM���Թ���TD�������ļ�
    set "TDconfig=%tool%tasm\TDC2.td"
    ::dosbox·������Ҫ��ʹ�õ�һЩ����
    set "dosbox=%tool%dosbox\DOSBox.exe"
    set mcd=-noautoexec -noconsole ^
    -c "mount c \"%tool%\"" -c "mount d \"%test%\"" ^
    -c "set path=C:\TASM;C:\masm" -c "d:"
        ::���������������
        if "%2" neq "" set "mode=%2"
        if "%3" neq "" set "tool=%~f3"

:OutputInfo
    echo Time:%time%
    echo ASMtoolsfrom:%tool%
    echo Mode:%mode% ASMfilefrom:%file%
::����dosbox��׼������
cd %test%
echo =========
    :ModeSelect
        if %mode%==A goto dealA
        if %mode%==B goto dealB
    ::���л��֮ǰ��׼��������������ʱ�ļ���д�뵱ǰ�ļ�
    if "%~x1"==".ASM" goto NEXT
    if "%~x1"==".asm" goto NEXT
    echo %~x1 is not a supported assembly file
    goto end
    :NEXT
        if not exist "%file%" echo no such file && goto end
        if exist T.* del T.*
        copy "%file%" T.ASM
        if "%mode%"=="0" goto deal0 
        if "%mode%"=="1" goto deal1 
        if "%mode%"=="2" goto deal2 
        if "%mode%"=="3" goto deal3 
        if "%mode%"=="4" goto deal4 
        if "%mode%"=="5" goto deal5 
        if "%mode%"=="6" goto deal6 
        if "%mode%"=="7" goto deal7 
        if "%mode%"=="8" goto deal8 
    echo invalid mode %mode%
    goto end

:deal0
    echo *Copy file to Test folder and dosbox at the folder
    %dosbox% %mcd% -conf %bigboxconf%^
    -c "dir"
    goto end
:deal1
    echo *Output in terminal
    echo [DOSBOX] OUTPUT:
    %dosbox% %mcd% ^
    -c "tasm/zi T.ASM>>T.txt"^
    -c "if exist T.OBJ tlink/v/3 T>>T.txt"^
    -c "if exist T.EXE T>T.out"^
    -c "EXIT"
    ::����������ǰ�������������ո�
    FOR /F "eol=; tokens=* delims=, " %%i in (T.txt) do echo   %%i
    if exist T.OUT echo [YOUR program] OUTPUT:
    ::TODO ��ʾ���н������֪���ɲ�����ʵ��ͬʱ��ӡ�к�
    FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
    goto end
:deal2
    echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %dosbox% -conf "%bigboxconf%" %mcd% ^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"
    goto end
:deal3
    echo *Output in dosbox ��press any key to exit dosbox
    %dosbox% -conf "%bigboxconf%" %mcd%^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"^
    -c "pause" -c "exit"
    goto end
:deal4
    echo *Tasm and turbo debugger in dosbox
    if exist "%TDconfig%" copy "%TDconfig%" TDCONFIG.TD
    %dosbox% -conf "%bigboxconf%" %mcd%^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"^
    -c "Td t"
    goto end
:deal5
    echo *Output in terminal
    echo [DOSBOX] OUTPUT:
    %dosbox% %mcd%^
    -c "masm T.ASM;>T.txt"^
    -c "if exist T.OBJ link T.obj;>>T.txt"^
    -c "if exist T.EXE T>T.out"^
    -c "exit"
    FOR /F "eol=; tokens=* delims=, " %%i in (T.txt) do echo   %%i
    if exist T.OUT echo [YOUR program] OUTPUT:
    FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
    goto end
:deal6
    echo *Output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %dosbox% -conf "%bigboxconf%" %mcd% ^
    -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"
    goto end
:deal7
    echo *Output in dosbox ��press any key to exit dosbox
    %dosbox% -conf "%bigboxconf%" %mcd%^
    -c "masm T.ASM;" -c "link T.OBJ;"-c "T.EXE"^
    -c "pause" -c "exit"
    goto end
:deal8
    echo *Masm and debug in dosbox
    %dosbox% -conf "%bigboxconf%" %mcd%^
    -c "masm T.ASM;" -c "link T.OBJ;"^
    -c "debug T.EXE"
    goto end
:dealA
    if not exist T.EXE  echo no EXE file && goto end
    echo *Turbo debugger without tasm first in dosbox
    if exist "%TDconfig%" copy "%TDconfig%" TDCONFIG.TD
    %dosbox% -conf "%bigboxconf%" %mcd%-c "td t"
    goto end
:dealB
    if not exist T.EXE  echo no EXE file && goto end
    echo *Masm debugg without tasm first in dosbox
    %dosbox% -conf "%bigboxconf%" %mcd%-c "debug t.exe"
    goto end
:end
cd %cdo%