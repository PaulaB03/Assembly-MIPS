# Sa se implementeza procedura divizibile_in_intervalul(a,b,x) care determina cate numere sunt divizibile cu x in intervalul [a,b], stiind ca a<b si  ca a,b si x sunt ner nat nenule.

.data
	a: .word 3
	q: .word 6
	x: .word 2

.text

divizibile_in_intervalul:	
	subu $sp, 4
	sw $fp, 0($sp)
	addi $fp, $sp, 4

	subu $sp, 4
	sw $s0, 0($sp)	
	subu $sp, 4
	sw $s1, 0($sp)	
	subu $sp, 4
	sw $s2, 0($sp)	

	# $sp: ($s2 v)($s1 v)($s0 v)($fp v) $fp: (a)(b)(x)

	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $s2, 8($fp)

	li $v0, 0
loop:
	bgt $s0, $s1, exit
	
	move $t0, $s0
	rem $t1, $t0, $s2
	
	beq $t1, 0, modif
return:
	addi $s0, 1
	j loop

modif:
	addi $v0, 1
	j return

exit:
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, 16
	jr $ra

main:
	lw $t0, x
	subu $sp, 4
	sw $t0, 0($sp) 

	lw $t0, q
	subu $sp, 4
	sw $t0, 0($sp)

	lw $t0, a
	subu $sp, 4
	sw $t0, 0($sp)

	jal divizibile_in_intervalul

	addu $sp, 12

	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
