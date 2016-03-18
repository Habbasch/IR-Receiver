;******************************************************************************
;* Programm:		
;*
;* Dateinname:		    .asm
;* Version:			    1.0
;* Autor:			    Werner Odermatt
;*
;* Verwendungszweck:	uP-Schulung
;*
;* Beschreibung:
;*		
;*				
;*
;* Entwicklungsablauf:
;* Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;* 1.0  01.01.13  WOd    Ganzes Programm erstellt				           Min.
;*
;*										Totalzeit:	 Min.
;*
;* Copyright: Werner Odermatt, alte Kappelerstrasse 46, 6340 Baar (2014)
;******************************************************************************

;*** Kontrollerangabe ***
.include "m8515def.inc" ;(STK-600: m2560def.inc)

		RJMP	Reset

;*** Include-Files ***
;.include "U:\AVR Include Files\delay.inc"



;*** Konstanten ***
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

;*** Variablen ***
.def 	mpr	        = R16		; Multifunktionsregister
.def 	counter		= R17
.def	addr		= R18
.def	invaddr		= R19
.def	comm		= R20
.def	invcomm		= R21



;******************************************************************************
; Hauptprogramm
;******************************************************************************

;*** Initialisierung ***
Reset:	SER	    mpr			        ; Output:= LED
		OUT	    LED_D, mpr

		CLR	    mpr			        ; Input:= Schalterwerte
		OUT	    SWITCH_D, mpr

		LDI	    mpr, LOW(RAMEND)    ; Stack initialisieren
		OUT	    SPL,mpr
		LDI	    mpr, HIGH(RAMEND)
		OUT	    SPH,mpr


;*** Hauptprogramm ***	
Main:		CLR		counter
			IN		mpr, SWITCH	
			
			TST		mpr
			BREQ	End

			RCALL	W100us
			INC		counter

Loop1:		IN		mpr, SWITCH
			TST		mpr
			BRNE	Loop1
				
			//$59 = 89
			CPI		counter, $59
			BRNE	End
			
			CLR		counter

Loop2:		INC		counter
			RCALL	W100us
			IN		mpr, SWITCH

			TST		mpr
			BREQ	Loop2

			CPI		counter, $2B
			BRNE	End

			RCALL	ReadSignal

			

End:		RJMP	Main
		
ReadSignal:	RJMP	Main



;******************************************************************************
; Unterprogramme
;******************************************************************************
