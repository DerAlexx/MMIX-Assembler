KGet	IS	#38
STEP	IS	32
				
		LOC	#100	
x		GREG 0
y		GREG 0

pushReg	IS	$10
key		IS	$11
rjs		IS	$1

Main	SET		x,0
		SET		y,0		
		PUSHJ	pushReg+2,:ShowSokoban:draw 
Loop	TRAP	0,KGet,0 
		SET		key,$255 
		GET		rjs,:rJ	
		PUSHJ	pushReg,:DoCommand:arr 
		PUT		:rJ,rjs 
		PUSHJ	pushReg+3,:ShowSokoban:draw 
		JMP		Loop 
		
=========================================================
% Unterprogramm ShowSokoban
=========================================================
		PREFIX	:ShowSokoban: 	 
GPutBmp	IS	#1F					
draw	SET		$255,5	     	
		SLU		$255,$255,16	
		OR		$255,$255,:x
		SLU		$255,$255,16
		OR		$255,$255,:y
		TRAP	0,GPutBmp,0
		POP		0,0
		PREFIX :
=========================================================
% Unterprogramm MoveSokoban
=========================================================
		PREFIX :MoveSokoban:	
dx 		IS	$0
dy		IS	$1

move	ADD	:x,dx,:x
		ADD	:y,dy,:y
		POP	0,0

		PREFIX :
=========================================================
% Unterprogramm DoCommand
=========================================================
		PREFIX :DoCommand:		
key 	IS	$0
arrow	IS	$1
tmp		IS	$2
UP		IS	#126
DOWN	IS	#128
RIGHT	IS	#127
LEFT	IS	#125
rjSave 	IS 	$4
Jum		IS	$5
dx		IS	$6
dy		IS	$7

arr		SET		dx,0
		SET		dy,0
		GET		rjSave,:rJ				
		SET		arrow,UP
		CMP		tmp,key,arrow
		BNZ		tmp,1F		
		SUB		dy,dy,32
		JMP		end
			
1H		SET		arrow,DOWN	
		CMP		tmp,key,arrow
		BNZ		tmp,1F	
		ADD		dy,dy,32
		JMP		end
		
1H		SET		arrow,RIGHT
		CMP		tmp,key,arrow
		BNZ		tmp,1F	
		ADD		dx,dx,32
		JMP		end

1H		SET		arrow,LEFT
		CMP		tmp,key,arrow
		BNZ		tmp,:Loop
		SUB		dx,dx,32

end		PUSHJ	Jum,:MoveSokoban:move	
		PUT		:rJ,rjSave				
		POP		0,0						
		
		PREFIX :
	
