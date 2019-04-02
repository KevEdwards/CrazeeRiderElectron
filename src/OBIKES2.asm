\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.OBIKES2"
\\ B%=P%
\\ [OPT pass
 
\ On entry temp2 and temp3
\ have been initialised to the
\ screen locations where the
\ sprite is to be removed from
\ and displayed at.
 
\ A,X,Y and temp4 on entry contain
\ the locations of the sprite's
\ source and destination graphics.
 
\ temp5 contains the sprite's
\ width minus 1 ie 0 to 4.
 
\ temp5+2 is the start graphics
\ offset,0 unless only part of the
\ sprite can be seen
 
 
.sprite_obikes
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
 
\ This next bit self-modifies the
\ sprite routine according to the
\ width of the sprite.
 
 LDX temp5
 LDA spr_relbra_tab,X
 STA sprite_branch+1
 LDA spr_stlo,X:STA temp5
 LDA spr_sthi,X:STA temp5+1
 
\ Now the routine is jumped to
\ which will finally return to
\ the code that JSR'd to
\ 'sprite_obikes' to start with.
\ X is set to the start offset
\ for the sprite graphics.
 
 LDX temp5+2
 JMP (temp5)
 
\ Table of relative branch values
\ for each sprite width
 
.spr_relbra_tab
 EQUB sp_wid1-sprite_branch-2
 EQUB sp_wid2-sprite_branch-2
 EQUB sp_wid3-sprite_branch-2
 EQUB sp_wid4-sprite_branch-2
 EQUB sp_wid5-sprite_branch-2
 
.spr_stlo
 EQUB sp_wid1 MOD 256
 EQUB sp_wid2 MOD 256
 EQUB sp_wid3 MOD 256
 EQUB sp_wid4 MOD 256
 EQUB sp_wid5 MOD 256
.spr_sthi
 EQUB sp_wid1 DIV 256
 EQUB sp_wid2 DIV 256
 EQUB sp_wid3 DIV 256
 EQUB sp_wid4 DIV 256
 EQUB sp_wid5 DIV 256
 
\ Table containing height of bikes
\ for widths 1 to 5 (minus 1)
\ width 1 not used
 
.heiofobikes
 EQUB 0:\ width 1 not used
 EQUB 12:EQUB 18:EQUB 24:EQUB 30
 
\\ ]
\\ PRINT"Oth.bikes2 from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
