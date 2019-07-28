Codigo SEGMENT

 Assume cs:codigo; ds:codigo; es:codigo; ss:codigo
 org 100H

Entrada: JMP Programa

   VETOR DB 4,?,4 DUP(0)
   msg1 db 'Numero 1: ','$' 
   msg2 db  0AH,0DH,'Numero 2: ','$'
   msgt db  0AH, 0DH,'Total: $' 
   VETOR1 DB 4,?,4 DUP(0)   
   RESULT DB 5,?,5 DUP(0)
   
   Programa proc near

   ;Primeira mensagem
   MOV DX, OFFSET msg1
   CALL mostramsg;
   MOV DX, OFFSET VETOR
   CALL INPUT

   ;Segunda mensagem
   MOV DX, OFFSET msg2
   CALL mostramsg
   MOV DX, OFFSET VETOR1
   CALL INPUT
   
   MOV AL, (VETOR+2)
   MOV AH, (VETOR1+2)
   CMP AL, AH 
   JE sinaisIguais          ;Se sao iguais manda para sinaisIguais 
   JNE sinaisDiferentes     ;Se sao diferentes manda para sinaisDiferentes

    sinaisIguais:
		JMP SUBTS
	
   sinaisDiferentes:
      JMP SOMAS

   SOMAS:
    CALL SOMA               ;chama a funcao soma
   INT 20H                  ;encerra o programa
   
   SUBTS:
    CALL SUBT               ;chama a funcao subtracao
   INT 20H                  ;encerra o programa
Programa ENDP
 
   SOMA proc near
      MOV AH, VETOR+3 ;fazer direto
      MOV AL, (VETOR+2*2)
      MOV BL, AL
      MOV BH,AH

      MOV AH,VETOR1+3
      MOV AL, (VETOR1+2*2)
      MOV CL,AL
      MOV CH,AH
     
      ADD BL,CL
      MOV AH,0 ;zerar p n pegar lixo
      MOV AL,BL
      AAA
      MOV DX,AX
      OR DX, 3030H
      MOV RESULT+5,DL
      MOV BL,DH
      ADD BH,CH
      MOV AH,0
      MOV AL,BH
      AAA
      MOV DX,AX
      OR DX,3030H
      MOV RESULT+3,DL
      MOV CH,DH
      MOV AH,0
      ADD BL,RESULT+3
      MOV AL,BL
      AAA
      MOV DX,AX
      OR DX,3030H
      MOV RESULT+3,DL
      MOV RESULT+2,CH
      MOV AH,(VETOR+1*2)
      CMP AH,'+';
      JE positivo
      JNE negativo

      positivo:
        MOV RESULT+1,'+'
        JMP imprime
      negativo:
        MOV RESULT+1,'-'
       	JMP imprime

      imprime:
	      MOV DX, OFFSET msgt
	      CALL mostramsg 
	      MOV DL,RESULT+1   ;mostrar o sinal
	      CALL mostrarchar
	      MOV DL, RESULT+2  ;mostrar centena
	      CALL mostrarchar
	      MOV DL,RESULT+3   ;mostrar dezena
	      CALL mostrarchar
	      MOV DL, RESULT+4  ;mostrar unidade
	      CALL mostrarchar
	      RET
   SOMA ENDP
  
   SUBT proc near
      MOV AH,VETOR+3
      MOV AL,(VETOR+2*2)      
      AAD
      MOV BL,AL
      MOV AH,VETOR1+3
      MOV AL,(VETOR1+2*2)
      AAD
      MOV CL,AL
      CMP BL,CL             ;compara os valores
      JG ME                 ;se o maior for o da esquerda vai pra me
      JLE MD                ;se for o da direita vai pra md
      
     ME:
      SUB BL,CL             ;subtrai
      MOV AL,BL
      MOV AH,0
      AAM
      OR AX,3030H
      MOV DH, VETOR+2
      MOV RESULT+1, DH     ;mudar comentario
      MOV RESULT+4,AL
      MOV RESULT+3,AH  
      JMP final             ;pula pra impressão 
      
     MD:
      SUB CL,BL             ;subtrai de forma inversa aos valores sendo passados
      MOV AL,CL             ;move o resultado 
      MOV AH,0
      AAM                   ;ajusta 
      OR AX,3030H           ;transforma em hexadecimal
      MOV DH, VETOR1+2

      CALL TROCASINAL

      MOV RESULT+1, DH   	;mudar comentario
      MOV RESULT+4,AL
      MOV RESULT+3,AH  
      JMP final
            

      final:
       MOV DX, OFFSET msgt
       CALL mostramsg 
       MOV DL,RESULT+1      ;para mostrar o sinal
       CALL mostrarchar
       MOV DL,RESULT+3      ;mostrar dezena
       CALL mostrarchar
       MOV DL, RESULT+4     ;mostrar unidade
       CALL mostrarchar
       RET

   SUBT ENDP


   INPUT proc near
   MOV AH, 0AH
   INT 21h
   ret
   INPUT endp

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


   mostrarchar proc near
   mov AH, 02h
   int 21h
   ret
   mostrarchar endp


   mostramsg proc near
   mov ah,09
   int 21h 
   ret
   mostramsg endp  


   Codigo ENDS
   END Entrada