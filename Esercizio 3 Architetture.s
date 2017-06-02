#ESERCIZIO 3 - PROGETTO ARCHITETTURE DEGLI ELABORATORI 2016-2017


.data
  string:   .asciiz "*************************************| ESERCIZIO 3 |******************************** \n Inserisci un numero intero compreso fra 0 e 5 per scegliere l'operazione da eseguire\n \t 1) Inserimento di matrici \n \t 2) Somma di matrici \n \t 3) Sottrazione di matrici \n \t 4) Prodotto di matrici \n \t 5) Uscita \n*************************************| ESERCIZIO 3 |******************************** \n"

  capo:	    .asciiz "\n"
  space:    .asciiz " "
  ok:	    .asciiz "Valori inseriti correttamente \n"
  prova:    .asciiz "Ho inserito un valore nella matrice finale "

  inserimento: .asciiz "\n Inserisci i valori della matrice. Vengono inseriti per riga, partendo dalla più in alto \n"
  dimensione: .asciiz "Scegli la grandezza della matrice (Max 5) \n"
  inserisciPrima: .asciiz "Inserisci un valore per la Prima Matrice \n"
  inserisciSeconda: .asciiz "Inserisci un valore per la Seconda Matrice \n"

.text

.globl main

main:

#STAMPA A SCHERMO IL MENU INIZIALE

    addi        $v0 , $0 , 4
    la          $a0 , string
    syscall

    addi        $v0, $0, 5
    syscall     #PRENDI IN INPUT LA SCELTA DELL'UTENTE

    move $t0, $v0

    beq $t0, 1, primo
    beq $t0, 2, secondo
    beq $t0, 3, terzo
    beq $t0, 4, quarto
    beq $t0, 5, uscita

primo:

    #SCEGLI LA DIMENSIONE DELLA MATRICE QUADRATA

    addi        $v0, $0, 4
    la          $a0, dimensione
    syscall

    li        $v0, 5
    syscall     #PRENDI IN INPUT LA SCELTA DELL'UTENTE

    move $t0, $v0

    move $s2 $t0	#SALVA IL NUMERO DI ELEMENTI DELLA SINGOLA RIGA

    mult $t0, $t0
    mflo $t0
    li $t1, 4
    mult $t0, $t1
    mflo $t0

    move $s3 $t0	#SALVA IL NUMERO DI BIT TOTALI DI OGNI MATRICE

    move $a0 $t0
    li $v0 9
    syscall		#ALLOCA DINAMICAMENTE LO SPAZIO PER LA PRIMA MATRICE

    move $s0 $v0	#SALVA LA POSIZIONE DELLA TESTA DELLA PRIMA MATRICE

    move $a0 $t0
    li $v0 9
    syscall		#ALLOCA DINAMICAMENTE LO SPAZIO PER LA SECONDA MATRICE

    move $s1 $v0	#SALVA LA POSIZIONE DELLA TESTA DELLA SECONDA MATRICE

    move $t3 $s0	#UTILIZZA I REGISTRI TEMPORANEI PER LAVORARE DURANTE L'INSERIMENTO. COSÌ TENGO IN MEMORIA LA TESTA DELLE MATRICI
    move $t4 $s1

    li $t1 0
    
inserisci:

    li $v0 4
    la $a0 inserisciPrima
    syscall

    li        $v0, 5
    syscall     	#PRENDI IN INPUT LA SCELTA DELL'UTENTE

    sw $v0 0($t3)	

    addi $t3 $t3 4	#SPOSTATI ALLA WORD SUCCESSIVA

    addi $t1 $t1 4	#VERIFICA SE DOVER INSERIRE ULTERIORI ELEMENTI OPPURE NO
    beq $t1 $s3 initSecondo
    j inserisci

initSecondo:

    li $t1 0

