\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"KERBGRA"
\\ B%=P%
\\ [OPT pass
 
.left_kerb_gra
\\ OPT FNloadkerbgra
\\ 3*10*4*2*2 = 480 bytes
 INCBIN "object\O.KERBGRA"

\\ ]
\\ PRINT"Kerb gra.  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
 
\\ DEF FNloadkerbgra
\\  IF pass>4 O%=O%+3*10*4*2*2:P%=P%+3*10*4*2*2:=pass
\\  OSCLI("LOAD O.KERBGRA "+STR$~(O%))
\\  O%=O%+3*10*4*2*2:P%=P%+3*10*4*2*2
\\ =pass
