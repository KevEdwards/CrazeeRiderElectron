\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"ROUT1"
\\ B%=P%
\\ [OPT pass
 
.fx19
 LDA #19:JMP osbyte
 
.chkh
 LDX #&AB:\ H key
.check_key
 LDA #&81:LDY #&FF
 JSR osbyte
 CPY #&FF:RTS
 
.xycalc
 LDA #0:STA temp1+1
 TYA:AND #7:STA temp1
 TYA:LSR A:LSR A:LSR A:TAY
 TXA:AND #&FC
 ASL A:ROL temp1+1
 ORA temp1:ADC rowlow,Y:TAX
 LDA temp1+1:ADC rowhi,Y
 RTS
 
.rowlow
EQUB&0:EQUB&40:EQUB&80:EQUB&C0:EQUB&0:EQUB&40:EQUB&80:EQUB&C0:EQUB&0:EQUB&40:EQUB&80:EQUB&C0:EQUB&0:EQUB&40:EQUB&80:EQUB&C0:EQUB&0:EQUB&40:EQUB&80:EQUB&C0:EQUB&0:EQUB&40:EQUB&80:EQUB&C0:EQUB&0:EQUB&40:EQUB&80:EQUB&C0:EQUB&0:EQUB&40
EQUB&80:EQUB&C0
 
.rowhi
EQUB&58:EQUB&59:EQUB&5A:EQUB&5B:EQUB&5D:EQUB&5E:EQUB&5F:EQUB&60:EQUB&62:EQUB&63:EQUB&64:EQUB&65:EQUB&67:EQUB&68:EQUB&69:EQUB&6A:EQUB&6C:EQUB&6D:EQUB&6E:EQUB&6F:EQUB&71
EQUB&72:EQUB&73:EQUB&74:EQUB&76:EQUB&77:EQUB&78:EQUB&79:EQUB&7B:EQUB&7C:EQUB&7D:EQUB&7E
 
 
.reset
 LDX #&FF
 STX road_direct
 INX
 STX myspeed
 STX oldspeed
 STX oldspeed+1
 STX oldspeed+2
 STX kerb_position
 LDA tab_kposlo
 STA kcolour1+1:STA kcolour2+1
 LDA tab_kposhi
 STA kcolour1+2:STA kcolour2+2
 STX curve_start
 STX curve_stage
 STX mount_off
 STX track_fin
 STX new_sect
 STX mytyrepos:STX mylasttyrepos
 STX numobikes
 STX medisabled
 STX medisabled2
 STX argdel:\ similar to medisabled but disables sound fx not my bike
 STX hits:\ Number of bikes hit off during track
 STX finsnd:\ NE when finish line noise is dying way
 INX:\ 1
 STX kcount:STX myleandel
 INX:\ 2
 STX mypos
 STX mylastgraoff
 LDA #centre:STA midx
 LDA #centre-4:STA myx:\ was -8
 LDA #4:STA scr_count:\ was 3, see MROAD as well
 LDX #maxbikes-1:LDA #0
.reset0
 STA obike_st,X
 DEX:BPL reset0
 LDA #0:LDX #3
.reset1
 STA lasthit,X
 DEX:BPL reset1
 LDA &FC:STA seed
 EOR #&DF:STA seed+1
 EOR #&24:STA seed+2
 RTS
 
.hard_reset
 LDX #5:LDA #0
.hardre0
 STA score,X:DEX:BPL hardre0
 RTS
 
.controls
 LDA #0:STA myrelx:STA temp1+1
 LDX medisabled:BEQ cancontr
 DEC medisabled:RTS
.cancontr
 LDX medisabled2:BEQ cancon0
 DEC medisabled2:RTS
 
.cancon0
 
 BIT fjoy:BMI rxjoy
 
 LDX #&9E:JSR check_key:\ Z
 ROL myrelx
 LDX #&BD:JSR check_key:\ X
 ROL myrelx
 BIT track_fin:BMI condecr
 LDX #&B7:JSR check_key:\ colon
 ROL temp1+1
 LDX #&97:JSR check_key:\ ?
 ROL temp1+1
 BPL contrest:\ always
 
.rxjoy
 BIT fjtype:BPL rxfbyt:\ Read 1st byte
 
 LDX #1:JSR chkjoy:ROL myrelx
 LDX #1:JSR chkjoy2:ROL myrelx
 BIT track_fin:BMI condecr
 LDX #2:JSR chkjoy:ROL temp1+1
 LDX #2:JSR chkjoy2:ROL temp1+1
 BPL contrest:\ always
 
.rxfbyt
 LDA &FCC0:EOR #&FF
 BIT track_fin:BPL rxfby0:\ Use accel/decel bits if not end of track
 LSR A:LSR A:BPL rxfby1:\ Ignore accel/decel bits and branch always
 
.rxfby0
 LSR A:ROL temp1+1
 LSR A:ROL temp1+1
.rxfby1
 LSR A:ROL myrelx
 LSR A:ROL myrelx
 BIT track_fin:BPL contrest:\ Drop through to 'condecr' if end of track
 
.condecr
 INC temp1+1:\ Force control to decelerate at end of race!
.contrest
 LDX myrelx
 LDA relxchange,X
 LDX myspeed:BNE contr8
 LDA #0
.contr8
 STA myrelx
 LDA counter:LSR A:BCS contr1:\ Alter speed every other game loop
 LDX temp1+1
 LDA myspeed:CMP #85:BCC contr10:\ was 35 then 75
 LDY myx:CPY #8:BEQ contr2
 CPY #140:BEQ contr2
.contr10
 LDA relspeed,X:BEQ contr1
 CLC:ADC myspeed
 CMP #maxspeed+1:BCC contr9
.contr1
 RTS
 
.contr2
 SBC #2
 
\ contr9 is called by 'BIKES'
 
.contr9
 STA myspeed
 LDY #0
.contr3
 CMP #100:BCC contr4
 INY
 SBC #100:BCS contr3
.contr4
 STY newspeed+2
 LDY #0
.contr5
 CMP #10:BCC contr6
 INY
 SBC #10:BCS contr5
.contr6
 STY newspeed+1
 STA newspeed
 STA oldspeed
 LDX #68:LDY #224:JSR pdigit
 LDY newspeed+1
 CPY oldspeed+1:STY oldspeed+1
 BNE prit
 JSR pdig_left:JMP prit0
.prit
 JSR pdigit2
.prit0
 LDY newspeed+2
 CPY oldspeed+2:STY oldspeed+2
 BEQ contr7
 JMP pdigit2
.contr7
 RTS
 
.show_speed
 LDA #0:LDX #68:LDY #224
 JSR pdigit
 LDY #0:JSR pdigit2
 LDY #0:JMP pdigit2
 
.relspeed
 EQUB 0:EQUB -1:EQUB 1:EQUB 0
.relxchange
 EQUB 0:EQUB 2:EQUB -2:EQUB 0
 
 
.proc_mount
 LDA mount_off:AND #1:TAX
 LDA tab_mnt_hi,X
 STA procmt1+2:STA procmt2+2
 LDA tab_mnt_lo,X
 STA procmt1+1:STA procmt2+1
 LDA mount_off:AND #&FE
 ASL A:ASL A
 TAY:CLC:ADC #&3F:STA temp1
 LDX #0
.procmt1
 LDA &FFFF,Y:STA &6340,X
 INY:INX:BNE procmt1
 LDX #&3F:LDY temp1
.procmt2
 LDA &FFFF,Y:STA &6440,X
 DEY:DEX:BPL procmt2
 RTS
 
.tab_mnt_lo
 EQUB (mount_gra+&100) MOD 256
 EQUB mount_gra MOD 256
.tab_mnt_hi
 EQUB (mount_gra+&100) DIV 256
 EQUB mount_gra DIV 256
 
.pdigit
 STA temp2
 JSR xycalc
 STA pdigit3+2:STX pdigit3+1
 TAY:TXA
 CLC:ADC #&40:STA pdigit4+1
 TYA:ADC #1:STA pdigit4+2
 LDY temp2
.pdigit2
 LDX tab_pdig,Y
 LDY #&F
.pdigit1
 LDA digits,X
.pdigit3
 STA &FFFF,Y
 LDA digits+&A0,X
.pdigit4
 STA &FFFF,Y
 DEX:DEY:BPL pdigit1
.pdig_left
 LDA pdigit3+1
 SEC:SBC #16:STA pdigit3+1
 BCS pdiglt0
 DEC pdigit3+2
.pdiglt0
 LDA pdigit4+1
 SEC:SBC #16:STA pdigit4+1
 BCS pdiglt1
 DEC pdigit4+2
.pdiglt1
 RTS
 
.tab_pdig
 EQUB &F:EQUB &1F:EQUB &2F:EQUB &3F:EQUB &4F:EQUB &5F:EQUB &6F:EQUB &7F:EQUB &8F:EQUB &9F
 
 
\\ ]
\\ PRINT"Routine 1  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
