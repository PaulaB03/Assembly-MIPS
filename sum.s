.data
	x: .word 15
	y: .word 8
.text

suma:
	subu $sp, 4
	sw $fp, 0($sp)		# PUSH $fp
	addi $fp, $sp, 4

	# $sp:($fp v)$fp:(x)(y)

	lw $t0, 0($fp)
	lw $t1, 4($fp)
	add $v0, $t0, $t1
	
	lw $fp, -4($fp)
	addu $sp, 4		# POP $fp
	jr $ra

main:
	lw $t0, y
	subu $sp, 4		# PUSH y
	sw $t0, 0($sp)

	lw $t0, x
	subu $sp, 4		# PUSH x
	sw $t0, 0($sp)

	jal suma

	addu $sp, 8		# POP x; POP y;

	move $a0, $v0
	li $v0, 1
	syscall

	li $v0, 10
	syscall
