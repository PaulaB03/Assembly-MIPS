# Sa se afiseze toate elementele perfecte dintr-un array declarat in memorie.
#	Numar perfect este egal cu suma divizorilor sai ( cu exceptia lui)


.data
	v: .word 15, 6, 13, 28, 9
	n: .word 5

.text

main:
	lw $t0, n			# n
	li $t1, 0			# i
	li $t2, 0			# sare din 4 in 4

loop:
	beq $t0, $t1, exit		# i == n

	li $t3, 1			# s = 1
	li $t4, 2			# d = 2
	lw $t5, v($t2)			# v[i]

divi:
	ble $t5, $t4, cont		# v[i] <= d
	
	rem $a0, $t5, $t4		# a0 = v[i] % d
	beq $a0, 0 sum			# a0 = 0

return:
	addi $t4, 1			# d ++
	j divi			

sum:
	add $t3, $t3, $t4		# s += d
	j return

cont:
	beq $t3, $t5, afis		# s == v[i]	
	bne $t3, $t5, plus		# s != v[i]

afis:
	move $a0, $t5
	li $v0, 1			# print int
	syscall
	
	li $v0, 11			# print byte
	li $a0, ' '
	syscall

plus:
	addi $t1, 1			# i ++
	addi $t2, 4 			# 
	j loop

exit:
	li $v0, 10
	syscall
