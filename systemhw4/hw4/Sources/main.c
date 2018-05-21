; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		;INCLUDE 'derivative.inc' 

RAMStart    EQU  $0800

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

            ORG RAMStart
         
 ; Insert here your data definition.

samples      DS.B #$10,#$20,#$30,$#A0,#$B0,#$C0
tsum         DS.B 1
   


; code section
            ORG   ROMStart


Entry:
_Startup:


            
mainLoop:
            
            
           ldaa $0800 ;a = 10
           adda $0801 ;a + 801 = 30
           ldaa #0    ; clears a
           
           ldx #samples; x =800
           ldaa 0,x   ; a = 10
           adda 1,+x  ; a = 800 + 801=30  (x=801)
           ldab #$1    ; b = 1
           adda b,x   ; x + b = 802, a = 30 + 30 = 60
           
           adda 2,+x  ; x = $803, $60 + $A0 = $100   
           adda 1,+x  ; x = $804, a = $100 + $B0 = $1B0
           adda 1,+x  ; x = $805, a = 1B0 + C0 = $270
           
           staa tsum  ; stores content of a into tsum
           rts  
           
