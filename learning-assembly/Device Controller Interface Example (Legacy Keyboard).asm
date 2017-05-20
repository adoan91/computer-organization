LOOP:
	IN (Port_1) // get status port
	AND 2
	CMP 2
	JEQ LOOP // keep checking if IBF = 0
	LD //... // configuration command
	OUT (Port_1)
// If IBF = 0
// Data or Command buffer empty
// Processor can now write to port
// If IBF = 0
// Scancode buffer full
// Processor can now read from port