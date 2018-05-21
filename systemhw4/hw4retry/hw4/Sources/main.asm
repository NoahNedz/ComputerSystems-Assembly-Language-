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
;		INCLUDE 'derivative.inc' 

RAMStart    EQU  $0800
ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

            ORG RAMStart

; code section
            

samples     DC.B  $90,$50,$A0,$00,$20,$CC,$88,$77
nelements   DC.B  8 ;negative numbers
psum        DS.B  1 ;positive sum
pnumber     DS.B  1 ;number of positive numbers
   


; code section
            ORG   ROMStart

Entry:
_Startup:            
            
          ldab samples ; current val
            
            
            ldaa #$07 ;max
            ldy #$00  ;sum
            
            BRA whileLoop 
            
            
            
            
                      
                   
whileLoop:   
           ldab 1,x+         
           
           
           TSTB
           BLE whileLoop ;repeat if neg
           
           ;if positive
           INC $810
           ABY    ;add b to y
           
           DECA
           
           TSTA
           BHS whileLoop
           
           ;when a is less than 0 end 
           RTS 
           
           
            
  

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
