
.data

vetor: .skip 300
.equ UART0, 0x860	


.text

.equ tamanho, r9
.equ ant, r10
.equ prox, r11
.equ aux, r12
.equ k, r13
.equ j, r14
.equ end_ant, r15
.equ espaco, r20 #32
.equ enter,  r19 #10


	movia r7, vetor
	
	addi espaco, r0, 32 #valor do espaço
	addi enter, r19, 10 #valor do enter
	addi r6, r0, 0
	addi tamanho, r0, 0
	
	num:		
		movia r5, UART0
		call nr_uart_rxchar
		blt r2, r0, num
		br loop
		
	pega_digito:
		muli r6, r6, 10
		add r8, r0, r2
		subi r8, r8, 48
		add r6, r6, r8
		call num
	
	
	loop:
		beq r2, espaco, guarda_num
		beq r2, enter, guarda_num
		br pega_digito
	
	guarda_num:
		stw r6, 0(r7) #guarda cada input na memória
		addi r7, r7, 4
		addi r6, r0, 0
		addi tamanho, tamanho, 1
		bne r2, enter, num

		

	
main:
	addi r6, r0, 0
	movia r7, vetor				#Pega endereço de memória do vetor

	
	add k, r0, tamanho			#i = tamanho -1
	#subi k, k, 1
	
	addi j, r0, 1				# j = 0
	
	beq tamanho, j, END
	
	buble_sort:
		
		
		ldw ant, 0(r7)			#Pega elemento na posiçao j
		mov end_ant, r7			#Pega o endereço de memória de j
		
		addi r7, r7, 4			#Passa para o endereço de memoria j+1
		
		ldw prox, 0(r7)			#Pega próximo elemento
			
		bgt ant, prox, troca		#Se ant > que prox troca
			
		br atualiza_j
		
		
		
	troca:
		add aux, ant, r0			#Pega valor de ant e joga em aux
		
						
		stw prox, 0(end_ant)		#Escreve no endereço do anterior o próximo
		stw ant, 0(r7)			#Escreve no endereço do próximo o anterior
		
		add ant, prox, r0		#Troca os valores nos registradores
		add prox, aux, r0
		
	
	atualiza_j:
		
		addi j, j, 1			#Atualiza j
		
		bgt tamanho, j, buble_sort	#Se j<tamanho continua
		br atualiza_k			#Se não atualiza k
	
			
	atualiza_k:
		
		subi k, k , 1
		addi j, r0, 1
		movia r7, vetor	
		bgt k, r0, buble_sort
		br END
		
		
	
	END:	
		movia r7, vetor	
		addi k, r0, 0
	
		lop:
			ldw r4, 0(r7)
			addi r7, r7, 4
			addi k, k, 1
			movia r5, UART0
			call nr_uart_txhex		#chamada da macro de escrita(no caso para a virgula)
			movi r4, 0x2C				#armazena o hexadecimal correspondente a virgula
			movia r5, UART0
			call nr_uart_txchar			#chamada da macro de escrita(no caso para a virgula)
			bgt tamanho, k, lop

.end
			
			

	
	
	
	

