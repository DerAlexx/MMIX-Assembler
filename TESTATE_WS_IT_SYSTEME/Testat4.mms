GPutBmp     IS     #1F
KGet        IS     #38

WIDTH       IS      10                
HEIGHT      IS      10                
F           IS      0  
B			IS 		1
T			IS		2              
W           IS      4      
           
x           GREG   0                 
y           GREG   0

			LOC	Data_Segment 
			GREG @
GameBoard   BYTE W,W,W,W,W,W,W,W,W,W   
			BYTE W,F,F,F,F,F,F,F,F,W   
			BYTE W,F,F,W,W,W,W,F,F,W   
			BYTE W,F,F,W,T,F,F,F,F,W   
			BYTE W,F,B,W,F,F,F,F,F,W   
			BYTE W,F,F,W,F,F,F,F,F,W   
			BYTE W,F,F,W,W,W,W,F,F,W 
			BYTE W,F,F,F,F,F,W,F,F,W  
			BYTE W,F,F,F,F,F,F,F,F,W   
			BYTE W,W,W,W,W,W,W,W,W,W 

            LOC    #100

===========================================================
%%%%%%%%%%%%%%%%%%% ShowSokoban %%%%%%%%%%%%%%%%%%%%%%%%%%%
===========================================================
            PREFIX :ShowSokoban:
ShowSokoban SL     $255,:x,16        
            OR     $255,$255,:y
            SL     $255,$255,5       
            ORMH   $255,5            
            TRAP   0,:GPutBmp,0
            POP    0,0

===========================================================
%%%%%%%%%%%%%%%%%%% PosType  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
===========================================================
            PREFIX :PosType:
x           IS     $0                
y           IS     $1                
tmp         IS     $2
offset		IS		$5
baAdr		IS		$6
iconID		IS		$7

:PosType 	LDA	baAdr,:GameBoard
			MUL	offset,y,:WIDTH
			ADD	offset,x,offset
			ADD baAdr,baAdr,offset
			LDB	iconID,baAdr
			CMP	tmp,iconID,4
			BZ	tmp,Wall
			CMP	tmp,iconID,1
			BZ	tmp,BOX
            SET    $0,:F
            POP    1,0
Wall        SET    $0,:W
            POP    1,0
BOX	        SET    $0,:B
            POP    1,0

===========================================================
%%%%%%%%%%%%%%%%%%% MoveSokoban %%%%%%%%%%%%%%%%%%%%%%%%%%%
===========================================================

            PREFIX :MoveSokoban:
dx          IS     $0                
dy          IS     $1                
return      IS     $2
tmp         IS     $3

:MoveSokoban SWYM
			GET		return,:rJ
            ADDU   tmp+1,:x,dx
            ADDU   tmp+2,:y,dy
            PUSHJ  tmp,:PosType
			SET		tmp+2,tmp
			CMP		tmp,tmp,4
            BZ      tmp,1F
			CMP		tmp,tmp+2,1
			BZ		tmp,1F
            ADDU   :x,:x,dx
            ADDU   :y,:y,dy

1H          PUT		:rJ,return	
			POP    0,0

===========================================================
%%%%%%%%%%%%%%%%%%% DoCommand %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
===========================================================

            PREFIX :DoCommand:
UP          IS     #126
DOWN        IS     #128
RIGHT       IS     #127
LEFT        IS     #125
STEP        IS     1
command     IS     $0
arrow       IS     $1
return      IS     $2
dx          IS     $3
dy          IS     $4
tmp         IS     $5

DoCommand   SWYM
		SET    dx,0
        SET    dy,0
        SET    arrow,UP
        CMP    tmp,command,arrow
        BNZ    tmp,1F
        NEG    dy,STEP
        JMP    Done
1H      SET    arrow,DOWN
        CMP    tmp,command,arrow
        BNZ    tmp,1F
        SET    dy,STEP
        JMP    Done
1H      SET    arrow,RIGHT
        CMP    tmp,command,arrow
        BNZ    tmp,1F
        SET    dx,STEP
        JMP    Done
1H      SET    arrow,LEFT
        CMP    tmp,command,arrow
        BNZ    tmp,Done
        NEG    dx,STEP
Done    GET    return,:rJ        
        SET    tmp+1,dx
        SET    tmp+2,dy
        PUSHJ  tmp,:MoveSokoban
        PUT    :rJ,return       
        POP    0,0

		PREFIX :

===========================================================
%%%%%%%%%%%%%%%%%%% ShowBoard %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
===========================================================

		PREFIX :showBoard:
rj		IS	$1
compI	IS	$2
compII	IS	$2
forI	IS	$6
forII	IS	$7
safex	IS	$8
safey	IS	$9
jum		IS	$10
x		IS	$11
y		IS	$12

show	SET		safex,:x
		SET		safey,:y
		SET		forI,:WIDTH 
		SET		forII,:HEIGHT
		SET		:x,0
		SET		:y,0
		GET		rj,:rJ
for 	CMP		compI,forI,0
		BZ		compI,Exit
		SET		forII,:HEIGHT
		SUB		forI,forI,1
for2	CMP		compII,forII,0	
		BZ		compII,fora
		SET		x,:x
		SET		y,:y
		PUSHJ	jum,:showField:show
		ADD		:y,:y,1
		SUB		forII,forII,1
		JMP		for2
fora	ADD		:x,:x,1	
		SET		:y,0
		JMP		for


Exit	PUT		:rJ,rj
		SET		:y,safey
		SET		:x,safex
		POP		0,0
		PREFIX :

===========================================================
%%%%%%%%%%%%%%%%%%% ShowField %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
===========================================================

		PREFIX :showField:
x		IS	$0
y		IS	$1
baAdr	IS	$2
offset	IS	$3
iconID	IS	$4
xR		IS	$5
yR		IS	$6
tmp		IS	$7
to255	IS	$8

show	SWYM
		LDA	baAdr,:GameBoard
		MUL	offset,y,:WIDTH
		ADD	offset,x,offset
		ADD baAdr,baAdr,offset
		LDB	iconID,baAdr
		SET	xR,0
		SET	yR,0
		MUL	tmp,x,32
		ADD	xR,tmp,xR
		MUL	tmp,y,32
		ADD	yR,tmp,yR
		SET	 to255,0
		SL	iconID,iconID,32
		SL	xR,xR,16
		ADD to255,xR,iconID
		ADD	to255,to255,yR
		SET	 $255,to255
		TRAP 0,:GPutBmp,0
		POP	0,0
		PREFIX :

===========================================================
%%%%%%%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
===========================================================

tmp     IS     $0

Main       SET x,1
		   SET y,1
loop	   PUSHJ  tmp,:showBoard:show
		   PUSHJ  tmp,:ShowSokoban:ShowSokoban
           TRAP   0,KGet,0          
           SET    tmp+1,$255
           PUSHJ  tmp,:DoCommand:DoCommand
		   JMP	loop



