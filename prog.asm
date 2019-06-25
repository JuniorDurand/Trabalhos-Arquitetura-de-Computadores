
Codigo SEGMENT
                                        ;SEGMENT - marcador de inicio de segmento

        ASSUME CS:Codigo; DS:Codigo; ES:Codigo; SS:Codigo

                                        ;ASSUME - Associa um segmento a um registrador de segmento.
                
                                        ;CS - (Segmento de Código): contém o endereço da área com as instruções de máquina em execução.
                                        ;DS - (Segmento de Dados): contém o endereço da área com os dados do programa.
                                        ;SS - (Segmento de Pilha): contém o endereço da área com a pilha. 
                                        ;ES - (Segmento Extra): utilizado para ganhar acesso a alguma área da memória (quando necessario).

        Org 100H                        ;Monta o programa no segmento 100h de memoria
        
Entrada: JMP Nomeprog                   ;Pula para o Nomeprog
                                        ;Entrada : rotulo (label)
        
        num1 db 0
        num2 db 0
        result db 0
        nument1 db 5,?,5 dup(0)
        nument2 db 5,?,5 dup(0)
        resultSaida db 7,?,7 dup(0)
        msg1 db 'digite o primeiro numero : ','$'
        pulalinha db 0AH, 0DH, '$'
        msg2 db 'digite o segundo numero : ','$'
        msg3 db 'O resultado: ','$'

                ;
                
Nomeprog PROC NEAR                      ;NEAR quando o procedimento (rotina) esta dentro do SEGMENT
                                        ;PROC - Marcam o inÃ­cio uma procedimento (rotina).
                
        ;Mostra mensagem 1
        MOV DX, OFFSET msg1              ;Referencia string msg no registrador DX
        CALL Mostrarstring              ;Chama interupÃ§Ã£o 09h (printa string referenciada em DX)
        
        
        ;ler primeiro numero
        LEA DX, nument1                 ;Referencia vetor nument1 no registrador DX
        MOV AH, 0AH                     ;Prepara interrupção AH (ler buffer do teclado)
        INT 21H                         ;chama interrupção AH (ler buffer do teclado)

        
        ;Pula linha
        MOV DX, OFFSET pulalinha        ;Referencia string pulalinha no registrador DX
        CALL Mostrarstring              ;Chama interupÃ§Ã£o 09h (printa string referenciada em DX)
        
        
        ;Mostra mensagem 2
        MOV DX, OFFSET msg2             ;Referencia string msg2 no registrador DX
        CALL Mostrarstring              ;Chama interupÃ§Ã£o 09h (printa string referenciada em DX)

        
        ;ler segundo numero
        LEA DX, nument2                 ;Referencia vetor nument2 no registrador DX
        MOV AH, 0AH                     ;Prepara interrupção AH (ler buffer do teclado)
        INT 21H  
        
        
        ;Pula linha
        MOV DX, OFFSET pulalinha        ;Referencia string pulalinha no registrador DX
        CALL Mostrarstring              ;Chama interupÃ§Ã£o 09h (printa string referenciada em DX)


        ;Prepara primeiro numero
        MOV BL, nument1+4               ;coloca unidade em BL
        MOV BH, nument1+3               ;coloca dezena em BH
        AND BX, 0F0FH                   ;tira 3030H de BX


        MOV AX, BX                      ;Coloca o valor de BX em AX
        AAD                             ;Converte o valor de AX em BCD descompactado
        MOV BX, AX                      ;guarda AX em BX

        MOV num1, Bl                    ;guarda valor do primeiro numero em bcd descompactado em variavel num1


        ;Prepara segundo numero
        MOV BL, nument2+4               ;coloca unidade em BL
        MOV BH, nument2+3               ;coloca dezena em BH
        AND BX, 0F0FH                   ;tira 3030H de BX


        MOV AX, BX                      ;Coloca o valor de BX em AX
        AAD                             ;Converte o valor de AX em BCD descompactado
        MOV BX, AX                      ;guarda AX em BX

        MOV num2, Bl                    ;guarda valor do segundo numero em bcd descompactado em variavel num2


        ;checa sinal
        MOV BH, nument1+2               ;coloca o sinal do primeiro numero em BH
        MOV BL, nument2+2               ;coloca o sinal do segundo numero em BL
        cmp BH, BL                      ;compara o sinal do primeiro num. com o do segundo num 
        
        JE      iguais                  ;se os sinais forem iguais pula para rotulo 'iguais'
        JNE     diferentes              ;se os sinais forem diferentes pula para rotulo 'diferentes'

                iguais:                 ;inicio do rotulo iguais
                        call subtra     ;chama rotina de subtração (sinais iguais)
                        JMP break       ;sai da comparação

                
                diferentes:             ;inicio do rotulo diferentes
                        call soma       ;chama rotina de soma (sinais diferentes)
                        
                        
                        
        break:                          ;inicio do rotulo break (sai da comparação)               
                        
         

        mov resultSaida+6, '$'          ;insere simbolo de fim de string
                
        ;unidade
        mov al, result                  ;move resultado para AX
        aam                             ;criar um par de valores BCD descompactados (base 10), AH = AL/10 || AL = AL mod 10
        mov resultSaida+5, al           ;salva unidade do resultado na string de saida
                
        ;dezena
        mov al, ah                      ;Coloca AH (Resto da divisão) em AL
        aam                             ;criar um par de valores BCD descompactados (base 10), AH = AL/10 || AL = AL mod 10
        mov resultSaida+4, al           ;salva dezena do resultado na string de saida
        
        ;centena
        mov al, ah                      ;Coloca AH (Resto da divisão) em AL
        aam                             ;criar um par de valores BCD descompactados (base 10), AH = AL/10 || AL = AL mod 10
        mov resultSaida+3, al           ;salva centena do resultado na string de saida
        
        
        add resultSaida+3, 30h          ;converte centena para Ascii
        add resultSaida+4, 30h          ;converte dezena para Ascii
        add resultSaida+5, 30h          ;converte unidade para Ascii
                
        MOV DX, OFFSET resultSaida      ;Referencia string msg2 no registrador DX
        CALL Mostrarstring              ;Chama interupÃ§Ã£o 09h (printa string referenciada em DX)
                       
        
                
        
        INT 20H                         ;Encerra o programa
                
