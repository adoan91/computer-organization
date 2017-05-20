// Note, arithmetic instructions can access memory
	movl $0, -48(%ebp) // initialize sum, Memory(%ebp - 48) <- 0 (sum = 0)
	movl $0, -44(%ebp) // initialize i, Memory(%ebp - 44) <- 0 (I = 0)
L7:
	cmpl $7, -44(%ebp) // is i > 7?
	jg L8 // if yes, jump to L8
	movl -44(%ebp), %eax // get i, %eax <- Memory[i]
	movl -40(%ebp, %eax, 4), %edx // get array[i], %edx <- Memory[array + i + 4]
	leal -48(%ebp), %eax // get address of sum, %eax <- %ebp - 48
	addl %edx, (%eax) // Memory[sum] <- array[i] + Memory[sum]
	leal -44(%ebp), %eax // get address of i, %eax <- %ebp - 44
	incl (%eax) // Memory[i] <- Memory[i] + 1
	jmp L7 // repeat
L8:	