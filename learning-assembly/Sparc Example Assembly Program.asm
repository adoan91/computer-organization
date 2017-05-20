// Note, arithmetic instructions access only registers
// Only "ld" and "st" instructions access memory
	st %g0, [%fp - 48] // Store, Memory[fp - 48] <- g0 (g0 always 0) (sum = 0)
	st %g0, [%fp - 44] // Store, Memory[fp - 44] <- g0 (i = 0)
.LL5:
	ld (%fp - 44), $g1 // Load g1 <- Memory[i]
	cmp %g1, 7 // Compare, is g1 > 7?
	bg .LL6 // Branch if greater than 7
	nop
	ld [%fp - 44], %g1 // Load, g1 <- Memory[i]
	sll %g1, 2, %g2 // Compute ptr to array[i]: Shift Left Logical (i * 2)
	add %fp, -8, %g1 // g1 <- fp - 8 (get memory location of array)
	add %g2, %g1, %g1 // g1 <- g2 + g1 (array location + next i * 2)
	ld [%fp - 48], %g2 // Load sum, g2 <- Memory[fp - 48]
	ld [%g1 - 32], %g1 // Load array[i], g1 <- Memory[g1 - 32]
	add %g2, %g1, %g1 // Array[i] + sum, g1 <- g2 + g1
	st %g1, [%fp - 48] // Store sum, Memory[fp - 48] <-  g1
	ld [%fp - 44], %g1 // Load i, g1 <- Memory[fp - 44]
	add %g1, 1, %g1 // Increment, g1 <- g1 + 1
	st %g1, [%fp - 44] // Store i, Memory[fp - 44] <- g1
	b .LLS // Branch to instruction at LLS
	nop
.LL6