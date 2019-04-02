\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.OBIKES3"
\\ B%=P%
\\ [OPT pass
 
.calc_gra_obikes
 JSR calc_bikesize
 LDA obike_lasttyre,X
 BNE calgraobik0
 LDA ogra_baselo,Y
 STA temp1
 LDA ogra_basehi,Y
 JMP calgraobik1
 
.calgraobik0
 LDA ogra1_baselo,Y
 STA temp1
 LDA ogra1_basehi,Y
 
.calgraobik1
 STA temp1+1
 LDA obike_y,X:JSR calcrealx
 AND #2
 BEQ calgraobik2:\ Y=0 here
 LDY #5:\ offset for shifted graphics
.calgraobik2
 TYA
 CLC
 ADC obike_leanpos,X
 TAY
 
 LDA (temp1),Y
 TAX
 TYA:CLC:ADC #10:TAY:\ adjust for hi bytes
 LDA (temp1),Y
 TAY:TXA
 LDX curr_id
 RTS
 
.ogra_baselo
 EQUB tab_bike2t0_lo MOD 256
 EQUB tab_bike3t0_lo MOD 256
 EQUB tab_bike4t0_lo MOD 256
 EQUB tab_bike5t0_lo MOD 256
.ogra_basehi
 EQUB tab_bike2t0_lo DIV 256
 EQUB tab_bike3t0_lo DIV 256
 EQUB tab_bike4t0_lo DIV 256
 EQUB tab_bike5t0_lo DIV 256
 
.ogra1_baselo
 EQUB tab_bike2t1_lo MOD 256
 EQUB tab_bike3t1_lo MOD 256
 EQUB tab_bike4t1_lo MOD 256
 EQUB tab_bike5t1_lo MOD 256
.ogra1_basehi
 EQUB tab_bike2t1_lo DIV 256
 EQUB tab_bike3t1_lo DIV 256
 EQUB tab_bike4t1_lo DIV 256
 EQUB tab_bike5t1_lo DIV 256
 
.calc_bikesize
 LDA obike_y,X
.calc_bike_b
 LDY #3
.calobsize
 CMP sizes_tab,Y:BCC calobsize0
 DEY:BNE calobsize
.calobsize0
 TYA
 RTS
 
.sizes_tab
 EQUB 255:EQUB 66:EQUB 48:EQUB 32:\ was 255 64 50 32
 
.initobike
 INC numobikes
 LDY #&FF
 STY obike_st,X
 INY
 STY obike_counter,X
 STY obike_accel,X
 STY obike_lasttyre,X
 LDY #2
 STY obike_leandel,X
 LDA road_direct
 BMI inobike
 BNE inobike0
 LDY #0:BEQ inobike
.inobike0
 LDY #4
.inobike
 STY obike_leanpos,X
 RTS
 
.put_sprite
 LDY temp4:LDX temp5
 STA putgra0+2
 STA putgra1+2
 STA putgra2+2
 STA putgra3+2
 STA putgra4+2
 STY putgra0+1
 STY putgra1+1
 STY putgra2+1
 STY putgra3+1
 STY putgra4+1
 
 LDA putroutlo,X
 STA temp5
 LDA putrouthi,X
 STA temp5+1
 LDA putbranchtab,X
 STA put_branch+1
 LDX temp5+2
 JMP (temp5)
 
.putbranchtab
 EQUB put_wid1-put_branch-2
 EQUB put_wid2-put_branch-2
 EQUB put_wid3-put_branch-2
 EQUB put_wid4-put_branch-2
 EQUB put_wid5-put_branch-2
 
.putroutlo
 EQUB put_wid1 MOD 256
 EQUB put_wid2 MOD 256
 EQUB put_wid3 MOD 256
 EQUB put_wid4 MOD 256
 EQUB put_wid5 MOD 256
.putrouthi
 EQUB put_wid1 DIV 256
 EQUB put_wid2 DIV 256
 EQUB put_wid3 DIV 256
 EQUB put_wid4 DIV 256
 EQUB put_wid5 DIV 256
 
.put_wid5
 LDY #&20
.putgra0
 LDA &FFFF,X:EOR (temp2),Y
 STA (temp2),Y:INX
.put_wid4
 LDY #&18
.putgra1
 LDA &FFFF,X:EOR (temp2),Y
 STA (temp2),Y:INX
.put_wid3
 LDY #&10
.putgra2
 LDA &FFFF,X:EOR (temp2),Y
 STA (temp2),Y:INX
.put_wid2
 LDY #8
.putgra3
 LDA &FFFF,X:EOR (temp2),Y
 STA (temp2),Y:INX
.put_wid1
 LDY #0
.putgra4
 LDA &FFFF,X:EOR (temp2),Y
 STA (temp2),Y:INX
 
 LDA temp2:AND #7:BEQ put0
 DEC temp2
.put1
 DEC sprheight
.put_branch
 BNE put_wid5:\ Self modified
 RTS
 
.put0
 LDA temp2:SEC:SBC #&39
 STA temp2
 LDA temp2+1:SBC #1:STA temp2+1
 JMP put1
 
.initgrad
 STA obike_speed,X
 JSR rand:AND #&7F
 CLC:ADC #xmin
.initgrad3
 STY obike_y,X
 CMP #xmax+1:BCC intg
 LDA #xmiddle
.intg
 LDY #ymax-ymin
 
.initgrad2
 STA obike_xoff,X
 SEC:SBC #4:\       Fudge required to give real X
 CMP #xmiddle:ROR obike_side,X
 SEC:SBC #xmiddle
 BCS intg0
 EOR #&FF:ADC #1
.intg0
 JSR cbikegrad
 STA obike_gradconst,X
 RTS
 
.startbikes
 LDX #obatstart-1:STX curr_id
.sarbi
 LDX curr_id
 JSR initobike
 LDA stytab,X:STA obike_y,X
 SEC:SBC #ymin:TAY
 LDA stxofftab,X:JSR initgrad2
 LDA #4
 STA obike_speed,X
 STA obike_accel,X
 JSR obikenewinfo
 JSR calsinfo0
 DEC curr_id:BPL sarbi
 RTS
 
.stytab
 EQUB 126:EQUB 126
.stxofftab
 EQUB 50:EQUB 102:\ Different to BBC version
 
.goodx
 JSR rand
 AND #31:STA temp1
 LDY myx
 CPY #95:BCC gdx
 ADC #xmin-1
 RTS
.gdx
 CPY #63:BCC gdx0
 LSR temp1:BCS gdx1
 LDA temp1:ADC #xmin
 RTS
.gdx0
 SEC
.gdx1
 LDA #xmax:SBC temp1
 RTS
 
\\ ]
\\ PRINT"Oth.bikes3 from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
