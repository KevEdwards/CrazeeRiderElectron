\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"KERB"
\\ B%=P%
\\ [OPT pass
 
.kerb_width
 \\ OPT FNloaddata("O.KERB",road_height*2)
 INCBIN "object\O.KERB"								 \\ MISMATCH!!!!! File is 80 bytes, road_height is 80*2!

.kerb_col
 \\ OPT FNloaddata("O.KERBCOL",road_height*5)
 INCBIN "object\O.KERBCOL"
 
.mount_gra
 \\ OPT FNloaddata("O.MOUNTIN",&200)
 INCBIN "object\O.MOUNTIN"
 
.digits
 \\ OPT FNloaddata("O.DIGITS",&140)
 INCBIN "object\O.DIGITS"
 
.lightgra
 \\ OPT FNloaddata("O.LIGHTS",&C0)
 INCBIN "object\O.LIGHTS"
 
.hitsgra
 \\ OPT FNloaddata("O.HITS",&80)
 INCBIN "object\O.HITS"
 
.chqflag
 \\ OPT FNloaddata("O.FLAGDAT",&100)
 INCBIN "object\O.FLAGDAT"
 
\\ ]
\\ PRINT"Kerb etc.  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
 
\\ DEF FNloaddata(filfsp$,size%)
\\  IF pass>4 O%=O%+size%:P%=P%+size%:=pass
\\  OSCLI("LOAD "+filfsp$+" "+STR$~(O%))
\\  O%=O%+size%:P%=P%+size%
\\ =pass
