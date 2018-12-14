// Euclidean algorithm build in MMIX-Assembler 
// Code by DerAlexx
// Donald Knuth's MMIX-Assembler

tmp		IS		$0
n 		IS		$1
m 		IS		$2
rest		IS		$3

		LOC		#100
Main		SWYM
# Set m and n on the start numbers.
		SET	n,1228
		SET	m,96

# Loop to Calculate the Euclidean algorithm.
Start		DIV	tmp,n,m 
#rR will contain the remainder of a Division.
		GET	rest,rR	
		BZ  rest,finish
		SET	n,m
		SET	m,rest
		JMP	Start
# End of the Programming -> Exit
finish		TRAP 0,Halt,0
