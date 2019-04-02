\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"ROAD1"
\\ B%=P%
\\ [OPT pass
 
.new_road
 \ JSR setup_scr   deleted now!
 
.display_road
 LDX #road_height-1:STX temp4
 LDX #0:LDY #ybase:JSR xycalc
 STA temp3+1:STX temp3
 
\ Start of main loop!
 
.draw_trk_row
 LDA temp3:STA temp2
 LDA temp3+1:STA temp2+1
 LDX temp4
 LDY new_left,X:INY
 TYA:AND #3:TAX
 LDA endbyte,X:STA temp1
 TYA:LDY #0
 LSR A:LSR A:TAX:BEQ no_block
.poke_road
 LDA #&F0:STA (temp2),Y
 TYA:CLC:ADC #8:TAY
 BCC poke_road0
 INC temp2+1
.poke_road0
 DEX:BNE poke_road
.no_block
 LDA temp1:BNE no_block2
 TYA:SEC:SBC #8:TAY:BCS no_block3
 DEC temp2+1:BCC no_block3
.no_block2
 STA (temp2),Y
.no_block3
 LDX temp4
 CLC:TYA:ADC temp2:STA left_lo,X
 LDA temp2+1:ADC #0:STA left_hi,X
 LDA temp3:AND #7:BNE poke_road2
 LDA temp3:SEC:SBC #&39:STA temp3
 LDA temp3+1:SBC #1:STA temp3+1
 JMP poke_road3
.poke_road2
 DEC temp3
.poke_road3
 DEC temp4:BPL draw_trk_row
 
\ Now Initialise the right edge
 
 LDX #road_height-1:STX temp4
 LDX #159:LDY #ybase:JSR xycalc
 STA temp3+1:STX temp3
.init_right
 LDA temp3:STA temp2
 LDA temp3+1:STA temp2+1
 LDX temp4
 LDA #159:SEC:SBC right_offset,X:SBC new_left,X
 TAY:AND #3:TAX
 LDA rightendbyte,X:STA temp1
 TYA:LDY #0
 LSR A:LSR A:TAX:BEQ no_right_blocks
.poke_right_blocks
 LDA #&F0:STA (temp2),Y
 LDA temp2:SEC:SBC #8:STA temp2
 BCS poke_right0
 DEC temp2+1
.poke_right0
 DEX:BNE poke_right_blocks
.no_right_blocks
 LDA temp1:BNE no_right_bl2
 LDA temp2:CLC:ADC #8:STA temp2
 BCC no_right_bl3
 INC temp2+1
 BCS no_right_bl3
.no_right_bl2
 STA (temp2),Y
.no_right_bl3
 LDX temp4
 LDA temp2:STA right_lo,X
 LDA temp2+1:STA right_hi,X
 LDA temp3:AND #7:BNE poke_right2
 LDA temp3:SEC:SBC #&39:STA temp3
 LDA temp3+1:SBC #1:STA temp3+1
 JMP poke_right3
.poke_right2
 DEC temp3
.poke_right3
 DEC temp4:BPL init_right
 LDA #&F0:STA (temp2),Y
 RTS
 
.endbyte
 EQUB 0:EQUB &80:EQUB &C0:EQUB &E0
 
.rightendbyte
 EQUB 0:EQUB &10:EQUB &30:EQUB &70
 
\\ ]
\\ PRINT"Road 1     from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
