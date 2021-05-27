# Se citeste n si un vector de elemente intregi. Sa se verifice daca elementele sunt in ordine strict crescatoare, iar daca da, sa se afiseze un mesaj corespunzator. Daca nu, sa se afiseze primul index de la care nu se mai respecta ordinea (indexare de la 0).

.data
	s1: .asciiz "Vectorul este crescator"
	s2: .asciiz "Vectorul nu mai este crescator de la indexul "

.text

main:
	li $v0, 5
	syscall
	move $t0, $v0			# n
	
	li $v0, 5
	syscall
	move $t1, $v0			# v[0]

	li $t2, 1			# i

loop:
	beq $t0, $t2 true

	li $v0, 5
	syscall
	move $t3, $v0
	
	bge $t1, $t3, false

	addi $t2, 1
	move $t1, $t3	
	j loop

true:
	la $a0, s1
	li $v0, 4
	syscall
	
	j exit

false:
	la $a0, s2
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall

exit:
	li $v0, 10
	syscall
