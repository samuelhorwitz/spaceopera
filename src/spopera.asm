;---------------------------------------------------------------------------------------------------
;SPACE OPERA
;A game by Samuel Horwitz (N19081895) - 2008
;With thanks to Robert Dewar for some code.
;---------------------------------------------------------------------------------------------------
					jmp		start						;Jump to code

;---------------------------------------------------------------------------------------------------
;CONSTANTS
;Constant values to be used at assemble time.
;---------------------------------------------------------------------------------------------------
;Video information
VIDEO_MODE			equ		0Dh							;EGA 16 Color mode
TEXT_MODE			equ		3							;CGA Color text mode
VIDEO_SEGMENT		equ		0A000h						;The location of VGA video memory
BIOS_SEGMENT		equ		40h							;The location of the ROM-BIOS variables
PAGE_OFFSET_ADR		equ		4Eh							;The offset in BIOS_SEGMENT for page data
VIDEO_MAX_PIX		equ		8000						;The max number of bytes on an EGA plane
VIDEO_HEIGHT		equ		25							;The number of bytes high the video is
VIDEO_HEIGHT_PIX	equ		VIDEO_HEIGHT*8				;The number of pixels high the video is
VIDEO_WIDTH			equ		40							;The number of bytes wide the video is
VIDEO_WIDTH_PIX		equ		VIDEO_WIDTH*8				;The number of pixels wide the video is

;Bitplane masks
NO_COLORS			equ		00000000b					;Mask off all planes
BLACK_MASK			equ		00000000b					;Mask off all planes
BLUE_MASK			equ		00000001b					;Mask off all planes except blue
GREEN_MASK			equ		00000010b					;Mask off all planes except green
CYAN_MASK			equ		00000011b					;Mask off all planes except blue and green
RED_MASK			equ		00000100b					;Mask off all planes except red
PURPLE_MASK			equ		00000101b					;Mask off all planes except red and blue
BROWN_MASK			equ		00000110b					;Mask off all planes except red and green
LIGHT_GRAY_MASK		equ		00000111b					;Mask off intensity plane only
DARK_GRAY_MASK		equ		00001000b					;Mask off all planes except intensity
LIGHT_BLUE_MASK		equ		00001001b					;Mask off all planes except i and blue
LIGHT_GREEN_MASK	equ		00001010b					;Mask off all planes except i and green
LIGHT_CYAN_MASK		equ		00001011b					;Mask off all planes except i green and blue
LIGHT_RED_MASK		equ		00001100b					;Mask off all planes except i and red
MAGENTA_MASK		equ		00001101b					;Mask off all planes except i red and blue
YELLOW_MASK			equ		00001110b					;Mask off all planes except i red and green
WHITE_MASK			equ		00001111b					;Mask off no planes
ALL_COLORS			equ		00001111b					;Mask off no planes
XOR_MODE			equ		18h							;XOR graphics mode

;Ports
SC_PORT				equ		3C4h						;SC Index port
GC_PORT				equ		3CEh						;GC Index port
TIMER_GATE_PORT		equ		61h							;Timer gate control port
TIMER_CTRL_PORT		equ		43h							;Timer control port
TIMER_CNTR_PORT		equ		42h							;Timer counter port

;Port registers
SC_MAP_MASK_REG		equ		2							;Register for map masking
GC_DATA_ROT_REG		equ		3							;Register for data rotation
GC_MODE_REG			equ		5							;Register for graphics modes

;Object sizes and data
PLAYER_HT			equ		3							;Number of bytes tall player is
PLAYER_HT_PIX		equ		PLAYER_HT*8					;Number of pixels tall player is
PLAYER_WD			equ		3							;Number of bytes wide player is
PLAYER_WD_PIX		equ		PLAYER_WD*8					;Number of pixels wide player is
ENEMY1_HT			equ		3							;Number of bytes tall enemy 1 is
ENEMY1_HT_PIX		equ		ENEMY1_HT*8					;Number of pixels tall enemey 1 is
ENEMY1_WD			equ		3							;Number of bytes wide enemy 1 is
ENEMY1_WD_PIX		equ		ENEMY1_WD*8					;Number of pixels wide enemy 1 is
ENEMY1_PT_VAL		equ		10							;Point value of enemy 1
EXP_WD				equ		3							;Number of bytes wide explosions are
EXP_WD_PIX			equ		EXP_WD*8					;Number of pixels wide explosions are
EXP_HT				equ		3							;Number of bytes tall explosions are
EXP_HT_PIX			equ		EXP_HT*8					;Number of pixels tall explosions are
LETTER_HT			equ		1							;The height of each letter/number
LETTER_HT_PIX		equ		LETTER_HT*8					;The height of each letter/number in pixels
LETTER_WD			equ		1							;The width of each letter/number
LETTER_WD_PIX		equ		LETTER_WD*8					;The width of each letter/number in pixels
LASER_WD			equ		1							;Number of bytes wide laser is
LASER_WD_PIX		equ		LASER_WD*8					;Number of pixels wide laser is
LASER_DUR			equ		1							;Duration of laser sound
LASER_FREQ			equ		500							;Frequency of laser sound
EXP_DUR				equ		2							;Duration of explosion sound
EXP_FREQ			equ		200							;Frequency of explosion sound
CHAR_ALIVE			equ		1							;Character is alive
CHAR_EXP			equ		0							;Character exploded
ENEMY_LIMIT			equ		12							;The maximum number of possible enemies
NO_ENEMY			equ		10000						;Used to specify blank array object enemy
NO_PLAYER			equ		10000						;Used to specify blank array object player
NO_BULLET			equ		10000						;Same as NO_ENEMY but named for bullets
PLAYER_COL			equ		1							;Signifies player on collision table
ENEMY1_COL			equ		2							;Signifies enemy 1 on collision table
PLASER_COL			equ		3							;Signifies good laser on collision table
ELASER_COL			equ		4							;Signifies bad laser on collision table
MENU_NEW			equ		0							;New game in menu
MENU_HELP			equ		1							;Help in menu
MENU_QUIT			equ		2							;Quit in menu
MENU2_EASY			equ		0							;Easy in difficulty menu
MENU2_MEDIUM		equ		1							;Medium in difficulty menu
MENU2_HARD			equ		2							;Hard in difficulty menu
MENU2_NIGHTMARE		equ		3							;Nightmare in difficulty menu
KBD_UP				equ		48h							;Scancode for up arrow
KBD_DOWN			equ		50h							;Scancode for down arrow
KBD_ESC				equ		1							;Scancode for escape
KBD_ENTER			equ		1Ch							;Scancode for enter
TRUE				equ		1							;True
FALSE				equ		0							;False

;Peripheral data
MOUSE_LBOUND		equ		0							;The left bound of the mouse's movement
MOUSE_RBOUND		equ		VIDEO_WIDTH_PIX-PLAYER_WD_PIX;The right bound of the mouse's movement
MOUSE_UBOUND		equ		48							;The upper bound of the mouse's movement
MOUSE_BBOUND		equ		VIDEO_HEIGHT_PIX-PLAYER_HT_PIX;The bottom bound of the mouse's movement
SCREEN_DELAY		equ		3							;The amount of time for the delay function
MOUSE_HORDEF		equ		160							;Default horizontal position for mouse
MOUSE_VERDEF		equ		MOUSE_BBOUND				;Default vertical position for mouse

;---------------------------------------------------------------------------------------------------
;DATA
;Named locations of memory within the program itself.
;---------------------------------------------------------------------------------------------------
PlayerX		dw		MOUSE_HORDEF						;The X location of the player in pixels
PlayerY		dw		MOUSE_VERDEF						;The Y location of the player in pixels
PlayerShotX	dw		NO_BULLET							;Player's laser location x,y
PlayerShotY	dw		NO_BULLET
PlayerStat	db		CHAR_ALIVE							;Player's health status
PlayerDead	db		0									;Is player dead?
EnemiesX	dw		ENEMY_LIMIT dup(NO_ENEMY)			;Array of enemy X locations
EnemiesY	dw		ENEMY_LIMIT dup(NO_ENEMY)			;Array of enemy Y locations
EnemiesStat	dw		ENEMY_LIMIT dup(NO_ENEMY)			;The health status of all the enemies
EnemyShotX	dw		ENEMY_LIMIT dup(NO_BULLET)			;Enemies' laser locations x,y
EnemyShotY	dw		ENEMY_LIMIT dup(NO_BULLET)
MaxEnemies	db		3									;The maximum number of enemies onscreen
NumEnemies	db		0									;The current number of enemies in any state
EnemyChance	db		20									;There is a 1/this number chance of enemy
PLaserSpeed	db		8									;Speed of player's laser
ELaserSpeed	db		4									;Speed of enemy's laser
ELaserChn	db		50									;There is a 1/num chance of enemy shooting
EnemySpdChn	db		25									;There is a 1/num chance enemy moves/direc
EnemySpeed	db		1									;How many bytes traversed per movement
MouseX		dw		MOUSE_HORDEF						;The X location of the cursor
MouseY		dw		MOUSE_VERDEF						;The Y location of the cursor
LeftButton	db		0									;Boolean on whether left button is pressed
Score		dw		0									;The score
NumKills	dw		0									;The number of kills
NumKillsCnt	db		0									;Counts every 10 kill
Lives		db		3									;The number of lives the player has left
GameOver	db		0									;1 if game is over (lives are lost)
MenuSelect	db		0									;Menu selection
MenuSelect2	db		0									;Difficulty menu selection
NumberPtrs	dw		offset zero							;This array contains the offsets to the
			dw		offset one							;number graphics. NumberPtrs[0] points to
			dw		offset two							;the zero graphic for example, making it
			dw		offset three						;useful for drawing numbers from data.
			dw		offset four
			dw		offset five
			dw		offset six
			dw		offset seven
			dw		offset eight
			dw		offset nine

