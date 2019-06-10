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
		
        ;Ler o primeiro numero e coloca em CX
        MOV DX, OFFSET msg
        CALL Mostrarstring
		    CALL Lertecla
        MOV CH, AL
        CALL Lertecla
        MOV CL, AL

        MOV DX, OFFSET pulalinha

        ;Ler o segundo numero e coloca em BX
        CALL Mostrarstring
        MOV DX, OFFSET msg2
        CALL Mostrarstring
        CALL Lertecla
        MOV BH, AL
        CALL Lertecla
        MOV BL, AL

        ;tira o 3030 de ascii para decimal
        ;mas cada digito fica separado no registrador
        AND BX, 0F0FH
        AND CX, 0F0FH


        ;Monta os digitos em hexadecimal em um unico registrador
        MOV AX, BX
        AAD
        MOV BX, AX

        MOV AX, CX
        AAD
        MOV CX, AX


        ;Soma os numeros em hexadecimal
        ADD CX, BX

        ;BCD descompactados para criar um par de valores BCD descompactados (base 10).
        ;Primeiro digito
        MOV AX, CX
        AAM
        MOV CL, AL
        
        ;Segundo digito
        MOV AL, AH
        AAM
        MOV CH, AL
        MOV BL, AH

	ADD BX, 3030H
	ADD CX, 3030H
        
        

        MOV DX, OFFSET pulalinha
        CALL Mostrarchar
        MOV DX, OFFSET msg3
        CALL Mostrarstring

        ;mostra resultado na tela
	MOV DL, BL
        CALL Mostrarchar
        MOV DL, CH
	CALL Mostrarchar
	MOV DL, CL
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