inserisciSecondo:

    li $v0 4
    la $a0 inserisciSeconda
    syscall

    li $v0 5
    syscall    		#PRENDI IN INPUT LA SCELTA DELL'UTENTE

    sw $v0 0($t4)	#MEMORIZZA IL VALORE NELLO SPAZIO ALLOCATO

    addi $t4 $t4 4	#SPOSTATI ALLA PAROLA SUCCESSIVA

    addi $t1 $t1 4
    beq $t1 $s3 finish
    j inserisciSecondo

finish:

    li $v0 4
    la $a0 ok
    syscall

    j main


secondo:

	li $v0 4	#VAI A CAPO
	la $a0 capo
	syscall

	move $t0 $s0	#MEMORIZZA LA TESTA DELLE MATRICI NEI DUE REGISTRI TEMPORANEI PER POTERCI LAVORARE SENZA PERDERE I RIFERIMENTI
	move $t1 $s1

	li $t4 0
	li $t5 0

calcola:

	lw $t2 0($t0)	#PRENDI GLI ELEMENTI CORRENTI, SOMMALI E STAMPALI
	lw $t3 0($t1)

	add $t2 $t2 $t3

	move $a0 $t2
	li $v0 1
	syscall

	li $t2 0

	li $v0 4	#STAMPA UN CARATTERE DI SPAZIO
	la $a0 space
	syscall

	addi $t0 $t0 4	#SPOSTATI ALLA WORD SUCCESSIVA DELLE MATRICI
	addi $t1 $t1 4

	addi $t4 $t4 1	#INCREMENTA IL CONTATORE DI RIGA
	addi $t5 $t5 4	#INCREMENTA IL CONTATORE GENERALE

	blt $t4 $s2 calcola	#SE NON SONO A FINE RIGA, STAMPO I SUCCESSIVI ELEMENTI

	li $t4 0	#SE ESEGUO QUESTO FRAMMENTO, AZZERO IL CONTATORE DI RIGA E VADO A CAPO
	
	li $v0 4
	la $a0 capo
	syscall
	
	blt $t5 $s3 calcola
	j main


terzo:

	li $v0 4	#VAI A CAPO
	la $a0 capo
	syscall

	move $t0 $s0	#MEMORIZZA LA TESTA DELLE MATRICI NEI DUE REGISTRI TEMPORANEI PER POTERCI LAVORARE SENZA PERDERE I RIFERIMENTI
	move $t1 $s1

	li $t4 0
	li $t5 0

calcolaSub:

	lw $t2 0($t0)	#PRENDI GLI ELEMENTI CORRENTI, SOTTRAILI E STAMPALI
	lw $t3 0($t1)

	sub $t2 $t2 $t3

	move $a0 $t2
	li $v0 1
	syscall

	li $t2 0

	li $v0 4	#STAMPA UN CARATTERE DI SPAZIO
	la $a0 space
	syscall

	addi $t0 $t0 4	#SPOSTATI AL CARATTERE SUCCESSIVO DELLE MATRICI
	addi $t1 $t1 4

	addi $t4 $t4 1	#INCREMENTA IL CONTATORE DI RIGA
	addi $t5 $t5 4	#INCREMENTA IL CONTATORE GENERALE

	blt $t4 $s2 calcolaSub	#SE NON SONO A FINE RIGA, STAMPO I SUCCESSIVI ELEMENTI

	li $t4 0	#SE ESEGUO QUESTO FRAMMENTO, AZZERO IL CONTATORE DI RIGA E VADO A CAPO
	
	li $v0 4
	la $a0 capo
	syscall
	
	blt $t5 $s3 calcolaSub	#SE NON HO STAMPATO TUTTI GLI ELEMENTI DELLA MATRICE, TORNO A STAMPARE GLI ALTRI ELEMENTI
	j main

