.data
	queue: .space 80
	visited: .space 80

	roles: .space 80
	matrix: .space 1600
	n: .space 4
	m: .space 4

	v1: .space 4
	v2: .space 4
	text: .space 20

	str1: .asciiz	"host index "
	str2: .asciiz   "switch index "
	str3: .asciiz   "switch malitios index "
	str4: .asciiz   "controller index "
	ch1: .asciiz    ": "
	ch2: .asciiz    "; "
	ch3: .asciiz	"Yes"
	ch4: .asciiz	"No"
	NL: .asciiz	"\n"

.text

main:
						# Citire matrice

	li $v0, 5
	syscall
	sw $v0, n

	li $v0, 5
	syscall
	sw $v0, m

	lw $t0, m
	lw $t6, n
	li $t1, 0

for_edges:
	bge $t1, $t0, cont0
			
	li $v0, 5
	syscall
	move $t2, $v0
	
	li $v0, 5
	syscall
	move $t3, $v0

	mul $t4, $t2, $t6
	add $t4, $t4, $t3
	mul $t4, $t4, 4

	li $t5, 1
	sw $t5, matrix($t4)

	mul $t4, $t3, $t6
	add $t4, $t4, $t2
	mul $t4, $t4, 4
	sw $t5, matrix($t4)

	addi $t1, 1
	j for_edges

						# Citire vector
cont0:
	lw $t0, n
	li $t1, 0
	li $t2, 0

for_loop:
	beq $t0, $t1, solve

	li $v0, 5
	syscall
	sw $v0, roles($t2)

	addi $t1, 1
	addi $t2, 4
	j for_loop
	
						# Rezolvare
solve:
	li $v0, 5 
	syscall
	move $t0, $v0

	beq $t0, 1, solve1			# Problema 1
	beq $t0, 2, solve2			# Problema 2
	beq $t0, 3, solve3			# Problema 3


						# Rezolvare problema 1
solve1:
	lw $t0, n				# $t0 = n
	li $t1, 0				# $t1 = i = 0
	li $t2, 0				# sare din 4 in 4
	
	loop:
		beq $t1, $t0, exit		# i = n

		lw $t3, roles($t2)		# $t3 = roles[i]
	
		bne $t3, 3, cont		# if(roles[i] = 3)
	
		la $a0, str3
		li $v0, 4
		syscall
	
		move $a0, $t1
		li $v0, 1
		syscall

		la $a0, ch1
		li $v0, 4
		syscall

		li $t4, 0			# $t4 = j = 0
	
		search:
			beq $t4, $t0, return 	# j = n

			mul $t5, $t1, $t0	
			add $t5, $t5, $t4
			mul $t5, $t5, 4

			lw $t6, matrix($t5)	# m[i][j]
		
			bne $t6, 1, cont1	# if(m[i][j] == 1)

			move $t5, $t4
			mul $t5, $t5, 4

			lw $t6, roles($t5)
	
			beq $t6, 1, et1
			beq $t6, 2, et2
			beq $t6, 3, et3
			beq $t6, 4, et4
		
			cout:

			move $a0, $t4
			li $v0, 1
			syscall
	
			la $a0, ch2
			li $v0, 4
			syscall
			
		cont1:
			addi $t4, 1
			j search
	
	return:
		lb $a0, NL
		li $v0, 11
		syscall
	
	cont:
		addi $t1, 1		# i ++
		addi $t2, 4
		j loop

	et1:
		la $a0, str1
		li $v0, 4
		syscall
		j cout

	et2:
		la $a0, str2
		li $v0, 4
		syscall
		j cout

	et3:
		la $a0, str3
		li $v0, 4
		syscall
		j cout

	et4:
		la $a0, str4
		li $v0, 4
		syscall
		j cout


#	for(i = 0; i < n; i ++)
#		if(roles[i] == 3)
#		{
#		    cout << "switch malitios index " << i << ": ";
#			for(j = 0; j < n ; j ++)
#				if(m[i][j] == 1)
#				{
#					if(roles[j] == 1) cout << "host index " << j << "; ";
#					if(roles[j] == 2) cout << "switch index " << j << "; ";
#					if(roles[j] == 3) cout << "switch malitios index " << j << "; ";
#					if(roles[j] == 4) cout << "switch index " << j << "; ";
#				}
#			cout<< "\n";
#		}			

						# Rezolveare problema 2
