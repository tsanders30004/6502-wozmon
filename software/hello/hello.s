; 1.  PURPOSE
;     A.  print "HELLO WORLD 6502"on the LCD of the FEB 2024 PCB to prove that the LCD is working.
; 2.  HARDWARE REQUIREMENTS
;     A.  this code will run on the FEB 2024 *prototype* rs232 board.
; 3.  IMPLEMENTATION DETAILS
;     A.  no rs232 code is in this file; this file is simply used to prove that the LCD is working.
;     B.  modifications to DDRA and the reset vectors will become necessary if this code is refactored
;         to support the rs232.

; 65c22 registers
; reg #   rs3 rs2 rs1 rs0     register    description
;  0       0   0   0   0      IRB / ORB   input or output register for port B
;  1       0   0   0   1      IRA / ORA   input or output register for port A
;  2       0   0   1   0      DDRB        data direction port B
;  3       0   0   1   1      DDRA        data direction port A

; 6522 addresses 
PORTB       = $6000     ; port B on the 6522
PORTA       = $6001     ; port A on the 6522
DDRB        = $6002     ; data direction register for port B on the 6522
DDRA        = $6003     ; data direction register for port A on the 6522

; lcd configuration
; these values are defined on the schematic (4-bit mode).
E           = %01000000 ; corresponds to PB6 on 6522; i.e., 0100 0000
RW          = %00100000 ; corresponds to PB5 on 6522; i.e., 0010 0000
RS          = %00010000 ; corresponds to PB4 on 6522; i.e., 0001 0000

; MAIN
  .org $8000

reset:
  ; initialize stack pointer to FF.
  LDX #$ff
  TXS

  JSR data_dir_config   ; configure 6522 data direction registers
  
  JSR lcd_init

  JSR lcd_configure

; print message.  use X as a counter to print each character in message.
  LDX #$00

print_message:
  LDA message,X
  BEQ infinite_loop     ; stop if we have printed the entire message.
  JSR print_char
  INX
  JMP print_message

infinite_loop:
  JMP infinite_loop

; CONSTANTS

; a # char is printed in the first column of the LCD for this pattern.
; message:  .asciiz "HELLO WORLD 1234567890abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstu*#"

;                           1         2         3         4         5         6         7         8
;                  12345678901234567890123456789012345678901234567890123456789012345678901234567890 
message:  .asciiz "HELLO WORLD 6502"

; SUBROUTINES

data_dir_config:
  PHA
  LDA #%11111111 ; set all pins on port B to output
  STA DDRB
  LDA #%11111111 ; WARNING!  pin 6 of DDRA must to set to 0 if you adapt this code to support the rs232.  it was not needed in this program so it was set to 1.
  STA DDRA
  PLA
  RTS
  
; ---------- E N D   O F  S U B R O U T I N E  ----------

lcd_wait:
  PHA
  LDA #%11110000  ; LCD data is input
  STA DDRB
lcdbusy:
  LDA #RW
  STA PORTB
  LDA #(RW | E)
  STA PORTB
  LDA PORTB       ; Read high nibble
  PHA             ; and put on stack since it has the busy flag
  LDA #RW
  STA PORTB
  LDA #(RW | E)
  STA PORTB
  LDA PORTB       ; Read low nibble
  PLA             ; Get high nibble off stack
  AND #%00001000
  BNE lcdbusy

  LDA #RW
  STA PORTB
  LDA #%11111111  ; LCD data is output
  STA DDRB
  PLA
  RTS

; ---------- E N D   O F  S U B R O U T I N E  ----------

lcd_init:
  LDA #%00000010  ; set 4-bit mode
  STA PORTB
  ORA #E
  STA PORTB
  AND #%00001111
  STA PORTB
  RTS

; ---------- E N D   O F  S U B R O U T I N E  ----------

lcd_configure:
    PHA                 ; store A
    
    LDA #%00101000      ; set 4-bit mode; 2-line display; 5x8 font
    JSR lcd_instruction

    ; LDA #%00001110      ; set display on, cursor on, blink off.
    LDA   #%00001100      ; set display on, cursor off, blink off.
    JSR lcd_instruction

    LDA #%00000110      ; increment and shift cursor; don't shift display.
    JSR lcd_instruction
    
    LDA #%00000001      ; clear display
    JSR lcd_instruction

    PLA
    RTS

; ---------- E N D   O F  S U B R O U T I N E  ----------

lcd_instruction:
  JSR lcd_wait
  PHA
  LSR
  LSR
  LSR
  LSR            ; Send high 4 bits
  STA PORTB
  ORA #E         ; Set E bit to send instruction
  STA PORTB
  EOR #E         ; Clear E bit
  STA PORTB
  PLA
  AND #%00001111 ; Send low 4 bits
  STA PORTB
  ORA #E         ; Set E bit to send instruction
  STA PORTB
  EOR #E         ; Clear E bit
  STA PORTB
  RTS

; ---------- E N D   O F  S U B R O U T I N E  ----------

print_char:
  JSR lcd_wait
  PHA
  LSR
  LSR
  LSR
  LSR             ; Send high 4 bits
  ORA #RS         ; Set RS
  STA PORTB
  ORA #E          ; Set E bit to send instruction
  STA PORTB
  EOR #E          ; Clear E bit
  STA PORTB
  PLA
  AND #%00001111  ; Send low 4 bits
  ORA #RS         ; Set RS
  STA PORTB
  ORA #E          ; Set E bit to send instruction
  STA PORTB
  EOR #E          ; Clear E bit
  STA PORTB
  RTS

; ---------- E N D   O F  S U B R O U T I N E  ----------

nmi:
  RTI

; Reset/IRQ vectors
  .org $fffa
  .word nmi
  .word reset
  .word $0000   ; we have to add this to expand the rom file to exactly 32768 bytes.  any value will do.
  
