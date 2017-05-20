.code
	LD 0
	ST (sum)
	ST (i)
L1:
	CMP 7
	JGTL2
	MVX
	LD X(array)
	ADD (sum)
	ST (sum)
	LD (i)
	ADD 1
	ST (i)
	JMP L1
L2:
.data
array: RB 16
i: RB 2
sum: RB 2