# Apeluri imbricate de proceduri
# f(x) = 2*g(x)				returneaza in $v0
# unde g(x) = x + 1			returneaza in $v1

#g:
#	# $ra stie sa se lege la (**)
#	...
#	jr $ra

#f:
#	# $ra stie sa se lege la (*)
#	jal g 
#-------> (**)
#		cicleaza in aceasta zona
#		din cauza ca nu am restaurat $ra
#	jr $ra

#main:
#
#	jal f
#------> (*)

.data
	x: .word 5
.text

g:
	# $sp: (x)			# $sp: (x)(s0 v f)(ra v f)(fp v f)$fp: (x)
	subu $sp, 4
	sw $fp, 0($sp)			# PUSH $fp
	addi $fp, $sp, 4		# $fp pointeaza in cadrul de apel

	# $sp: ($fp v)$fp:(x)	

	subu $sp, 4
	sw $s0, 0($sp)			# PUSH $s0

	# $sp: ($s0 v)($fp v)$fp:(x)

	lw $s0, 0($fp)			
	addi $v1, $s0, 1		# $v1 = $s0 + 1 i.e. $v1 = x + 1

	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, 8
	jr $ra

f:
	subu $sp, 4
	sw $fp, 0($sp)			# PUSH $fp
	addi $fp, $sp, 4		# $fp pointeaza in cadrul de apel

	subu $sp, 4
	sw $ra, 0($sp)			# PUSH $ra

	# $sp: ($ra v)($fp v)$fp: (x)

	# iau x intr-o variabila locala, adica intr-un registru $s
	subu $sp, 4
	sw $s0, 0($sp)			# PUSH $s0

	# $sp: ($s0 v)($ra v)($fp v)$fp: (x)
	lw $s0, 0($fp)			# $s0 este x 

	# trebuie sa apelez procedura g 


	# creez un cadru local de apel: PUSH x; call g; POP x;	
	# -----------------------------------------------------
	subu $sp, 4
	sw $s0, 0($sp)			# PUSH x
	
	# $sp: (x)($s0 v)($ra v)($fp v)$fp: (x)

	jal g 				# call g 
	# $ra este modificat sa se intoarca la linia urmatoare
	addu $sp, 4			# POP x
	# $sp: ($s0 v)($ra v)($fp v)$fp: (x)
	# -----------------------------------------------------

	mul $v0, $v1, 2

	# $sp: ($s0 v)($ra v)($fp v)$fp: (x)
	lw $s0, -12($fp)
	lw $ra, -8($fp)
	lw $fp, -4($fp)
	addu $sp, 12
	jr $ra

main:
	lw $t0, x
	subu $sp, 4
	sw $t0, 0($sp)			# PUSH x

	jal f

	addu $sp, 4

	move $a0, $v0
	li $v0, 1			# PRINT WORD
	syscall

	li $v0, 10
	syscall
