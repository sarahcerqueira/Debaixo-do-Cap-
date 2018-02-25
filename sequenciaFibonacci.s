# Problema 1 - Debaixo do Cap� (TEC499 - MI  Sistemas Digitais P01)
# Programa de Teste: Sequ�ncia Fibonacci
# Equipe: Camille Jesus, Pedro Gomes e Sarah Pereira
# Data: 9/10/17

.equ espaco, r20 #32   #Decimal do caractere "space" em ASCII.
.equ enter,  r19 #10   #Decimal do caractere "line feed" em ASCII.

.data

.equ UART0, 0x860   #Defini��o de constante.

.text


main: 
	movi r15, 1   #Inicializa a sequ�ncia com termo 1.
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
		muli r6, r6, 10
		mov r8, r2
		subi r8, r8, 48
		add r6, r6, r8
		call num
		
	recebe_dado:
		beq r2, espaco, inicio   #Se recebeu espa�o, desvia para inicio.
		beq r2, enter, inicio   #Se n�o, se recebeu enter, desvia para inicio.
		br pega_digito   #Se n�o, desvia para pega_digito.
	
inicio:
	mov r10, r15   #Valor do termo atual � atribu�do � r10.
    	movi r8, 1   #Coloca 1 em r8.
    	call fib   #Verifica se necess�rio c�lculo do fibonacci.
    	
    	mov r4, r1   #Valor do termo atual da sequ�ncia.
	call nr_uart_txhex   #Procedimento de escrita de caracteres em hexadecimal pela UART0.
	
	movi r4, 0x2C   #Hexadecimal do caractere "," em ASCII.
	call nr_uart_txchar   #Procedimento de escrita de caracteres em ASCII pela UART0.
		    	  
    	addi r15, r15, 1   #Incrementa o termo atual.
    	bge r6, r15, inicio   #Se o termo limite for maior que o termo atual, continua gerando.
	br finish   #Se n�o, finaliza execu��o.
    	   	      
fib:
	bgt r10, r8, fibonacci   #Se o valor do termo atual for maior que 1, calcula fibonacci.
	mov r1, r10   #Se n�o, coloca em r1 o termo atual.
	ret   #Retorna.
      
fibonacci:
      	subi sp, sp, 12   #Reserva-se 3 espa�os na pilha.
      	stw ra, 0(sp)   #No primeiro � colocado o endere�o de retorno.
      	stw r10, 4(sp)   #No segundo o termo atual.
      	
     	subi r10, r10, 1   #Subtrai-se 1 do termo atual.
      	call fib   #Verifica se necess�rio c�lculo do fibonacci.
      	
      	ldw r10, 4(sp)   #Carrega em r10 o termo atual.
	stw r1, 8(sp)   #Armazena no terceiro espa�o o valor do termo corrente.
            
	subi r10, r10, 2   #Subtrai-se 2 do termo atual.
	call fib   #Verifica se necess�rio c�lculo do fibonacci.
      
	ldw r5, 8(sp)   #Carrega em r5 o valor do termo atual.
	add r1, r5, r1   #Soma o valor do termo atual ao valor do termo anterior.
      
	ldw ra, 0(sp)   #Carrega o endere�o de retorno salvo em ra.
	addi sp, sp, 12   #Reseta pilha.
	ret   #Retorna.
      	
finish:     	
	.end   #Final.
