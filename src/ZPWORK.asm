\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"ZPWORK"
\\ P%=0:O%=&8000
\\ [OPT 6

 ORG 0

.temp     EQUD 0:\ Double
.temp1    EQUW 0
.temp2    EQUW 0
.temp3    EQUW 0
.temp4    EQUW 0
.temp5    EQUD 0:\ Double
 
.grad     EQUB 0
.curve_start EQUB 0
 
.midx     EQUB 0
 
.tdata EQUW 0
.tdataoff EQUB 0
 
.sprheight EQUB 0
 
.seed EQUW 0:EQUB 0
.curr_id EQUB 0
.grahold EQUW 0:EQUB 0
 
.vec EQUW 0
 
.vec2 EQUW 0
.vec3 EQUW 0
 
.holdxoff EQUB 0
.holdcounter EQUB 0
 
\ Symbol values for other bikes
 
.obike_st		SKIP maxbikes
.obike_speed	SKIP maxbikes
.obike_accel	SKIP maxbikes
 
.obike_side		SKIP maxbikes
.obike_leandel	SKIP maxbikes
.obike_xoff		SKIP maxbikes
.obike_y		SKIP maxbikes
.obike_leanpos	SKIP maxbikes
.obike_lasttyre	SKIP maxbikes
 
.obike_scrlo		SKIP maxbikes
.obike_scrhi		SKIP maxbikes
.obike_gralo		SKIP maxbikes
.obike_grahi		SKIP maxbikes
.obike_graoff		SKIP maxbikes
.obike_sprheight	SKIP maxbikes
.obike_wid			SKIP maxbikes
 
 
.obike_counter		SKIP maxbikes
.obike_gradconst	SKIP maxbikes
 
 
\\ ]
\\ PRINT'"Zero page from 0 to &";~P%-1
\\ PAGE=PG%
\\ RETURN
PRINT"Zero page from 0 to ", ~P%-1

\\ DEFFNres2(gap%)
\\ P%=P%+gap%:O%=O%+gap%
\\ =6
