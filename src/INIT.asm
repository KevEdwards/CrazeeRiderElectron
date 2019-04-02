\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"INIT"
\\ B%=P%
\\ [OPT pass
.exec
 
 
 LDA #event MOD 256:STA &220
 LDA #event DIV 256:STA &221
 LDA #14:LDX #4:JSR osbyte
 LDX #1:JSR keyinfo:\ Display K
 LDX #2:JSR keyinfo:\ Display S
 LDX #3:JSR keyinfo:\ Display D (Digital First Byte Joystick)
 JSR clstop
 JSR show_score:\ Show 000000
 JSR dispchq:\ Display chqrd flag
 JMP dispheader
 
\ -----------------------------
\ -----------------------------
 
.newgame
 LDA jmpstart:STA current_track
 JSR trktens_units:\ calc new 10s 1s for start track number as text chars.
 JSR hard_reset
 JSR show_score:\ show 000000 always!
 
.nxt_circuit
 
 JSR show_speed
 
\ simple var. setup, probably go into 'reset' when checked!
 
 LDA #0:STA position:STA bahead:JSR show_pos
 LDA #obikesracing-obatstart:STA bbehind
 
 JSR reset
 
.repeat
 
\ Set up data according to track number
 
 LDA #0:STA tdataoff
 JSR getrkoff
 LDA secdtab,X:STA secdel:\ Delay value for road sections
 LDA trackdata_lo,X:STA tdata
 LDA trackdata_hi,X:STA tdata+1
 JSR dmap
 LDA #0:STA tdataoff:\ Reset pointer back to start of data
 JSR strxy
 LDA #&51:LDX #4:JSR pltmin:\ EOR my position at start line
 
 LDX current_track
 CPX #5:BCC usetab
 LDX #5
.usetab
 LDA catchsp_tab,X:STA catch_speed
 LDY overtsp_tab,X:STY overtake_speed
 
 
\ Now put the track on the screen for the start
 
 JSR calc_track
 LDX #road_height-1
.test_setup
 LDA new_left,X:STA old_left,X
 DEX:BPL test_setup
 JSR proc_mount
 JSR display_road
 JSR update_road
 LDA #&FF:STA restarted
 JSR obnewspd:\ New speed values when bikes are init.
 
\ Put all the bikes on the screen ready for the start
 
 JSR startbikes:\ Put other bikes on at start
 JSR shwmybik
 
 JSR shwnam:\ Show trk number and name for about a second then erase it
 
 LDA #50:STA curvol
 LDA #&FF:STA stcnt:JSR start_up
 
 
\ This is the main loop --------------------------
 
.again
 CLI
 INC counter
 JSR keys
 JSR controls
 JSR move_road
 BIT track_fin:BPL aga0
 LDA myspeed:BEQ endlop
.aga0
 JSR calc_track
 JSR update_road
 JSR process_signs
 JSR mybike:\  Leave if ok
 JSR sndrevs
 JSR otherbikes:LDA alterspd:CMP myspeed:BEQ ncoln:\ No speed change due to collision
 JSR contr9:\ Display new speed
.ncoln
\ LDX #&FE JSR check_key BEQ endlop Skip track (CTRL key)
 LDX #&8F:JSR check_key:BEQ pesc
 JMP again
 
.pesc
 LDA #&E0:JSR clsrow_a:\ Clear flags as well !!
 JMP pescap
 
\ End of the main loop --------------------------
 
.endlop
 LDY #50:JSR frame_delay:\ delay
 LDA #obikesracing:SEC:SBC position
 TAX:LDA #0:CLC
.posbon
 ADC #3:\ Add 3*10 (30) for each bike behind you
 DEX:BPL posbon
 JSR add_score:\ Add position bonus to score
 JSR sndbon
 LDY #35:JSR frame_delay:\ short delay
 
 JSR clsrows:\ Clear map and road/mountain area only (not flags!)
 LDA #'0'-32:LDX #4
.bonus
 STA bonusdig,X
 DEX:BPL bonus
 
 LDY #12:JSR pstring:\ TRACK COMPLETED
 LDY #20:JSR frame_delay:\ short delay
.bonus1
 LDA hits:BEQ bonus0:\ 0 bonus
 DEC hits:JSR shw_hits
 LDA #20:JSR add_score:\ Add 200 to score
 LDY #6:JSR frame_delay
 JSR sndbon
 LDX #2:\ Hundreds column offset
 TXA:\ Intial value to be added to hundreds column (2*100=200)
.bonus2
 CLC:ADC bonusdig,X:STA bonusdig,X
 CMP #'9'-32+1
 BCC bonus1
 SBC #10:STA bonusdig,X
 LDA #1:\ Carry one to next column ie tens,hundreds,thousands
 DEX:BPL bonus2
 
.bonus0
 LDY #8:JSR pstring
 LDY #10:JSR pstring
 LDY #35:JSR frame_delay
 LDA position:CMP #6:BCS notqual
 
 LDA jmpstart:BNE ntpasw:\ No passwords if you don't start from trk 1 (0)
 LDY #26:LDA current_track
 CMP #6:BEQ dopasw:\ Chk if end of track 7
 LDY #28
 CMP #13:BEQ dopasw:\ Chk if end of track 14
 LDY #48
 CMP #20:BNE ntpasw:\ Chk if end of track 21
 
.dopasw
 JSR pstring:\ Display password
 LDY #6:JSR pstring:\ Display PRESS SPACE TO PLAY
.dopas0
 LDY #25:JSR frame_delay:\ .5 second delay
 LDY #14:JSR tune:\ Play tune
 JSR spcts0:BNE dopas0:\ Keep playing until space pressed
 BEQ ntpas0:\ Always
 
.ntpasw
 LDY #30:JSR pstring:\ Print WELL DONE!, not if 7th/14th track!
 LDY #0:JSR tune
 
.ntpas0
 LDY #25:JSR frame_delay
 JSR clstop
 INC current_track
 JSR trktens_units:\ calc new 10s 1s for trk number
 JMP nxt_circuit
 
 
.notqual
 LDY #14:JSR pstring:\ YOU HAVE NOT QUALIFIED
 LDA #120:JSR delspc:\ Wait 120 frames OR until space pressed
 JSR clstop
 
.pescap
 LDA current_track:CMP highlevel:BCC ntgrtr
 STA highlevel
 
.ntgrtr
 JSR dispchq:\ Display chqrd flag
 
 JSR flush:\ FX 15,0 when escape is pressed or when you don't qualify
 JSR hig:\ See if new hi, process if it is.
 
.dispheader
 LDA #0:STA jmpstart:STA grahold
.disphe0
 LDY #0:JSR pstring:\ CRAZEE RIDER etc.
 LDY #2:JSR pstring
 LDY #4:JSR pstring
 LDY #6:JSR pstring
 LDA #50:STA temp2
.waitspc
 DEC temp2:BEQ waitspc0
 LDX #&AD:\ C key
 JSR check_key:BEQ cpressed
 JSR spctstloop
 BNE waitspc
 
.waitspc2
 LDX #&3F:LDA #0
.delchflg
 STA &58F8,X:STA &58F8+&140,X:STA &58F8+&280,X:STA &58F8+&3C0,X
 DEX:BPL delchflg
 JSR clstop
 JMP newgame
 
.cpressed
 JSR cycle:JMP disphe0
 
.waitspc0
 JSR clstop
 LDY #18:JSR pstring:\ TODAYS BEST SCORE
 JSR phi
 LDA #50:STA temp2
.waitspc1
 LDX #&AD:\ C key
 JSR check_key:BEQ cpressed
 JSR spctstloop
 BEQ waitspc2
 DEC temp2:BNE waitspc1
 JSR clstop
 JMP disphe0
 
.spctstloop
 LDY #10:JSR frame_delay
 LDA temp2:PHA
 JSR keys_b
 JSR chkjmp
 PLA:STA temp2
 LDA grahold:BNE spcloo
 JSR rand:AND #7:BNE spcts0
 LDA seed+1:AND #3:ADC #7:STA grahold:\ temp use of grahold
.spcloo
 DEC grahold:\ decrement number of revs counter
 JSR brm:\ Make random interval brrrummms during header pages!
 
\ spcts0  is called in MUSIC1 and other places (don't alter!!!)
 
.spcts0
 LDX #&9D:JMP check_key
 
.trktens_units
 LDX current_track:INX:TXA
 LDX #'0'-32:\ 0 in my char set
.tenu3
 CMP #100:BCC tenu4
 SBC #100:INX:BCS tenu3
.tenu4
 LDY #'0'-32:\ 0 in my char set
.tens_unit1
 CMP #10:BCC tens_unit0
 SBC #10:INY:BCS tens_unit1
.tens_unit0
 ADC #'0'-32:\ my ascii for 0
.tens_unit2
 STX txttrknum
 STY txttrknum+1
 STA txttrknum+2
 RTS
 
.delspc
 STA temp1
.delsp0
 JSR fx19
 JSR spcts0:BEQ delsp1:\ Exit when space pressed
 DEC temp1:BNE delsp0
.delsp1
 RTS
 
.catchsp_tab
 EQUB 132:EQUB 133:EQUB 134:EQUB 136:EQUB 138
 EQUB 140:\ Very hard level
.overtsp_tab
 EQUB 112:EQUB 113:EQUB 114:EQUB 116:EQUB 118
 EQUB 120:\ Very hard level
 
\ Section delay values for each track
 
.secdtab
 EQUB 4:EQUB 3:EQUB 4:EQUB 3
 EQUB 3:EQUB 4:EQUB 4
 
.chkjmp
 LDA highlevel:CMP #6:BCC chkjm0
 LDA #5
.chkjm0
 STA temp1
.chkjm1
 LDY temp1:LDX jmpkeys,Y
 JSR check_key:BNE chkjm2
 LDA temp1:STA jmpstart
 JSR sndbon:\ Use bonus 'bip' to acknowledge jmp key press
.chkjm2
 DEC temp1:BPL chkjm1
 RTS
 
.highlevel EQUB 0
.jmpstart EQUB 0
 
.jmpkeys
 EQUB &CF:EQUB &CE:EQUB &EE:\ 1 2 3 keys
 EQUB &ED:EQUB &EC:EQUB &CB:\ 4 5 6 keys
 
.dispchq
 LDX #&3F
.dispch0
 LDA chqflag,X:STA &58F8,X
 LDA chqflag+&40,X:STA &58F8+&140,X
 LDA chqflag+&80,X:STA &58F8+&280,X
 LDA chqflag+&C0,X:STA &58F8+&3C0,X
 DEX:BPL dispch0
 RTS
 
\\ ]
\\ PRINT"Init       from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
