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
RAMStart    EQU  $800
INTCR       EQU  $001E
DDRA        EQU  2
PORTA       EQU  0
STACK       EQU  $2000

; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
neat       ds.b  1


; code section
            ORG   ROMStart


Entry:
_Startup:
            ldaa #$A
            ldab  #$90
loop:       dbeq a,stupid
            rolb
            bra loop
            
stupid:     rts            
                     


interrupt_ISR:
            rti            
                        
            
            

            RTS                   ; result in D

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
            ORG   $FFF2
            dc.w  interrupt_ISR