;---------------------------------------------------------------------------------------------------
;Strings
;ASCII Strings for menu
;---------------------------------------------------------------------------------------------------
newgamestr	db		'New Game', 0
helpstr		db		'Help', 0
quitstr		db		'Quit', 0
copystr		db		'(c) Samuel Horwitz 2008', 0
diffstr		db		'Choose your difficulty', 0
gameoverstr	db		'Game Over. Press any key '
			db		'to continue.', 0
diff1		db		'Easy', 0
diff2		db		'Medium', 0
diff3		db		'Hard', 0
diff4		db		'Nightmare', 0
thanksstr	db		'Thanks to Robert Dewar and', 0Dh, 8, 8, 8
			db		'Nathan Hull for portions of code', 0
help		db		'SPACE OPERA is a very simple game. '
			db		'The goal is to destroy as many ' 
			db		'enemies as you can before '
			db		'dying.', 0Dh, 0Dh
			db		'You control a small, blue ' 
			db		'spaceship that can move around '
			db		'the screen and fire ', 0Dh
			db		'lasers. '
			db		'Your enemies are magenta spaceships, '
			db		'and they, too, can fire '
			db		'lasers.', 0Dh, 0Dh
			db		'Move around the screen with your '
			db		'mouse, and fire your lasers with '
			db		'the left mouse button.', 0Dh, 0Dh
			db		'Watch out though, you only '
			db		'have 3 lives.', 0Dh, 0Dh
			db		'Have fun! (To leave this '
			db		'screen, press ESC)', 0Dh, 0Dh
			db		'Also, you can pause your game '
			db		'with the "p" button. '
			db		'Make sure you do not have ', 0Dh
			db		'caps lock on!', 0

;Thanks to http://www.network-science.de/ascii/ for ASCII art generator
spoperastr	db		'     _______________      __'
			db		'_       ______  _______     ', 0Dh
			db		'    /            _  \    /  '
			db		' \     /      ||   ____|    ', 0Dh
			db		'   |   (-----|  |_)  |  /  ^'
			db		'  \   |  ,---- |  |__       ', 0Dh
			db		'    \   \    |   ___/  /  /_'
			db		'\  \  |  |     |   __|      ', 0Dh
			db		'.----)   |   |  |     /  ___'
			db		'__  \ |  `----.|  |____     ', 0Dh
			db		'|_______/    | _|    /__/   '
			db		'  \__\ \______||_______|    ', 0Dh
			db		'  ______   .______    ______'
			db		'_ .______          ___      ', 0Dh
			db		' /  __  \  |   _  \  |   ___'
			db		'_||   _  \        /   \     ', 0Dh
			db		'|  |  |  | |  |_)  | |  |__ '
			db		'  |  |_)  |      /  ^  \    ', 0Dh
			db		'|  |  |  | |   ___/  |   __|'
			db		'  |      /      /  /_\  \   ', 0Dh
			db		'|  `--   | |  |      |  |___'
			db		'_ |  |\  \----./  _____  \  ', 0Dh
			db		' \______/  | _|      |______'
			db		'_|| _| `.________/     \__\ ', 0

;---------------------------------------------------------------------------------------------------
;SPRITES
;The bitmap data used to construct the characters and objects that appear on the screen.
;---------------------------------------------------------------------------------------------------
;The player custom bitmap.
player		db		00000000b, 00000000b, 00000000b
			db		00000000b, 00000000b, 00000000b
			db		00000000b, 01000010b, 00000000b
			db		00000000b, 01011010b, 00000000b
			db		00000000b, 00111100b, 00000000b
			db		00000000b, 00111100b, 00000000b
			db		00000000b, 01111110b, 00000000b
			db		00000100b, 01111110b, 00100000b
			db		00000100b, 01111110b, 00100000b
			db		00001110b, 01111110b, 01110000b
			db		00001110b, 01111110b, 01110000b
			db		00001110b, 01111110b, 01110000b
			db		00001110b, 01111110b, 01110000b
			db		00001110b, 01111110b, 01110000b
			db		00001110b, 01111110b, 01110000b
			db		00001110b, 01111110b, 01110000b
			db		00001111b, 11111111b, 11110000b
			db		00001111b, 11111111b, 11110000b
			db		01111111b, 11111111b, 11111110b
			db		11111111b, 11111111b, 11111111b
			db		11111111b, 11111111b, 11111111b
			db		11111111b, 11111111b, 11111111b
			db		11110001b, 10000001b, 10001111b
			db		01110001b, 10000001b, 10001110b

;The graphic used for number of lives
playerlife	db		00000000b
			db		00011000b
			db		00011000b
			db		01011010b
			db		01011010b
			db		01111110b
			db		01111110b
			db		10100101b

;The enemy number 1 custom characters.
enemy1		db		01100000b, 00000000b, 00000110b
			db		01100000b, 00000000b, 00000110b
			db		01110000b, 00011000b, 00001110b
			db		01110000b, 00011000b, 00001110b
			db		01111000b, 00011000b, 00011110b
			db		01111000b, 00011000b, 00011110b
			db		00111111b, 11111111b, 11111100b
			db		00011111b, 11111111b, 11111000b
			db		00011111b, 11111111b, 11111000b
			db		00011111b, 11111111b, 11111000b
			db		00011111b, 11111111b, 11111000b
			db		00011101b, 11111111b, 10111000b
			db		00001000b, 11111111b, 00010000b
			db		00001000b, 01111110b, 00010000b
			db		00001000b, 01111110b, 00010000b
			db		00001000b, 01111110b, 00010000b
			db		00001000b, 01111110b, 00010000b
			db		00000000b, 01111110b, 00000000b
			db		00000000b, 00111100b, 00000000b
			db		00000000b, 00111100b, 00000000b
			db		00000000b, 00111100b, 00000000b
			db		00000000b, 00011000b, 00000000b
			db		00000000b, 00000000b, 00000000b
			db		00000000b, 00000000b, 00000000b
			
;Explosion
explosion	db		00000000b, 00000000b, 00000000b
			db		01000000b, 00000000b, 00000000b
			db		00111100b, 01100000b, 00000000b
			db		00111110b, 01110000b, 00111000b
			db		00111111b, 01111000b, 11111000b
			db		00111111b, 11111001b, 11111000b
			db		00111111b, 11111111b, 11111000b
			db		00011111b, 11111111b, 11110000b
			db		00001111b, 11111111b, 11110000b
			db		00011111b, 11111111b, 11000000b
			db		00111111b, 11111111b, 11000000b
			db		00011111b, 11111111b, 11100000b
			db		00000111b, 11111111b, 11100000b
			db		00111111b, 11111111b, 11110000b
			db		00011111b, 11111111b, 11111100b
			db		00011111b, 11111111b, 11111100b
			db		00011111b, 11111111b, 11111100b
			db		00011100b, 11111111b, 11111100b
			db		00010000b, 11110001b, 11111100b
			db		00000000b, 11110001b, 11111000b
			db		00000000b, 11100000b, 11001000b
			db		00000000b, 11000000b, 00001110b
			db		00000000b, 10000000b, 00000010b
			db		00000000b, 00000000b, 00000001b

;Laser
laser		db		01000010b

;One
one			db		00111100b
			db		01001000b
			db		00001000b
			db		00001000b
			db		00001000b
			db		00001000b
			db		00001000b
			db		01111110b
			
;Two
two			db		00111000b
			db		01000100b
			db		00000100b
			db		00001000b
			db		00010000b
			db		00100000b
			db		01000000b
			db		01111100b

;Three
three		db		00111000b
			db		01000100b
			db		01000010b
			db		00011100b
			db		00000010b
			db		01000010b
			db		00100100b
			db		00011000b

;Four
four		db		10000100b
			db		10000100b
			db		10000100b
			db		11111110b
			db		00000100b
			db		00000100b
			db		00000100b
			db		00000100b
			
;Five
five		db		01111110b
			db		01000000b
			db		10000000b
			db		01111110b
			db		00000010b
			db		10000010b
			db		01000010b
			db		00111100b
			
;Six
six			db		00011100b
			db		00100010b
			db		01000000b
			db		11111100b
			db		10000010b
			db		10000010b
			db		01000010b
			db		00111100b
			
;Seven
seven		db		01111110b
			db		10000010b
			db		00000010b
			db		00000100b
			db		00000100b
			db		00001000b
			db		00001000b
			db		00001000b
			
;Eight
eight		db		00111100b
			db		01000010b
			db		01100110b
			db		00011000b
			db		00100100b
			db		01000010b
			db		01000010b
			db		00111100b
			
;Nine
nine		db		00111100b
			db		01000010b
			db		01000010b
			db		00111110b
			db		00000010b
			db		01000010b
			db		01000010b
			db		00111100b
			
