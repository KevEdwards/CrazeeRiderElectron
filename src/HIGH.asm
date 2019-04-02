\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.HIGH"
\\ B%=P%
\\ [OPT pass
 
\ This routine handles a 6 entry high score where the names are 16 chars.
\ long and the score is 6 chars.
\ Format is  000000ABCDEFGHIJKLMNOP for each entry
\ where 000000 is the score field and ABCD.. is the name field
 
 
\ Start offset values for the 6 high score entries
 
.ti22
 EQUB 0:EQUB 22:EQUB 44:EQUB 66:EQUB 88:EQUB 110
 
 
\ See if score if good enough for a new high score
 
.hig
 LDX #0:STX temp2:\ Entry counter
.hig0
 LDY ti22,X:STY temp2+1:\ Offset start for current entry 0,22,44..
 DEY:LDX #&FF
.hig1
 INY:INX:CPX #6:BEQ hig3
 LDA score,X:CLC:ADC #'0'-32:\ Convert to my ascii
 CMP hsbase,Y
 BEQ hig1
 BCC hig2
 BNE hig3
.hig2
 INC temp2:LDX temp2:\ Next entry
 CPX #6:BCC hig0
 RTS:\ score not in high score table, so exit
 
\ Shuffle names down from the new entry position so that the new
\ entry can be inserted
 
.hig3
 LDA temp2:PHA:\ Save entry number (0-5) on stack for input routine
 CMP #5:BEQ hig5:\ Don't shuffle down if last entry in table
 LDY #5*22:\ point to 1st byte of last entry, the DEY will then adjust ok!
.hig4
 DEY
 LDA hsbase,Y:STA hsbase+22,Y:\ Copy names up memory 1 entry
 CPY temp2+1:\ Has start of source offset been copied and reached yet?
 BNE hig4
 
\ Copy the new score into the table at the correct position and then
\ fill the name field with space characters
 
.hig5
 LDY temp2+1:\ Read start offset for current entry
 TYA:PHA:\ Save start offset for current entry (used by input routine)
 LDX #0
.hig6
 LDA #' '-32:\ My ascii for space
 CPX #6:BCS hig7:\ Branch if accesing the name field
 LDA score,X:CLC:ADC #'0'-32:\ Convert score value into my ascii digits
.hig7
 STA hsbase,Y
 INY:INX
 CPX #22:BCC hig6
 
 LDY #16:JSR pstring:\ 'A NEW HIGH SCORE'
 JSR phi:\ Display the high score table
 LDY #7:JSR tune
 LDY #25:JSR frame_delay:\ Short delay after tune/time to release space
 
 PLA:STA vec:\ Save start offset for new entry
 PLA:ASL A:ASL A:ASL A:ASL A:\ entry value (0-5) times 16
 ADC #10*8:\ Add offset to Y position for input
 TAY:LDX #64:JSR xycalc:\ Calc address of input start position
 STA txhsline+1:STX txhsline:\ Save in 'pstring' screen address field
 
 LDX #&FF:JSR kbdonof:\ Turn kbd irqs on again
 LDA #0:STA vec+1:\ Next free name counter
 BEQ gtn0
.gtn1
 LDA #7:JSR oswrch
.gtn2
 STX vec:STY vec+1
.gtn0
 LDA #21:LDX #0:JSR osbyte:\ Flush kbd buffer only! to overcome fkeys!
 LDA #202:LDX #&20:LDY #0:JSR osbyte:\ Caps Lock on/Shift Lock off
 LDA #&7E:JSR osbyte:\ Clear escape condition
 JSR osrdch:\ Get character
 BCS gtn0:\ Again, if escape pressed
 LDX vec:\ Offset from 'hsbase' for next input character
 LDY vec+1:\ Next free name counter (0-15) if 16 can only delete/return
 
 CMP #&D:BEQ gtnex:\ Return has ended input
 CMP #&7F:BEQ gtn3:\ If delete pressed
 
 CPY #16:BEQ gtn1:\ Name 'full', can only press delete or return
 CMP #'Z'+1:BCS gtn1:\ Beep, invalid char.
 SBC #' '-1:\ Subtract ASC " " for my ascii, with fudge because c=0
 BCC gtn1:\ Beep, invalid char.
 STA hsbase+6,X:\ Save in table in the name field, NOT in the score part!
 STA txhsl0:\ Save in 'pstring' character position
 JSR pit:\ Print new character
 
 LDA txhsline:AND #2:ASL A
 ORA #10
 CLC:ADC txhsline
 STA txhsline:BCC gtn4
 INC txhsline+1
.gtn4
 INX:INY:\ Increase pointer and counter
 BPL gtn2:\ always
 
.gtn3
 CPY #0:BEQ gtn1:\ Can't delete when no characters entered
 LDA txhsline:AND #2:EOR #2:ASL A
 ORA #10
 STA temp1
 LDA txhsline:SEC:SBC temp1
 STA txhsline:BCS gtn5
 DEC txhsline+1
.gtn5
 DEX:\ 'hsbase' offset back to last character
 LDA hsbase+6,X:STA txhsl0:\ Read last char and put in 'pstring' block
 JSR pit:\ Erase last character
 LDA #' '-32:STA hsbase+6,X:\ Put space into erased character place
 DEY:JMP gtn2:\ Branch won't reach!
 
.pit
 TXA:PHA:TYA:PHA
 LDY #32:JSR pstring
 PLA:TAY:PLA:TAX
 RTS
 
.gtnex
 LDY #25:JSR frame_delay
 JSR clstop
 LDX #0:\ Value to disable kbd
 
.kbdonof
 LDA #178:LDY #0:JMP osbyte:\ FX 178 disables KBD irqs
 
.txhsline
 EQUW &FFFF:EQUB &F0
.txhsl0
 EQUS "A"
 EQUB &FF
 
.txent
 EQUW &FFFF:EQUB &FF
.txent0
 EQUS "1":EQUW 0:EQUS "000000":EQUB 0:EQUS "1234567890123456"
 EQUB &FF
 
.phi
 LDX #4:LDY #10*8:JSR xycalc
 STA txent+1:STX txent:\ Save top left screen address of table
 LDA #&80:\ 1st entry in colour 2 (green)
 LDX #0:STX vec:\ Entry counter
 
.phi0
 STA txent+2:\ Text colour byte, 1st entry green others white!
 TXA:CLC:ADC #'1'-32:\ Make 0,1,2.. into my ascii chars 1,2,3
 STA txent0
 LDY ti22,X
 LDX #0
.phi1
 LDA hsbase,Y:STA txent0+3,X
 INY:INX:CPX #6:BCC phi1
 INX:\ skip over for space between score and name field
.phi2
 LDA hsbase,Y:STA txent0+3,X
 INY:INX:CPX #23:BCC phi2:\ 0-22 copy (1 extra due to space skipped)
 LDY #34:JSR pstring
 LDA txent:CLC:ADC #&80:STA txent
 LDA txent+1:ADC #2:STA txent+1
 LDA #&88:\ New text colour (3, white)!
 INC vec:LDX vec:CPX #6:BCC phi0
 RTS
 
 
\\ ]
\\ PRINT"High       from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
