# Fie un array declarat in memorie. Sa se scrie o procedura modif(*v, n) care adauga +1 pe fiecare element.

.data
	v: .word 3, 7, 2, 15, 21
	n: .word 5

.text

modif:
	subu $sp, 4
	sw $fp, 0($sp)
	addi $fp, $sp, 4
	
	subu $sp, 4
	sw $s0, 0($sp)
	subu $sp, 4
	sw $s1, 0($sp)

	# $sp: ($s1 v)($s0 v)($fp v) $fp: (*v)(n)

	lw $s0, 0($fp)
	lw $s1, 4($fp)

	li $t0, 0
loop:
	beq $t0, $s1, ex_loop
	
	lw $t1, 0($s0)			# $t1 este elementul curent 
	addi $t1, 1
	sw $t1, 0($s0)

	addi $t0, 1
	addi $s0, 4
	j loop

ex_loop:
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, 12
	jr $ra

main:
	lw $t0, n
	subu $sp, 4
	sw $t0, 0($sp)

	la $t0, v
	subu $sp, 4
	sw $t0, 0($sp)

	jal modif

	addu $sp, 8

lw $t0, n
	li $t1, 0			# pe post de "i"
	li $t2, 0			# sare locatii de memorie din 4 in 4
afis_vector:
	bge $t1, $t0, exit
	
	lw $a0, v($t2)
	li $v0, 1			# PRINT WORD
	syscall

	li $a0, ' '
	li $v0, 11			# PRINT BYTE, nu functioneaza pentru tema
	syscall

	addi $t1, 1			# i++
	addi $t2, 4			# sar inca 4 bytes
	j afis_vector
	
exit:
	li $v0, 10
	syscall
