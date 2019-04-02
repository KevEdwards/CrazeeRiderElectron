\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"ABSWORK"
\\ P%=&400:ST%=P%:O%=&8000
\\ [OPT 6

ORG &400

.AbsStartDummy

.old_left	SKIP road_height
.new_left	SKIP road_height
 
.left_lo	SKIP road_height
.left_hi	SKIP road_height
.right_lo	SKIP road_height
.right_hi	SKIP road_height
 
.kerb_position EQUB 0
.counter EQUB 0
.counter2 EQUB 0
 
.road_direct EQUB 0
.sect_length EQUB 0
.curve_stage EQUB 0
.curve_dest EQUB 0
 
.myspeed EQUB 0
.myx EQUB 0
.mynewx EQUB 0
.myrelx EQUB 0
.relxpush EQUB 0
.myleandel EQUB 0
.mypos EQUB 0
.mytyrepos EQUB 0
.mylasttyrepos EQUB 0
.mylastgraoff EQUB 0
.position EQUB 0
.medisabled EQUB 0
.medisabled2 EQUB 0
 
.kcount EQUB 0
.restarted EQUB 0
.current_track EQUB 0
 
.mount_off EQUB 0
.track_fin EQUB 0
 
.score EQUS"000000"
.scr_count EQUB 0
.oldspeed EQUS"000"
.newspeed EQUS"000"
 
.new_sect EQUB 0
.startoff EQUB 0
 
.numobikes EQUB 0
.catch_speed EQUB 0
.overtake_speed EQUB 0
.bahead EQUB 0
.bbehind EQUB 0
.stcnt EQUB 0
.alterspd EQUB 0
 
.curvol EQUB 0
 
.intopspd EQUB 0
.inbotspd EQUB 0
 
.degree EQUB 0
.clen EQUB 0
.rlclen EQUB 0
.degrel EQUB 0
.secparts EQUB 0
.curx EQUB 0:.cury EQUB 0
.bkrelx EQUB 0:.bkrely EQUB 0
.mingcon EQUB 0
.mingradder EQUB 0
 
.argdel EQUB 0
.hits EQUB 0
.lasthit EQUS "0123"
.finsnd EQUB 0
 
.secdel EQUB 0
 
.joyval EQUW 0:\ Last values read from Plus 1 A to D chip
 
\\ ]
\\ PRINT"General workspace from &";~ST%;" to &";~P%-1
PRINT"General workspace from ",~AbsStartDummy," to ",~P%-1

\\ PAGE=PG%
\\ RETURN
 
\\ DEFFNres(gap%)
\\ P%=P%+gap%:O%=O%+gap%
\\ =6
