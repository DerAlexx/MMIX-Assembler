// "Hello World" Programm
// Code by DerAlexx
// Donald Knuth's MMIX-Assembler

		
			LOC 	Data_Segment
			GREG 	@
Zeichen		BYTE 	"Hello World"
GSetPos		IS		#24

			LOC		#100
Main		SET		$255,#0000
			TRAP	0,GSetPos,0
			LDA		$255,Zeichen
			TRAP	0,Fputs,StdOut
			TRAP	0,Halt,0

