.386
DATAS SEGMENT USE16
   TABF DW  -1,262,350,352,350,441,393,350,393,441
   		DW  350,352,441,525,589,588,589,525,441
   		DW  440,350,393,350,393,441,350,293,294,262
   		DW  350,589,525,441,440,350,393,350,393,589
   		DW  525,441,440,525,589,700,525,441,440,350
   		DW  393,350,393,441,350,294,292,262,350,0
   TABT	DB	4,4,6,2,4,4,6,2,4,4
   		DB  6,2,4,4,12,1,3,6,2
   		DB  4,4,6,2,4,4,6,2,4,4
   		DB  6,4,6,2,4,4,6,2,4,4
   		DB  6,2,4,4,12,4,6,2,4,4
   		DB  6,2,4,4,6,2,4,4,12
   N1   EQU 100
   N2	EQU	1500
   TTT	DW	0 ;�˴��������ݶδ���
DATAS ENDS


CODES SEGMENT  USE16
    ASSUME CS:CODES,DS:DATAS
START:
    	MOV AX,DATAS
    	MOV DS,AX
OPEN: 	IN	AL,61H
		OR	AL,03H
		OUT	61H,AL;打开扬声器
AGA:	LEA	SI,TABF;SI为计时器的输出频率值
		LEA	DI,TABT;DI为延时值
LAST:	CMP	WORD PTR [SI],0
		JE	AGA;相等跳转；实现循环重新播放
		MOV	DX,12H
		MOV	AX,34DEH
		DIV	WORD PTR [SI]
		OUT	42H,AL;先写低八位
		MOV	AL,AH
		OUT	42H,AL;写高八位
		CALL	DELAY
		ADD	SI,2
		INC	DI
		MOV	AH,1
		INT	16H
		JZ	LAST
CLOSE:	IN	AL,61H
		AND	AL,11111100B
		OUT	61H,AL;关闭扬声器
		MOV AH,4CH
    	INT 21H

DELAY	PROC
		MOV	EAX,0
		MOV	AL, [DI];音长
		MOV	CL,N1
		MUL CL
		MOV CX,N2
		MUL CX
		MOV CX, DX
		MOV DX, AX;DX=TABT*N1*N2
                ;MOV     EAX,0
                ;MOV     AL,[DI]
                ;IMUL    EAX,EAX,N
                ;MOV     DX,AX
                ;ROL     EAX,16
                ;MOV     CX,AX
                MOV     AH,86H
                INT     15H
;延迟86H
;功能描述:延迟
;入口参数: AH=86H .
;CX:DX=千分秒
;出口参数: CF=0--操作成功，AH=00H
;
		RET

DELAY	ENDP
CODES ENDS
    END START