;Zero
zero		db		00111100b
			db		01000010b
			db		01000010b
			db		01000010b
			db		01000010b
			db		01000010b
			db		01000010b
			db		00111100b

;---------------------------------------------------------------------------------------------------
;PROCEDURES
;Callable segments of code that make programming easier.
;---------------------------------------------------------------------------------------------------
;Add enemies
addenemies	proc
			push	ax							;Save registers
			push	bx
			push	cx
			push	dx
			push	si
			mov		al, NumEnemies				;Copy number of enemies to register
			cmp		al, MaxEnemies				;Compare number of current enemies to max
			je		addendn						;Number of enemies is equal to max, done
			mov		ah, 0						;Prepare ah for ax
			mov		al, EnemyChance				;Prepare for random interrupt
			int		62h							;Get random number
			cmp		ax, 0						;See if random number is 0
			jne		addendn						;Not 0 so done
			mov		si, 0						;Otherwise, prepare array pointer
addenlp1:	cmp		EnemiesX[si], NO_ENEMY		;Check if this location in array is free
			jne		addenlp2					;Location isn't free
			mov		EnemiesY[si], 0				;Spawn on top row
addenlp3:	mov		ax, VIDEO_WIDTH-ENEMY1_WD-1	;Upper bound for random number
			int		62h							;Get random number
			inc		ax							;Between 1 and 39
			mov		cl, 3						;Prepare for shift
			shl		ax, cl						;Multiply random number by 8
			mov		bx, 0						;Prepare registers for collision check proc
			mov		ch, ENEMY1_WD_PIX
			mov		cl, ENEMY1_HT_PIX
			call	chkcolenemy					;Check for collisions with other enemies
			cmp		dx, NO_ENEMY				;Check if no enemy constant is returned
			jne		addendn						;If not, forget about new enemy for now
			mov		EnemiesX[si], ax			;Otherwise, move random number into X location
			mov		EnemiesStat[si], CHAR_ALIVE	;Enemy is alive
			inc		NumEnemies					;Increment the number of enemies
			jmp		addendn						;Finished
addenlp2:	add		si, 2						;Increment array pointer
			cmp		si, ENEMY_LIMIT*2			;Check if out of bounds
			jne		addenlp1					;Not out of array bounds so loop
addendn:	pop		si							;Restore registers
			pop		dx
			pop		cx
			pop		bx
			pop		ax
			ret									;Return
addenemies	endp

;Calculates the byte offset
;REGISTERS	AX		X Offset
;			BX		Y Offset
;RETURNS	AX		Byte Offset
;			BX		Bit Offset
byteoffset	proc
			push	di							;Save registers
			push	dx
			push	si
			mov		di, ax						;Backup X offset
			mov		si, bx						;Backup Y offset
			mov		ax, VIDEO_WIDTH				;Get the video width in bytes for multiplication
			mul		bx							;Multiply width by Y offset
			mov		si, ax						;Backup product
			mov		ax, di						;Get X offset for division use
			mov		bx, 8						;The number of bits in byte, for division use
			div		bx							;Divide the X offset by 8
			add		ax, si						;Add the quotient and product
			mov		bx, dx						;Copy the remainder to bx
			pop		si							;Restore registers
			pop		dx
			pop		di
			ret									;Return
byteoffset	endp

;This procedure directly accesses EGA video memory and clears the screen by writing 0s in a loop.
clearscn	proc
			push	ax							;Save registers
			push	cx
			push	di
			push	dx
			mov		dx, SC_PORT					;Copy SC port location to dx for out use
			mov		al, SC_MAP_MASK_REG			;Use map masking capability of SC port
			mov		ah, ALL_COLORS				;Mask off no planes
			out		dx, ax						;Write to all bitplanes
			mov		di, 0						;Reset video memory pointer
			mov		cx, VIDEO_MAX_PIX/2			;Set repeat loop register to max number of pixels/2
			mov		ax, 0						;AX is 0 which will clear video memory by word
			rep		stosw						;Write 0 to video memory until end of video memory
			pop		dx							;Restore registers
			pop		di
			pop		cx
			pop		ax
			ret									;Return
clearscn	endp

;Checks for an enemy collision given an X and Y coordinates
;REGISTERS	AX		X Offset
;			BX		Y Offset
;			CH		Width in pixels
;			CL		Height in pixels
;RETURNS	DX		NO_ENEMY if no collision or the array pointer to the enemy collided with
chkcolenemy	proc
			push	ax							;Save registers
			push	bp
			push	bx
			push	cx
			push	di
			push	si
			mov		si, 0						;Prepare array pointer
			mov		bp, NO_ENEMY				;Default return value to be put in dx at end of proc
chkcolelp1:	cmp		EnemiesX[si], NO_ENEMY		;Check if enemy is present in this offset
			je		chkcolelp2					;No enemy present so next in array
			mov		di, bx						;Copy Y offset to new register
			mov		dh, 0						;Prepare dx
			mov		dl, cl
			add		di, dx						;Add the height to the temp Y offset
			cmp		di, EnemiesY[si]			;Compare enemy top to inputted bottom
			jb		chkcolelp2					;Inputted object above enemy, so next in array
			mov		di, EnemiesY[si]			;Copy enemy's Y offset to new register
			add		di, ENEMY1_HT_PIX			;Add height of enemy to temp enemy Y offset
			cmp		bx, di						;Compare inputted top to enemy bottom
			ja		chkcolelp2					;Inputted object below enemy, so next
			mov		di, ax						;Copy X offset to new register
			mov		dh, 0						;Prepare dx
			mov		dl, ch
			add		di, dx						;Add the width to the new temp X offset
			cmp		di, EnemiesX[si]			;Compare enemy left to inputted right
			jb		chkcolelp2					;Inputted object is left of enemy, so next
			mov		di, EnemiesX[si]			;Copy enemy's X offset to new register
			add		di, ENEMY1_WD_PIX			;Add width of enemy to temp enemy X offset
			cmp		ax, di						;Compare inputted left to enemy right
			ja		chkcolelp2					;Inputted object is right of enemy, so next
			mov		bp, si						;Collision has occured, indicate with whom
			jmp		chkcoledn					;Finished
chkcolelp2:	add		si, 2						;Increment array pointer
			cmp		si, ENEMY_LIMIT*2			;Check if array is out of bounds
			jne		chkcolelp1					;Not out of bounds so loop
chkcoledn:	mov		dx, bp						;Set return register to "no enemy" or collided enemy
			pop		si							;Restore registers
			pop		di
			pop		cx
			pop		bx
			pop		bp
			pop		ax
			ret									;Return
chkcolenemy	endp

;Checks for an enemy collision given an X and Y coordinates
;REGISTERS	AX		X Offset
;			BX		Y Offset
;			CH		Width in pixels
;			CL		Height in pixels
;RETURNS	DX		NO_PLAYER if no collision or the array pointer to the enemy collided with
chkcolplay	proc
			push	ax							;Save registers
			push	bp
			push	bx
			push	cx
			push	di
			push	si
			mov		bp, NO_PLAYER				;Default return value to be put in dx at end of proc
			mov		di, bx						;Copy Y offset to new register
			mov		dh, 0						;Prepare dx
			mov		dl, cl
			add		di, dx						;Add the height to the temp Y offset
			cmp		di, PlayerY					;Compare player top to inputted bottom
			jb		chkcolpdn					;Inputted object above player, so next in array
			mov		di, PlayerY					;Copy player's Y offset to new register
			add		di, PLAYER_HT_PIX			;Add height of player to temp player Y offset
			cmp		bx, di						;Compare inputted top to player bottom
			ja		chkcolpdn					;Inputted object below enemy, so next
			mov		di, ax						;Copy X offset to new register
			mov		dh, 0						;Prepare dx
			mov		dl, ch
			add		di, dx						;Add the width to the new temp X offset
			cmp		di, PlayerX					;Compare player left to inputted right
			jb		chkcolpdn					;Inputted object is left of player, so next
			mov		di, PlayerX					;Copy player's X offset to new register
			add		di, PLAYER_WD_PIX			;Add width of player to temp player X offset
			cmp		ax, di						;Compare inputted left to player right
			ja		chkcolpdn					;Inputted object is right of player, so next
			mov		bp, 1						;Collision has occured
			jmp		chkcolpdn					;Finished
chkcolpdn:	mov		dx, bp						;Set return register
			pop		si							;Restore registers
			pop		di
			pop		cx
			pop		bx
			pop		bp
			pop		ax
			ret									;Return
chkcolplay	endp

;Decrement lives
declives	proc
			sub		Lives, 1					;Decrement lives
			jnz		declivesdn					;Check if 0
			mov		GameOver, 1					;Yes so game over
declivesdn:	ret									;Return
declives	endp

;Decrement score by specified amount
;REGISTERS	AX		Amount to decrement
decscore	proc
			cmp		ax, Score					;Compare amount to current score
			ja		decscore1					;If amount to decrement is greater, make 0
			sub		Score, ax					;Otherwise, subtract score
			jmp		decscoredn					;And finish
decscore1:	mov		Score, 0					;Score is 0
decscoredn:	ret									;Return
decscore	endp

;Delay routine. This code borrows heavily from the Dewar Game Program. Some wording and constant
;names have been changed.
delay		proc
			push	ax							;Save registers
			push	dx
			sub		ax, ax						;Set ax to 0 for procedure call
			mov		dx, SCREEN_DELAY			;Delay length
			call	note						;Play blank note for specified time
			pop		dx							;Restore registers
			pop		ax
			ret									;Return
