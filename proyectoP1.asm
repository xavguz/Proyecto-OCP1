.data
tablero: .space 480
jugador: .word 0,0,0,0 
maquina: .word 0,0,0,0 
num: .word 20
tesoros: .word 0
num_aleatorio: .word 0
msg_num_casillas: .asciiz "Ingrese el numero de casillas (20 - 120): "
msg_calc_avg: .asciiz "El numero de tesoros en la partida: "
msg_mov_jugador: .asciiz "Ingrese el numero de casillas a mover (1 - 6): "
msg_valor_incorrecto: .asciiz "Valor incorrecto!\n"
msg_no_puedes_mover: .asciiz "No te puedes mover ese numero de casillas!\n"
msg_turno_jugador: .asciiz "\nTURNO: Jugador\n"
msg_turno_maquina: .asciiz "\nTURNO: Maquina\n"
msg_movio_casillas: .asciiz " se movio "
msg_casillas: .asciiz " casillas, su posicion actual es "
msg_llego_meta: .asciiz " casillas, llego a la meta!\n"
msg_robo: .asciiz "Se robo "
msg_dinero: .asciiz " dinero\n"
msg_dinero_obtenido: .asciiz "Dinero obtenido: "
msg_dinero_acumulado: .asciiz "\tDinero acumulado: "
msg_tesoros: .asciiz "\tTesoros: "
msg_encontro_tesoro: .asciiz "Encontro tesoro +1!\n"
msg_partida_termino: .asciiz "\nLa partida termino\n"
msg_ganador: .asciiz "GANADOR: "
msg_perdedor: .asciiz "PERDEDOR: "
msg_jugador_txt: .asciiz "JUGADOR"
msg_maquina_txt: .asciiz "MAQUINA"
msg_empate_dinero: .asciiz "EMPATE EN DINERO! Se decide por tesoros...\n"
msg_empate_total: .asciiz "EMPATE TOTAL!\n"
msg_debug_tablero: .asciiz "\n===== DEBUG: TABLERO =====\n"
msg_casilla: .asciiz "Casilla "
msg_tesoro_marker: .asciiz ": [TESORO]\n"
msg_dinero_marker: .asciiz ": $"
msg_fin_debug: .asciiz "==========================\n\n"
tab: .asciiz "\t"
salto: .asciiz "\n"
.text
main:
	jal num_casillas
	jal calc_avg
	jal fill_arr
	jal imprimir_arreglo  
bucle_principal:
	jal partida
	beqz $v0, fin_juego  
	la $t0, jugador
	lw $t1, 12($t0)  
	bnez $t1, turno_maquina  
	li $v0, 4
	la $a0, msg_turno_jugador
	syscall
	jal mov_jugador
turno_maquina:
	jal partida
	beqz $v0, fin_juego
	la $t0, maquina
	lw $t1, 12($t0)  
	bnez $t1, bucle_principal  
	li $v0, 4
	la $a0, msg_turno_maquina
	syscall
	jal mov_maquina
	j bucle_principal
fin_juego:
	li $v0, 4
	la $a0, msg_partida_termino
	syscall
	la $s0, jugador
	la $s1, maquina
	lw $s2, 8($s0)   
	lw $s3, 8($s1)   
	lw $s4, 4($s0)   
	lw $s5, 4($s1)   
	li $t0, 3
	beq $s3, $t0, maquina_gana_tesoros
	beq $s2, $t0, jugador_gana_tesoros
	bgt $s5, $s4, maquina_gana_dinero
	blt $s5, $s4, jugador_gana_dinero
	li $v0, 4
	la $a0, msg_empate_dinero
	syscall
	bgt $s3, $s2, maquina_gana_tesoros_empate
	blt $s3, $s2, jugador_gana_tesoros_empate
	j empate_total
maquina_gana_tesoros:
	la $a0, maquina
	la $a1, jugador
	jal robo
	jal imprimir_ganador_maquina
	j salir
