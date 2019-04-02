\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.BIKES"
\\ B%=P%
\\ [OPT pass
 
.mybike
 ASL relxpush:\ make relx change multiple of +/- 2
 
 LDA counter:LDX myspeed
 CPX #55:BCC adjspeed1:\ Never force bike outward when speed<55 mph
.adjspeed0
 CPX #74:BCS adjspeed
 LSR A:BCC adjspeed
 
.adjspeed1
 LDA #0:STA relxpush
 
.adjspeed
 LDA finsnd:BEQ nttend:\ No skid/passing noises when just passed line!
 DEC finsnd:JMP obnoise2
 
.nttend
 LDA road_direct:BMI noskd:\ Can't skid if on a straight!
 LDA medisabled:BNE noskd:\ Can't skid when disabled
 JSR canipush_a:\ Is my speed>= max allowed for current curve type?
 BCS askd1:\ Yes, so bike is ALWAYS skidding
 
 LDA relxpush:BEQ noskd:\ If also NO relxpush then obike noise OK
 CLC:ADC myrelx:BEQ noskd:\ No skid noise if push and relx cancel out!
.askd1
 LDA seed+1:BPL obnoise2:\ don't make other bike noise (skid!!)
 LDX #sndskd MOD 256:LDY #sndskd DIV 256:JSR sound
 LDA #6:STA argdel:\ Disable my bike FX for skid noise!
 JMP obnoise2:\ don't make other bike noise (channel 3 making skid sound!)
 
 
\ Find bike with greatest Y coord
\ and make its noise!
 
.noskd
 JMP obnoise2:\              THE OTHER BIKES NO LONGER MAKE A NOISE!!!
 LDX #maxbikes-1
.fndid
 LDA obike_st,X:BMI obnoise
 DEX:BPL fndid
 BMI obnoise2:\ always, no bike found
 
.obnoise
 LDA obike_y,X
.obnoise0
 DEX:BMI obnoise1
 LDY obike_st,X:BPL obnoise0
 CMP obike_y,X:BCS obnoise0
 LDA obike_y,X:BCC obnoise0:\ always
 
.obnoise1
 LDX startoff:BNE obnoise2:\ No noise just after start of race!
 LSR A:LSR A:LSR A:CLC:ADC #22:STA bpass+4:\ Pitch part of control block
 LDX #bpass MOD 256:LDY #bpass DIV 256:JSR sound
 
.obnoise2
 LDX myrelx:BNE mybike5
 LDA mypos:CMP #2:BEQ mybike5
 BCS mybike6
 
\ Make my bike go back to central
\ position when he's leaning
\ to the left.
 
 CLC:LDA myleandel:ADC #1
 STA myleandel
 CMP #3:BCC mybike5
 LDA #0:STA myleandel
 INC mypos:BPL mybike5:\ Always
 
\ Make my bike go back to central
\ position when he's leaning
\ to the right.
 
.mybike6
 SEC:LDA myleandel:SBC #1
 STA myleandel
 BCS mybike5
 LDA #2:STA myleandel
 DEC mypos
 
.mybike5
 TXA:CLC:ADC relxpush
 LDX #0:STX relxpush
 
.mybike0
 CLC:ADC myx
 CMP #8:BCC mybike3
 CMP #141:BCC mybike4
.mybike3
 LDA #3:STA medisabled2:\ disable my bike, not the sound FXs though!
 SEC
 LDA myspeed:SBC #4:BCS mybike2:\ was sbc #2
 LDA #0
.mybike2
 JSR contr9:\ Warning !
 LDA myx
 
.mybike4
 STA mynewx:\ 'New' X value
 LDX myx:STA myx:TXA:PHA:\ save my last X
 LDX #maxbikes-1:STX curr_id
 
.sidecol
 LDX curr_id:SEC:\ C=1 so BPL sideco2 and last item doesn't cause problem
 LDA obike_st,X:BPL sideco2
 JSR collme:BCC sideyes
.sideco2
 DEC curr_id:BPL sidecol
.sideyes
 PLA:STA myx:\ Restore previous X
 BCS sideco1:\ branch if no collision
 
 STA mynewx:\ new X=old X, if collision
 
\ See if my bike is going to push the other bike away
\ or just a simple side collision.
 
 LDA obike_y,X:CMP #myy:BCC aside
 JSR nobl:JMP sideco1
 
.aside
 LDA #8:STA medisabled
 LDA myspeed:SEC:SBC #7:BCS sidey0
 LDA #0
.sidey0
 JSR contr9:\ Warning !
 JSR flush:\ FX 15,0
 LDA #10:STA argdel:\ Delay to let bounce sound finish
 LDX #boucr MOD 256:LDY #boucr DIV 256:JSR sound
 
.sideco1
 LDA myrelx:TAX
 CLC:ADC myleandel
 CMP #5:BCC mvemybik1
 TXA:BMI mvemybik2
 LDA mypos:CMP #4:BCS mvemybik
 INC mypos:LDA #0:BEQ mvemybik1
.mvemybik2
 LDA mypos:BEQ mvemybik
 DEC mypos:LDA #4
 
.mvemybik1
 STA myleandel
 
.mvemybik
 LDX mylastgraoff
 LDA myx:CLC:ADC tab_xfudge,X
 TAX:LDY #myy+ytop
 JSR xycalc
 STX temp2:STA temp2+1
 LDX mypos
 LDA mynewx:CLC:ADC tab_xfudge,X
 TAX:LDY #myy+ytop
 JSR xycalc
 STX temp3
.mvemybi0
 STA temp3+1
 LDA #30:STA sprheight
 
\ Init Dest. info for the
\ sprite routine
 
 LDX #0
 LDA mynewx:AND #2:BEQ mvemybi6
 LDX #5
.mvemybi6
 TXA:CLC:ADC mypos:TAX
 LDA mytyrepos:BNE mvemybi3
 
 LDA tab_biket0_lo,X
 LDY tab_biket0_hi,X
 JMP mvemybi5
.mvemybi3
 LDA tab_biket1_lo,X
 LDY tab_biket1_hi,X
 
\ Now init source info for the
\ sprite routine
 
.mvemybi5
 STA temp5+1
 TXA:PHA
 LDX mylastgraoff
 LDA mylasttyrepos:BEQ mvemybi4
 
 LDA tab_biket1_lo,X
 STA temp4
 LDA tab_biket1_hi,X
 JMP nowsprite
 
.mvemybi4
 LDA tab_biket0_lo,X
 STA temp4
 LDA tab_biket0_hi,X
 
.nowsprite
 LDX temp5+1
 JSR sprite
 PLA:STA mylastgraoff
 LDA mynewx:STA myx
 LDA mytyrepos:STA mylasttyrepos
 RTS
 
.shwmybik
 LDX myx:STX mynewx:LDY #myy+ytop
 JSR xycalc
 STX temp2:STA temp2+1
 LDA #&BE:BNE mvemybi0
 
 
\\ ]
\\ PRINT"Bikes      from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
