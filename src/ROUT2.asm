\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.ROUT2"
\\ B%=P%
\\ [OPT pass
 
 
\ Erase start lights if still
\ there and startoff=0
 
.process_signs
 LDX startoff:BEQ nolites
 DEX:STX startoff
 BNE nolites
 JMP start_erase
.nolites
 RTS
 
.start_calc
 LDX #0:LDY #40:JSR xycalc:\ X was 64
 STA vec2+1:STX vec2
 TAY:TXA
 CLC:ADC #&40:STA vec3
 TYA:ADC #1:STA vec3+1
 LDY #3*3*8-1
 RTS
 
.start_up
 JSR start_calc
.staup0
 LDX #3*8-1
.staup1
 LDA lightgra+&48,X
 STA (vec2),Y
 LDA lightgra+&A8,X
 STA (vec3),Y
 DEY:BMI staup2
 DEX:BPL staup1
 BMI staup0
.staup2
 LDY #40:JSR frame_delay
 LDA #1*3*8-1:JSR lighton
 LDX #76:JSR sndlit:\ was 60
 LDA #2*3*8-1:JSR lighton
 LDX #76:JSR sndlit:\ was 60
 LDA #3*3*8-1:JSR lighton
 LDX #172:JSR sndlit:\ was 156
 
\ Delay period before lights
\ are erased!
 
 LDA #14:STA startoff:\ was 18
 RTS
 
.lighton
 PHA
 LDY #5
 CMP #3*3*8-1:BNE fudlite:\ Branch if not 3rd light
 JSR rand:AND #3:ADC #5:TAY:\ Random delay before third light
.fudlite
 STY vec
.ligondel
 LDY #10:JSR frame_delay
 
 BIT fjoy:BMI nostjoy:\ Branch if joystick selected
 
 LDX #&B7:JSR check_key:BNE nostal:\ Chk if trying to cheat at start
 BEQ nostjo1:\ always
 
\ Joystick check routines
 
.nostjoy
 BIT fjtype:BMI nostjo0:\ Branch if Plus 1 selected
 
 LDA &FCC0:LSR A:BCS nostal:\ Branch if Joystick not UP
 BCC nostjo1:\ always
 
.nostjo0
 LDX #2:JSR chkjoy:BCC nostal:\ Branch if joy not UP
 
.nostjo1
 LDA #26:STA medisabled:\ Was 36 on BBC version
 
.nostal
 JSR keys_b
 JSR brm
 DEC vec:BNE ligondel
 PLA:TAX
 LDY #8*3-1
.ligon0
 LDA lightgra,X
 STA (vec2),Y
 LDA lightgra+&60,X
 STA (vec3),Y
 DEX:DEY:BPL ligon0
 LDA vec2
 CLC:ADC #8*3:STA vec2
 BCC ligon1
 INC vec2+1
.ligon1
 LDA vec3
 CLC:ADC #8*3:STA vec3
 BCC ligon2
 INC vec3+1
.ligon2
 RTS
 
.frame_delay
 STY temp3
.framdel
 JSR fx19
 DEC temp3:BNE framdel
 RTS
 
.start_erase
 JSR start_calc
 LDA #0
.staera0
 STA (vec2),Y
 STA (vec3),Y
 DEY:BPL staera0
 RTS
 
.clstop
 LDA #8:STA temp2
.clstop0
 LDA #0:TAX:STA clstop1+1
 LDA #&5D:STA clstop1+2
 LDY #&1B
.clstop2
 TYA:BNE clstop1
 TXA:BMI clstop3
.clstop1
 LSR &FFFF,X
 INX:BNE clstop2
 INC clstop1+2
 DEY:BPL clstop2
.clstop3
 DEC temp2:BNE clstop0
 RTS
 
.rand
 LDA seed
 ROR seed:ROR seed+1:ROR seed+2
 EOR seed+1:EOR &FC
 STA seed:EOR seed+2
 CMP seed+2
 ROR seed+2:ROR seed
 LDA seed
 RTS
 
.chkjoy
 LDA joyval-1,X:CMP #&C0
 RTS
 
.chkjoy2
 LDA joyval-1,X:CMP #&40
 ROR A:EOR #&80:ROL A:\ Invert carry
 RTS
 
.hitsclo
 EQUB &5930 MOD 256
 EQUB (&5930+&280) MOD 256
 EQUB (&5930+&500) MOD 256
 EQUB (&5930+&780) MOD 256
 
.hitschi
 EQUB &5930 DIV 256
 EQUB (&5930+&280) DIV 256
 EQUB (&5930+&500) DIV 256
 EQUB (&5930+&780) DIV 256
 
.hitvalue
 EQUB 1:EQUB 5:EQUB 10:EQUB 50
 
.shw_hits
 LDA hits
.shw_hitsa
 STA temp2
 LDX #3:STX temp2+1
 
.shwits
 LDX temp2+1
 LDA hitsclo,X:STA temp1
 LDY hitschi,X:STY temp1+1
 CLC:ADC #&40:STA temp3
 TYA:ADC #1:STA temp3+1
 
 LDY #0:LDA temp2
.shwits0
 CMP hitvalue,X:BCC shwits1
 SBC hitvalue,X
 INY:BNE shwits0:\ Always
 
.shwits1
 STA temp2
 TYA:SEC:SBC lasthit,X:BEQ shwits2:\ If same number of flags as before
 PHP:PHA
 
 TYA:\ A is new number of flags
 BCC shwits6:\ If less flags now than before
 LDY lasthit,X:\ Y has number of old flags
 
\ Skip to end of last flag if more are to be added to end  OR
\ Skip to new end of flag ready to erase ones remaining to the left!
 
.shwits6
 STA lasthit,X:\ Put new flag value in table
 LDA temp1:SEC:SBC mul16tab,Y:STA temp1
 BCS shwits4
 DEC temp1+1
 
.shwits4
 
 LDA temp3:SEC:SBC mul16tab,Y:STA temp3
 BCS shwits3
 DEC temp3+1
 
.shwits3
 PLA:PLP:BCS shwits5:\ If flags are to be added
 
\ Flags to be deleted
 
 EOR #&FF:ADC #1:\ complement to give true flag difference
 STA temp4
.shwits10
 LDY #&F:LDA #0
.shwits7
 STA (temp1),Y
 STA (temp3),Y
 DEY:BPL shwits7
 JSR hitsub16
 DEC temp4:BNE shwits10
 BEQ shwits2:\ always
 
\ Flags to be added
 
.shwits5
 STA temp4
 LDX temp2+1
 LDA flaghitlo,X:STA shwits11+1
 LDY flaghithi,X:STY shwits11+2
 CLC:ADC #&40:STA shwits12+1
 TYA:ADC #0:STA shwits12+2
.shwits13
 LDY #&F
.shwits11
 LDA &FFFF,Y:STA (temp1),Y
.shwits12
 LDA &FFFF,Y:STA (temp3),Y
 DEY:BPL shwits11
 JSR hitsub16
 DEC temp4:BNE shwits13
 
.shwits2
 DEC temp2+1:BMI shwits14
 JMP shwits
.shwits14
 RTS
 
.mul16tab
 EQUB 0:EQUB &10:EQUB &20:EQUB &30:EQUB &40:EQUB &50
 
.hitsub16
 LDA temp1:SEC:SBC #&10:STA temp1
 BCS shwits8
 DEC temp1+1
.shwits8
 LDA temp3:SEC:SBC #&10:STA temp3
 BCS shwits9
 DEC temp3+1
.shwits9
 RTS
 
.flaghitlo
 EQUB hitsgra MOD 256
 EQUB (hitsgra+&10) MOD 256
 EQUB (hitsgra+&20) MOD 256
 EQUB (hitsgra+&30) MOD 256
.flaghithi
 EQUB hitsgra DIV 256
 EQUB (hitsgra+&10) DIV 256
 EQUB (hitsgra+&20) DIV 256
 EQUB (hitsgra+&30) DIV 256
 
\\ ]
\\ PRINT"Routine 2  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
