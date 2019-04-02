\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.END"
\\ B%=P%
\\ [OPT pass
 
.tab_xfudge
 EQUB &F8:EQUB &F8:EQUB 0:EQUB 0:EQUB 0
 EQUB &F8:EQUB &F8:EQUB 0:EQUB 0:EQUB 0
 
\ Graphic pointers for my bike
\ tyre position 0
 
.tab_biket0_lo
 EQUB (biket0+spsiz*4) MOD 256
 EQUB (biket0+spsiz*3) MOD 256
 EQUB (biket0+spsiz*0) MOD 256
 EQUB (biket0+spsiz*1) MOD 256
 EQUB (biket0+spsiz*2) MOD 256
 EQUB (biket0+spsiz*9) MOD 256
 EQUB (biket0+spsiz*8) MOD 256
 EQUB (biket0+spsiz*5) MOD 256
 EQUB (biket0+spsiz*6) MOD 256
 EQUB (biket0+spsiz*7) MOD 256
.tab_biket0_hi
 EQUB (biket0+spsiz*4) DIV 256
 EQUB (biket0+spsiz*3) DIV 256
 EQUB (biket0+spsiz*0) DIV 256
 EQUB (biket0+spsiz*1) DIV 256
 EQUB (biket0+spsiz*2) DIV 256
 EQUB (biket0+spsiz*9) DIV 256
 EQUB (biket0+spsiz*8) DIV 256
 EQUB (biket0+spsiz*5) DIV 256
 EQUB (biket0+spsiz*6) DIV 256
 EQUB (biket0+spsiz*7) DIV 256
 
\ As above, tyre position 1
 
.tab_biket1_lo
 EQUB (biket1+spsiz*4) MOD 256
 EQUB (biket1+spsiz*3) MOD 256
 EQUB (biket1+spsiz*0) MOD 256
 EQUB (biket1+spsiz*1) MOD 256
 EQUB (biket1+spsiz*2) MOD 256
 EQUB (biket1+spsiz*9) MOD 256
 EQUB (biket1+spsiz*8) MOD 256
 EQUB (biket1+spsiz*5) MOD 256
 EQUB (biket1+spsiz*6) MOD 256
 EQUB (biket1+spsiz*7) MOD 256
 
.tab_biket1_hi
 EQUB (biket1+spsiz*4) DIV 256
 EQUB (biket1+spsiz*3) DIV 256
 EQUB (biket1+spsiz*0) DIV 256
 EQUB (biket1+spsiz*1) DIV 256
 EQUB (biket1+spsiz*2) DIV 256
 EQUB (biket1+spsiz*9) DIV 256
 EQUB (biket1+spsiz*8) DIV 256
 EQUB (biket1+spsiz*5) DIV 256
 EQUB (biket1+spsiz*6) DIV 256
 EQUB (biket1+spsiz*7) DIV 256
 
\ Graphic pointers for closest
\ other bike
 
.tab_bike2t0_lo
 EQUB (bike2t0+spsiz*4) MOD 256
 EQUB (bike2t0+spsiz*3) MOD 256
 EQUB (bike2t0+spsiz*0) MOD 256
 EQUB (bike2t0+spsiz*1) MOD 256
 EQUB (bike2t0+spsiz*2) MOD 256
 EQUB (bike2t0+spsiz*9) MOD 256
 EQUB (bike2t0+spsiz*8) MOD 256
 EQUB (bike2t0+spsiz*5) MOD 256
 EQUB (bike2t0+spsiz*6) MOD 256
 EQUB (bike2t0+spsiz*7) MOD 256
.tab_bike2t0_hi
 EQUB (bike2t0+spsiz*4) DIV 256
 EQUB (bike2t0+spsiz*3) DIV 256
 EQUB (bike2t0+spsiz*0) DIV 256
 EQUB (bike2t0+spsiz*1) DIV 256
 EQUB (bike2t0+spsiz*2) DIV 256
 EQUB (bike2t0+spsiz*9) DIV 256
 EQUB (bike2t0+spsiz*8) DIV 256
 EQUB (bike2t0+spsiz*5) DIV 256
 EQUB (bike2t0+spsiz*6) DIV 256
 EQUB (bike2t0+spsiz*7) DIV 256
 
\ As above, tyre position 1
 
.tab_bike2t1_lo
 EQUB (bike2t1+spsiz*4) MOD 256
 EQUB (bike2t1+spsiz*3) MOD 256
 EQUB (bike2t1+spsiz*0) MOD 256
 EQUB (bike2t1+spsiz*1) MOD 256
 EQUB (bike2t1+spsiz*2) MOD 256
 EQUB (bike2t1+spsiz*9) MOD 256
 EQUB (bike2t1+spsiz*8) MOD 256
 EQUB (bike2t1+spsiz*5) MOD 256
 EQUB (bike2t1+spsiz*6) MOD 256
 EQUB (bike2t1+spsiz*7) MOD 256
 
.tab_bike2t1_hi
 EQUB (bike2t1+spsiz*4) DIV 256
 EQUB (bike2t1+spsiz*3) DIV 256
 EQUB (bike2t1+spsiz*0) DIV 256
 EQUB (bike2t1+spsiz*1) DIV 256
 EQUB (bike2t1+spsiz*2) DIV 256
 EQUB (bike2t1+spsiz*9) DIV 256
 EQUB (bike2t1+spsiz*8) DIV 256
 EQUB (bike2t1+spsiz*5) DIV 256
 EQUB (bike2t1+spsiz*6) DIV 256
 EQUB (bike2t1+spsiz*7) DIV 256
 
\ 2nd largest other bike
 
.tab_bike3t0_lo
 EQUB (bike3t0+spsiz1*2) MOD 256
 EQUB (bike3t0+spsiz1*2) MOD 256
 EQUB (bike3t0+spsiz1*0) MOD 256
 EQUB (bike3t0+spsiz1*1) MOD 256
 EQUB (bike3t0+spsiz1*1) MOD 256
 EQUB (bike3t0+spsiz1*5) MOD 256
 EQUB (bike3t0+spsiz1*5) MOD 256
 EQUB (bike3t0+spsiz1*3) MOD 256
 EQUB (bike3t0+spsiz1*4) MOD 256
 EQUB (bike3t0+spsiz1*4) MOD 256
 
.tab_bike3t0_hi
 EQUB (bike3t0+spsiz1*2) DIV 256
 EQUB (bike3t0+spsiz1*2) DIV 256
 EQUB (bike3t0+spsiz1*0) DIV 256
 EQUB (bike3t0+spsiz1*1) DIV 256
 EQUB (bike3t0+spsiz1*1) DIV 256
 EQUB (bike3t0+spsiz1*5) DIV 256
 EQUB (bike3t0+spsiz1*5) DIV 256
 EQUB (bike3t0+spsiz1*3) DIV 256
 EQUB (bike3t0+spsiz1*4) DIV 256
 EQUB (bike3t0+spsiz1*4) DIV 256
 
.tab_bike3t1_lo
 EQUB (bike3t1+spsiz1*2) MOD 256
 EQUB (bike3t1+spsiz1*2) MOD 256
 EQUB (bike3t1+spsiz1*0) MOD 256
 EQUB (bike3t1+spsiz1*1) MOD 256
 EQUB (bike3t1+spsiz1*1) MOD 256
 EQUB (bike3t1+spsiz1*5) MOD 256
 EQUB (bike3t1+spsiz1*5) MOD 256
 EQUB (bike3t1+spsiz1*3) MOD 256
 EQUB (bike3t1+spsiz1*4) MOD 256
 EQUB (bike3t1+spsiz1*4) MOD 256
 
.tab_bike3t1_hi
 EQUB (bike3t1+spsiz1*2) DIV 256
 EQUB (bike3t1+spsiz1*2) DIV 256
 EQUB (bike3t1+spsiz1*0) DIV 256
 EQUB (bike3t1+spsiz1*1) DIV 256
 EQUB (bike3t1+spsiz1*1) DIV 256
 EQUB (bike3t1+spsiz1*5) DIV 256
 EQUB (bike3t1+spsiz1*5) DIV 256
 EQUB (bike3t1+spsiz1*3) DIV 256
 EQUB (bike3t1+spsiz1*4) DIV 256
 EQUB (bike3t1+spsiz1*4) DIV 256
 
\\ ]
\\ PRINT"End graf.  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
