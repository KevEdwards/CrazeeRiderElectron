\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"ENDB"
\\ B%=P%
\\ [OPT pass
 
.tab_bike4t0_lo
 EQUB (bike4t0+spsiz2*2) MOD 256
 EQUB (bike4t0+spsiz2*2) MOD 256
 EQUB (bike4t0+spsiz2*0) MOD 256
 EQUB (bike4t0+spsiz2*1) MOD 256
 EQUB (bike4t0+spsiz2*1) MOD 256
 EQUB (bike4t0+spsiz2*5) MOD 256
 EQUB (bike4t0+spsiz2*5) MOD 256
 EQUB (bike4t0+spsiz2*3) MOD 256
 EQUB (bike4t0+spsiz2*4) MOD 256
 EQUB (bike4t0+spsiz2*4) MOD 256
 
.tab_bike4t0_hi
 EQUB (bike4t0+spsiz2*2) DIV 256
 EQUB (bike4t0+spsiz2*2) DIV 256
 EQUB (bike4t0+spsiz2*0) DIV 256
 EQUB (bike4t0+spsiz2*1) DIV 256
 EQUB (bike4t0+spsiz2*1) DIV 256
 EQUB (bike4t0+spsiz2*5) DIV 256
 EQUB (bike4t0+spsiz2*5) DIV 256
 EQUB (bike4t0+spsiz2*3) DIV 256
 EQUB (bike4t0+spsiz2*4) DIV 256
 EQUB (bike4t0+spsiz2*4) DIV 256
 
.tab_bike4t1_lo
 EQUB (bike4t1+spsiz2*2) MOD 256
 EQUB (bike4t1+spsiz2*2) MOD 256
 EQUB (bike4t1+spsiz2*0) MOD 256
 EQUB (bike4t1+spsiz2*1) MOD 256
 EQUB (bike4t1+spsiz2*1) MOD 256
 EQUB (bike4t1+spsiz2*5) MOD 256
 EQUB (bike4t1+spsiz2*5) MOD 256
 EQUB (bike4t1+spsiz2*3) MOD 256
 EQUB (bike4t1+spsiz2*4) MOD 256
 EQUB (bike4t1+spsiz2*4) MOD 256
 
 
.tab_bike4t1_hi
 EQUB (bike4t1+spsiz2*2) DIV 256
 EQUB (bike4t1+spsiz2*2) DIV 256
 EQUB (bike4t1+spsiz2*0) DIV 256
 EQUB (bike4t1+spsiz2*1) DIV 256
 EQUB (bike4t1+spsiz2*1) DIV 256
 EQUB (bike4t1+spsiz2*5) DIV 256
 EQUB (bike4t1+spsiz2*5) DIV 256
 EQUB (bike4t1+spsiz2*3) DIV 256
 EQUB (bike4t1+spsiz2*4) DIV 256
 EQUB (bike4t1+spsiz2*4) DIV 256
 
.tab_bike5t0_lo
 EQUB (bike5t0+spsiz3*0) MOD 256
 EQUB (bike5t0+spsiz3*0) MOD 256
 EQUB (bike5t0+spsiz3*0) MOD 256
 EQUB (bike5t0+spsiz3*0) MOD 256
 EQUB (bike5t0+spsiz3*0) MOD 256
 EQUB (bike5t0+spsiz3*1) MOD 256
 EQUB (bike5t0+spsiz3*1) MOD 256
 EQUB (bike5t0+spsiz3*1) MOD 256
 EQUB (bike5t0+spsiz3*1) MOD 256
 EQUB (bike5t0+spsiz3*1) MOD 256
 
.tab_bike5t0_hi
 EQUB (bike5t0+spsiz3*0) DIV 256
 EQUB (bike5t0+spsiz3*0) DIV 256
 EQUB (bike5t0+spsiz3*0) DIV 256
 EQUB (bike5t0+spsiz3*0) DIV 256
 EQUB (bike5t0+spsiz3*0) DIV 256
 EQUB (bike5t0+spsiz3*1) DIV 256
 EQUB (bike5t0+spsiz3*1) DIV 256
 EQUB (bike5t0+spsiz3*1) DIV 256
 EQUB (bike5t0+spsiz3*1) DIV 256
 EQUB (bike5t0+spsiz3*1) DIV 256
 
.tab_bike5t1_lo
 EQUB (bike5t1+spsiz3*0) MOD 256
 EQUB (bike5t1+spsiz3*0) MOD 256
 EQUB (bike5t1+spsiz3*0) MOD 256
 EQUB (bike5t1+spsiz3*0) MOD 256
 EQUB (bike5t1+spsiz3*0) MOD 256
 EQUB (bike5t1+spsiz3*1) MOD 256
 EQUB (bike5t1+spsiz3*1) MOD 256
 EQUB (bike5t1+spsiz3*1) MOD 256
 EQUB (bike5t1+spsiz3*1) MOD 256
 EQUB (bike5t1+spsiz3*1) MOD 256
 
.tab_bike5t1_hi
 EQUB (bike5t1+spsiz3*0) DIV 256
 EQUB (bike5t1+spsiz3*0) DIV 256
 EQUB (bike5t1+spsiz3*0) DIV 256
 EQUB (bike5t1+spsiz3*0) DIV 256
 EQUB (bike5t1+spsiz3*0) DIV 256
 EQUB (bike5t1+spsiz3*1) DIV 256
 EQUB (bike5t1+spsiz3*1) DIV 256
 EQUB (bike5t1+spsiz3*1) DIV 256
 EQUB (bike5t1+spsiz3*1) DIV 256
 EQUB (bike5t1+spsiz3*1) DIV 256
 
 
\\ ]
\\ PRINT"End graf.B from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
