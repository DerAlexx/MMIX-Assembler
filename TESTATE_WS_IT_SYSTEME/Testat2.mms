GPutBmp	IS	#1F
KGET	IS	#38

		LOC	#100
x		IS	$0
y		IS	$1
mask	IS	$2
comp	IS	$3
ascii	IS	$4
r 		IS	$5
l		IS	$6
d		IS	$7
u		IS	$8

Main	SET		mask,#FFFF
		SET		x,0
		SET		y,0
		SET		r,#127
		SET		l,#125
		SET		d,#128
		SET		u,#126

		JMP		PUTO

Loop	TRAP	0,KGET,0
		SET 	ascii,$255

		CMP		comp,ascii,u
		BZ		comp,upc 
		CMP		comp,ascii,d
		BZ		comp,doc
		CMP		comp,ascii,l
		BZ		comp,lc
		CMP		comp,ascii,r
		BZ		comp,rc
		JMP		Loop 

upc		SUB 	y,y,32 
		JMP		PUTO
doc		ADD		y,y,32 
		JMP		PUTO
lc		SUB		x,x,32 
		JMP		PUTO
rc		ADD		x,x,32 

PUTO	SET		$255,5	     	
		SLU		$255,$255,16	
		OR		$255,$255,x
		SLU		$255,$255,16
		OR		$255,$255,y
		TRAP	0,GPutBmp,0
		JMP		Loop
