\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"ROFFSET"
\\ B%=P%
\\ [OPT pass
 
.right_offset
\\  OPT FNloadroffset
INCBIN "object\O.ROFFSET"									\\ MISMATCH!!!!! File is 96 bytes, road_height is 80!

\\ ]
\\ PRINT"Right Off. from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
 
\\ DEF FNloadroffset
\\  IF pass>4 O%=O%+road_height:P%=P%+road_height:=pass
\\  OSCLI("LOAD O.ROFFSET "+STR$~(O%))
\\  O%=O%+road_height:P%=P%+road_height
\\ =pass