delay		endp

;Difficulty menu
diffmenu	proc
			push	ax							;Save registers
			push	bx
			push	dx
			mov		MenuSelect2, 0				;Start at top of menu
			mov		ah, 5						;Change video page
			mov		al, 2
			int		10h
diffmenulp:	mov		ax, offset diffstr
			mov		bh, 2
			mov		bl, LIGHT_CYAN_MASK
			mov		dh, 8
			mov		dl, 30
			call	writeasciiz
			mov		ax, offset diff1
			mov		bh, 2
			cmp		MenuSelect2, MENU2_EASY		;Check if menu selection is 0
			jne		diffmen1_1					;It's not so next
			mov		bl, YELLOW_MASK
			jmp		diffmen1_2					;Next
diffmen1_1:	mov		bl, WHITE_MASK
diffmen1_2:	mov		dh, 9
			mov		dl, 30
			call	writeasciiz
			mov		ax, offset diff2
			mov		bh, 2
			cmp		MenuSelect2, MENU2_MEDIUM	;Check if menu selection is 1
			jne		diffmen2_1					;It's not so next
			mov		bl, YELLOW_MASK
			jmp		diffmen2_2					;Next
diffmen2_1:	mov		bl, WHITE_MASK
diffmen2_2:	mov		dh, 10
			mov		dl, 30
			call	writeasciiz
			mov		ax, offset diff3
			mov		bh, 2
			cmp		MenuSelect2, MENU2_HARD		;Check if menu selection is 2
			jne		diffmen3_1					;It's not so next
			mov		bl, YELLOW_MASK
			jmp		diffmen3_2					;Next
diffmen3_1:	mov		bl, WHITE_MASK
diffmen3_2:	mov		dh, 11
			mov		dl, 30
			call	writeasciiz
			mov		ax, offset diff4
			mov		bh, 2
			cmp		MenuSelect2, MENU2_NIGHTMARE;Check if menu selection is 3
			jne		diffmen4_1					;It's not so next
			mov		bl, YELLOW_MASK
			jmp		diffmen4_2					;Next
diffmen4_1:	mov		bl, WHITE_MASK
diffmen4_2:	mov		dh, 12
			mov		dl, 30
			call	writeasciiz
;The following gets keyboard input and acts accordingly
			mov		ax, 0
			int		16h
			cmp		ah, KBD_DOWN
			jne		diffmenu1
			cmp		MenuSelect2, 3
			jne		diffmenu2
			mov		MenuSelect2, 0
			jmp		diffmenu1
diffmenu2:	inc		MenuSelect2
diffmenu1:	cmp		ah, KBD_UP
			jne		diffmenu3
			cmp		MenuSelect2, 0
			jne		diffmenu4
			mov		MenuSelect2, 3
			jmp		diffmenu3
diffmenu4:	dec		MenuSelect2
diffmenu3:	cmp		ah, KBD_ESC
			jne		diffmenu5
			call	menuinit
diffmenu5:	cmp		ah, KBD_ENTER
			jne		diffmenu9
			cmp		MenuSelect2, 0
			jne		diffmenu6
			call	start_easy
diffmenu6:	cmp		MenuSelect2, 1
			jne		diffmenu7
			call	start_med
diffmenu7:	cmp		MenuSelect2, 2
			jne		diffmenu8
			call	start_hard
diffmenu8:	cmp		MenuSelect2, 3
			jne		diffmenu9
			call	start_nm
diffmenu9:	jmp		diffmenulp
			pop		dx							;Restore registers
			pop		bx
			pop		ax
			ret									;Return
diffmenu	endp

;Display the help screen
disphelp	proc
			push	ax							;Save registers
			push	bx
			push	dx
			mov		ah, 5
			mov		al, 1
			int		10h
			mov		ax, offset help
			mov		bh, 1
			mov		bl, WHITE_MASK
			mov		dh, 0
			mov		dl, 0
			call	writeasciiz					;Write help data to screen
disphelp1:	mov		ax, 0
			int		16h							;Get input
			cmp		ah, KBD_ESC					;Check if Escape key pressed
			jne		disphelp					;If not, get input
			mov		ah, 5
			mov		al, 0
			int		10h							;Go back to menu video page
			pop		dx							;Restore registers
			pop		bx
			pop		ax
			ret									;Return
disphelp	endp

;Display the number of lives the player has
displives	proc
			push	ax							;Save registers
			push	bx
			push	cx
			push	di
			push	dx
			push	si
			mov		ch, Lives					;Move number of lives to a register
			cmp		ch, 0						;Check if lives are 0
			je		displidn					;Zero so done
			mov		dx, SC_PORT					;Prepare for out statement
            mov		al, SC_MAP_MASK_REG			;Prepare for out statement to set color
            mov		ah, LIGHT_CYAN_MASK			;Lives color is light cyan
            out		dx, ax						;Set lives color by masking off correct planes
			mov		dx, VIDEO_WIDTH_PIX			;Prepare registers for proc
displilp1:	sub		dx, 10
			mov		ax, dx
			mov		bx, 8
			call	byteoffset					;Get byte offset
			mov		di, ax						;Set video offset
			mov		si, 0						;Reset array pointer
			mov		cl, 8						;Reset counter
displilp2:	mov		al, playerlife[si]			;The bmp data for the graphic
			stosb								;Send bmp data to video memory
			add		di, VIDEO_WIDTH-1			;Point to next row
			inc		si							;Next row in bmp data
			sub		cl, 1						;Decrement count
			jnz		displilp2					;Next row
			sub		ch, 1						;Decrement life count
			jnz		displilp1					;Not zero so loop
displidn:	pop		si							;Restore registers
			pop		dx
			pop		di
			pop		cx
			pop		bx
			pop		ax
			ret									;Return
displives	endp

;Display a number
;REGISTERS	AX		Number to display (between 0-9 inclusive)
;			BX		X Offset
;			CX		Y Offset
dispnumber	proc
			push	ax							;Save registers
			push	bp
			push	bx
			push	cx
			push	di
			push	si
			cmp		ax, 9
			ja		dispnmdn
			cmp		ax, 0
			jb		dispnmdn
			mov		si, ax						;Backup number
			mov		ax, bx						;Prepare registers for proc
			mov		bx, cx
			call	byteoffset					;Get byte offset
			mov		di, ax						;Set video offset
			shl		si, 1						;Multiply pointer by 2 because word array
			mov		bp, NumberPtrs[si]			;Get number offset
			mov		cl, 8						;Number of times to repeat
dispnmlp1:	mov		al, [bp]					;Draw number by looping through bmp data
			stosb
			inc		bp
			add		di, VIDEO_WIDTH-1
			sub		cl, 1
			jnz		dispnmlp1
dispnmdn:	pop		si							;Restore registers
			pop		di
			pop		cx
			pop		bx
			pop		bp
			pop		ax
			ret									;Return
dispnumber	endp

;Displays the score
dispscore	proc
			push	ax							;Save registers
			push	bp
			push	bx
			push	cx
			push	di
			push	dx
			push	si
			mov		dx, SC_PORT					;Prepare for out statement
            mov		al, SC_MAP_MASK_REG			;Prepare for out statement to set color
            mov		ah, WHITE_MASK				;Score color is white
            out		dx, ax						;Set score color by masking off correct planes
			mov		ax, Score					;Prepare for divison
			mov		dx, 0
			mov		bx, 10000
			div		bx							;Divide
			mov		bx, 10						;Prepare registers for proc
			mov		cx, 8
			call	dispnumber					;Display number
			mov		ax, dx						;Prepare
			mov		dx, 0
			mov		bx, 1000
			div		bx							;Divide
			mov		bx, 18						;Prepare registers for proc
			mov		cx, 8
			call	dispnumber					;Display number
			mov		ax, dx						;Prepare
			mov		dx, 0
			mov		bx, 100
			div		bx							;Divide
			mov		bx, 26						;Prepare registers for proc
			mov		cx, 8
			call	dispnumber					;Display number
			mov		ax, dx						;Prepare
			mov		dx, 0
			mov		bx, 10
			div		bx							;Divide
			mov		bx, 34						;Prepare registers for proc
			mov		cx, 8
			call	dispnumber					;Display number
			mov		ax, dx
			mov		bx, 42						;Prepare registers for proc
			mov		cx, 8
			call	dispnumber					;Display number
			pop		si							;Restore registers
			pop		dx
			pop		di
			pop		cx
			pop		bx
			pop		bp
			pop		ax
			ret									;Return
dispscore	endp

;Draw the enemies
drawenemies	proc
			push	ax							;Save registers
			push	bp
			push	bx
			push	di
			push	dx
			push	si
			mov		bp, 0						;Array pointer
			jmp		drawenlp1					;Go to first loop
