\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.OBIKES"
\\ B%=P%
\\ [OPT pass
 
.otherbikes
 LDA myspeed:STA alterspd
 LDA numobikes:BNE obike0
 JMP addmorebikes
 
.obike0
 LDA #maxbikes-1:STA curr_id
.obike1
 LDX curr_id
 LDA obike_st,X:BMI obike2
 JMP nxtobike
 
\ ---- Process active bikes ----
 
.obike2
 
\ Alter leanpos and tyre position
 
 JSR obnewpos
 
 
 LDA obike_y,X:PHA:\ save current y coord (for overtaking checks)
 
 LDA obike_xoff,X:STA holdxoff
 LDA obike_counter,X:STA holdcounter
 
 LDA obike_speed,X
 CLC:ADC obike_accel,X
 BCS nospwrap
 STA obike_speed,X
 
.nospwrap
 LDA obike_speed,X:BNE normproc
 SEC:PHP:LDA #6:BNE calover0:\ if bikespd=0 then move him back (rear collision)
.normproc
 LDA myspeed
 SEC:SBC obike_speed,X:PHP
 BCS calover
 EOR #&FF:ADC #1:\ make +ve
.calover
 CMP #1:BEQ calover0:\ if relative speed=1 mph
 LSR A:CMP #maxstep+1:BCC calover0
 LDA #maxstep
.calover0
 TAY:\ set Z
 BNE calover1
 PLP
.nomoveob
 JMP obike4:\ bike hasn't moved!
 
.calover1
 LDA obike_y,X
 CMP #50:BCS normspd
 CPY #3:LDY #2
 BCS normspd
 DEY
.normspd
 PLP
 TYA:STA temp1:\ Y change of bike
 BCS mefaster
 JMP meslower
 
.mefaster
 LDY obike_y,X:STY temp1+1
 CLC:ADC temp1+1
 STA obike_y,X
 CPY #80:BCS mefa0
 CMP #80:BCS mefa1
 LDA temp1:BNE mefa2:\ always
 
.mefa1
 LDA #80:SBC temp1+1
.mefa2
 CLC:ADC obike_xoff,X
 STA obike_xoff,X
.mefa0
 CLC:LDY temp1
 LDA obike_side,X:BMI mefa3
 
 LDA obike_counter,X
.mefa4
 ADC obike_gradconst,X
 BCC mefa5
 DEC obike_xoff,X:CLC
.mefa5
 DEY:BNE mefa4
 BEQ mefa8:\ always
 
.mefa3
 LDA obike_counter,X
.mefa6
 ADC obike_gradconst,X
 BCC mefa7
 INC obike_xoff,X:CLC
.mefa7
 DEY:BNE mefa6
 
.mefa8
 STA obike_counter,X
 LDA obike_y,X
 CMP #ymax:BCC mefa9
 INC bbehind:JMP obike3:\ off bottom of screen
 
.mefa9
 PLA:PHA:\ Read old Y value
 CMP #myy:BCS mefa10
 JSR collme:BCS mefa10:\ No collision
 LDA holdxoff:STA obike_xoff,X
 LDA holdcounter:STA obike_counter,X
 PLA:PHA:\ Read old Y value
 STA obike_y,X
 LDA myspeed:SEC:SBC #110:BCS mefa11
 LDA #0
.mefa11
 STA alterspd
 LDA #26:STA medisabled:\ 40 on BBC version
 JSR flush:\ Shouldn't be needed but it's here anyway!
 JSR sndcrun:LDX curr_id
 
.mefa10
 JMP obike4
 
.meslower
 LDY stcnt:BEQ nobigstep
 ASL temp1
.nobigstep
 LDY obike_y,X:TYA
 SEC:SBC temp1
 STA obike_y,X
 CMP #80:BCS mesl0
 CPY #80:BCC mesl1
 LDA #80:SBC obike_y,X:BCS mesl2
 
.mesl1
 LDA temp1
.mesl2
 STA temp2
 LDA obike_xoff,X
 SEC:SBC temp2
 STA obike_xoff,X
 
.mesl0
 SEC:LDY temp1
 LDA obike_side,X:BMI mesl3
 
 LDA obike_counter,X
.mesl4
 SBC obike_gradconst,X
 BCS mesl5
 INC obike_xoff,X:SEC
.mesl5
 DEY:BNE mesl4
 BEQ mesl8:\ always
 
.mesl3
 LDA obike_counter,X
.mesl6
 SBC obike_gradconst,X
 BCS mesl7
 DEC obike_xoff,X:SEC
.mesl7
 DEY:BNE mesl6
 
.mesl8
 STA obike_counter,X
 LDA obike_y,X
 CMP #ymin:BCS mesl9
 INC bahead:JMP obike3:\ Off top of screen
 
.mesl9
 PLA:PHA:\ Restore old Y
 CMP #myy:BCC obike4
 JSR collme:BCS obike4:\ Take if no collision
 LDA holdxoff:STA obike_xoff,X
 LDA holdcounter:STA obike_counter,X
 PLA:PHA:STA obike_y,X
 JSR nobl:LDX curr_id
 
 
\ Update bike's sprite and position
 
.obike4
 JSR calc_spinfo
 
\ Now see if i've been overtaken or if i've overtaken another bike
 
 LDA #0:STA temp1
 PLA:\ recover bikes last y coord
 BIT track_fin:BMI obike6:\ Don't alter position if track over!
 CMP #112:ROL temp1
 LDX curr_id
 LDA obike_y,X
 CMP #112:ROL temp1
 BEQ obike6:\ both y<112
 LDA temp1:CMP #3
 BEQ obike6:\ both y>=112
 LSR temp1:BCS obike7
 
 INC position
 BCC obike8:\ always
 
.obike7
 DEC position
.obike8
 JSR show_pos:\ display new position number
.obike6
 JMP nxtobike
 
\ Remove bike from screen
 
.obike3
 JSR remove_obike
 PLA:\ remove old y (not required)
 
.nxtobike
 DEC curr_id
 BMI addmorebikes
 JMP obike1
 
\ ---- Add more bikes ----
 
.addmorebikes
 LDA numobikes:CMP #maxbikes
 BNE addob
.addobex
 RTS
 
.addob
 LDX #maxbikes-1
.addfree
 LDA obike_st,X:BPL addfree0
 DEX:BPL addfree
 RTS
 
.addfree0
 STX curr_id
 LDA stcnt:BEQ addfree1
 DEC stcnt
 JSR rand:BMI addfree2
.addobex2
 RTS
.addfree1
 LDA medisabled:BNE addfree2:\ My speed will be very low if branch taken
 JSR rand
 AND #31:BNE addobex2
.addfree2
 LDA myspeed
 CMP overtake_speed:BCC addatbot
 CMP catch_speed:BCS addattop
 RTS
 
.addatbot
 LDA bbehind:BEQ addobex2
 LDY #maxbikes-1
.adbt
 LDA obike_st,Y:BPL adbt0
 LDA obike_y,Y:CMP #ymax-18:BCS addobex2
.adbt0
 DEY:BPL adbt
 DEC bbehind
 JSR initobike
 LDA inbotspd:\ Speed value for bikes put on at bottom
 STA obike_speed,X
 JSR goodx
 LDY #ymax-1
 JSR initgrad3
 JMP addob0
 
.addattop
 LDA stcnt:BNE addobex2:\ None allowed for many seconds after start of race!
 LDA medisabled:BNE addobex2:\ None allowed if i'm disabled
 LDA bahead:BEQ addobex2
 CMP #16:BCS addalw
 LDA seed+1:BMI addobex2:\ If bahead <16 make harder to catch them!
.addalw
 LDY #maxbikes-1
.adtp
 LDA obike_st,Y:BPL adtp0
 LDA obike_y,Y:CMP #ymin+10:BCC addobex2
.adtp0
 DEY:BPL adtp
 DEC bahead
 JSR initobike
 LDY #ymin
 LDA intopspd:\ Speed of bike put on at top of screen
 JSR initgrad
 LDA #ymin-4:STA obike_xoff,X
 
.addob0
 JSR obikenewinfo
 JMP calsinfo0
 
.remove_obike
 LDA #0:STA obike_st,X
 DEC numobikes:BNE remov0
 JSR obnewspd
.remov0
 JSR dload_info
 LDA sprheight:BEQ removex
 LDA grahold
 JMP put_sprite
.removex
 RTS
 
.cbikegrad
 STY temp1
 LDY #&FE:STY grad
.cbgr
 ASL A:BCS cbgr0
 CMP temp1:BCC cbgr1
.cbgr0
 SBC temp1:SEC
.cbgr1
 ROL grad:BCS cbgr
 LDA grad
.noblext
 RTS
 
.nobl
 LDA obike_speed,X:BEQ noblext:\ No bonus if already nobbled!
 LDA #0:STA obike_speed,X:STA obike_accel,X
 JSR flush:\ FX 15,0
 LDA #15:STA argdel:\ Disable my bike sound fx for a period
 LDX #argh MOD 256:LDY #argh DIV 256:JSR sound
 INC hits:JMP shw_hits
 
\\ ]
\\ PRINT"Other bike from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