quarto:

	li $s6 0
	li $t4 0
	li $t5 0

	li $v0 4	#VAI A CAPO
	la $a0 capo
	syscall

	mult $s3 $s3	#CREO UNA NUOVA MATRICE N X N DI APPOGGIO
	
	move $a0 $s3
   	li $v0 9
    	syscall

	move $s5 $v0	#SALVA IN S5 LA POSIZIONE DI TESTA DELLA NUOVA MATRICE

	li $t3 4
	mult $t3 $s2
	mflo $s4	#SALVA IN S4 L'OFFSET DI CUI SPOSTARSI NELLA COLONNA

	li $t3 0	#INIZIALIZZA IL REGISTRO CONTATORE DI RIGA
	li $t6 0	#INIZIALIZZA IL REGISTRO CONTATORE TOTALE

	move $t0 $s0	#CARICA LA TESTA DELLA PRIMA MATRICE
	move $t1 $s1	#CARICA LA TESTA DELLA SECONDA MATRICE
	move $t2 $s5	#CARICA LA TESTA DELLA MATRICE DI APPOGGIO

operation:

	lw $t8 0($t0)	#CARICA I VALORI DA MOLTIPLICARE
	lw $t9 0($t1)

	mult $t8 $t9
	mflo $t4
	add $t5 $t5 $t4	#AGGIORNA IL CONTO TOTALE

	addi $t0 $t0 4	#AGGIORNO I PUNTATORI ALLE MATRICI
	add $t1 $t1 $s4

	addi $t3 $t3 1	#INCREMENTO IL CONTATORE DI RIGA

	blt $t3 $s2 operation	#SE PRENDO IL SALTO, NON HO FINITO DI CALCOLARE IL MIO ELEMENTO

	addi $t6 $t6 4	#INCREMENTO IL CONTATORE TOTALE

	li $t3 0	#RIPORTA A 0 IL CONTATORE DI RIGA
	sw $t5 0($t2)	#SALVA IL RISULTATO DEL PRODOTTO ED INCREMENTA IL PUNTATORE ALLA MATRICE DI APPOGGIO
	addi $t2 $t2 4
	addi $s6 $s6 1	#INCREMENTA IL CONTATORE DI INSERIMENTO. OGNI VOLTA CHE VALE 3, LO USO PER SPOSTARMI CON LA RIGA
	li $t5 0	#AZZERO IL RISULTATO DEL CONTO

	beq $t6 $s3 stampa	#SE HO MEMORIZZATO TUTTI GLI ELEMENTI, STAMPO LA MATRICE DI APPOGGIO

	sub $t0 $t0 $s4		#RIPORTO I PUNTATORI ALLA POSIZIONE INIZIALE DELLA RIGA E COLONNA DI PARTENZA
	mult $s4 $s2
	mflo $s7
	sub $t1 $t1 $s7	

	beq $s6 $s2 else	#IN BASE ALL'IESIMO ELEMENTO STAMPATO, DECIDO COME RIPOSIZIONARE I MIEI PUNTATORI ALLE MATRICI A E B
	addi $t1 $t1 4
	j operation

else:

	li $s6 0		#AZZERO IL CONTATORE PARZIALE
	add $t0 $t0 $s4		#SALTO ALLA RIGA SUCCESSIVA

	li $s7 4
	sub $s7 $s4 $s7
	sub $t1 $t1 $s7
	
	j operation
	
stampa:
	li $t1 0
	move $t0 $s5
	li $t2 0

successivo:

	lw $a0 0($t0)
	li $v0 1
	syscall

	addi $t2 $t2 1

	li $v0 4	#STAMPA UN CARATTERE DI SPAZIO
	la $a0 space
	syscall
	bne $t2 $s2 continue
	
	li $t2 0
	
	li $v0 4	#VAI A CAPO
	la $a0 capo
	syscall


continue:

	addi $t0 $t0 4
	addi $t1 $t1 4
	blt $t1 $s3 successivo

	li $v0 4	#VAI A CAPO
	la $a0 capo
	syscall
	
	jal main

uscita:

	jr $ra