jugador_gana_tesoros:
	la $a0, jugador
	la $a1, maquina
	jal robo
	jal imprimir_ganador_jugador
	j salir
maquina_gana_dinero:
	la $a0, maquina
	la $a1, jugador
	jal robo
	jal imprimir_ganador_maquina
	j salir
jugador_gana_dinero:
	la $a0, jugador
	la $a1, maquina
	jal robo
	jal imprimir_ganador_jugador
	j salir
maquina_gana_tesoros_empate:
	la $a0, maquina
	la $a1, jugador
	jal robo
	jal imprimir_ganador_maquina
	j salir
jugador_gana_tesoros_empate:
	la $a0, jugador
	la $a1, maquina
	jal robo
	jal imprimir_ganador_jugador
	j salir
empate_total:
	li $v0, 4
	la $a0, msg_empate_total
	syscall
	la $a0, msg_jugador_txt
	syscall
	la $a0, msg_dinero_acumulado
	syscall
	li $v0, 1
	lw $a0, 4($s0)  
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	lw $a0, 8($s0)  
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	la $a0, msg_maquina_txt
	syscall
	la $a0, msg_dinero_acumulado
	syscall
	li $v0, 1
	lw $a0, 4($s1)  
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	lw $a0, 8($s1)  
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	j salir
salir:
	li $v0, 10
	syscall
num_casillas:
loop_1:	
	li $v0, 4
	la $a0, msg_num_casillas
	syscall
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
    	move $a1, $t0
    	li $a0, 0          
   	li $v0, 42
    	syscall     
    	add $v0, $a0, $t1
    	sw $v0, num_aleatorio  
	lw $ra, 0($sp)
	addi $sp, $sp, 4
    	jr $ra
mov_jugador:
	addi $sp, $sp, -12
    	sw $ra, 0($sp)
    	sw $s0, 4($sp)  
    	sw $s1, 8($sp)  
loop_2:	
	li $v0, 4
	la $a0, msg_mov_jugador
	syscall
	li $v0, 5       
	syscall
	move $s0, $v0  
	slti $t2, $s0, 1     
	li $t0, 6
	slt $t3, $t0, $s0    
	or $t4, $t2, $t3
	beqz $t4, validar_movimiento
	li $v0, 4
	la $a0, msg_valor_incorrecto
	syscall
	j loop_2
validar_movimiento:
	la $t0, jugador
	lw $t4, 0($t0)       
	add $t5, $t4, $s0    
	lw $t8, num
	slt $t9, $t8, $t5    
	beqz $t9, mover_jugador
	li $v0, 4
	la $a0, msg_no_puedes_mover
	syscall
	j loop_2
mover_jugador:
	sw $t5, 0($t0)
	move $s1, $t5  
	la $t6, tablero
	sub $t7, $s1, 1      
	sll $t7, $t7, 2      
	add $t7, $t6, $t7    
	lw $s2, 0($t7)       
	li $t9, 1
	bne $s2, $t9, es_dinero
	li $v0, 4
	la $a0, msg_encontro_tesoro
	syscall
	la $t0, jugador
	lw $t1, 8($t0)
	addi $t1, $t1, 1
	sw $t1, 8($t0)
	li $s3, 0  
	j verificar_meta
es_dinero:
	move $s3, $s2  
	la $t0, jugador
	lw $t1, 4($t0)
	add $t1, $t1, $s3
	sw $t1, 4($t0)
verificar_meta:
	lw $t8, num
	bne $s1, $t8, no_llego_meta
	la $t0, jugador
	li $t1, 1
	sw $t1, 12($t0)
	li $v0, 4
	la $a0, msg_jugador_txt
	syscall
	la $a0, msg_movio_casillas
	syscall
	li $v0, 1
	move $a0, $s0  
	syscall
	li $v0, 4
	la $a0, msg_llego_meta
	syscall
	j mostrar_stats_jugador
