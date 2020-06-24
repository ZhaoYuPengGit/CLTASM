@echo off
REM %1Ϊѡ��ִ������ķ�ʽ %2Ϊ��������Ŀ¼ %3Ϊ��Ҫ�������ļ�
set  bb=\ASM\TASM
set  cc=\ASM\Dosbox\
set "aa=%2%bb%"
set "dd=%2%cc%"

echo workspaceRoot:%2
echo ASMfilefrom:%3
echo ASMtoolsfrom:%aa%
cd %aa%
if %1==4 goto D
if exist T.* del T.*>nul
copy %3 T.ASM>nul
if %1==0 goto deal0 REM ���ն�����������code runnerû���������ն������еĻ����������������
if %1==1 goto deal1 REM ��dosbox�л����������
if %1==3 goto deal3 REM ��dosbox�л�����ӵ���
if %1==2 goto deal2 REM ��dosbox�����г��򣬰�����������ر�dosbox������һЩ�������״̬�ĳ��򣬱���chapter 4/OC.asm���Զ��ر�
if %1==5 goto deal5 REM ���ļ����Ƶ�TASM�ļ����У�dosbox�򿪸��ļ���
if %1==6 goto deal6 %3 REM ʹ��dosbox�򿪵�ǰ�ļ������ļ���
:deal0
    echo output in terminal
    echo DOSBOX OUTPUT:
    REM -conf %dd%minbox.conf
    %dd%DOSBox -noconsole^
    -c "mount c \"%aa%\"" -c "c:"^
    -c "tasm/t/zi T.ASM>T.txt" ^
    -c "if exist T.OBJ tlink/v/3 T>>T.txt"^
    -c "echo ----->>T.txt"^
    -c "if exist T.EXE T>>T.txt"^
    -c "EXIT"
    echo.>>T.txt
    type T.txt
    exit
:deal1
    echo output in dosbox,input "exit" or ctrl-F9 or click 'x' to exit dosbox
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf ^
    -c "mount c \"%aa%\"" -c "c:"^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"
    exit
:deal2
    echo output in dosbox ��press any key to exit dosbox
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf  ^
    -c "mount c \"%aa%\"" -c "c:"^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"-c "T.EXE"^
    -c "pause" -c "exit"
    exit
:deal3
    echo tasm and turbo debugger in dosbox
    copy TDCONFIG1 TDCONFIG.TD
    REM ʹ��td.exe ʹ����������ļ�
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf ^
    -c "mount c \"%aa%\"" -c "c:"^
    -c "tasm/zi T.ASM" -c "tlink/v/3 T.OBJ"^
    -c "Td t"
    exit

:deal5
    echo copy file to TASM folder and dosbox at the folder
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf ^
    -c "mount c %aa%" -c "c:" -c"dir"
    exit
:deal6
    echo dosbox here with tasm added to path
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf ^
    -c "mount d %aa%" -c "set path=D:"^
    -c "mount c '%~d3%~p3'" -c "c:" -c "dir"
    exit
)^
exit
:D
if exist TD.TR echo tr exist
    echo turbo debugger without tasm first in dosbox
    copy TDCONFIG1 TDCONFIG.TD
    %dd%DOSBox -noautoexec -noconsole -conf %dd%bigbox.conf^
    -c "mount c %aa%" -c "c:" -c "td t"
echo ---end---
exit