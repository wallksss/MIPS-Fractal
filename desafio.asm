###############################################################
### 			BITMAP SETTINGS			    ###	
###							    ###
###	Unit Width in pixels: 1 			    ###
###	Unit Heigh in Pixels: 1				    ###
###	Display Width in Pixels: 512			    ###
###	Display Height in Pixels: 512  			    ###
###	Base address for display 0x10010000 (static data)   ###
###							    ###	
###############################################################
.data
frameBuffer: .space 0x100000 # 512 width x 512 height x 4 bytes = 1048576 bytes = 0x100000 bytes

.text

.macro save_registers
    addi $sp, $sp, -32
    sw $t0, 28($sp)
    sw $t1, 24($sp)
    sw $t2, 20($sp)
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $a3, 4($sp)
    sw $ra, 0($sp)
.end_macro

.macro load_registers
    lw $ra, 0($sp)
    lw $a3, 4($sp)
    lw $a2, 8($sp)
    lw $a1, 12($sp)	
    lw $a0, 16($sp)
    lw $t2, 20($sp)
    lw $t1, 24($sp)
    lw $t0, 28($sp)
    addi $sp, $sp, 32
.end_macro

.macro save_recursion_registers
    addi $sp, $sp, -44
    sw $t0, 40($sp)
    sw $t1, 36($sp)
    sw $t2, 32($sp)
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $a3, 4($sp)
    sw $ra, 0($sp)
.end_macro

.macro load_recursion_registers
    lw $ra, 0($sp)
    lw $a3, 4($sp)
    lw $a2, 8($sp)
    lw $a1, 12($sp)
    lw $a0, 16($sp)
    lw $t2, 32($sp)
    lw $t1, 36($sp)
    lw $t0, 40($sp)
    addi $sp, $sp, 44
.end_macro

main:
    #DEFINICAO DE PONTOS DO PRIMEIRO TRIANGULO
    li $a0, 10 #x1
    li $a1, 501 #y1
    li $a2, 501 #x2
    li $a3, 501 #y2
    li $t0, 256 #x3
    li $t1, 10 #y3
    
    #AJUSTAR A PROFUNDIDADE
    li $s7, 10 #depth = 3
    
    #PASSAGEM DE PARAMETRO PELA PILHA
    addi $sp, $sp, -8
    sw $t0, 4($sp)
    sw $t1, 0($sp)
       
    jal draw_sierpinski

    #SAI DO PROGRAMA
    li $v0, 10
    syscall	

draw_sierpinski:
    lw $t1, 0($sp)
    lw $t0, 4($sp)
    addi $sp, $sp, 8

    #DESENHO PRIMEIRA LINHA
    save_registers 
    jal draw_line
    load_registers
    
    #DESENHO SEGUNDA LINHA
    save_registers
    move $a2, $t0
    move $a3, $t1
    jal draw_line
    load_registers
    
    #DESENHO TERCEIRA LINHA
    save_registers
    move $a0, $a2
    move $a1, $a3
    move $a2, $t0
    move $a3, $t1
    jal draw_line
    load_registers
    
    addi $sp, $sp, -32
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $a3, 4($sp)
    sw $ra, 0($sp)
 
    #REGISTRADORES TEMPORARIOS PARA REALIZAR AS CONTAS 
    move $t2, $a0 #temp = x1
    move $t3, $a1 #temp = y1
    move $t4, $a2 #temp = x2
    move $t5, $a3 #temp = y2
    move $t6, $t0 #temp = x3
    move $t7, $t1 #temp = y3
    
    #(x1 + x2) / 2	
    add $a0, $t2, $t4
    srl $a0, $a0, 1
    #(y1 + y2) / 2
    add $a1, $t3, $t5
    srl $a1, $a1, 1
    #(x1 + x3) / 2
    add $a2, $t2, $t6
    srl $a2, $a2, 1
    #(y1 + y3) / 2
    add $a3, $t3, $t7
    srl $a3, $a3, 1
    #(x2 + x3) / 2
    add $t0, $t4, $t6
    srl $t0, $t0, 1
    #(y2 + y3) / 2
    add $t1, $t5, $t7
    srl $t1, $t1, 1

    #PASSAGEM DE ARGUMENTOS PELA PILHA
    li $t2, 1
    sw $t0, 28($sp) #n
    sw $t1, 24($sp) #y3
    sw $t2, 20($sp) #x3
            
    jal sub_triangle

    lw $ra, 0($sp)
    lw $a3, 4($sp)
    lw $a2, 8($sp)
    lw $a1, 12($sp)
    lw $a0, 16($sp)
    lw $t1, 20($sp)
    lw $t0, 24($sp)
    addi $sp, $sp, 40
    
    jr $ra
    
sub_triangle:
    #RECUPERANDO OS PARAMETROS QUE ESTAO NA PILHA
    lw $t2, 20($sp) #x3
    lw $t1, 24($sp) #y3
    lw $t0, 28($sp) #n

    #DESENHO PRIMEIRA LINHA
    save_registers 
    jal draw_line
    load_registers
    
    #DESENHO SEGUNDA LINHA
    save_registers
    move $a2, $t0
    move $a3, $t1
    jal draw_line
    load_registers
    
    #DESENHO TERCEIRA LINHA
    save_registers
    move $a0, $a2
    move $a1, $a3
    move $a2, $t0
    move $a3, $t1
    jal draw_line
    load_registers

################################################################################
### 			IMPLEMENTE SEU CODIGO DAQUI			    ###
###############################################################################
    #INICIO RECURSAO

    exit_recursion:
    jr $ra
###############################################################
### 			ATÉ AQUI			    ###	
###############################################################

draw_line:
    sub $s0, $a2, $a0 # dx = x1 - x0
    sub $s1, $a3, $a1 # dy = y1 - y0

    #(dx > 0) ? 1 : -1;
    blez $s0, else_dx
    li $s3, 1 # sx = 1
    j end_if_dx
    else_dx:
        li $s3, -1 # sx = -1
    end_if_dx:

    #(dy > 0) ? 1 : -1;
    blez $s1, else_dy
    li $s4, 1 # sy = 1
    j end_if_dy
    else_dy:
        li $s4, -1 # sy = -1
    end_if_dy:

    # dx = abs(dx);
    bgez $s0, end_abs_dx
    negu $s0, $s0 # dx = -dx
    end_abs_dx:

    # dy = abs(dy);
    bgez $s1, end_abs_dy
    negu $s1, $s1 # dy = -dy
    end_abs_dy:

    sub $s5, $s0, $s1 # err = dx - dy

while_loop:
    #pegando a posição do pixel atual no buffer de pixels
    sll $t0, $a1, 9
    add $t0, $t0, $a0
    sll $t0, $t0, 2

    #colocando a cor branca na posição x0, y0
    li $t1, 0xffffff
    sw $t1, frameBuffer($t0)

    #if (x0 == x1 && y0 == y1) break;
    bne $a0, $a2, continue_loop
    bne $a1, $a3, continue_loop
    j exit_loop

continue_loop:
    sll $s6, $s5, 1 # e2 = err * 2

    negu $t0, $s1
    blt $s6, $t0, ignore_if_negative_dy # if (e2 > -dy)
    sub $s5, $s5, $s1 # err -= dy
    add $a0, $a0, $s3 # x0 += sx
ignore_if_negative_dy:

    bge $s6, $s0, ignore_if_dx # if (e2 < dx)
    add $s5, $s5, $s0 # err += dx
    add $a1, $a1, $s4 # y0 += sy
ignore_if_dx:

    j while_loop

exit_loop:
    jr $ra