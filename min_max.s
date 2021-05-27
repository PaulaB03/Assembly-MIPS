#Sa se determine maximul, minimul si numarul lor de aparitii dintr-un array declarat in memorie.

.data
	n: .word 10
	v: .word 3, 8, 1, 9, 1, 11, 11, 11, 10, 11
	str1: .asciiz "Valoarea maxima: "
	str2: .asciiz " aparitie: "
	str3: .asciiz "Valoarea minima: "
	space: .asciiz "\n"

.text

main:
	li $t0, 0
	lw $t1, v($t0)			# registrul t1 va salva max
	lw $t2, v($t0)			# registrul t2 va salva min
	li $t3, 1			# numarul aparitiilor max 
	li $t4, 1			# numarul aparitiilor min

	lw $t0, n
	li $t5, 1			# i = 1 (sarim peste primul element)
	li $t6, 4			# sare locatii de memorie din 4 in 4

loop:
	beq $t0, $t5, exit		# i = n
	
	lw $t7, v($t6)					
	
	beq $t7, $t1, maxim1		# v[i] == max
	beq $t7, $t2, minim1		# v[i] == min
	bgt   $t7, $t1, maxim		# v[i] > max
	blt   $t7, $t2, minim 		# v[i] < min

return:
	addi $t5, $t5, 1		# i++		
	addi $t6, $t6, 4
	j loop


maxim1:					# aparitii max
	addi $t3, $t3, 1
	j return

minim1:					# aparitii min
	addi $t4, $t4, 1
	j return 

maxim:
	move $t1, $t7			# actualizare max
	li $t3, 1			# resetare numar aparitii
	j return 

minim:
	move $t2, $t7			# actualizare min
	li $t4, 1			# resetare numar aparitii
	j return 

exit:

#Afisarea maximului:

	la $a0, str1
	li $v0, 4			# print string
	syscall	

	move $a0, $t1
	li $v0, 1			# print int
	syscall	

	la $a0, str2
	li $v0, 4			# print string
	syscall				        

	move $a0, $t3
	li $v0, 1			# print int
	syscall	

	la $a0, space
	li $v0, 4			# print string
	syscall				        

#Afisarea minimului:

	la $a0, str3
	li $v0, 4			# print string
	syscall			

	move $a0, $t2
	li $v0, 1			# print int
	syscall	

	la $a0, str2
	li $v0, 4			# print string
	syscall		

	move $a0, $t4
	li $v0, 1			# print int
	syscall	

	li, $v0, 10			# EXIT
	syscall
