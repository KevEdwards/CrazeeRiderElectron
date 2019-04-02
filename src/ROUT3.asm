\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.ROUT3"
\\ B%=P%
\\ [OPT pass
 
 
.show_score
 LDX #5:STX temp3
.shosc0
 LDA score,X:LDX #40:LDY #16
 JSR pdigit
.shosc1
 DEC temp3:BMI shoexit
 LDX temp3
 LDY score,X
 JSR pdigit2
 JMP shosc1
.shoexit
 RTS
 
.add_score
 STA temp3+1
 TAY:BEQ adscoext
 LDX #4:STX temp3
.addsco0
 LDX temp3
 LDA temp3+1:BEQ adscoext
 CLC:ADC score,X
 LDY #0
.addsco1
 CMP #10:BCC addsco2
 INY
 SBC #10:BCS addsco1
.addsco2
 STA score,X
 STY temp3+1
 CPX #4:BEQ addsco3
 TAY
 JSR pdigit2
 DEC temp3:BPL addsco0
 RTS
.addsco3
 LDX #32:LDY #16:JSR pdigit
 DEC temp3:BPL addsco0
.adscoext
 RTS
 
 
.event
 PHP
 CMP #4:BNE event0
 JMP framev
.event0
 PLP:RTS
 
.show_pos
 LDX position:INX:TXA:LDY #0
.shwpos
 CMP #10:BCC shwpos0
 SBC #10:INY:BNE shwpos
.shwpos0
 STY temp+3
 LDX #96:LDY #224
 JSR pdigit
 LDY temp+3
 JMP pdigit2
 
.clsrows
 LDA #&98
.clsrow_a
 STA temp1
 LDA #&60:STA clsmap+1:LDA #&58:STA clsmap+2
 LDY #8
.clmap0
 LDX #0:TXA
.clsmap
 STA &FFFF,X
 INX:CPX temp1:BCC clsmap
 LDA clsmap+1:ADC #&3F:STA clsmap+1:\ C=1 before ADC
 LDA clsmap+2:ADC #1:STA clsmap+2
 DEY:BNE clmap0
 
 JSR start_erase:\ Make sure start lights are erased as well
 LDA #256-6*8-8*8:STA temp2
 LDX #0:LDY #8*8:JSR xycalc
 STA temp4+1:STX temp4
 STA temp3+1:STX temp3
.clsro2
 LDX #40:\ bytes across
 LDY #0
.clsro0
 LDA #0:STA (temp3),Y
 TYA:CLC:ADC #8:TAY
 BCC clsro1
 INC temp3+1
.clsro1
 LDA #8:STA temp2+1
.clsrdel
 DEC temp2+1:BNE clsrdel
 DEX:BNE clsro0
 LDA temp4:AND #7:CMP #7
 BNE clsro3
 LDA temp4:ADC #&38:\ c=1 here
 STA temp3:STA temp4
 LDA temp4+1:ADC #1
 STA temp3+1:STA temp4+1
 BNE clsro4:\ always
.clsro3
 LDX temp4:INX
 STX temp3:STX temp4
 LDX temp4+1:STX temp3+1
.clsro4
 DEC temp2:BNE clsro2
 RTS
 
.getrkoff
 LDA current_track
.getrkof1
 CMP numoftracks:BCC getrkof0
 SBC numoftracks:BCS getrkof1
.getrkof0
 TAX
 RTS
 
.keyinfo
 LDA adrlo,X:STA keylet
 LDA adrhi,X:STA keylet+1
 LDA keylettab,X:STA keychar
 LDY #22:JMP pstring
 
.keys
 LDA counter:AND #7:BNE keys0
.keys_b
 LDX #3:STX curr_id:\ Use curr_id as a counter variable
 
.keys1
 LDY curr_id:LDX keytable,Y
 JSR check_key:BNE keys2
 LDX curr_id
 LDA fpause,X:EOR #&FF:STA fpause,X:\ Change option flag
 JSR keyinfo:\ Erase current option letter
 JSR flush:\ FX 15,0 (not really wanted for K/J but it does it)
 LDX curr_id:BEQ keys3:\ branch if Pause option, H or space!
 
 LDA keylettab,X:EOR leteor,X
 STA keychar:STA keylettab,X
 JMP keys6
.keys3
 JSR chkh:BEQ keys3:\ wait until key is released
.key4
 JSR chkh:BNE key4:\ wait until key is pressed
.key5
 JSR chkh:BEQ key5:\ wait until released
 LDA #0:STA fpause:\ reset pause flag to 0 (off)
 
.keys6
 LDY #22:JSR pstring:\ display new option letter
.keys2
 DEC curr_id:BPL keys1
.keys0
 RTS
 
.adrlo
 EQUB &AA:EQUB &A:EQUB &18:EQUB &A0
.adrhi
 EQUB &7F:EQUB &7F:EQUB &7F:EQUB &7F
.keylettab
 EQUB 'H'-32:EQUB 'K'-32:EQUB 'S'-32:EQUB 'D'-32
.keytable
 EQUB &AB:EQUB &B9:EQUB &AE:EQUB &BA:\ H K S J
 
.fpause
 EQUB 0
.fjoy
 EQUB 0
.fsound
 EQUB &FF
.fjtype
 EQUB 0:\ Default joystick is D (digital First Byte)
 
.leteor
 EQUB ' '-32 EOR 'H'-32:\ doesn't actually get used
 EQUB 'K'-32 EOR 'J'-32
 EQUB 'S'-32 EOR 'Q'-32
 EQUB 'D'-32 EOR 'P'-32
 
 
.flush
 LDA #15:LDX #0:JMP osbyte
 
 
.cycle
 LDA temp2:PHA:\ Save temp2 as 'clstop' corrupts it
 JSR clstop
 LDA #36
.cycl0
 PHA:TAY
 JSR pstring
 PLA:CLC:ADC #2
 CMP #48:BCC cycl0
 
 LDX #2
.cycl1
 LDA defpal,X:STA curpal,X
 DEX:BPL cycl1
 
 LDA #20:JSR oswrch:\ Reset palette
 LDX #2:LDY #2:JSR vdu19:\ Change colour 2 to green, other values ok.
 
.cycl2
 LDA #2:STA temp1+1
.cycl3
 LDY temp1+1:LDX cyckey,Y
 JSR check_key:BNE cycl4
 
 LDX temp1+1
.cycl5
 INC curpal,X
 LDA curpal,X:AND #7:BEQ cycl5
 STA curpal,X
 TAY:\ New colour value
 INX:\ Adjust due to 0=colour 1, 1=colour 2...
 JSR vdu19
 
.cycl4
 DEC temp1+1:BPL cycl3
 LDA #10:JSR delspc:\ Wait 10 frames or until space pressed
 JSR spcts0:BNE cycl2:\ Loop back if space not pressed
 
 JSR clstop
 PLA:STA temp2:\ Restore temp2
 RTS
 
.vdu19
 LDA #19:JSR oswrch
 TXA:JSR oswrch
 TYA:JSR oswrch
 LDA #0
 JSR oswrch:JSR oswrch:JMP oswrch
 
.curpal
 EQUB 0:EQUB 0:EQUB 0
.defpal
 EQUB 1:EQUB 2:EQUB 7:\ Default colour values for colour 1,2 and 3
 
.cyckey
 EQUB &CF:EQUB &CE:EQUB &EE
 
\\ ]
\\ PRINT"Routine 3  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
