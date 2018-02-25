##################################################
# Gerador de n�meros primos
#
# Alunos:
# 	Camile
# 	Pedro Henrique Gomes
# 	Sarah Pereira
##################################################

.equ limite_inferior, r12
.equ dividendo, r11
.equ divisor, r6
.equ resto, r7
.equ metade_dividendo, r8
.equ dois, r9
.equ espaco, r20 #32
.equ enter,  r19 #10

.data
	.equ UART0, 0x860

.text



main:

	addi espaco, r0, 32 #c�digo ascii do espa�o
	addi enter, r19, 10 #c�digo ascii do enter
	addi r6, r0, 0 #r6 servir� para armzenar o n�mero de entrada da UART0
	addi r11, r0, 0 #Servir� para compara��es futuras
	
	num:		
		movia r5, UART0 #endere�o do uart no r5(rx)
		call nr_uart_rxchar 
		blt r2, r0, num #checa se r2 < 0, caso seja menor, � porque n�o h� entrada.
		br loop # se n�o for, chama o loop
		
	pega_digito:
		muli r6, r6, 10 # no primeiro loop, r6 ser� zero, logo n�o ir� alterar o valor final da entrada
		add r8, r0, r2 #transfere o valor de r2 pra r8
		subi r8, r8, 48 #convertendo de ascii para bin�rio/hex
		add r6, r6, r8 # soma o n�mero anterior (zero na primeira vez) com o r8
		call num
	
	
	loop: #essa subrotina verifica se h� um espa�o ou enter
		beq r2, espaco, guarda_num
		beq r2, enter, guarda_num
		br pega_digito #caso n�o seja nenhum dos dois, ele ir� chamar a subrotina de armazenamento do numero
	
	guarda_num: 
		beq r11,r0, guarda_num1 #se r11 for zero, � porque estamos no primeiro valor do intervalo, logo guarda ele.
		br inicializacao
		
	
	guarda_num1:
		add limite_inferior,r0,r6 #guarda o limite inferior em r6
		addi r11, r11, 1 #atualiza o r11 (que checa se estamos no primeiro ou segundo valor do intervalo)
		addi r6, r0, 0 #reseta o r6.
		call num

	inicializacao:
		add dividendo,r0,r6				#Guarda o limite superior em r3
		#addi limite_inferior,r0,2			#Guarda o limite inferior em r2
		addi dois, r0,2
		add divisor,r0, dois 				#Inicia o divisor em 2
		div metade_dividendo, dividendo, dois		#Pega a metade do dividendo
	
	verifica_se_primo:
	
		div resto,dividendo,divisor		#Pega o quociente da divisao
		mul resto,resto,divisor			#Multiplica o quociente da divis�o pelo divisor
		sub resto,dividendo,resto		#Subtrai o dividendo pela multiplica��o do quociente pelo divisor, para pega o valor do resto
		bne resto,r0, atualiza_divisor		#Se o resto for diferente de 0 atualiza o divisor
		br atualizar_dividendo			#O n�mero n�o � primo, atualiza do dividendo
		
		
	atualiza_divisor:
		addi divisor, divisor, 1				#Aumenta dividor
		bgt metade_dividendo, divisor, verifica_se_primo		#Verifica se o divisor � menor ou igual a metade do dividendo
									#OBS: UM N�MERO N�O � DIVISIVEL POR N�MEROS MAIOR QUE SUA METADE
						

		#bgt dividendo,divisor, verifica_se_primo #Verifica se o dividendo � maior que o divisor/contado
		
		br impressao
		
	impressao: 
		mov r4, dividendo
		movia r15,UART0	
		call nr_uart_txhex
		
		movi r4, 0x2C
		movia r15,UART0	
		call nr_uart_txchar
		
		
		call atualizar_dividendo					#Atualiza do dividendo
	
	
	atualizar_dividendo:

		addi dividendo,dividendo, -1				#Diminui o dividendo
		beq dividendo, dois, impressao
		
		addi divisor,r0,2					#Reseta o divisor
		div metade_dividendo, dividendo,dois			#Atualiza a metade do dividendo
		
		bgt dois, dividendo, fim
		bgt dividendo,limite_inferior,verifica_se_primo		#Se o dividendo � maior que o limite inferior, continua a busca por mais n�meros primos
	
	
	
	fim:
		.end
		
		
	
	