drawenlp1:	cmp		EnemiesX[bp], NO_ENEMY		;Compare current enemy to "no enemy" constant
			je		drawenlp2					;No enemy here so draw nothing
			mov		ax, EnemiesX[bp]			;Prepare registers for procedure
			mov		bx, EnemiesY[bp]
			call	byteoffset					;Get byte offset
			mov		di, ax						;Copy byte offset to di
			cmp		EnemiesStat[bp], CHAR_EXP	;Check if enemy had been shot
			je		drawenlp4					;Enemy will be not drawn as explosion
			mov		si, 0						;Bitmap pointer
			mov		dx, SC_PORT					;Prepare for out statement
            mov		al, SC_MAP_MASK_REG			;Prepare for out statement to set color
            mov		ah, MAGENTA_MASK			;Enemy color is magenta
            out		dx, ax						;Set enemy color by masking off correct planes
            mov		bh, ENEMY1_WD				;Store enemy width
            mov		bl, ENEMY1_HT_PIX			;Store enemy height
drawenlp3:	mov		al, enemy1[si]				;Move current bmp byte into al for drawing
			stosb								;Write byte to video memory
			inc		si							;Increment bmp pointer
			sub		bh, 1						;Decrement enemy width
			jnz		drawenlp3					;Check if width is equal to 0. If not, next byte
			mov		bh, ENEMY1_WD				;Width has been decremented to 0, reset
			sub		bl, 1						;Decrement the height of the enemy
			jz		drawenlp2					;Height of enemy is 0, next enemy
			add		di, VIDEO_WIDTH - ENEMY1_WD	;Otherwise begin drawing next row
			jmp		drawenlp3					;Loop
drawenlp4:	mov		ax, EnemiesX[bp]			;Prepare registers for proc
			mov		bx, EnemiesY[bp]
			call	drawexp						;Draw an explosion
drawenlp2:	add		bp, 2						;Increment array pointer
			cmp		bp, ENEMY_LIMIT*2			;Check if pointer is out of bounds
			jne		drawenlp1					;Not out of bounds so loop
drawendn:	pop		si							;Restore registers
			pop		dx
			pop		di
			pop		bx
			pop		bp
			pop		ax
			ret									;Return
drawenemies	endp

;Draw an explosion
;REGISTERS	AX		X Offset
;			BX		Y Offset
drawexp		proc
			push	ax							;Save registers
			push	bx
			push	di
			push	dx
			push	si
			call	byteoffset
			mov		di, ax
			mov		si, 0						;Bitmap pointer
			mov		bh, EXP_WD					;Width in reg
			mov		bl, EXP_HT_PIX				;Height in reg
			mov		dx, SC_PORT					;Prepare for out statement
            mov		al, SC_MAP_MASK_REG			;Prepare for out statement to set color
            mov		ah, YELLOW_MASK				;Explosion color is yellow
            out		dx, ax						;Set explosion color by masking off correct planes
drawexplp1:	mov		al, explosion[si]			;Move current bmp byte into al for drawing
			stosb								;Write byte to video memory
			inc		si							;Increment bmp pointer
			sub		bh, 1						;Decrement enemy width
			jnz		drawexplp1					;Check if width is equal to 0. If not, next byte
			mov		bh, EXP_WD					;Width has been decremented to 0, reset
			sub		bl, 1						;Decrement the height of the explosion
			jz		drawexpen					;Height of enemy is 0, done
			add		di, VIDEO_WIDTH - EXP_WD	;Otherwise begin drawing next row
			jmp		drawexplp1					;Loop
drawexpen:	mov		ax, EXP_FREQ				;Prepare registers for procedure
			mov		dx, EXP_DUR
			call	note	
			pop		si							;Restore registers
			pop		dx
			pop		di
			pop		bx
			pop		ax
			ret									;Return
drawexp		endp

;Draw the player. This should not be called directly, instead the player should be moved around the 
;screen by the appropriate functions that will call this function to redraw the player correctly.
drawplayer	proc
			push	ax							;Save registers
			push	bx
			push	cx
			push	di
			push	dx
			push	si
			cmp		PlayerStat, CHAR_EXP		;Check if player is exploded
			je		drawplayex					;Draw the player exploded
			mov		ax, PlayerX					;Prepare registers for procedure
			mov		bx, PlayerY
			call	byteoffset					;Get byte offset from X and Y
			mov		di, ax						;The byte offset to begin drawing the player
            mov		si, 0						;Player bitmap data array pointer
            mov		dx, SC_PORT					;Prepare for out statement
            mov		al, SC_MAP_MASK_REG			;Prepare for out statement to set color
            mov		ah, LIGHT_CYAN_MASK			;Player color is light cyan
            out		dx, ax						;Set player color by masking off correct planes
            mov		bh, PLAYER_WD				;Store player width in register for drawing
            mov		bl, PLAYER_HT_PIX			;Store player height in register for drawing
drawplaylp: mov		al, player[si]				;Move the current player bmp byte into draw reg
            stosb								;Move current bitmap byte to current vid offset
            inc		si							;Increment the bitmap array pointer
            sub		bh, 1						;Decrement the width of the player
            jnz		drawplaylp					;Check if width is equal to 0. If not, next byte
            mov		bh, PLAYER_WD				;Width has decremented to 0, reset width
            sub		bl, 1						;Decrement the height of the player
            jz		enddrwplay					;If the height of the player is 0, we are done
            add		di, VIDEO_WIDTH - PLAYER_WD	;Otherwise, beging drawing next row of bmp data
            jmp		drawplaylp					;Loop
drawplayex:	mov		ax, PlayerX					;Prepare registers for proc
			mov		bx, PlayerY
			call	drawexp						;Draw an explosion
enddrwplay:	pop		si							;Restore registers
			pop		dx
			pop		di
			pop		cx
			pop		bx
			pop		ax
			ret									;Return
drawplayer	endp

;Draw the enemies' bullets on the screen
draweshot	proc
			push	ax							;Save registers
			push	bp
			push	bx
			push	cx
			push	di
			push	dx
			push	si
			mov		bp, 0						;Reset array pointer
draweshlp1:	cmp		EnemyShotX[bp], NO_BULLET	;Check if laser has been shot
			je		draweshlp2					;No laser shot so loop
			mov		ax, EnemyShotX[bp]			;Prepare registers for collision check proc
			mov		bx, EnemyShotY[bp]
			mov		ch, LASER_WD_PIX
			mov		cl, ELaserSpeed
			call	chkcolplay					;Check if collision with player
			cmp		dx, NO_PLAYER				;See if collision occured
			je		draweshot1					;No collision, draw laser
			mov		PlayerStat, CHAR_EXP		;Player has exploded
			call	declives					;Decrement player's lives
			mov		ax, ENEMY1_PT_VAL
			call	decscore					;Decrement player's score
			mov		EnemyShotX[bp], NO_BULLET	;Reset enemy's laser
			mov		EnemyShotY[bp], NO_BULLET
			jmp		draweshlp2					;Done drawing laser
draweshot1:	mov		dx, SC_PORT					;Prepare for out statement
            mov		al, SC_MAP_MASK_REG			;Prepare for out statement to set color
            mov		ah, LIGHT_RED_MASK			;Laser color
            out		dx, ax						;Set laser color by masking off correct planes
            mov		ax, EnemyShotX[bp]
            mov		bx, EnemyShotY[bp]
            call	byteoffset
            mov		di, ax
            mov		dl, 7						;Temporary loop count register
            mov		al, laser					;Load bmp data for laser
draweshlp3:	stosb								;Send to video memory
			add		di, VIDEO_WIDTH - LASER_WD	;Next row
			sub		dl, 1						;Subtract 1 from count
			jnz		draweshlp3					;Count not zero so loop
draweshlp2:	add		bp, 2						;Increment array pointer
			cmp		bp, ENEMY_LIMIT*2			;Check if out of bounds
			jne		draweshlp1					;Not out of bounds so loop
enddrwesht:	pop		si							;Restore registers
			pop		dx
			pop		cx
			pop		di
			pop		bx
			pop		bp
			pop		ax
			ret									;Return
draweshot	endp

;Draw the player's bullets on the screen
drawpshot	proc
			push	ax							;Save registers
			push	bx
			push	cx
			push	di
			push	dx
			push	si
			cmp		PlayerShotX, NO_BULLET		;Check if laser has been shot
			je		enddrwpsht					;No laser shot so finish
			mov		ax, PlayerShotX				;Prepare registers for collision check proc
			mov		bx, PlayerShotY
			mov		ch, LASER_WD_PIX
			mov		cl, PLaserSpeed
			call	chkcolenemy					;Check if collision
			cmp		dx, NO_ENEMY				;See if collision occured from return value
			je		drawpshot1					;No collision, draw laser
			mov		si, dx						;Copy enemy value to new register
			mov		EnemiesStat[si], CHAR_EXP	;Enemy is now in exploded state
			dec		NumEnemies					;Decrement enemy count
			mov		PlayerShotX, NO_BULLET		;Reset player's laser
			mov		PlayerShotY, NO_BULLET
			mov		ax, ENEMY1_PT_VAL			;Prepare register for proc
			call	incscore					;Increment the score
			jmp		enddrwpsht					;Done drawing laser
drawpshot1:	mov		dx, SC_PORT					;Prepare for out statement
            mov		al, SC_MAP_MASK_REG			;Prepare for out statement to set color
            mov		ah, LIGHT_BLUE_MASK			;Laser color
            out		dx, ax						;Set laser color by masking off correct planes
            mov		ax, PlayerShotX
            mov		bx, PlayerShotY
            call	byteoffset
            mov		di, ax
			mov		dl, 7						;Temporary loop count register
			mov		al, laser					;Load bmp data for laser