solve2:
	lw $t0, n
	li $t1, 0				# $t1 = queueLen
	li $t2, 0				# $t2 = queueIdx
	
	li $t7, 0				# $t7 = numarul nodurilor host din vectorul queue

	li $t3, 0
	sw $t3, queue($t1)			# queue[0] = 0
	addi $t1, 1				# queueLen ++
	
	li $t5, 1
	sw $t5, visited($t2)			# visited[0] = 1

	loop2:
		beq $t2, $t1, check		# while queueIdx != queueLen
	
		mul $t3, $t2, 4
		lw $t4,	queue($t3)		# currentNode = queue[queueIdx]

		addi $t2, 1			# queueIdx ++

		mul $t3, $t4, 4
		lw $t5, roles($t3)		# $t5 = roles[currentNode]

		beq $t5, 1, et1_2		# if roles[currentNode] == 1

	cont2_0:
		li $t5, 0			# columnIndex = 0
	
	loop2_1:
		bge $t5, $t0, loop2		# while columnIndex < n

		mul $t3, $t4, $t0
		add $t3, $t3, $t5
		mul $t3, $t3, 4

		lw $t6, matrix($t3)		# $t6 = matrix[currentNode][columnIndex]

		bne $t6, 1, cont2_1		# if matrix[currentNode][columnIndex] == 1

		mul $t3, $t5, 4
		lw $t6, visited($t3)		# $t6 = visited[columnIndex]

		beq $t6, 1, cont2_1		# if visited[columnIndex] != 1

		mul $t3, $t1, 4
		sw $t5, queue($t3)		# queue[queueLen] = columnIndex
		addi $t1, 1			# queueLen ++
	
		mul $t3, $t5, 4
		li $t6, 1
		sw $t6,	visited($t3)		# visited[columnIndex] = 1

	cont2_1:
		addi $t5, 1			# columnIndex ++
		j loop2_1

	et1_2:					#  print currentNode
		la $a0, str1
		li $v0, 4
		syscall
			
		move $a0, $t4
		li $v0, 1
		syscall

		la $a0, ch2
		li $v0, 4
		syscall

		addi $t7, 1
		j cont2_0

	check:					# verifica daca vectorii queue si roles au acelasi numar de noduri host
		la $a0, NL
		li $v0, 4
		syscall

		li $t2, 0
		li $t3, 0
		li $t5, 0		

		for2:				# numara nodurile host din vectorul roles
			beq $t0, $t2, check_out
			lw $t4, roles($t3)
			
			bne $t4, 1, cont2_2
			addi $t5, 1
			
		cont2_2:
			addi $t2, 1
			addi $t3, 4
			j for2
			
	check_out:
		beq $t5, $t7, True

		la $a0, ch4
		li $v0, 4
		syscall	
		j exit

	True:	
		la $a0, ch3
		li $v0, 4
		syscall
		j exit

						# Rezolvare problema 3
solve3:
	li $v0, 5
	syscall
	sw $v0, v1				# citire primul nod

	li $v0, 5
	syscall
	sw $v0, v2				# citire al doile nod

	li $v0, 8
	la $a0, text
	li $a1, 20
	syscall					# Citire mesaj 

	lw $t0, n
	li $t1, 1				# $t1 = queueLen
	li $t2, 0				# $t2 = queueIdx
	
	lw $t3, v1
	sw $t3, queue($t2)			# queue[0] = v1
	mul $t3, $t3, 4
	sw $t1, visited($t3)			# visited[v1] = 1

	loop3:
		beq $t2, $t1, modif		# while queueIdx != queueLen
	
		mul $t3, $t2, 4
		lw $t4,	queue($t3)		# currentNode = queue[queueIdx]

		lw $t7, v2
		beq $t4, $t7, cout3				# daca currentNode = b exit


		addi $t2, 1			# queueIdx ++
		li $t5, 0			# columnIndex = 0
	
	loop3_1:
		bge $t5, $t0, loop3		# while columnIndex < n

		mul $t3, $t4, $t0
		add $t3, $t3, $t5
		mul $t3, $t3, 4

		lw $t6, matrix($t3)		# $t6 = matrix[currentNode][columnIndex]

		bne $t6, 1, cont3_0		# if matrix[currentNode][columnIndex] == 1

		mul $t3, $t5, 4
		lw $t6, visited($t3)		# $t6 = visited[columnIndex]

		beq $t6, 1, cont3_0		# if visited[columnIndex] != 1

		lw $t6, roles($t3)
		beq $t6, 3, cont3_0		# if roles[columnIndex] != 3

		mul $t3, $t1, 4
		sw $t5, queue($t3)		# queue[queueLen] = columnIndex
		addi $t1, 1			# queueLen ++
	
		mul $t3, $t5, 4
		li $t6, 1
		sw $t6,	visited($t3)		# visited[columnIndex] = 1

	cont3_0:
		addi $t5, 1			# columnIndex ++
		j loop3_1

	modif:					# modifica mesajul
		li $t0, 0
	rep:
		lb $t1, text($t0)
		beqz $t1, cout3
	
		ble $t1, 106, end 
	cont3_1:
		sub $t1, $t1, 10
		sb $t1, text($t0)
		addi $t0, 1
		j rep
	end:
		addi $t1, 26
		j cont3_1

	cout3:					# afiseaza mesajul
		la $a0, text
		li $v0, 4
		syscall

exit:
	li $v0, 10
	syscall
