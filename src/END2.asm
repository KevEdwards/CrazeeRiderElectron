\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.END2"
\\ B%=P%
\\ [OPT pass
 
 
.biket0
\\  OPT FNloadgraf(":2.O.BIKET0",&5DC)
 INCBIN "object\O.BIKET0"

.biket1
\\  OPT FNloadgraf(":2.O.BIKET1",&5DC)
 INCBIN "object\O.BIKET1"

.bike2t0
\\  OPT FNloadgraf(":2.O.BIKE2T0",&5DC)
 INCBIN "object\O.BIKE2T0"

.bike2t1
\\  OPT FNloadgraf(":2.O.BIKE2T1",&5DC)
 INCBIN "object\O.BIKE2T1"

.bike3t0
\\  OPT FNloadgraf(":2.O.BIKE3T0",&240)
 INCBIN "object\O.BIKE3T0"

.bike3t1
\\  OPT FNloadgraf(":2.O.BIKE3T1",&240)
 INCBIN "object\O.BIKE3T1"

.bike4t0
\\  OPT FNloadgraf("O.BIKE4T0",&144)
 INCBIN "object\O.BIKE4T0"

.bike4t1
\\  OPT FNloadgraf("O.BIKE4T1",&144)
 INCBIN "object\O.BIKE4T1"

.bike5t0
\\  OPT FNloadgraf("O.BIKE5T0",&30)
 INCBIN "object\O.BIKE5T0"

.bike5t1
\\  OPT FNloadgraf("O.BIKE5T1",&30)
 INCBIN "object\O.BIKE5T1"
 
\\ ]
\\ PRINT"End graf2  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
 
\\ DEF FNloadgraf(filfsp$,size%)
\\  IF pass>4 O%=O%+size%:P%=P%+size%:=pass
\\  OSCLI("LOAD "+filfsp$+" "+STR$~(O%))
\\  O%=O%+size%:P%=P%+size%
\\ =pass
