# # Sa se implementeze functia calcul(x, y, z) care evalueaza expresia calcul(x, y, z) ≔ ∑(de la 0 la x + 1) [(y − i)*(z + [i/3]) + 1] , x, y, z ∈ N\{0}

.data
	x: .word 3
	y: .word 2
	z: .word 5

.text

calcul:
	subu $sp, 4
	sw $fp, 0($sp)			# PUSH $fp
	addi $fp, $sp, 4

	# $sp: ($fp v) $fp: (x) (y) (z)

	subu $sp, 4
	sw $s2, 0($sp)			# PUSH $s2

	subu $sp, 4
	sw $s1, 0($sp)			# PUSH $s1

	subu $sp, 4
	sw $s0, 0($sp)			# PUSH $s0

	# $sp: ($s0 v) ($s1 v) ($s2 v) ($fp v) $fp: (x) (y) (z)
	
	lw $s0, 0($fp)			# $s0 = x
	addi $s0, 1			# $s0 = x + 1
	lw $s1, 4($fp)			# $s1 = y
	lw $s2, 8($fp)			# $s2 = z

	li $t0, 0 			# i = 0
	li $t3, 0			# s = 0

loop:
	bgt $t0, $s0, exit	# i >  x + 1

	sub $t1, $s1, $t0	# y - i
	div $t2, $t0, 3		# i // 3
	add $t2, $t2, $s2	# z + i // 3
	mul $t2, $t1, $t2	# (y - i) * (z + i // 3)
	add $t2, $t2, 1		# (y - i) * (z + i // 3) + 1

	add $t3, $t3, $t2
	
	addi $t0, 1		# i ++
	j loop

exit:
	move $v0, $t3
	
	lw $s0, -16($fp)
	lw $s1, -12($fp)
	lw $s2,	-8($fp)
	lw $fp, -4($fp)
	addu $sp, 16		# POP $s0, $s1, $s2, $fp
	jr $ra

main:
	lw $t0, z
	subu $sp, 4
	sw $t0, 0($sp)			# PUSH z

	lw $t1, y
	subu $sp, 4
	sw $t1, 0($sp)			# PUSH y

	lw $t3, x
	subu $sp 4
	sw $t3, 0($sp)			# PUSH x

	jal calcul

	addu $sp, 12			# POP x, y, z

	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

#	s = 0
#	for i in range(x + 2):
#		s = s + 1 + (y - i) * (z + i // 3)