drawpshtlp:	stosb								;Send to video memory
			add		di, VIDEO_WIDTH - LASER_WD	;Next row
			sub		dl, 1						;Subtract 1 from count
			jnz		drawpshtlp					;Count not zero so loop
enddrwpsht:	pop		si							;Restore registers
			pop		dx
			pop		cx
			pop		di
			pop		bx
			pop		ax
			ret									;Return
drawpshot	endp

;Enemy shoots weapon
enemyshoot	proc
			push	ax							;Save registers
			push	bx
			push	dx
			push	si
			mov		si, 0						;Reset array pointer
enshootlp1:	cmp		EnemiesX[si], NO_ENEMY		;Check if enemy exists in this pointer
			je		enshootlp2					;Doesn't exist so next enemy
			cmp		EnemyShotX[si], NO_BULLET	;Check if enemy has shot anything yet
			jne		enshootlp2					;Yes, enemy has already fired weapon
			mov		ah, 0						;Prepare ax
			mov		al, ELaserChn				;Set random number upperbound
			int		62h							;Get random number
			cmp		ax, 0						;Check if random number is 0
			jne		enshootlp2					;Not 0, so next enemy
			mov		ax, EnemiesX[si]			;Prepare registers for proc
			mov		bx, EnemiesY[si]
			cmp		bx, VIDEO_HEIGHT_PIX-8		;Check if too close to bottom of screen
			jae		enshootlp2					;Too close, next enemy
			add		ax, 8
			add		bx, 8
			mov		EnemyShotX[si], ax
			mov		EnemyShotY[si], bx
			mov		ax, LASER_FREQ				;Prepare registers for procedure
			mov		dx, LASER_DUR
			call	note						;Laser sound
enshootlp2:	add		si, 2						;Increment array pointer
			cmp		si, ENEMY_LIMIT*2			;Check if out of bounds
			jne		enshootlp1					;Not out of bounds so loop
			pop		si							;Restore registers
			pop		dx
			pop		bx
			pop		ax
			ret									;Return
enemyshoot	endp

;Resets video modes and exits to DOS
exitgame	proc
			push	ax							;Save registers
			mov		ah, 0						;Prepare graphics mode registers
			mov		al, 3
			int		10h
			int		20h							;Exit game
			pop		ax							;Restore registers
			ret									;Return
exitgame	endp

;Gets the input from the mouse
getinput	proc
			push	ax							;Save registers
			push	bx
			push	cx
			push	dx
			mov		ax, 3						;Prepare mouse interrupt
			int		33h							;Get mouse position and buttons
			cmp		cx, MOUSE_RBOUND			;Compare X offset to player max
			jna		movx						;Not greater so move X
			mov		cx, MOUSE_RBOUND			;Fix X
movx:		mov		MouseX, cx					;Copy X position to variable
			cmp		dx, MOUSE_BBOUND			;Compare Y offset to player max
			jna		movy						;Not greater so check upper bound
			mov		dx, MOUSE_BBOUND			;Fix Y
movy:		cmp		dx, MOUSE_UBOUND			;Compare Y offset to player max
			jnb		movy2						;Not less so move Y
			mov		dx, MOUSE_UBOUND			;Fix Y
movy2:		mov		MouseY, dx					;Copy Y position to variable
			mov		ax, 0000000000000001b		;Create bitmask
			and		bx, ax						;Mask off button click register
			cmp		bx, 1						;Compare button click register to 1
			jne		notpressed					;Not 1 so left not pressed
			mov		LeftButton, 1				;Otherwise, left is pressed
			jmp		movdone						;Finished
notpressed:	mov		LeftButton, 0				;Set left as not pressed
movdone:	pop		dx							;Restore registers
			pop		cx
			pop		bx
			pop		ax
			ret									;Return
getinput	endp

;Move enemies' laser downscreen
inceshot	proc
			push	ax							;Save registers
			push	bx
			push	si
			mov		si, 0						;Reset array pointer
inceshlp1:	cmp		EnemyShotX[si], NO_BULLET	;Check if laser in play
			je		inceshlp2					;No laser, next enemy
			mov		ax, EnemyShotX[si]			;Set registers for proc
			mov		bx, EnemyShotY[si]
			call	byteoffset
			cmp		ax, 0						;Check if laser is on screen
			je		inceshlp2					;No laser, no incrementing
			mov		ah, 0
			mov		al, ELaserSpeed
			cmp		EnemyShotY[si], VIDEO_WIDTH_PIX;See if shot is at bottom of screen
			jne		inceshlp3					;Not so next check
			mov		EnemyShotX[si], NO_BULLET	;Otherwise, remove laser from screen completely
			mov		EnemyShotY[si], NO_BULLET
			jmp		inceshlp2					;Next enemy
inceshlp3:	cmp		EnemyShotY[si], ax			;Compare Y location and what will be subtracted
			jnae	inceshlp4					;Not above or equal so make Y 0
			add		EnemyShotY[si], ax			;Otherwise move Y naturally
			jmp		inceshlp2					;Next enemy
inceshlp4:	mov		EnemyShotY[si], 0
inceshlp2:	add		si, 2						;Increment array pointer
			cmp		si, ENEMY_LIMIT*2			;Check if in bounds
			jne		inceshlp1					;In bounds, so loop
			pop		si							;Restore registers
			pop		bx
			pop		ax
			ret									;Return
inceshot	endp

;Move player's lasers upscreen
incpshot	proc
			push	ax							;Save registers
			push	bx
			cmp		PlayerShotX, NO_BULLET		;Check if laser in play
			je		incpshotdn					;No laser, done
			mov		ax, PlayerShotX				;Set registers for procedure
			mov		bx, PlayerShotY
			call	byteoffset
			cmp		ax, 0						;Check if laser is on screen
			je		incpshotdn					;No laser, no incrementing
			mov		ah, 0
			mov		al, PLaserSpeed
			cmp		PlayerShotY, 0				;See if shot is at top of screen
			jne		incpshotd3					;Not so next check
			mov		PlayerShotX, NO_BULLET		;Otherwise, remove laser from screen completely
			mov		PlayerShotY, NO_BULLET
			jmp		incpshotdn					;Finished
incpshotd3:	cmp		PlayerShotY, ax				;Compare Y location and what will be subtracted
			jnae	incpshotd2					;Not above or equal so make Y 0
			sub		PlayerShotY, ax				;Otherwise move Y naturally
			jmp		incpshotdn					;Finished
incpshotd2:	mov		PlayerShotY, 0
incpshotdn:	pop		bx							;Restore registers
			pop		ax
			ret									;Return
incpshot	endp

;Increment the score by specified amount
;REGISTERS	AX		Amount to increase score by
incscore	proc
			push	ax							;Save registers
			push	bx
			push	dx
			add		Score, ax					;Add specified amount to score
			inc		NumKills					;Increment the number of kills
			cmp		MaxEnemies, ENEMY_LIMIT		;Check if max enemies reached
			je		incscrdn					;Max enemies reached, done
			inc		NumKillsCnt					;Increment the 20 count of number of kills
			cmp		NumKillsCnt, 19				;Compare number of kills 20 count to 19
			jne		incscrdn					;Not 19 so done
			mov		NumKillsCnt, 0				;Reset number of kills 20 count
			inc		MaxEnemies					;Increment the maximum number of enemies
incscrdn:	pop		dx							;Restore registers
			pop		bx
			pop		ax
			ret									;Return
incscore	endp

;Initialize menu
menuinit	proc
			push	ax							;Save registers
			push	bx
			push	cx
			push	dx
			mov		ah, 0						;Initialize text mode
			mov		al, TEXT_MODE
			int		10h
			mov		MenuSelect, 0
menuinlp1:	mov		ax, offset spoperastr
			mov		bh, 0
			mov		bl, LIGHT_CYAN_MASK
			mov		dh, 0
			mov		dl, 12
			call	writeasciiz					;Write SPACE OPERA string
			mov		ax, offset copystr
			mov		bh, 0
			mov		bl, CYAN_MASK
			mov		dh, 14
			mov		dl, 26
			call	writeasciiz					;Write copyright string
			mov		ax, offset thanksstr
			mov		bh, 0
			mov		bl, MAGENTA_MASK
			mov		dh, 16
			mov		dl, 26
			call	writeasciiz					;Write thank you string
			mov		ax, offset newgamestr
			mov		bh, 0
			cmp		MenuSelect, MENU_NEW		;Check if menu selection is 0
			jne		menuin1_1					;It's not so next
			mov		bl, YELLOW_MASK
			jmp		menuin1_2					;Next
menuin1_1:	mov		bl, WHITE_MASK
menuin1_2:	mov		dh, 19
			mov		dl, 34
			call	writeasciiz					;Write new game string
			mov		ax, offset helpstr
			mov		bh, 0
			cmp		MenuSelect, MENU_HELP		;Check if menu selection is 0
			jne		menuin2_1					;It's not so next
			mov		bl, YELLOW_MASK
			jmp		menuin2_2					;Next
menuin2_1:	mov		bl, WHITE_MASK
menuin2_2:	mov		dh, 20
			mov		dl, 36
			call	writeasciiz					;Write help string
			mov		ax, offset quitstr
			mov		bh, 0
			cmp		MenuSelect, MENU_QUIT		;Check if menu selection is 0
			jne		menuin3_1					;It's not so next
			mov		bl, YELLOW_MASK
			jmp		menuin3_2					;Next
