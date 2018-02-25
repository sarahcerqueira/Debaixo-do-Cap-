# Problema 1 - Debaixo do Cap� (TEC499 - MI  Sistemas Digitais P01)
# Programa de Teste: Ano Bissexto
# Equipe: Camille Jesus, Pedro Gomes e Sarah Pereira
# Data: 9/10/17

#Defini��o de constantes:
.equ UART0, 0x0860
.equ ano, r5
.equ divisor, r6
.equ resto, r7
.equ resultado, r8

.data   #Segmento de dados:
agree: .asciz "� bissexto!"
deny: .asciz "N�o � bissexto!"

.equ espaco, r20  #32   #Decimal do caractere "space" em ASCII.
.equ enter,  r19  #10   #Decimal do caractere "line feed" em ASCII.

.text

.global main   #Define in�cio do c�digo.


main:		
	#Atribui��o dos valores ASCII:
	movi espaco, 32
	movi enter, 10
	
	num:	
		movia r9, UART0   #Move endere�o imediato para r9.
		call nr_uart_rxchar   #Procedimento de leitura de caracteres em ASCII pela UART0.
		blt r2, r0, num   #Repete enquanto n�o recebe dado serial.
		br recebe_dado   #Se recebeu, desvia para recebe_dado.
		
	#Rotina que transforma o ASCII recebido em decimal e junta d�gitos de um mesmo n�mero:
	pega_digito:
		muli r10, r10, 10
		mov r11, r2
		subi r11, r11, 48
		add r10, r10, r11
		call num
		
	recebe_dado:   
		beq r2, espaco, guarda_num   #Se recebeu espa�o, desvia para guarda_num.
		beq r2, enter, guarda_num   #Se n�o, se recebeu enter, desvia para guarda_num.
		br pega_digito   #Se n�o, desvia para pega_digito.
	
	guarda_num:	
		mov ano, r10   #Atribui � ano o n�mero recebido.
		call verifica   #Chama a verifica��o de ano bissexto.
      
verifica:
      	movi divisor, 4   #Primeiro divisor: 4.
      	call resto_divisao   #Calcula o resto da divis�o por 4.
	beq resto, r0, verifica2   #Primeira condi��o: se resto da divis�o por 4 for igual a 0, chama a segunda condi��o.
	br nao_bissexto   #Se n�o, N�O � BISSEXTO.
	
verifica2:
	movi divisor, 400   #Segundo divisor: 400.
	call resto_divisao   #Calcula o resto da divis�o por 400.
	beq resto, r0, bissexto   #Segunda condi��o: se resto da divis�o por 400 for igual a 0, � BISSEXTO.
	br verifica3   #Se n�o, chama a terceira condi��o.

verifica3:
	movi divisor, 100   #Terceiro divisor: 100.
	call resto_divisao   #Calcula o resto da divis�o por 100.
	bne resto, r0, bissexto   #Terceira condi��o: se resto da divis�o por 100 n�o for igual a 0, � BISSEXTO.
	br nao_bissexto   #Se n�o, N�O � BISSEXTO.
	
#Rotina que calcula o resto da divis�o:
resto_divisao:
	div resto, ano, divisor
	mul resto, resto, divisor
	sub resto, ano, resto
	ret
		
#SE N�O FOR BISSEXTO:
nao_bissexto:
	movi resultado, 0   #Zera o registrador de resultado.
	movia r4, deny
	call nr_uart_txstring   #Procedimento de escrita de string pela UART0.
	call finish   #Finaliza execu��o.
	
#SE FOR BISSEXTO:
bissexto:
	movi resultado, 1   #Coloca 1 no registrador de resultado.
	movia r4, agree
	call nr_uart_txstring   #Procedimento de escrita de string pela UART0.
	call finish   #Finaliza execu��o.
	
finish:
	.end   #Final.
