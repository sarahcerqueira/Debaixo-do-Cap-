# Alunos:
#	Pedro Henrique Gomes
# 	Camile L. Jesus
# 	Sarah Pereira
##################################################

.data
.equ UART0, 0x860
.equ divisor, r12
.equ resto, r13
.equ resultado, r14

msg_out: .asciz "Fatorial ="

.text
.equ espaco, r20 #32
.equ enter,  r19 #10


main:
	addi espaco, r0, 32
	addi enter, r19, 10
	addi r6, r0, 0

	
	num:		
		movia r15, UART0
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
		call ini

	ini:
		#bgeu r5, r4, fatorial #if(r4 <= 1)
		#addi r6, r0, 5 # r6 = valor inicial (1)
		movia r4, msg_out
		movia r5, UART0
		call nr_uart_txstring
		
		movi r4, 1
		call stack #chama a pilha
		call print
		br end


	calcular_fatorial:		
		subi r6, r6, 1
		call stack
		ldw r6, 0(sp)
		ldw ra, 4(sp)
		addi sp, sp, 8
		mul r7, r7, r6
		ret

	stack:
		subi sp, sp, 8	#
		stw ra, 4(sp)	#		
		stw r6, 0(sp) 	#guarda r6 no vetor
		bgt r6, r4, calcular_fatorial#(if r6 > r4)
		addi r7, r0, 1
		addi sp, sp, 8
		ret


	print:  #printa o resultado
	
		#call resto_divisao
		#addi resto, resto, 48
 		mov r4, r7 #passa o resultado que está em r7 para o tx(r4)
 		movia r5, UART0    
 		call nr_uart_txhex  

	end:
		.end
		
		
	
	