no_llego_meta:
	li $v0, 4
	la $a0, msg_jugador_txt
	syscall
	la $a0, msg_movio_casillas
	syscall
	li $v0, 1
	move $a0, $s0  
	syscall
	li $v0, 4
	la $a0, msg_casillas
	syscall
	li $v0, 1
	move $a0, $s1  
	syscall
	li $v0, 4
	la $a0, salto
	syscall
mostrar_stats_jugador:
	la $a0, jugador
	move $a1, $s3  
	jal mostrar_datos
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
    	addi $sp, $sp, 12
    	jr $ra
mov_maquina:
	addi $sp, $sp, -12
    	sw $ra, 0($sp)
    	sw $s0, 4($sp)  
    	sw $s1, 8($sp)  
loop_3:
	li $a0, 1
	li $a1, 6
	jal random
	move $s0, $v0  
	la $t0, maquina
	lw $t4, 0($t0)       
	add $t5, $t4, $s0    
	lw $t8, num
	slt $t9, $t8, $t5    
	bnez $t9, loop_3     
mover_maquina:
	sw $t5, 0($t0)
	move $s1, $t5  
	la $t6, tablero
	sub $t7, $s1, 1      
	sll $t7, $t7, 2      
	add $t7, $t6, $t7    
	lw $s2, 0($t7)       
	li $t9, 1
	bne $s2, $t9, es_dinero_maq
	li $v0, 4
	la $a0, msg_encontro_tesoro
	syscall
	la $t0, maquina
	lw $t1, 8($t0)
	addi $t1, $t1, 1
	sw $t1, 8($t0)
	li $s3, 0  
	j verificar_meta_maq
es_dinero_maq:
	move $s3, $s2  
	la $t0, maquina
	lw $t1, 4($t0)
	add $t1, $t1, $s3
	sw $t1, 4($t0)
verificar_meta_maq:
	lw $t8, num
	bne $s1, $t8, no_llego_meta_maq
	la $t0, maquina
	li $t1, 1
	sw $t1, 12($t0)
	li $v0, 4
	la $a0, msg_maquina_txt
	syscall
	la $a0, msg_movio_casillas
	syscall
	li $v0, 1
	move $a0, $s0  
	syscall
	li $v0, 4
	la $a0, msg_llego_meta
	syscall
	j mostrar_stats_maquina
no_llego_meta_maq:
	li $v0, 4
	la $a0, msg_maquina_txt
	syscall
	la $a0, msg_movio_casillas
	syscall
	li $v0, 1
	move $a0, $s0  
	syscall
	li $v0, 4
	la $a0, msg_casillas
	syscall
	li $v0, 1
	move $a0, $s1  
	syscall
	li $v0, 4
	la $a0, salto
	syscall
mostrar_stats_maquina:
	la $a0, maquina
	move $a1, $s3  
	jal mostrar_datos
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
    	addi $sp, $sp, 12
    	jr $ra
fill_arr:
	addi $sp, $sp, -16
    	sw $ra, 0($sp)
    	sw $s0, 4($sp)   
    	sw $s1, 8($sp)
    	sw $s2, 12($sp)
    	li $s0, 0        
    	lw $s1, num      
    	li $s2, 0        
for_loop:
	beq $s2, $s1, end_loop
	lw $t4, tesoros 
    	sub $t5, $t4, $s0    
    	sub $t6, $s1, $s2    
    	beq $t5, $t6, poner_tesoro
    	li $a0, 1
    	li $a1, 3
    	jal random
    	move $t7, $v0
    	li $t8, 3
    	bne $t7, $t8, poner_money
    	lw $t9, tesoros
   	slt $t0, $s0, $t9
   	beqz $t0, poner_money
   	j poner_tesoro
poner_tesoro:
	la  $t5, tablero
    	sll $t6, $s2, 2      
    	add $t7, $t5, $t6
    	li  $t8, 1
    	sw  $t8, 0($t7)      
    	addi $s0, $s0, 1     
    	j siguiente
poner_money:
	li $a0, 10
    	li $a1, 100
    	jal random
    	la  $t5, tablero
    	sll $t6, $s2, 2      
    	add $t7, $t5, $t6
    	sw  $v0, 0($t7)      
