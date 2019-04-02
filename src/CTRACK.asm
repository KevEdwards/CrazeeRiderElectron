\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"CTRACK"
\\ B%=P%
\\ [OPT pass
 
.calc_track
 
 LDA #leftx
 STA new_left+road_height-1
 STA temp1
 
\ Self modify curve effect
 
 LDX #&B0:\ BCS opcode (in/curve)
 LDA restarted:BMI calc_tr3
 LDA curve_stage:BPL calc_tr3
 LDA road_direct:BMI calc_tr3
 LDX #&90:\ BCC opcode (out/curve)
.calc_tr3
 STX inoutcur0+2
 STX inoutcur1+2
 STX inoutcur2+2
 STX inoutcur3+2
 
 LDX #&FE:STX grad
 LDX #road_height-2
 LDA midx
 LDY road_direct:BNE calc_tr2
 SEC:LDA #159:SBC midx
.calc_tr2
 LDY #&80
 SEC:SBC #leftx
 CMP #road_height:BCC calc_grad
 
 STA temp1+1
 LDA #road_height
 
.calc_grad2
 ASL A:BCS lessdx
 CMP temp1+1:BCC too_small2
.lessdx
 SBC temp1+1:SEC
.too_small2
 ROL grad:BCS calc_grad2
 LDA road_direct:BNE very_horiz
 JMP very_horiz2
 
.calc_grad
 ASL A:BCS lessdy
 CMP #road_height:BCC too_small
.lessdy
 SBC #road_height:SEC
.too_small
 ROL grad:BCS calc_grad
 LDA road_direct:BEQ left_curve
 
.right_curve
 CLC
 TYA:ADC grad:TAY
 BCC not_across
 INC temp1
.not_across
 LDA temp1
 STA new_left,X
.inoutcur0
 CPX curve_start:BCS dont_bend
 INC grad:BEQ very_horiz0
.dont_bend
 DEX:BPL right_curve
 RTS
 
.left_curve
 CLC
 TYA:ADC grad:TAY
 BCC not_across2
 INC temp1
.not_across2
 CLC:LDA #rightx
 SBC temp1:SBC right_offset,X
 STA new_left,X
.inoutcur1
 CPX curve_start:BCS dont_bend3
 INC grad:BEQ very_horiz1
.dont_bend3
 DEX:BPL left_curve
 RTS
 
 
.very_horiz0
 LDY #&80
.very_horiz
.inoutcur2
 CPX curve_start:BCS dont_bend2
 DEC grad
.dont_bend2
 INC temp1
 CLC:TYA:ADC grad:TAY
 BCC very_horiz
 LDA temp1
 STA new_left,X
 DEX:BPL very_horiz
 RTS
 
.very_horiz1
 LDY #&80
.very_horiz2
.inoutcur3
 CPX curve_start:BCS dont_bend4
 DEC grad
.dont_bend4
 INC temp1
 CLC:TYA:ADC grad:TAY
 BCC very_horiz2
 LDA #rightx-1
 SBC temp1:SBC right_offset,X
 STA new_left,X
 DEX:BPL very_horiz2
 RTS
 
 
\\ ]
\\ PRINT"Calc Track from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
