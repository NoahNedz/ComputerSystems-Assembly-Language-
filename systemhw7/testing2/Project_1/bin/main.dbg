;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		;INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000
RAMStart    EQU  $0800
STACKStart  EQU  $2000
PORTB       EQU   1
PORTE       EQU   8
NumCol      EQU   4
INTCR       EQU   $001E
IRQEN       EQU   $40  

; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
KEYS        DC.B  20
key         DS.B  1
colNum      DS.B  1
MaskP       DC.B  $FE, $FD, $FB, $F7, $EF


; code section
            ORG   ROMStart


Entry:      
_Startup:
            lds   #STACKStart
            ldy   #KEYS
            movb  #$F0, PORTE
            bset  INTCR, IRQEN
            cli

loop:       wai
            movb  key,1,y+
            bsr   delay
            bra   loop
            rts
            
delay:       ldaa  #$40
outer:      ldx   #$FFFF
inner:      dbne  x,inner
            dbne  a,outer
            rts
            
KEY_ISR:     clrb
            ldx #MaskP

start:      movb  1,x+,PORTE
            ldaa  PORTB
            cmpa  #$FF
            bne   column
            incb
            cmpb  #NumCol
            blt   start
            beq   return_ISR

column:     stab  colNum
            clrb
            ldx #MaskP
next:       cmpa 1,x+
            beq add
            addb  #NumCol
            bra next
add:        addb  colNum
            stab  key
return_ISR: movb  #$F0,PORTE
            RTI
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
            ORG   $FFF2
            DC.W  KEY_ISR
