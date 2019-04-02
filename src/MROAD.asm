\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"MROAD"
\\ B%=P%
\\ [OPT pass
 
.move_road
 LDA myspeed:BNE mover0
 
.movexit
 RTS:\ Car isn't moving
 
.mover0
 TAY
 CPY #120:BCS sp120fudge
 DEC kcount:BPL movexit
 
 LSR A:LSR A:LSR A:LSR A:STA temp1
 LDA #INT(120/16)
 SEC:SBC temp1
 STA kcount
 CPY #100:BCC notmegafast
.sp120fudge
 LDA kerb_position
 AND #1:EOR #1:STA kerb_position
 ADC #2:TAX:BNE mover1
 
.notmegafast
 CPY #16:BCS notmegaf2
 LDA #25:STA kcount
 CPY #10:BCS notmegaf2
 LDA #30:STA kcount
.notmegaf2
 DEC kerb_position
 LDX kerb_position
 BPL mover1
 LDX #2:STX kerb_position
.mover1
 LDA tab_kposlo,X
 STA kcolour1+1
 STA kcolour2+1
 LDA tab_kposhi,X
 STA kcolour1+2
 STA kcolour2+2
 
\ Process the track data
 
 INC counter2
 
 DEC scr_count:BPL nopoints
 LDA #1:JSR add_score
 LDA #4:STA scr_count:\ was 3 (elk)
 
.nopoints
 LDA mytyrepos:EOR #1
 STA mytyrepos
 
 BIT track_fin:BMI moexi:\ Exit if bike slowing down at end of race!
 
 LDA restarted:BEQ mover3
 
 JSR decode:BIT track_fin:BPL movcalgd
 
\ Make 'crossed line' noise when end of track reached
 
 LDA #20:STA argdel:\ Let finish line ringing take over channel 1
 LDX #sndcline MOD 256:LDY #sndcline DIV 256:JSR sound
 
.moexi
 RTS
 
.sndcline
 EQUW &11:EQUW 9:EQUW 176:EQUW 12
 
.movcalgd
 JSR minit
 
.mover3
 LDX curve_stage
 BMI mover5
 BEQ mover12
 JMP mover13
 
\ Going into the curve still
 
.mover12
 LDA curve_start
 CMP #road_height:BCS mover4
 LDA myspeed
 LSR A:LSR A:LSR A:LSR A
 SEC:ADC curve_start
 STA curve_start
 RTS
 
\ At maximum edge of the curve
 
.mover4
 LDA road_direct:BMI mover8
 BNE mover7
 
\ At max edge and going left
 
 DEC midx
 INC relxpush
 LDA midx:LDX curve_dest
 CMP tab_lmidxdest,X
 BCS mover8
 LDX #1:STX curve_stage
.mover8
 RTS
 
\ At max edge and going right
 
.mover7
 INC midx
 DEC relxpush
 LDA midx:LDX curve_dest
 CMP tab_rmidxdest,X
 BCC mover6
 LDX #1:STX curve_stage
.mover6
 RTS
 
\ The road is returning to
\ the midx value
 
.mover5
 LDA road_direct
 BPL nastybranch
 JMP mover15
.nastybranch
 BEQ mover9
 
\ Road returning from right
\ edge to centre
 
 LDA midx
 CMP #centre:BEQ mover10
 DEC midx
 JMP mover14:\ Move mountains
 
\ Road returning from left
\ edge to centre
 
.mover9
 LDA midx
 CMP #centre:BEQ mover10
 INC midx
 JMP mover14:\ Move mountains
 
.mover10
 LDA myspeed
 LSR A:LSR A:LSR A:LSR A
 SEC
 ADC curve_start
 CMP #road_height
 BCC mover11
 LDA #&FF:STA restarted
 LDA #0
.mover11
 STA curve_start
 JMP mover14:\ Move mountains
 
\ The maximum edge has been
\ reached, so stay here for
\ a while!
 
.mover13
 LDA counter2
 AND #3:BNE mover14
 DEC sect_length:BNE mover14
 LDA #&51:\ EOR (ind),Y opcode
 LDX #4:JSR promin:\ process mini map block and use colour 1 block
 LDA secdel:STA sect_length
 
\ Move mountains!
 
.mover14
 LDA road_direct
 BMI mover16
 BNE mover17
 
 INC relxpush
 JSR canipush:BCC nopush
 INC relxpush
.nopush
 DEC mount_off
 LDA mount_off:CMP #64
 BCC mover18
 LDA #63:STA mount_off
 JMP mover18
.mover17
 DEC relxpush
 JSR canipush:BCC nopush0
 DEC relxpush
.nopush0
 INC mount_off
 LDA mount_off:CMP #64
 BCC mover18
 LDA #0:STA mount_off
.mover18
 JMP proc_mount
.mover16
 RTS
 
.mover15
 LDA #&FF:STA restarted
 RTS
 
\ Vectors which point to the
\ three different kerb colour
\ tables for road movement
 
.tab_kposlo
 EQUB (kerb_col+160) MOD 256
 EQUB (kerb_col+80) MOD 256
 EQUB kerb_col MOD 256
 EQUB (kerb_col+240) MOD 256
 EQUB (kerb_col+320) MOD 256
 
.tab_kposhi
 EQUB (kerb_col+160) DIV 256
 EQUB (kerb_col+80) DIV 256
 EQUB kerb_col DIV 256
 EQUB (kerb_col+240) DIV 256
 EQUB (kerb_col+320) DIV 256
 
.tab_lmidxdest
 EQUB 75:EQUB 70:EQUB 62
 
.tab_rmidxdest
 EQUB 85:EQUB 90:EQUB 98
 
.canipush
 LDA counter:LSR A:BCC imightpush0:\ Exit with c=0, can't push
.canipush_a
 LDY curve_dest
 LDX myspeed
 CPY #2:BEQ imightpush
 CPX #135:RTS
.imightpush
 CPX #126
.imightpush0
 RTS
 
\\ ]
\\ PRINT"Move road  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
