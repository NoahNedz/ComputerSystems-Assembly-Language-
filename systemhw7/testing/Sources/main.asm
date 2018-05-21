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

ROMStart    EQU  $4000  ; absolute address to place my code/constant data
RAMStart    EQU  $0800
STACK       EQU  $2000
INTCR       EQU  $001E
PORTA       EQU  $0000
DDRA        EQU  $0002



            
            ORG RAMStart
Min         DS.B 1
Pos         DS.B 1
Array       DC.B $F0,$89,$21,$78,$52,$11,$F1,$5,$89,$15            
            
            LDS   #STACK

            
             
            ORG   ROMStart
Entry:
_Startup:            
            
            
             
main:
            ldd #$FACB 
            lsld
            tsty
            rts
            
            
            



;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
