# Citirea unei matrici si afisarea ei

.data
	matrix: .space 1600
	NL: .asciiz "\n"
	SP: .asciiz " "

.text

main:
	li $v0, 5
	syscall
	move $t0, $v0			# Lines

	li $v0, 5
	syscall
	move $t1, $v0			# Collums

	li $t2, 0			# LineIndex
lines:
	bge $t2, $t0, exit
	
	li $t3, 0			# CollumIndex

	collums:
		bge $t3, $t1, cont
	
		li $v0, 5
		syscall
		move $t5, $v0

		mul $t4, $t2, $t1
		add $t4, $t4, $t3
		mul $t4, $t4, 4

		sw $t5, matrix($t4)

		move $a0, $t5
		li $v0, 1
		syscall

		lb $a0, SP
		li $v0, 11
		syscall
	
		addi $t3, 1
		j collums
		

cont:
	lb $a0, NL
	li $v0, 11
	syscall

	addi $t2, 1
	j lines

exit:
	li $v0, 10
	syscall