siguiente:
    	addi $s2, $s2, 1     
    	j for_loop
end_loop:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	addi $sp, $sp, 16
    	jr $ra
imprimir_arreglo:
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	li $v0, 4
    	la $a0, msg_debug_tablero
    	syscall
    	lw $t0, num        
    	li $t1, 0          
    	li $t8, 0          
loop_print:
    	slt $t2, $t1, $t0  
    	beq $t2, $zero, fin_print
    	la  $t3, tablero
    	sll $t4, $t1, 2    
    	add $t5, $t3, $t4  
    	lw $t6, 0($t5)
    	li $v0, 4
    	la $a0, msg_casilla
    	syscall
    	li $v0, 1
    	addi $a0, $t1, 1
    	syscall
    	li $t7, 1
    	bne $t6, $t7, es_dinero_print
    	li $v0, 4
    	la $a0, msg_tesoro_marker
    	syscall
    	addi $t8, $t8, 1  
    	j siguiente_print
es_dinero_print:
    	li $v0, 4
    	la $a0, msg_dinero_marker
    	syscall
    	li $v0, 1
    	move $a0, $t6
    	syscall
    	li $v0, 4
    	la $a0, salto
    	syscall
siguiente_print:
    	addi $t1, $t1, 1
    	j loop_print
fin_print:
	li $v0, 4
	la $a0, msg_fin_debug
	syscall
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	move $a0, $t8
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	la $a0, salto
	syscall
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra
mostrar_datos:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	move $t0, $a0  
	move $t1, $a1  
	li $v0, 4
	la $a0, msg_dinero_obtenido
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, msg_dinero_acumulado
	syscall
	lw $t2, 4($t0)  
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	lw $t3, 8($t0)  
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	la $a0, salto
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
robo:
	lw $t0, 4($a1)  
	sw $zero, 4($a1)  
	lw $t1, 4($a0)  
	add $t1, $t1, $t0  
	sw $t1, 4($a0)
	li $v0, 4
	la $a0, msg_robo
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, msg_dinero
	syscall
	jr $ra
partida:
	la $t0, jugador
	lw $t1, 8($t0)   
	la $t2, maquina
	lw $t3, 8($t2)   
	slti $t4, $t1, 3  
	slti $t5, $t3, 3  
	and $t6, $t4, $t5  
	lw $t7, 12($t0)  
	lw $t8, 12($t2)  
	seq $t9, $t7, 1  
	beq $t8, 1, check_bool2
	li $s0, 0
	j compute_result
check_bool2:
	and $s0, $t9, 1  
compute_result:
	xori $s1, $s0, 1  
	and $v0, $t6, $s1
	jr $ra
imprimir_ganador_jugador:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 4
	la $a0, msg_ganador
	syscall
	la $a0, msg_jugador_txt
	syscall
	la $a0, msg_dinero_acumulado
	syscall
	la $t0, jugador
	li $v0, 1
	lw $a0, 4($t0)  
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	lw $a0, 8($t0)  
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	la $a0, msg_perdedor
	syscall
	la $a0, msg_maquina_txt
	syscall
	la $a0, msg_dinero_acumulado
	syscall
	la $t1, maquina
	li $v0, 1
	lw $a0, 4($t1)  
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	lw $a0, 8($t1)  
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
imprimir_ganador_maquina:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 4
	la $a0, msg_ganador
	syscall
	la $a0, msg_maquina_txt
	syscall
	la $a0, msg_dinero_acumulado
	syscall
	la $t0, maquina
	li $v0, 1
	lw $a0, 4($t0)  
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	lw $a0, 8($t0)  
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	la $a0, msg_perdedor
	syscall
	la $a0, msg_jugador_txt
	syscall
	la $a0, msg_dinero_acumulado
	syscall
	la $t1, jugador
	li $v0, 1
	lw $a0, 4($t1)  
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	lw $a0, 8($t1)  
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
