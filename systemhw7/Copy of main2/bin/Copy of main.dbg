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
Stack       EQU  $2000
PortA       EQU  0
PortB       EQU  1
PortE       EQU  8
DDRA        EQU  2
INTCR       EQU  $001E
Col         EQU  4
Row         EQU  5
IRQEN       EQU  $40 
bit         EQU  %10000000
TSCR1       EQU  $0046
TFLG2       EQU  $004F



; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
KEYS        DS.B  1
LEDS        DS.B 1  ;800

timer       DC.B 0 
lMax        DC.B 0  
lMin        DC.B 0 
arrayVal    DC.B 0 

pressed     DS.B  1
colNumber   DS.B  1
rowNumber   DS.B  1
Mask        DC.B  $FE,$FD,$FB,$F7,$E7
Vals        DC.B  $00,$01,$02,$03,$04,$05,$06,$07,$08,$08,$09
Iteration   DC.B  $01
timer1      DC.B $FF 
timer2      DC.B $FF 
timer3      DC.B $20


refT1       DC.B $FF  
refT2       DC.B $26
replay      DC.B $0
baseVal     DC.B $0  
multi       DC.B $1
last        DC.B $0C
states      DC.W $0000
location    DC.W $0002
NTOF        DC.B 31
cycles      DC.B $0

            ORG   ROMStart


Entry:       lds  #Stack
_Startup:    
             movb  #$F0, PortE
             bset  INTCR, IRQEN
             
             cli
             
main:       
            wai
            
loop:       
            cli       
            ldab KEYS
            cmpb #$0C
            beq  restart
            
            
            ldy states
            cpy #$01
            beq wait
            
            ldy states
            cpy #$03
            beq go2
            
            
            
            ldy #$0001
            lbra delay
 d1:                  
            movb KEYS,timer
            bra max
            bra loop  
            rts
            
max:          ;goes to max
            movw #$0001,location
            ldab lMax 
            cmpb timer
            ble back_2_base      
            asl LEDS
            movb LEDS,$000
            
            ldy #$02
            lbra delay
d2:                
            inc timer
            bra max

restart:    movb #$00,states
            movb #$00,LEDS
            movb LEDS,$000
            bra main

wait:       wai
            bra loop

go2:        
            ldy location
            
            cpy #$0001
            beq max
            cpy #$0002
            beq back_2_base
            cpy #$0003
            beq min
            cpy #$0004
            beq back_2_base1 
            bra max

back_2_base:          ;goes to inputed number
            movw #$0002,location
            ldab arrayVal 
            cmpb timer
            bge  min
            lsr LEDS
            movb LEDS,$000
            ldy #$03
            dec timer
            lbra delay
d3:            
            
            bra back_2_base
        
min:                  ;goes to min value
            movw #$0003,location
            ldab lMin        
            cmpb timer
            bge  back_2_base1;
            asr LEDS
            movb LEDS,$000
            ldy #$04
            dec timer
            lbra delay
d4:            
            
            bra min    

back_2_base1:         
            movw #$0004,location
            ldab arrayVal 
            cmpb timer
            ble  reset  
            asl LEDS
            movb LEDS,$000
            ldy #$05
            inc timer
         
            lbra delay
 d5:           
            
            bra back_2_base1

reset:                 
            movw #$0000,states
            ldaa #$01            
            ldab KEYS
            lbra max                       

            
delay:      movb #bit,TSCR1
            movb #bit,TFLG2
            ldaa cycles
spin:       brclr TFLG2,$80,spin
            movb  #bit, TFLG2
            dbne  a,spin
            cpy #$0001
            lbeq d1
            cpy #$0002
            lbeq d2
            cpy #$0003
            lbeq d3
            cpy #$0004
            lbeq d4
            cpy #$0005
            lbeq d5
            rts                              
            
             
                                             


KEY_ISR     
            clrb
            ldx #Mask
start:      movb  1,x+, PortE; puts mask into portB to open it up, we are itterating through Rows
            ldaa  PortB ;read the  row
            cmpa  #$FF
            bne   row
            incb
            cmpb  #Col
            blt   start
            beq   return_ISR
row:        stab  colNumber ;stores the col number
            clrb
            ldx   #Mask ;resets the column for the next input

cont:       cmpa  1,x+
            beq   arr
            addb  #Col
            bra cont 
arr:        addb  colNumber
            stab  pressed          

return_ISR  movb  #$F0,PortE
            movb  #$FF,DDRA   
 
            
            ldab pressed
            
            
            ldy states
            cpy #$0001
            lbeq controls
            
            cmpb #$0D
            lbeq rip1
            cmpb #$08
            lbeq stopWithout
            cmpb #$09
            lbeq stopWithout
            cmpb #$0A
            lbeq stopWithout
            cmpb #$0B
            lbeq stopWithout
            cmpb #$0F
            lbeq stopWithout
            cmpb #$0C
            lbeq stopWithout
            
            
            
            
            cmpb #$0E
            lbeq stopWithout
           

 ends2:           
            movw #$0000,states
            movb pressed,KEYS
            movb KEYS,arrayVal
            movb KEYS,last     
            movb #$00,timer
            movb #$00,LEDS
            movb #$00,lMin
            movb #$00,lMax
            movb #$00,LEDS
            movb #$00,baseVal
            ldab KEYS           
            
            cmpb #$4
            beq set1
            cmpb #$3
            beq set1
            cmpb #$6
            beq set2
            cmpb #$1
            beq set2
            cmpb #$5
            beq set3
            cmpb #$2
            beq set3
            bra step
            
controls:   cmpb #$0D
            lbeq rip1
            
            cmpb #$0E
            lbeq rip2
            cmpb #$0C
            lbeq ends2
            
            
            bra rip1
stopWithout:  rti                              
          
set1:       movb #$35,cycles
            bra step
set2:       movb #$91,cycles
            
            bra step
set3:       movb #$63,cycles                                    
            
            bra step
            
step:       cmpb #$03
            bls less1       
            ldaa #$07
            staa lMax
            sba           
            exg a,b 
            sba  
            staa lMin      
            bra base_num3                   
less1:    
            tba 
            aba 
            staa lMax
            ldaa #$0
            staa lMin 
            
base_num3:   ldaa #$00
            staa timer           
            ldaa #$01
            ldab pressed            
                    
base_num4:  cmpb timer
            ble base5
            asla 
            inc timer   
            bra base_num4      

base5:      staa baseVal
            movb baseVal,LEDS
            movb LEDS,$000
           
            
            movw #$400E,$1FFE
            bra ends    

rip1:       ;
            movw #$400E,$1FFE
            movw #$0001,states
            rti
            

rip2:       movw #$400E,$1FFE
            movw #$0003,states         
            rti     

ends:       movw #$400E,$1FFE
            rti





            
        

            





                         
                         

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
            ORG   $FFF2
            DC.W  KEY_ISR
            