menuin3_1:	mov		bl, WHITE_MASK
menuin3_2:	mov		dh, 21
			mov		dl, 36
			call	writeasciiz					;Write quit string
menugetin:	mov		ax, 0						;Get input
			int		16h
;The following controls menu selections and keyboard input
			cmp		ah, KBD_UP
			jne		menuin5
			cmp		MenuSelect, 0
			jne		menuin4
			mov		MenuSelect, 2
			jmp		menuin5
menuin4:	sub		MenuSelect, 1
menuin5:	cmp		ah, KBD_DOWN
			jne		menuin7
			cmp		MenuSelect, 2
			jne		menuin6
			mov		MenuSelect, 0
			jmp		menuin7
menuin6:	add		MenuSelect, 1
menuin7:	cmp		ah, KBD_ESC
			jne		menuin8
			call	exitgame
menuin8:	cmp		ah, KBD_ENTER
			jne		menuin11
			cmp		MenuSelect, MENU_NEW
			jne		menuin9
			call	diffmenu					;Start game
menuin9:	cmp		MenuSelect, MENU_HELP
			jne		menuin10
			call	disphelp					;Display help
menuin10:	cmp		MenuSelect, MENU_QUIT
			jne		menuin11
			call	exitgame
menuin11:	jmp		menuinlp1					;Loop
			pop		dx							;Restore registers
			pop		cx
			pop		bx
			pop		ax
			ret									;Return
menuinit	endp

;Initialize the mouse
mouseinit	proc
			push	ax							;Save registers
			push	cx
			push	dx
			mov		ax, 0						;Initialize mouse
            int		33h
            mov		ax, 4						;Set mouse position
			mov		cx, MOUSE_HORDEF
			mov		dx, MOUSE_VERDEF
			int		33h
			pop		dx							;Restore registers
			pop		cx
			pop		ax
			ret									;Return
mouseinit	endp

;Move the enemies
moveenemies	proc
			push	ax							;Save registers
			push	cx
			push	si
			mov		si, 0						;Prepare array pointer
			mov		ah, 0						;Prepare al for ax
			mov		al, EnemySpeed				;Prepare register for addition
			mov		cl, 3						;Prepare for shift
			shl		ax, cl						;Multiply register by 8
			mov		bp, ax						;Copy speed offset to dx
moveenlp1:	cmp		EnemiesX[si], NO_ENEMY		;Check if enemy exists
			je		moveenlp2					;No enemy so next
			cmp		EnemiesStat[si], CHAR_EXP	;Check if it's exploded
			jne		moveenlp3					;Not exploded so continue
			mov		EnemiesX[si], NO_ENEMY		;Reset enemy in array
			mov		EnemiesY[si], NO_ENEMY
			mov		EnemiesStat[si], NO_ENEMY
			jmp		moveenlp2					;Next enemy
moveenlp3:	mov		ah, 0						;Set random number upper bound
			mov		al, EnemySpdChn
			int		62h							;Get random number
			cmp		ax, 0						;Compare random number to 0
			jne		moveenlp2					;Not 0 so finished
			add		EnemiesY[si], bp			;Otherwise move enemy forward
			mov		bx, PlayerX					;Send player X location to register
			cmp		EnemiesX[si], bx			;Compare player X to current enemy X
			jna		moveenrght					;The player is to the right so move right
			sub		EnemiesX[si], bp			;Otherwise, player is to the left so move left
			jmp		moveenlp4					;Finished
moveenrght:	add		EnemiesX[si], bp			;Move player right
moveenlp4:	cmp		EnemiesY[si], VIDEO_HEIGHT_PIX;Check and see if player has gone offscreen
			jna		moveenlp2
			mov		EnemiesX[si], NO_ENEMY		;Enemy no longer exists; offscreen
			mov		EnemiesY[si], NO_ENEMY
			mov		EnemiesStat[si], NO_ENEMY
			dec		NumEnemies					;Decrement number of enemies
moveenlp2:	add		si, 2						;Increment array pointer
			cmp		si, ENEMY_LIMIT*2			;Check if array is out of bounds
			jne		moveenlp1					;Not out of bounds so loop
moveendn:	pop		si							;Restore registers
			pop		cx
			pop		ax
			ret									;Return
moveenemies	endp

;Move player by mouse
moveplayer	proc
			push	ax							;Save registers
			push	bx
			push	cx
			push	dx
			mov		ax, MouseX					;Copy mouse X to temp register
			mov		PlayerX, ax					;Copy temp register to player X
			mov		ax, MouseY					;Copy mouse Y to temp register
			mov		PlayerY, ax					;Copy temp register to player Y
			mov		ax, PlayerX					;Prepare registers for collision check proc
			mov		bx, PlayerY
			mov		ch, PLAYER_WD_PIX
			mov		cl, PLAYER_HT_PIX
			call	chkcolenemy					;Check if player has collided with enemy
			cmp		dx, NO_ENEMY				;Check if no enemy
			je		moveplaydn					;No enemy so done
			mov		bx, dx						;Copy enemy array pointer
			mov		PlayerStat, CHAR_EXP		;Player has exploded
			mov		EnemiesStat[bx], CHAR_EXP	;Enemy has exploded
			dec		NumEnemies					;Decrement the number of enemies
			mov		ax, ENEMY1_PT_VAL			;Prepare register for proc
			call	decscore					;Decrement score
			call	declives					;Decrement lives
moveplaydn:	pop		dx							;Restore registers
			pop		cx
			pop		bx
			pop		ax
			ret									;Return
moveplayer	endp

;Player shoots weapon
playershoot	proc
			push	ax							;Save registers
			push	bx
			cmp		PlayerShotX, NO_BULLET		;Check if laser exists
			jne		endpshoot					;Is not 0, so done
			mov		ax, PlayerX					;Prepare registers for procedure
			mov		bx, PlayerY
			cmp		bx, 8
			jbe		endpshoot
			add		ax, 8
			sub		bx, 8
			mov		PlayerShotX, ax				;Store the byte offset in the laser table
			mov		PlayerShotY, bx
			mov		ax, LASER_FREQ				;Prepare registers for procedure
			mov		dx, LASER_DUR
			call	note						;Laser sound
endpshoot:	pop		bx							;Restore registers
			pop		ax
			ret									;Return
playershoot	endp

;Reset the game data
resetgame	proc
			push	si							;Save registers
			mov		PlayerShotX, NO_BULLET
			mov		PlayerShotY, NO_BULLET
			mov		PlayerStat, CHAR_ALIVE
			mov		PlayerDead, FALSE
			mov		si, 0						;Array pointer
resetlp1:	mov		EnemiesX[si], NO_ENEMY
			mov		EnemiesY[si], NO_ENEMY
			mov		EnemiesStat[si], NO_ENEMY
			mov		EnemyShotX[si], NO_BULLET
			mov		EnemyShotY[si], NO_BULLET
			add		si, 2
			cmp		si, ENEMY_LIMIT*2
			jne		resetlp1
			mov		MaxEnemies, 3
			mov		NumEnemies, 0
			mov		LeftButton, 0
			mov		Score, 0
			mov		NumKills, 0
			mov		NumKillsCnt, 0
			mov		Lives, 3
			mov		GameOver, FALSE
			pop		si							;Restore registers
			ret									;Return
resetgame	endp

;Reset player if dead
resetplayer	proc
			push	ax							;Save registers
			push	cx
			push	dx
			mov		PlayerStat, CHAR_ALIVE		;Player is alive again
			mov		ax, 4
			mov		cx, 160
			mov		dx, MOUSE_BBOUND
			int		33h
			pop		dx							;Restore registers
			pop		cx
			pop		ax
			ret									;Return
resetplayer	endp

;Start easy
start_easy	proc
			mov		EnemyChance, 50
			mov		PLaserSpeed, 16
			mov		ELaserSpeed, 4
			mov		ELaserChn, 100
			mov		EnemySpdChn, 50
			mov		EnemySpeed, 1
			jmp		init
			ret									;Return
start_easy	endp

;Start medium
start_med	proc
			mov		EnemyChance, 25
			mov		PLaserSpeed, 8
			mov		ELaserSpeed, 4
			mov		ELaserChn, 50
			mov		EnemySpdChn, 25
			mov		EnemySpeed, 1
			jmp		init
			ret									;Return
start_med	endp

;Start hard
start_hard	proc
			mov		EnemyChance, 20
			mov		PLaserSpeed, 8
			mov		ELaserSpeed, 8
			mov		ELaserChn, 50
			mov		EnemySpdChn, 25
			mov		EnemySpeed, 2
			jmp		init
			ret									;Return
start_hard	endp

;Start nightmare
start_nm	proc
			mov		EnemyChance, 10
			mov		PLaserSpeed, 4
			mov		ELaserSpeed, 8
			mov		ELaserChn, 100
			mov		EnemySpdChn, 10
			mov		EnemySpeed, 2
			jmp		init
			ret									;Return
start_nm	endp

;Writes an ASCIIZ string in text mode at specified location
;REGISTERS	AX		Offset to ASCIIZ string
;			BH		Video page
;			BL		Color
;			DH		Row
;			DL		Column
writeasciiz	proc
			push	ax							;Save registers
			push	bx
			push	cx
			push	di
			push	dx
			mov		di, ax						;Backup offset
			mov		si, dx						;Backup location
