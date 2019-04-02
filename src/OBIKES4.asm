\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.OBIKES4"
\\ B%=P%
\\ [OPT pass
 
.dload_info
 LDA obike_scrlo,X:STA temp2
 LDA obike_scrhi,X:STA temp2+1
 LDA obike_gralo,X:STA temp4
 LDA obike_grahi,X:STA grahold
 LDA obike_graoff,X:STA temp5+2
 LDA obike_sprheight,X:STA sprheight
 LDA obike_wid,X:STA temp5
 RTS
 
.calc_spinfo
 JSR dload_info
 JSR obikenewinfo
 CMP sprheight:BNE calsinfo
 CPY temp5:BNE calsinfo
 TAX:BEQ calinfex
 
 LDA grahold
 LDX grahold+1
 LDY grahold+2
 JMP sprite_obikes
 
.calinfex
 RTS
 
.calsinfo
 LDA sprheight:BEQ calsinfo0
 LDA grahold
 JSR put_sprite
 
.calsinfo0
 LDX curr_id
 LDA obike_sprheight,X
 BEQ calinfex
 STA sprheight
 LDA temp3:STA temp2
 LDA temp3+1:STA temp2+1
 LDA obike_wid,X
 STA temp5
 LDA obike_graoff,X
 STA temp5+2
 LDA grahold+1
 STA temp4
 LDA grahold+2
 JMP put_sprite
 
.obikenewinfo
 LDY #pantopy:\ base Y for split sprite
 LDA obike_y,X
 SEC:SBC #pantopy
 BCS bnewinf
 LDA #0
.bnewinf
 STA temp+2:\ rows which are behind panel!
 BNE bnewinf0
 LDY obike_y,X
.bnewinf0
 TYA:JSR calcrealx
 TAX:\ real screen X
 LDA temp:\ see 'calcrealx'
 CLC:ADC #ytop
 TAY
 JSR xycalc
 STA temp3+1:STX temp3
 LDY curr_id
 STX obike_scrlo,Y
 STA obike_scrhi,Y
 
 LDX curr_id
 LDA temp+2
 ASL A:ASL A:\ times 4
 ADC temp+2:\ times 5
 STA obike_graoff,X
 
 JSR calc_gra_obikes
 STA obike_gralo,X
 STY obike_grahi,X
 STA grahold+1:STY grahold+2
 
 JSR calc_bikesize
 LDA tabactwid,Y
 STA obike_wid,X
 LDA tabacthei,Y
 SEC:SBC temp+2
 BCS bnewinf1
 LDA #0
.bnewinf1
 STA obike_sprheight,X
 LDY obike_wid,X
 RTS
 
.tabactwid
 EQUB 4:EQUB 3:EQUB 2:EQUB 1:\ widths-1
.tabacthei
 EQUB 30:EQUB 24:EQUB 18:EQUB 12
 
.obnewpos
 LDY #3
 LDA obike_speed,X
.obnewpo0
 CMP tswaptab,Y
 BCC obnewpo1
 DEY:BNE obnewpo0
.obnewpo1
 LDA counter
 AND bitmasktab,Y
 CMP bitmasktab,Y
 BNE obnewpo2
 LDA obike_lasttyre,X
 EOR #1
 STA obike_lasttyre,X
.obnewpo2
 LDY obike_leanpos,X
 LDA road_direct
 BMI obnewpo3:\ Straight
 BNE obnewpo4:\ Right
 
\ Left
.obnewpo5
 TYA:BEQ obnewpoex
 DEC obike_leandel,X
 BPL obnewpoex
 LDA #4:STA obike_leandel,X
 DEC obike_leanpos,X
.obnewpoex
 RTS
 
.obnewpo3
 CPY #2:BEQ obnewpoex
 BCS obnewpo5
 
.obnewpo4
 CPY #4:BEQ obnewpoex
 INC obike_leandel,X
 LDA obike_leandel,X
 CMP #5:BCC obnewpoex
 LDA #0:STA obike_leandel,X
 INC obike_leanpos,X
 RTS
 
.tswaptab
 EQUB 100:EQUB 70:EQUB 45:EQUB 25
.bitmasktab
 EQUB 0:EQUB 1:EQUB 3:EQUB 7
 
.calcrealx
 STA temp:\ Y coord of bike's 'base'
 JSR calc_bike_b
 LDA obxfudtablo,Y:STA vec
 LDA obxfudtabhi,Y:STA vec+1
 LDA fudmiddl,Y:STA vec2
 LDA #&FF:LDY temp:\ Y=Y coord of bike from top of road
 
 CPY #80:BCS calcrealx0:\ If Y below road area
 CPY #ymin+32:BCS calcrealx1:\ Don't fudge
 
 TYA:SBC #ymin-1:\ c=0 at this point
 LSR A:LSR A:\ A=0 to 7 now
 EOR #7:CMP #7:BCC clrlx
 LDA #6
.clrlx
 STA temp
 TYA:SEC:SBC temp:STY temp
 TAY
 LDA midx
 CMP #centre+6:BCS calcrealx1
 CMP #centre-5:BCC calcrealx2
 LDY temp:JMP calcrealx1
 
.calcrealx2
 LDA old_left,Y:ADC right_offset,Y
 LDY temp:SEC:SBC vec2:SBC right_offset,Y:JMP calcrealx0
.calcrealx1
 LDA old_left,Y
.calcrealx0
 SEC
 ADC obike_xoff,X
 CLC
 LDY obike_leanpos,X
 ADC (vec),Y:\ adjust for bike's lean
 LDY #0
 RTS
 
.fudmiddl
 EQUB 9:EQUB 7:EQUB 5:EQUB 3
 
.obxfudtablo
 EQUB obxfudval0 MOD 256
 EQUB obxfudval1 MOD 256
 EQUB obxfudval2 MOD 256
 EQUB obxfudval3 MOD 256
 
.obxfudtabhi
 EQUB obxfudval0 DIV 256
 EQUB obxfudval1 DIV 256
 EQUB obxfudval2 DIV 256
 EQUB obxfudval3 DIV 256
 
.obxfudval0
 EQUB -8:EQUB -8:EQUB 0:EQUB 0:EQUB 0
.obxfudval1
 EQUB -4:EQUB -4:EQUB 0:EQUB 0:EQUB 0
.obxfudval2
 EQUB -4:EQUB -4:EQUB 0:EQUB 0:EQUB 0
.obxfudval3
 EQUB 0:EQUB 0:EQUB 0:EQUB 0:EQUB 0
 
 
.collme
 LDA #myy
 SEC:SBC obike_y,X
 BCS clme
 EOR #&FF:ADC #1
.clme
 CMP #12:BCC clme0
 RTS
 
.clme0
 LDA myx:AND #&FE
 LDY mypos
 CLC:ADC colxfud,Y
 STA temp1
 LDY obike_leanpos,X
 LDA obike_xoff,X:AND #&FE
 CLC:ADC colxfud,Y
 
 SEC:SBC temp1
 BCS clme1
 EOR #&FF:ADC #1
 CMP tab_pixwide,Y
 RTS
 
.clme1
 LDY mypos:CMP tab_pixwide,Y
 RTS
 
.colxfud
 EQUB -4:EQUB -2:EQUB 0:EQUB 2:EQUB 4
.tab_pixwide
 EQUB 12:EQUB 11:EQUB 11:EQUB 11:EQUB 12
 
.obnewspd
 JSR rand:AND #7
 CLC:ADC overtake_speed
 STA inbotspd
 LDA seed+2:AND #7:STA temp1
 SEC:LDA catch_speed
 SBC temp1
 STA intopspd
 RTS
 
\\ ]
\\ PRINT"Oth.bikes4 from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
