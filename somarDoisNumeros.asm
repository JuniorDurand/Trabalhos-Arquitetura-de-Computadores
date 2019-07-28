Codigo SEGMENT
	ASSUME CS:Codigo; DS:Codigo; ES:Codigo; SS:Codigo
	Org 100H
	
Entrada: JMP Nomeprog
	
	msg db 'digite o primeiro numero : ','$'
	pulalinha db 0AH, 0DH, '$'
	msg2 db 'digite o segundo numero : ','$'
	msg3 db 'O resultado: ','$'

		;
		
Nomeprog PROC NEAR
		
		MOV DX, OFFSET msg 
		CALL Mostrarstring
		CALL Lertecla
		MOV CL, AL
		MOV DX, OFFSET pulalinha 
		CALL Mostrarstring
		MOV DX, OFFSET msg2
		CALL Mostrarstring
		CALL Lertecla
		MOV DX, OFFSET pulalinha 
		CALL Mostrarstring
		MOV DX, OFFSET msg3
		CALL Mostrarstring
		MOV BL, AL
		ADD CL, BL
		MOV AL, CL
		MOV AH, 0
		AAA
		OR AX, 3030H
		MOV BX, AX
		MOV DL, BH
		
		CALL Mostrarchar
		MOV DL, BL
		CALL Mostrarchar
		
		
		
		
	
		INT 20H
		
Nomeprog ENDP

Lertecla PROC NEAR

	MOV AH, 01H
	INT 21H
	RET

Lertecla ENDP
	
Mostrarchar PROC NEAR

	MOV AH, 02H
	INT 21H
	RET

Mostrarchar ENDP

Mostrarstring PROC NEAR

	MOV AH, 09
;	MOV DX, OFFSET MESS1
	INT 21H
	RET

Mostrarstring ENDP


	
	Codigo ENDS
	END Entrada