wrasciilp1:	mov		ah, 2						;Set cursor position
			int		10h
			mov		ah, 9						;Write character
			mov		al, [di]					;Copy character into new register
			cmp		al, 0						;Check if null
			je		wrasciidn					;If null, finished
			cmp		al, 0Dh						;Check if carriage return
			jne		wrasciilp2					;Not so skip
			inc		dh							;Increment row
			mov		cx, si
			mov		dl, cl						;Reset column
			jmp		wrasciilp3					;Next character
wrasciilp2:	cmp		al, 8						;Check if backspace
			jne		wrasciip4					;Not so skip
			dec		dl							;Decrement column
			jmp		wrasciilp3					;Next character
wrasciip4:	mov		cx, 1						;Repeat once
			int		10h							;Otherwise, write char
			inc		dl							;Increment column offset
wrasciilp3:	inc		di							;Increment character offset in string
			jmp		wrasciilp1					;Loop
wrasciidn:	mov		ah, 1
			mov		ch, 32
			int		10h							;Get rid of cursor
			pop		dx							;Restore registers
			pop		di
			pop		cx
			pop		bx
			pop		ax
			ret									;Return
writeasciiz	endp

;Initialize video
videoinit	proc
			push	ax							;Save registers
			mov		ah, 0						;Prepare registers for setting video mode int 10h
			mov		al, VIDEO_MODE				;Choose video mode for int 10h
			int		10h							;Initialize video mode
			mov		ah, 5						;Prepare registers for setting default page
			mov		al, 0						;Default page is 0
			int		10h							;Set default page
			mov		ax, VIDEO_SEGMENT			;Set video segment for copying into ES register
			mov		es, ax						;ES points to video segment
			pop		ax							;Restore registers
			ret									;Return
videoinit	endp

;---------------------------------------------------------------------------------------------------
;DEWAR CODE
;Code taken from Dewar game
;---------------------------------------------------------------------------------------------------
;
;  Routine to play note on speaker
;
;      (AX)           Frequency in Hz (32 - 32000)
;      (DX)           Duration in units of 1/100 second
;      CALL  NOTE
;
;  Note: a frequency of zero, means rest (silence) for the indicated
;  time, allowing this routine to be used simply as a timing delay.
;
;  Definitions for timer gate control
;
CTRL      EQU   61H          ; timer gate control port
TIMR      EQU   00000001B     ; bit to turn timer on
SPKR      EQU   00000010B     ; bit to turn speaker on
;
;  Definitions of input/output ports to access timer chip
;
TCTL      EQU   043H          ; port for timer control
TCTR      EQU   042H          ; port for timer count values
;
;  Definitions of timer control values (to send to control port)
;
TSQW      EQU   10110110B     ; timer 2, 2 bytes, sq wave, binary
LATCH     EQU   10000000B     ; latch timer 2
;
;  Define 32 bit value used to set timer frequency
;
FRHI      EQU   0012H          ; timer frequency high (1193180 / 256)
FRLO      EQU   34DCH          ; timer low (1193180 mod 256)
;
NOTE      PROC
      PUSH  AX          ; save registers
      PUSH  BX
      PUSH  CX
      PUSH  DX
      PUSH  SI
      MOV   BX,AX          ; save frequency in BX
      MOV   CX,DX          ; save duration in CX
;
;  We handle the rest (silence) case by using an arbitrary frequency to
;  program the clock so that the normal approach for getting the right
;  delay functions, but we will leave the speaker off in this case.
;
      MOV   SI,BX          ; copy frequency to BX
      OR    BX,BX          ; test zero frequency (rest)
      JNZ   NOT1          ; jump if not
      MOV   BX,256          ; else reset to arbitrary non-zero
;
;  Initialize timer and set desired frequency
;
NOT1: MOV   AL,TSQW          ; set timer 2 in square wave mode
      OUT   TCTL,AL
      MOV   DX,FRHI          ; set DX:AX = 1193180 decimal
      MOV   AX,FRLO          ;      = clock frequency
      DIV   BX          ; divide by desired frequency
      OUT   TCTR,AL          ; output low order of divisor
      MOV   AL,AH          ; output high order of divisor
      OUT   TCTR,AL
;
;  Turn the timer on, and also the speaker (unless frequency 0 = rest)
;
      IN    AL,CTRL          ; read current contents of control port
      OR    AL,TIMR          ; turn timer on
      OR    SI,SI          ; test zero frequency
      JZ    NOT2          ; skip if so (leave speaker off)
      OR    AL,SPKR          ; else turn speaker on as well
;
;  Compute number of clock cycles required at this frequency
;
NOT2: OUT   CTRL,AL          ; rewrite control port
      XCHG  AX,BX          ; frequency to AX
      MUL   CX          ; frequency times secs/100 to DX:AX
      MOV   CX,100          ; divide by 100 to get number of beats
      DIV   CX
      SHL   AX,1          ; times 2 because two clocks/beat
      XCHG  AX,CX          ; count of clock cycles to CX
;
;  Loop through clock cycles
;
NOT3: CALL  RCTR          ; read initial count
;
;  Loop to wait for clock count to get reset. The count goes from the
;  value we set down to 0, and then is reset back to the set value
;
NOT4: MOV   DX,AX          ; save previous count in DX
      CALL  RCTR          ; read count again
      CMP   AX,DX          ; compare new count : old count
      JB    NOT4          ; loop if new count is lower
      LOOP  NOT3          ; else reset, count down cycles
;
;  Wait is complete, so turn off clock and return
;
      IN    AL,CTRL          ; read current contents of port
      AND   AL,0FFH-TIMR-SPKR ; reset timer/speaker control bits
      OUT   CTRL,AL          ; rewrite control port
      POP   SI          ; restore registers
      POP   DX
      POP   CX
      POP   BX
      POP   AX
      RET               ; return to caller
NOTE      ENDP
;
;  Routine to read count, returns current timer 2 count in AX
;
RCTR      PROC
      MOV   AL,LATCH      ; latch the counter
      OUT   TCTL,AL          ; latch counter
      IN    AL,TCTR          ; read lsb of count
      MOV   AH,AL
      IN    AL,TCTR          ; read msb of count
      XCHG  AH,AL          ; count is in AX
      RET               ; return to caller
RCTR      ENDP
;---------------------------------------------------------------------------------------------------
;END OF DEWAR CODE
;End of code taken from Dewar game
;---------------------------------------------------------------------------------------------------

start:
;---------------------------------------------------------------------------------------------------
;Menu code
;Code for pre-game menu
;---------------------------------------------------------------------------------------------------
menu:		call	menuinit					;Initialize menu

;---------------------------------------------------------------------------------------------------
;INITIALIZE CODE
;Pre-game loop code.
;---------------------------------------------------------------------------------------------------
init:		call	videoinit					;Initialize video
            call	mouseinit					;Initialize mouse
            call	resetgame					;Reset game data
			call	clearscn					;Clear the screen
			jmp		game						;Skip first get input call/draw enemies call
            
;---------------------------------------------------------------------------------------------------
;GAME LOOP
;The main loop that is run through, throughout the game.
;---------------------------------------------------------------------------------------------------
;GAME LOOP CODE HERE
game:		mov		ah, 1						;Check if key press
			int		16h
			jz		game3						;No key pressed so do loop
			mov		ah, 0						;Otherwise, get pressed key
			int		16h
			cmp		ah, KBD_ESC					;If key is escape go to menu
			jne		game5
			call	menuinit
game5:		cmp		al, 'p'						;If key is 'p', pause game
			jne		game3
			mov		cx, MouseX
			mov		dx, MouseY
game6:		mov		ah, 0						;Get key while paused
			int		16h
			cmp		al, 'p'						;If key is 'p', unpause
			jne		game6						;Otherwise, getkey loop
			mov		ax, 4						;Unpaused, reset mouse to wear start of pause loc
			int		33h
game3:		call	clearscn					;Clear the screen
			call	addenemies					;Add enemies
			call	getinput					;Get input			
			call	moveplayer					;Move the player
			call	moveenemies					;Move the enemies
			call	enemyshoot					;Enemies will try and shoot
			cmp		LeftButton, 1				;See if left button is pressed
			jne		game2						;It's not so do nothing
			call	playershoot					;Otherwise, shoot
game2:		call	draweshot					;Draw enemies' lasers
			call	drawpshot					;Draw player's lasers
			call	incpshot					;Increment player's lasers
			call	inceshot					;Increment enemies' lasers
			call	drawenemies					;Draw the enemies
			call	drawplayer					;Draw the player on the screen
			call	dispscore					;Display the score
			call	displives					;Display number of lives
			call	delay						;Delay
			cmp		GameOver, 0					;Check if game is over
			je		game4						;Not game over, continue
			mov		ax, offset gameoverstr
			mov		bh, 0
			mov		bl, WHITE_MASK
			mov		dh, 11
			mov		dl, 2
			call	writeasciiz					;Right game over string
			mov		ax, 0
			int		16h							;Before returning to menu, have player press key
			call	menuinit					;Otherwise, exit game
game4:		cmp		PlayerStat, CHAR_EXP		;Check if player has exploded
			jne		game7						;Not exploded, so loop
			call	resetplayer					;Reset the player
game7:		jmp		game						;Loop
			end