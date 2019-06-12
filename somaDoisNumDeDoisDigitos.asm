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
		
        ;Mostra mensagem
        MOV DX, OFFSET msg              ;Referencia string msg no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX)
        
        

        ;Ler o primeiro numero e coloca em CX
        CALL Lertecla                   ;Chama interupção 01h (ler caracter do teclado e guarda em AL)
        MOV CH, AL                      ;Guarda caracter em CH
        CALL Lertecla                   ;Chama interupção 01h (ler caracter do teclado e guarda em AL)
        MOV CL, AL                      ;Guarda caracter em CL


        ;Pula linha e Mostra mensagem
        MOV DX, OFFSET pulalinha        ;Referencia string pulalinha no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX)
        MOV DX, OFFSET msg2             ;Referencia string msg2 no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX)



        ;Ler o segundo numero e coloca em BX
        CALL Lertecla                   ;Chama interupção 01h (ler caracter do teclado e guarda em AL)
        MOV BH, AL                      ;Guarda caracter em BH
        CALL Lertecla                   ;Chama interupção 01h (ler caracter do teclado e guarda em AL)
        MOV BL, AL                      ;Guarda caracter em BL

        

        ;tira o 3030 de ascii para decimal
        ;mas cada digito fica separado no registrador
        AND BX, 0F0FH                   ;tira 3030H de BX
        AND CX, 0F0FH                   ;tira 3030H de CX


        ;ajustado no registrador AX por um valor BCD descompactado.
        MOV AX, BX                      ;Coloca o valor de BX em AX
        AAD                             ;Converte o valor de AX em BCD descompactado
        MOV BX, AX                      ;guarda AX em BX

        MOV AX, CX                      ;Coloca o valor de CX em AX
        AAD                             ;Converte o valor de AX em BCD descompactado
        MOV CX, AX                      ;guarda AX em CX


        
        ;Soma os numeros em hexadecimal
        ADD CX, BX                      ;Somando BX e CX 

        
        ;ajuste do conteúdo do AX para criar dois dígitos descompactados (base 10).
        ;Primeiro digito
        MOV AX, CX                      ;Coloca o valor de CX em AX
        AAM                             ;criar um par de valores BCD descompactados (base 10), AH = AL/10 || AL = AL mod 10
        MOV CL, AL                      ;Salva AL em CL
        
        ;Segundo e Terceiro digito
        MOV AL, AH                      ;Coloca AH (Resto da divisão) em AL
        AAM                             ;criar um par de valores BCD descompactados (base 10), AH = AL/10 || AL = AL mod 10
        MOV CH, AL                      ;Salva AL em CH
        MOV BL, AH                      ;Salva AH em BL

        ;Adiciona 3030H para ajustar na tabela ascii
	ADD BX, 3030H                   ;Adiciona 3030h para ficar compativel com ascii
	ADD CX, 3030H                   ;Adiciona 3030h para ficar compativel com ascii


        ;Pula linha e Mostra mensagem
        MOV DX, OFFSET pulalinha        ;Referencia string pulalinha no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX) 
        MOV DX, OFFSET msg3             ;Referencia string msg3 no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX)

        
        ;mostra resultado na tela
	MOV DL, BL                     ;Colocando primeiro numero em BL
        CALL Mostrarchar               ;Chama interupção 02h (printa caracter(ASCII) que esta no registrador DL)
        MOV DL, CH                     ;Colocando segundo numero em BL
	CALL Mostrarchar               ;Chama interupção 02h (printa caracter(ASCII) que esta no registrador DL)
	MOV DL, CL                     ;Colocando terceiro numero em BL
        CALL Mostrarchar               ;Chama interupção 02h (printa caracter(ASCII) que esta no registrador DL)
		
	
	INT 20H                        ;Encerra o programa
		
Nomeprog ENDP

Lertecla PROC NEAR

        ;Chama interupção 01h (ler caracter do teclado e echoa na tela e guarda em AL)
	MOV AH, 01H
	INT 21H
	RET

Lertecla ENDP
	
Mostrarchar PROC NEAR

	;Chama interupção 02h (printa caracter(ASCII) que esta no registrador DL)
        MOV AH, 02H
	INT 21H
	RET

Mostrarchar ENDP

Mostrarstring PROC NEAR

        ;Chama interupção 09h (printa string referenciada em DX)
	MOV AH, 09
	INT 21H
	RET

Mostrarstring ENDP


	
Codigo ENDS
END Entrada