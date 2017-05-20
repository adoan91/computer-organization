// When possible moves an instructon to between LD and
// dependdent next instructon
// Example
// Before:
	LD R3, R1, (array)
	ADD R4, R2, R3
	ST (sum), R4
	ADD R1, R1, 1
// After:
	LD R3, R1, (array)
	ADD R1, R1, 1
	ADD R4, R2, R3
	ST (sum), R4