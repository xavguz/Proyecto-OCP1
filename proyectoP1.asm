.data
tablero: .space 480
jugador: .word 0,0,0 #arr[posicion, dinero_acumulado,n_tesoros,llego_a_la_meta]
maquina: .word 0,0,0 #arr[posicion, dinero_acumulado,n_tesoros,llego_a_la_meta]
num:.word 20
tesoros: .word 0
num_aleatorio: .word 0

#mensajes
msg_num_casillas: .asciiz "Ingrese el numero de casillas (20 - 120): "
msg_calc_avg: .asciiz "El numero de tesoros en la partida: "
msg_mov_jugador: .asciiz "Ingrese el numero de casillas a mover (1 - 6): "
msg_mov_maquina: .asciiz "La maquina se movio a la posicion: "
msg_aleatorio: .asciiz "El numero aleatorio es "
msg_turno_jugador: .asciiz "\nTURNO: JUGADOR\n "
msg_turno_maquina: .asciiz "\nTURNO: MAQUINA\n "
msg_robo: .asciiz "Se robo: "
msg_dinero_obtenido: .asciiz "Dinero obtenido: "
msg_dinero_acumulado: .asciiz "Dinero acumulado: "
msg_tesoros: .asciiz "Tesoros: "
msg_encontro_tesoro: .asciiz "Encontro tesoro +1!"
espacio_blanco: .asciiz " "
salto: .asciiz "\n"

.text
main:
	jal num_casillas
	jal calc_avg
	jal fill_arr
	jal imprimir_arreglo
	
	li $v0, 10
	syscall

num_casillas:
loop_1:	
	li $v0, 4
	la $a0, msg_num_casillas
	syscall
	
	#lee ingreso de un entero		
	li $v0, 5      
	syscall
	move $t1, $v0 
		 
	slti $t2, $t1, 20
	li $t0, 120
	slt $t3, $t0, $t1 
		
	or $t4, $t2, $t3
		
	bne $t4, $zero, loop_1
		
	sw $t1, num	
	jr $ra

calc_avg:
	lw $t0, num
	li $t1, 30
	li $t4, 100
	
	mul $t3, $t0, $t1
	div $t3, $t4
	mflo $t5
	sw $t5, tesoros
	
	li $v0, 4
	la $a0, msg_calc_avg
	syscall
	
	li $v0, 1
	la $a0, ($t5)
	syscall
	
	li $v0, 4
    	la $a0, salto
    	syscall
	
	jr $ra

random:
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	
    	move $t1, $a0          
    	sub $t0, $a1, $a0
    	addi $t0, $t0, 1       
    	move $a0, $t0          
   	li $v0, 42
    	syscall     
    	           
    	add $v0, $a0, $t1
    	sw $v0, num_aleatorio  
    	   
	lw $ra, 0($sp)
	addi $sp, $sp, 4
    	jr $ra

mov_jugador:
	addi $sp, $sp, -4
    	sw   $ra, 0($sp)
loop_2:	
	li $v0, 4
	la $a0, msg_turno_jugador
	syscall
	
	li $v0, 4
	la $a0, msg_mov_jugador
	syscall
		
	#lee ingreso de un entero	
	li $v0, 5       
	syscall
	move $t1, $v0 
		 
	slti $t2, $t1, 1
	li $t0, 6
	slt $t3, $t0, $t1 
		
	or $t4, $t2, $t3
		
	bne $t4, $zero, loop_2
	
	la  $t0, jugador
	li  $t1, 0
	sll $t2, $t1, 2
	add $t3, $t0, $t2 		
	lw $t4, 0($t3)
	
	add $t5, $t4, $v0
	
	la $t7, num   
	lw $t8, 0($t7)
	
	slt $t9, $t8, $t5
	bne  $t9, $zero, loop_2
	
	sw $t5, 0($t3)
	
	lw   $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr   $ra

mov_maquina:
loop_3:
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    		
	li $a0, 1
	li $a1, 6
	jal random
	
	la  $t0, maquina
	li  $t1, 0
	sll $t2, $t1, 2
	add $t3, $t0, $t2 		
	lw $t4, 0($t3)
	
	add $t5, $v0, $t4
	
	la $t6, num   
	lw $t7, 0($t6)
	
	slt $t8, $t7, $t5
	bne  $t8, $zero, loop_3
	
	sw $t5, 0($t3)
	
	li $v0, 4
	la $a0, msg_turno_maquina
	syscall
	
	li $v0, 4
	la $a0, msg_mov_maquina
	syscall
	
	li $v0, 1     
	move $a0, $t5
	syscall
	
	lw   $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr   $ra
    	
fill_arr:
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	
    	li $t0, 0 #n_tesoros en el arr
    	
    	lw $t1, num
    	li $t2, 0 #i = 0

for_loop:
	
	beq $t2, $t1, end_loop
	
	lw $t4, tesoros 
    	sub $t5, $t4, $t0
    	
    	sub $t6, $t1, $t2 #casillas_faltantes
    	
    	beq $t5, $t6, poner_tesoro
    	
    	li $a0, 1
    	li $a1, 2
    	jal random
    	
    	move $t7, $v0
    	
    	li $t8, 3
    	bne $t7, $t8, poner_money
    	        
   	beq $t0, $zero , poner_money

poner_tesoro:
	la  $t5, tablero
    	sll $t6, $t2, 2            
    	add $t7, $t5, $t6
    	li  $t8, 1
    	sw  $t8, 0($t7)
    	
    	addi $t0, $t0, 1
    	
    	j siguiente
    	
poner_money:
	li $a0, 10
    	li $a1, 90
    	jal random

    	la  $t5, tablero
    	sll $t6, $t2, 2
    	add $t7, $t5, $t6
    	sw  $v0, 0($t7)
    	
siguiente:
    	addi $t2, $t2, 1      
    	j for_loop

end_loop:
	
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra
    
imprimir_arreglo:
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)

    	#### cargar num
    	lw $t0, num        # t0 = num
    	li $t1, 0          # t1 = i

loop_print:
    	slt $t2, $t1, $t0  # i < num ?
    	beq $t2, $zero, fin_print

    	#### dirección de p_arr[i]
    	la  $t3, tablero
    	sll $t4, $t1, 2    # offset = i * 4
    	add $t5, $t3, $t4  # t5 = &p_arr[i]

    	#### cargar valor
    	lw $a0, 0($t5)

    	#### imprimir entero
    	li $v0, 1
    	syscall

   	#### salto de línea
    	li $v0, 4
    	la $a0, salto
    	syscall

    	#### i++
    	addi $t1, $t1, 1
    	j loop_print

fin_print:
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra