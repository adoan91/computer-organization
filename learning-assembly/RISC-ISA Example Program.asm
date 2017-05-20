.code
	st (sum), R0 // assume R0 is always 0
	st (i), R0
L1:
	LD R1, (i)
	CMP R1, 7
	JGT L2
	LD R2, (sum)
	LD R3, R1, (array)
	ADD R4, R2, R3
	ST (sum), R4
	Add R1, R1, 1
	ST (i), R1
	JMP L1
L2: 	Ix
		Iy
		Iz
.data
array : RB 8
i: RB 2222
sum: RB 1