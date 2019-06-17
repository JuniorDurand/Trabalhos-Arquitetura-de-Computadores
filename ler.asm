Codigo SEGMENT
	ASSUME CS:Codigo; DS:Codigo; ES:Codigo; SS:Codigo
	Org 100H
	
Entrada: JMP Nomeprog
	
	DADO db 5,?,5 dup(0)
	pulalinha db 0AH, 0DH, '$'
		;
		
Nomeprog PROC NEAR
		
		LEA DX, DADO
		MOV AH, 0AH
		INT 21H
		
		
		MOV DX,	OFFSET pulalinha
		CALL Mostrarstring
		
		MOV DX, OFFSET DADO
		CALL Mostrarstring
		
		
		
		
		
		
	
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