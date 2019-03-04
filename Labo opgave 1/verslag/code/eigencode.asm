reset:
	jump setup
	
isr:
	; check irq flags
	ldr  R0, IRQF
	andl R0, 04 	; mask tmr irq
	jz btns_irq
	call inc_s  	; tmr flag was set
	reti
btns_irq:
	ldr  R0, E8 	; read btns state
	movr R1, R0 	; backup state
	andl R0, 04 	; btnL mask
	jz check_btnR
	call inc_s
	reti
check_btnR:
	movr R0, R1 	; backup state
	andl R1, 02 	; btnR mask
	jz middle_under_button
	call inc_mm
	reti

middle_under_button:
	andl R0, 03 	; btnMU mask
	jz other_button
	call set_time

other_button:
	reti
	
setup:
	; enable btn en tmr irq
	movl R0, 05
	str  C0, R0
	; enable timer
	movl R0, 01
	str  D8, R0
	
loop:	; continuously update 7 segment
	str  FF, R7
	str  FE, R6
	str  FD, R5
	str  FC, R4
	str  BCD3, R7
	str  FA, R6
	str  F9, R5
	str  F8, R4
	jmp loop

; set time subroutine
set_time:
	movl R4, 00
	movl R5, 00
	movl R7, 00
	movl R6, 00
	retc

; inc seconds subroutine
inc_s:
	; toggle led
	movl R0, 00
	str  F0, R0
	str  F1, R0
	addl R4, 01 		; increment R4 (seconds least-significant digit)
	cmpl R4, 0A 		; check if R4 = 10
	je   s0_overflow
	retc			; no overflow
s0_overflow:
	movl R4, 00		; reset LS digit
	addl R5, 01 		; increment R5 (MS digit)
	cmpl R5, 06 		; check if R5 = 6
	je   s1_overflow
	retc		        ; no overflow
s1_overflow:
	movl R5, 00 		; reset MS digit
	call inc_mm
	retc			; end of subroutine
	
; inc minutes subroutine
inc_mm:
	addl R6, 01 		; increment R6 (minutes LS digit)
	cmpl R6, 0A 		; check if R6 = 10
	je   m0_overflow
	retc			; end of subroutine
m0_overflow: 
	movl R6, 00 		; reset LS digit
	; toggle all leds
	movl R0, FF
	str  F0, R0
	str  F1, R0
	retc			; end of subroutine
	; end of program
