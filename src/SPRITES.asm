\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.SPRITES"
\\ B%=P%
\\ [OPT pass
 
.sprite
 STA sourcgra0+2
 STA sourcgra1+2
 STA sourcgra2+2
 STA sourcgra3+2
 STA sourcgra4+2
 LDA temp4
 STA sourcgra0+1
 STA sourcgra1+1
 STA sourcgra2+1
 STA sourcgra3+1
 STA sourcgra4+1
 STY destgra0+2
 STY destgra1+2
 STY destgra2+2
 STY destgra3+2
 STY destgra4+2
 STX destgra0+1
 STX destgra1+1
 STX destgra2+1
 STX destgra3+1
 STX destgra4+1
 
 LDA spr_relbra_tab+4
 STA sprite_branch+1
 LDX #0
 
.sp_wid5
.sprite0
 LDY #&20
.sourcgra0
 LDA &FFFF,X
 EOR (temp2),Y
 STA (temp2),Y
.destgra0
 LDA &FFFF,X
 EOR (temp3),Y
 STA (temp3),Y
 INX
.sp_wid4
 LDY #&18
.sourcgra1
 LDA &FFFF,X
 EOR (temp2),Y
 STA (temp2),Y
.destgra1
 LDA &FFFF,X
 EOR (temp3),Y
 STA (temp3),Y
 INX
.sp_wid3
 LDY #&10
.sourcgra2
 LDA &FFFF,X
 EOR (temp2),Y
 STA (temp2),Y
.destgra2
 LDA &FFFF,X
 EOR (temp3),Y
 STA (temp3),Y
 INX
.sp_wid2
 LDY #8
.sourcgra3
 LDA &FFFF,X
 EOR (temp2),Y
 STA (temp2),Y
.destgra3
 LDA &FFFF,X
 EOR (temp3),Y
 STA (temp3),Y
 INX
.sp_wid1
 LDY #0
.sourcgra4
 LDA &FFFF,X
 EOR (temp2),Y
 STA (temp2),Y
.destgra4
 LDA &FFFF,X
 EOR (temp3),Y
 STA (temp3),Y
 INX
 
 LDA temp2:AND #7:BEQ sprite3
 DEC temp2
.sprite1
 LDA temp3:AND #7:BEQ sprite4
 DEC temp3
.sprite2
 DEC sprheight
.sprite_branch
 BNE sprite0
 RTS
 
.sprite3
 LDA temp2:SEC
 SBC #&39:STA temp2
 LDA temp2+1:SBC #1
 STA temp2+1:JMP sprite1
 
.sprite4
 LDA temp3:SEC
 SBC #&39:STA temp3
 LDA temp3+1:SBC #1
 STA temp3+1:JMP sprite2
 
\\ ]
\\ PRINT"Sprites    from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
