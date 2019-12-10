;	  RANDOM.COM		       Designed and written by Wilson Seto
;	  Version 1.10		       Inspired by Nathan Hull and Ettiene Martin
;				       Idea borrowed from TURBO C & PASCAL
;
;	  Terminate and stay resident random number generator.
;
;	  HOW TO ASSEMBLE:	       tasm random.asm
;				       tlink random.obj /t
;
;	  HOW THIS WORKS: First check to see if already installed, if not then
;	  do so, else abort.  Print the appropriate message.  To get a random
;   number do an INT 62H with AX equal to the desired range value.
;	  The random number is created by shifting, adding, multiplying, and
;	  dividing the seed values.  The number returned in AX is between
;	  0 and the range value, all other registers are unchanged.
	  page	 60,130
cseg	  segment
	  assume cs:cseg, ds:cseg
	  assume es:cseg, ss:cseg
	  org	 100h
start:	  jmp	 short check
;---------TSR routine-----------------------------------------------------------
constant  dw	 8405h		       ;multiplier value
seed1	  dw	 ?
seed2	  dw	 ?		       ;random number seeds
int_62h   proc   far
	  or	 ax,ax		       ;range value <> 0?
	  jz	 abort		       ;if not then abort
	  push	 bx
	  push	 cx
	  push	 dx
	  push	 ds
	  push	 ax		       ;save the range value
	  push	 cs
	  pop	 ds		       ;ds = cs
	  mov	 ax,seed1
	  mov	 bx,seed2	       ;load seeds
	  mov	 cx,ax		       ;save seed
	  mul	 constant	       ;(dx,ax) = ax * constant
	  shl	 cx,1
	  shl	 cx,1
	  shl	 cx,1
	  add	 ch,cl
	  add	 dx,cx
	  add	 dx,bx
	  shl	 bx,1		       ;begin scramble algorithm
	  shl	 bx,1
	  add	 dx,bx
	  add	 dh,bl
	  mov	 cl,5
	  shl	 bx,cl
	  add	 ax,1
	  adc	 dx,0
	  mov	 seed1,ax
	  mov	 seed2,dx	       ;save results as the new seeds
	  pop	 bx		       ;get back range value
	  xor	 ax,ax		       ;clear register
	  xchg	 ax,dx		       ;adjust ordering
	  div	 bx		       ;ax = trunc((dx,ax) / bx), dx = (r)
	  xchg	 ax,dx		       ;return remainder as the random number
	  pop	 ds
	  pop	 dx
	  pop	 cx
	  pop	 bx
abort:	  iret			       ;return to caller
int_62h   endp
;-------------------------------------------------------------------------------

;---------Initialization routine------------------------------------------------
check:	  mov	 ax,3000h	       ;get DOS version
	  int	 21h
	  cmp	 al,3		       ;DOS version 3.0 or higher?
	  jae	 chk_vec
	  mov	 dx,offset wrong_dos   ;incorrect DOS version, inform user
quit:	  mov	 ah,9
	  int	 21h
	  int	 20h		       ;back to DOS
chk_vec:  mov  ax,3562h        ;get interrupt vector for int 62h - es:bx
	  int	 21h
    mov  di,bx           ;es:di points to int 62h
    mov  si,offset int_62h     ;point to our copy of int 62h
	  mov	 cx,16		       ;# of bytes to compare
	  cld			       ;forward string movement
	  repe	 cmpsb		       ;compare memory regions
	  jnz	 install	       ;if not identical then not installed
	  mov	 dx,offset loaded      ;already loaded, inform user
	  jmp	 short quit
install:  mov	 ah,2ch 	       ;get current time
	  int	 21h
	  mov	 seed1,cx
	  mov	 seed2,dx	       ;save as initial seeds
	  mov	 dx,offset ready
	  mov	 ah,9		       ;print ready message
	  int	 21h
    mov  dx,offset int_62h     ;point to routine to install - ds:dx
    mov  ax,2562h        ;change interrupt 62h vectors
	  int	 21h
	  mov	 dx,offset check       ;end of resident code
	  int	 27h		       ;TSR
;-------------------------------------------------------------------------------

;---------Data area-------------------------------------------------------------
wrong_dos db     13,10,10,'Requires DOS V3.0 or higher!',13,10,10,7,7,36
loaded    db     13,10,10,'Random number generator is already loaded.'
	  db	 13,10,10,7,7,36
ready     db     13,10,10,'Random number generator V1.1 loaded.',13,10,10,36
;-------------------------------------------------------------------------------
cseg	  ends
	  end	 start

