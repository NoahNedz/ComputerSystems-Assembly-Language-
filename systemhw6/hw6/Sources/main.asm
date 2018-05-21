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
        XDEF Entry, _Startup           ; export 'Entry' symbol
        ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		;INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data
RAMStart    EQU  $0800
STACK       EQU  $2000  ;stack
PortA       EQU  $0000
PortB       EQU  1
PortE       EQU  8
DDRA        EQU  $0002
DDRB        EQU  $0003
DDRE        EQU  $0009
INTCR       EQU  $001E



; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
LEDS        DS.B 1  ;800
Initial     DS.B 2;801,802 ;801 is what the max min looks at,store val in this
timer       DC.B 0 ;803
lMax        DC.B 0 ;804 
lMin        DC.B 0 ;805
arrayVal    DC.B 0 ;806
counter     DC.B 0 ;807 not used

timer1      DC.B $FF ;808
timer2      DC.B $FF ;809
timer3      DC.B $20  ;80A

refT1       DC.B $FF  ;80B
refT2       DC.B $20  ;80C

KEYS        DS.B 20   ;80D





; code section
            ORG   ROMStart
Entry:
_Startup:
            
            

main:                   
            ORG   ROMStart
            lds   #STACK
            ldx   #$801
            MovB  #$40,INTCR
            movb  #$FF,DDRA
            ;movb  #$FF,DDRB  ;these are inputs
            ;movb  #$FF,DDRE            
            
waits:      
            cli
            wai
            
            
            ldab  0,x 
            stab $0806
            jsr find_maxmin ;b contains the key value
            ldaa #$00
            staa $803           
            ldaa #$01
            ldab $806           
            jsr update_leds  
            
            bra waits 
            rts
            
            
find_maxmin:  
            
            cmpb #$03
            bls less       
            ldaa #$07
            staa $804
            sba           
            exg a,b 
            sba  
            staa $805      
            rts
                    
less:    
            tba 
            aba 
            staa $804
            ldaa #$0
            staa $805 
            rts 
          
update_leds:  
 
base_num:        
        
            cmpb $803
            ble first
            asla 
            inc $803   
            bra base_num  
        

first:                    ;stores the inputed number to be displayed
            staa $800
            movb $800,$000
            jsr delay
            bra max
        
max: 
                         ;goes to max
            ldab $804 
            cmpb $803
            ble back_2_base      
            asl $800
            movb $800,$000
            jsr delay        
            inc $803
            bra max

back_2_base:          ;goes to inputed number
            ldab $806 
            cmpb $803
            bge  min
            lsr $800
            movb $800,$000
            jsr delay
            dec $803
            bra back_2_base
        
min:                  ;goes to min value
            ldab $805        
            cmpb $803
            bge  back_2_base1 
            asr $800
            movb $800,$000
            jsr delay
            dec $803
            bra min    

back_2_base1:         ;brings back to the inputed number
            ldab $806 
            cmpb $803
            ble  done
            asl $800
            movb $800,$000
            jsr delay
            inc $803
            bra back_2_base1
       
            
done:       rts


delay:      dec timer1 ; delays 2 second 32(255^2)= 2,080,800
            tst timer1
            bne delay
            ;next 255
            movb  refT1,timer1
            dec timer2
            bne delay
            movb  refT1,timer2;resets the 255 counter
            ;jsr delay2
            
            dec timer3
            tst timer3
            bne delay
            
            movb refT2,timer3 ;resets the 16 counter
            rts
            
 key_isr:
            ;this never gets called because the keyboard never triggers interrupt :(
            ldab PortB
            stab $801
            jsr delay
            
            rti          
            
                       
            
            
            
            
            
                 
                   

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry
            ORG   $FFF2
            DC.W  key_isr          ; Reset Vector