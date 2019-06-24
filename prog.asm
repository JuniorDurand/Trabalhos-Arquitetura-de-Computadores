
Codigo SEGMENT
                                        ;SEGMENT - marcador de inicio de segmento

	ASSUME CS:Codigo; DS:Codigo; ES:Codigo; SS:Codigo

                                        ;ASSUME - Associa um segmento a um registrador de segmento.
                
                                        ;CS - (Segmento de Código): contém o endereço da áreacom as instruções de máquina em execução.
                                        ;DS - (Segmento de Dados): contém o endereço da área com os dados do programa.
                                        ;SS - (Segmento de Pilha): contém o endereço da área com a pilha. 
                                        ;ES - (Segmento Extra): utilizado para ganhar acesso a alguma área da memória (quando necessario).

	Org 100H                        ;Monta o programa no segmento 100h de memoria
	
Entrada: JMP Nomeprog                   ;Pula para o Nomeprog
                                        ;Entrada : rotulo (label)
	
        num1 dw 0
        num2 dw 0
        result dw 0
        nument1 db 5,?,5 dup(0)
        nument2 db 5,?,5 dup(0)
        resultSaida db 6,?,6 dup(0)
	msg db 'digite o primeiro numero : ','$'
	pulalinha db 0AH, 0DH, '$'
	msg2 db 'digite o segundo numero : ','$'
	msg3 db 'O resultado: ','$'

		;
		
Nomeprog PROC NEAR                      ;NEAR quando o procedimento (rotina) esta dentro do SEGMENT
                                        ;PROC - Marcam o início uma procedimento (rotina).
		
        ;Mostra mensagem
        MOV DX, OFFSET msg              ;Referencia string msg no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX)
        
        

        LEA DX, nument1
        MOV AH, 0AH
        INT 21H

        ;Pula linha e Mostra mensagem
        MOV DX, OFFSET pulalinha        ;Referencia string pulalinha no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX)
        MOV DX, OFFSET msg2             ;Referencia string msg2 no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX)



        LEA DX, nument2
        MOV AH, 0AH
        INT 21H


        MOV BL, nument1+4
        MOV BH, nument1+3
        AND BX, 0F0FH                   ;tira 3030H de BX


        MOV AX, BX                      ;Coloca o valor de BX em AX
        AAD                             ;Converte o valor de AX em BCD descompactado
        MOV BX, AX                      ;guarda AX em BX

        MOV num1, BX


        MOV BL, nument2+4
        MOV BH, nument2+3
        AND BX, 0F0FH                   ;tira 3030H de BX


        MOV AX, BX                      ;Coloca o valor de BX em AX
        AAD                             ;Converte o valor de AX em BCD descompactado
        MOV BX, AX                      ;guarda AX em BX

        MOV num2, BX


        ;checa sinal
        MOV BH, nument1+2
        MOV BL, nument1+2
        cmp BH, BL
        JE      iguais
        JNE     diferentes

                iguais:

                        ;isso
                        JMP break

                diferentes:
                

                        ;isso
                        mov resultSaida+2, BH

                        mov BX, num1
                        mov CX, num2
                        add BX, CX
                        mov result, BX
                        
                        ;unidade
                        mov ax, result
                        aam
                        mov resultSaida+5, al
                        
                        ;dezena
                        mov al, ah
                        aam
                        mov resultSaida+4, al
                        
                        ;centena
                        mov al, ah
                        aam
                        mov resultSaida+3, al
                        

                break:

                        add resultSaida+3, 30h
                        add resultSaida+4, 30h
                        add resultSaida+5, 30h

                        MOV DX, OFFSET resultSaida             ;Referencia string msg2 no registrador DX
                        CALL Mostrarstring
                        INT 20H
        
                        ;isso
                        
       
		
	
	INT 20H                        ;Encerra o programa
		
Nomeprog ENDP                          ;ENDP - Marca o fim de uma procedimento (rotina).

Lertecla PROC NEAR

        ;Chama interupção 01h (ler caracter do teclado e echoa na tela e guarda em AL)
	MOV AH, 01H
	INT 21H                        ;INT - indica interupção || INT 21 - interupção 21 contém os serviços do DOS.
	RET                            ;RET - Retorno de uma chamada de rotina

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


	
Codigo ENDS                             ;ENDS - Marcam o fim de um segmento.
END Entrada                             ;END - Marcam o fim de um rotulo (label).