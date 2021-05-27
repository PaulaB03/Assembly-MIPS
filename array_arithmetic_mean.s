#Sa se calculeze media aritmatica a elementelor unui array citit de la tastatura

.data
	v: .space 400
	str1: .asciiz "Catul = "
	str2: .asciiz "Restul = "
	space: .asciiz "\n"

.text

main:
	li $v0, 5
	syscall
	move $t0, $v0				# citire n

	li $t1, 0				# i = 0
	li $t2, 0				# sare locatii de memorie din 4 in 4
	li $t3, 0				# s = 0 

loop:
	beq $t1, $t0, exit                      # i = n
	
	li $v0, 5
	syscall
	sw $v0, v($t2)				# citire element
	
	lw $t4, v($t2)
	add $t3, $t3, $t4			# suma elementelor

	addi $t1, $t1, 1			# i ++	
	addi $t2, $t2, 4
	j loop

exit:

	la $a0, str1
	li $v0, 4				# print string
	syscall	

	div $a0, $t3, $t0			# s / n
	li $v0, 1				# print int
	syscall

	la $a0, space
	li $v0, 4				# print string
	syscall

	la $a0, str2
	li $v0, 4				# print string			
	syscall	

	rem $a0, $t3, $t0			# s % n
	li $v0, 1				# print int
	syscall					

	li, $v0, 10				# exit
	syscall
