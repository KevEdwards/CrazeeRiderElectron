\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"UPDATE"
\\ B%=P%
\\ [OPT pass
 
.update_road
 
 LDX #road_height-1
 STX temp4
.update2
 LDX temp4
 LDA left_lo,X:STA temp2
 LDA left_hi,X:STA temp2+1
 
 LDA old_left,X:TAY
 LSR A:LSR A:STA temp1
 TYA
 CMP new_left,X
 BCC left_bigger
 
\ Left edge is < or = to its
\ previous position
 
 
 BNE left_less
 JMP process_kerb2
.left_less
 
 LDA new_left,X
 LSR A:LSR A:TAX
 LDY #0
 CPX temp1:BNE lft_match0
 JMP process_kerb1
 
.lft_match0
 INX
 TYA:STA (temp2),Y
 LDA temp2:SEC:SBC #8:STA temp2
 BCS left_les1
 DEC temp2+1
.left_les1
 CPX temp1:BNE lft_match0
 JMP process_kerb
 
 
\ Left edge is > than its
\ previous position
 
.left_bigger
 CMP #8:BCC edge_stuff
 LDA temp2:SBC #16:STA temp3
 LDA temp2+1:SBC #0:STA temp3+1
 LDA new_left,X
 LSR A:LSR A:TAX
 LDY #0
 CPX temp1:BEQ process_kerb1
 
.lft_big0
 DEX
 LDA #&F0:STA (temp3),Y
 TYA:CLC:ADC #8:TAY
 BCC other_one
 INC temp3+1
.other_one
 LDA temp2:CLC:ADC #8:STA temp2
 BCC lft_big1
 INC temp2+1
.lft_big1
 CPX temp1:BNE lft_big0
 JMP process_kerb
 
.edge_stuff
 LDA new_left,X
 LSR A:LSR A:TAX
 CPX temp1:BEQ process_kerb1
 
.edge_st0
 DEX
 LDA temp2:CLC:ADC #8:STA temp2
 BCC edge_st1
 INC temp2+1
.edge_st1
 CPX temp1:BNE edge_st0
 JMP process_kerb
 
\ This bit adds the kerbing!
 
.process_kerb1
 LDX temp4
.process_kerb2
 LDA temp2:SEC:SBC #16:STA temp2
 BCS process1
 DEC temp2+1
 JMP process1
 
.process_kerb
 LDX temp4
 LDA temp2:STA left_lo,X
 SEC:SBC #16:STA temp2
 LDA temp2+1:STA left_hi,X
 SBC #0:STA temp2+1
 
.process1
 LDA new_left,X
 TAY
 AND #3:STA temp1+1
 LDA kerb_width,X
 ASL A:ASL A:ORA temp1+1
 
\ Adjust offset according to
\ the colour required
 
.kcolour1
 ADC kerb_col,X
 TAX
 
 CPY #8:BCS process2
 CPY #4:BCS process3
 JMP process4
.process2
 LDA left_kerb_gra,X
 LDY #0:STA (temp2),Y
.process3
 LDA left_kerb_gra+40,X
 LDY #8:STA (temp2),Y
.process4
 LDA left_kerb_gra+80,X
 LDY #16:STA (temp2),Y
 
\ Now update the right hand
\ side of the track
 
 LDX temp4
 LDA right_lo,X:STA temp2
 LDA right_hi,X:STA temp2+1
 
 SEC
 LDA new_left,X:ADC right_offset,X
 STA temp3
 LSR A:LSR A:STA temp3+1
 
 LDA old_left,X:TAY
 SEC:ADC right_offset,X
 LSR A:LSR A:STA temp1
 TYA
 CMP new_left,X
 BCC right_less
 
 BNE right_bigger
 JMP rprocess_kerb2
 
.right_bigger
 SEC:ADC right_offset,X
 CMP #152:BCS redge_stuff
 
 LDX temp3+1
 CPX temp1:BEQ rprocess_kerb1
 
 LDY #16
.rgt_big0
 INX
 LDA #&F0:STA (temp2),Y
 SEC:LDA temp2:SBC #8:STA temp2
 BCS rgt_big1
 DEC temp2+1
.rgt_big1
 CPX temp1:BNE rgt_big0
 JMP rprocess_kerb
 
.redge_stuff
 LDX temp3+1
 CPX temp1:BEQ rprocess_kerb1
 
.redge_st0
 INX
 SEC:LDA temp2:SBC #8:STA temp2
 BCS redge_st1
 DEC temp2+1
.redge_st1
 CPX temp1:BNE redge_st0
 JMP rprocess_kerb
 
.right_less
 LDX temp3+1
 CPX temp1:BEQ rprocess_kerb1
 
 LDY #0
.rgt_les0
 DEX
 TYA:STA (temp2),Y
 CLC:LDA temp2:ADC #8:STA temp2
 BCC rgt_les1
 INC temp2+1
.rgt_les1
 CPX temp1:BNE rgt_les0
 
.rprocess_kerb
 LDX temp4
 LDA temp2:STA right_lo,X
 LDA temp2+1:STA right_hi,X
.rprocess_kerb1
 LDX temp4
 LDA new_left,X
 STA old_left,X
.rprocess_kerb2
 LDA temp3:TAY
 AND #3:STA temp1+1
 LDA kerb_width,X
 ASL A:ASL A:ORA temp1+1
 
\ Adjust for other colour
 
.kcolour2
 ADC kerb_col,X
 TAX
 
 CPY #152:BCC rprocess1
 CPY #156:BCC rprocess2
 JMP rprocess3
 
.rprocess1
 LDA left_kerb_gra+320,X
 LDY #16:STA (temp2),Y
.rprocess2
 LDA left_kerb_gra+280,X
 LDY #8:STA (temp2),Y
.rprocess3
 LDA left_kerb_gra+240,X
 LDY #0:STA (temp2),Y
 
 DEC temp4:BEQ update_fin
 JMP update2
 
.update_fin
 LDA left_lo+1:STA temp2
 LDA left_hi+1:STA temp2+1
 LDA old_left+1:AND #3:TAX
 LDA ledgegra,X
 ORA (temp2),Y
 STA (temp2),Y
.updexit
 RTS
 
.ledgegra
 EQUB &80:EQUB &C0:EQUB &E0:EQUB &F0

\\ ]
\\ PRINT"Update     from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
