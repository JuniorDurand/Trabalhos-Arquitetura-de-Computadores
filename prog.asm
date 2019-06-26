
Codigo SEGMENT                          ;SEGMENT - marcador de inicio de segmento de codigo
                                        

        ASSUME CS:Codigo; DS:Codigo; ES:Codigo; SS:Codigo

                                        ;ASSUME - Associa um segmento a um registrador de segmento.
                
                                        ;CS - (Segmento de Código): contém o endereço da área com as instruções de máquina em execução.
                                        ;DS - (Segmento de Dados): contém o endereço da área com os dados do programa.
                                        ;SS - (Segmento de Pilha): contém o endereço da área com a pilha. 
                                        ;ES - (Segmento Extra): utilizado para ganhar acesso a alguma área da memória (quando necessario).

        Org 100H                        ;Monta o programa no segmento 100h de memoria
        
Entrada: JMP Nomeprog                   ;Pula para o Nomeprog
                                        ;Entrada : rotulo (label)
        
        num1 db 0                       ;variavel usada para guardar primeiro numero
        num2 db 0                       ;variavel usada para guardar segundo numero
        result db 0                     ;variavel usada para guardar resultado da operação
        
        nument1 db 5,?,5 dup(0)         ;String usada para entrada do primeiro numero
        nument2 db 5,?,5 dup(0)         ;String usada para entrada do segundo numero
        resultSaida db 7,?,7 dup(0)     ;String usada para saida do resultado da operação
        
        ;mensagens do programa
        msg1 db 'digite o primeiro numero : ','$'
        pulalinha db 0AH, 0DH, '$'
        msg2 db 'digite o segundo numero : ','$'
        msg3 db 'O resultado: ','$'

                ;
                
Nomeprog PROC NEAR                      ;NEAR quando o procedimento (rotina) esta dentro do SEGMENT
                                        ;PROC - Marcam o inÃ­cio uma procedimento (rotina).
                
        ;Mostra mensagem 1
        MOV DX, OFFSET msg1             ;Referencia string msg no registrador DX
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
                
        MOV DX, OFFSET resultSaida      ;Referencia string do resultado no registrador DX
        CALL Mostrarstring              ;Chama interupção 09h (printa string referenciada em DX)
                       
        
                
        
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
                call trocasinal         ;chama função trocasinal caso o segundo numero for maior q o primeiro
                xchg ch, cl             ;troca o prim. numero com o seg. numero
        
        sair:                           ;inicio do rotulo sair (sai da comparação) 
        
        sub ch, cl                      ;subtrai os numeros
        mov result, ch                  ;guarda o resultado na variavel result
        mov resultSaida+2, dh           ;coloca o sinal do resultado na string de saida
        
        RET                             ;RET - Retorno de uma chamada de rotina

subtra ENDP                             ;ENDP - Marca o fim de uma procedimento (rotina) de subtração.


;Inicio rotina de soma
soma PROC NEAR                          
             
      mov dh, nument1+2                 ;guarda sinal do primeiro numero
      mov resultSaida+2, dh             ;coloca o sinal do resultado na string de saida
      mov ch, num1                      ;copia primeiro numero em ch
      mov cl, num2                      ;copia segundo numero em cl
      add ch, cl                        ;soma os numeros
      
      mov result, ch                    ;guarda o resultado na variavel result
        
      RET                               ;RET - Retorno de uma chamada de rotina
             
soma ENDP                               ;ENDP - Marca o fim de uma procedimento (rotina) de soma.

       


;Inicio rotina de Mostrarstring
;chama int. 09H 
;q printa str. refereciada em DX
Mostrarstring PROC NEAR

        MOV AH, 09                      ;prepara int. 09H
        INT 21H                         ;chama interrupção do SO.
        RET                             ;RET - Retorno de uma chamada de rotina

Mostrarstring ENDP                      




;Inicio rotina de troca de sina
TROCASINAL proc near

        CMP DH, '+'                     ;compara o sinal salvo em DH com '+' 
        JE trocasinal1                  ;se forem iguais pula para rotulo 'trocasinal1'
        JNE trocasinal2                 ;se forem diferentes pula para rotulo 'trocasinal2'

        trocasinal1:                    ;inicio do rotulo trocasinal1
                MOV DH, '-'             ;coloca sinal '-' em DH q possui '+'
                RET                     ;RET - Retorno de uma chamada de rotina
        
        trocasinal2:                    ;inicio do rotulo trocasinal2
                MOV DH, '+'             ;coloca sinal '+' em DH 
                RET                     ;RET - Retorno de uma chamada de rotina

TROCASINAL ENDP                         ;ENDP - Marca o fim de uma procedimento (rotina) de trocasinal.



        
Codigo ENDS                             ;ENDS - Marcam o fim de um segmento.
END Entrada                             ;END - Marcam o fim de um rotulo (label).