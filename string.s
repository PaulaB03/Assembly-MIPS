# Fie str un sir de caractere format doar din caracterele englezesti mari (de la A la Z) si ch un caracter de la A la Z. Sa se returneze pozitia primei aparitii a lui ch in sirul str daca ch exista in acest sir si doar daca pozitia imediat urmatoare pozitiei curente pe care ne aflam este consoana, si -1 altfel.
# Exemplu:
#	(“DJSAHK”, ‘A’) = 3 pentru ca dupa ‘A’ urmeaza consoana in sir.
#	(“DJSAEK”, ‘A’) = -1 pentru ca dupa ‘A’ urmeaza o vocala.
#	(“DJSAEKAT”, ‘A’) = 6 pentru ca dupa primul ‘A’ urmeaza vocala, iar dupa cel de-al doilea ‘A’ urmeaza consoana.

# Daca ultimul caracter cautat este strict la finalul sirului, de exemplu cautam ‘Z’ in “ABCDZ”, atunci rezultatul va fi pozitia lui, in acest caz 4.

.data
	str: .asciiz "DJSAHK"
	ch: .byte 'A'
	voc: .asciiz "AEIOU"

.text

main:
	li $t0, 0
	li $t1, -1
	lb $t5, ch
	
loop:
	lb $t2, str($t0)
	beqz $t2, exit
	bne $t1, -1, vocala
	
	beq $t5, $t2, change

cont:
	addi $t0, 1
	j loop

change:
	move $t1, $t0
	j cont


			#cautarea vocalei in urmatorul caracter
	
vocala:
	li $t3, 0
	
repet:
	lb $t4, voc($t3)
	beqz $t4 cont

	beq $t2, $t4, false

return:
	addi $t3, 1
	j repet

false:
	li $t1, -1
	j return


			# afisare	

exit:
	move $a0, $t1
	li $v0, 1
	syscall

	li $v0, 10
	syscall
	