Nomeprog ENDP                           ;ENDP - Marca o fim de uma procedimento (rotina).




;Inicio rotina de subtração
subtra PROC NEAR
        mov dh, nument1+2               ;guarda sinal do primeiro numero
        mov ch, num1                    ;copia primeiro numero em ch
        mov cl, num2                    ;copia segundo numero em cl
        cmp ch, cl                      ;compara os numeros
        JA maiorq                       ;se o prim. numero for maior pula para rotulo 'maiorq'
        JBE menorq                      ;se o seg. numero for menor ou igual pula para rotulo 'menorq'

        
        maiorq:                         ;inicio do rotulo 'maiorq' 
                jmp sair                ;pula para rotulo 
        
        menorq:                         ;inicio do rotulo 'menorq'
                call trocasinal         ;chama
                xchg ch, cl
        
        sair:
        
        sub ch, cl
        mov result, ch
        
        mov resultSaida+2, dh
        
        ret
subtra ENDP

soma PROC NEAR
             
      mov dh, nument1+2
      mov resultSaida+2, dh
      mov ch, num1
      mov cl, num2
      add ch, cl
      
      mov result, ch
        
      ret
             
soma ENDP

Lertecla PROC NEAR

        ;Chama interupÃ§Ã£o 01h (ler caracter do teclado e echoa na tela e guarda em AL)
        MOV AH, 01H
        INT 21H                        ;INT - indica interupÃ§Ã£o || INT 21 - interupÃ§Ã£o 21 contÃ©m os serviÃ§os do DOS.
        RET                            ;RET - Retorno de uma chamada de rotina

Lertecla ENDP
        
Mostrarchar PROC NEAR

        ;Chama interupÃ§Ã£o 02h (printa caracter(ASCII) que esta no registrador DL)
        MOV AH, 02H
        INT 21H
        RET

Mostrarchar ENDP

Mostrarstring PROC NEAR

        ;Chama interupÃ§Ã£o 09h (printa string referenciada em DX)
        MOV AH, 09
        INT 21H
        RET

Mostrarstring ENDP 

   TROCASINAL proc near
                CMP DH, '+'
        JE trocasinal1
        JNE trocasinal2

        trocasinal1:
                MOV DH, '-'
                ret
        trocasinal2:
                MOV DH, '+'
                ret 

TROCASINAL endp


        
Codigo ENDS                             ;ENDS - Marcam o fim de um segmento.
END Entrada                             ;END - Marcam o fim de um rotulo (label).