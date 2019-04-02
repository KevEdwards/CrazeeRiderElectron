\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"TRACK1"
 
\\ B%=P%
\\ [OPT pass

\\ Re-map EQUS strings for this file - reset below!
MAPCHAR ' ','Z', 0

\ Passwords for completion of track 7, 14 and 21
 
.pwrd1
 EQUW &6B38:EQUB &80
 EQUS "CHATTER":EQUB &FF
.pwrd2
 EQUW &6B38:EQUB &80
 EQUS "FURNACE":EQUB &FF
.pwrd3
 EQUW &6B38:EQUB &80
 EQUS "HELIPAD":EQUB &FF
 
\ General text overflow from MODULE
 
.wdone
 EQUW &6DA8:EQUB &80
 EQUS "WELL DONE!":EQUB &FF
 
.shwnam
 JSR getrkoff
 LDA tknlow,X:STA txnam:\ Screen low address
 LDY tknmoff,X:LDX #0
.shna0
 LDA tkna1,Y:STA ttnam,X
 BMI shna1
 INY:INX:BNE shna0:\ Always
.shna1
 JSR shna2
 LDY #15:JSR frame_delay
 LDA #80:JSR delspc:\ Wait 80 frames OR until space pressed (see INIT)
.shna2
 LDY #20:JSR pstring
 LDY #24:JMP pstring
 
.tknmoff
 EQUB tkna1-tkna1
 EQUB tkna2-tkna1
 EQUB tkna3-tkna1
 EQUB tkna4-tkna1
 EQUB tkna5-tkna1
 EQUB tkna6-tkna1
 EQUB tkna7-tkna1
 
.tknlow
 EQUB &40+&38:\ Le Mans
 EQUB &40+&23:\ Anderstorp
 EQUB &40+&20:\ Paul Ricard
 EQUB &40+&19:\ Brands Hatch
 EQUB &40+&3B:\ Misano
 EQUB &40+&20:\ Silverstone
 EQUB &40+&20:\ Nurburgring
 
.tkna1
 EQUS "LE MANS":EQUB &FF
.tkna2
 EQUS "ANDERSTORP":EQUB &FF
.tkna3
 EQUS "PAUL RICARD":EQUB &FF
.tkna4
 EQUS "BRANDS HATCH":EQUB &FF
.tkna5
 EQUS "MISANO":EQUB &FF
.tkna6
 EQUS "SILVERSTONE":EQUB &FF
.tkna7
 EQUS "NURBURGRING":EQUB &FF
 
 
\ Number of tracks defined
 
.numoftracks
 EQUB 7
 
.trackdata_lo
 EQUB trak1 MOD 256
 EQUB trak2 MOD 256
 EQUB trak3 MOD 256
 EQUB trak4 MOD 256
 EQUB trak5 MOD 256
 EQUB trak6 MOD 256
 EQUB trak7 MOD 256
 
.trackdata_hi
 EQUB trak1 DIV 256
 EQUB trak2 DIV 256
 EQUB trak3 DIV 256
 EQUB trak4 DIV 256
 EQUB trak5 DIV 256
 EQUB trak6 DIV 256
 EQUB trak7 DIV 256
 
 
\ Start line position and road direction values
 
.slinx
 EQUB 62:\ Le Mans
 EQUB 95:\ Anderstorp
 EQUB 95:\ Paul Ricard
 EQUB 59:\ Brands Hatch
 EQUB 83:\ Misano
 EQUB 59:\ Silverstone
 EQUB 106:\ Nurburgring
.sliny
 EQUB 42:\ Le Mans
 EQUB 54:\ Anderstorp
 EQUB 41:\ Paul Ricard
 EQUB 33:\ Brands Hatch
 EQUB 46:\ Misano
 EQUB 37:\ Silverstone
 EQUB 45:\ Nurburgring
.slind
 EQUB 2:\  Le Mans
 EQUB 19:\ Anderstorp
 EQUB 18:\ Paul Ricard
 EQUB 0:\  Brands Hatch
 EQUB 1:\  Misano
 EQUB 0:\  Silverstone
 EQUB 19:\ Nurburgring
 
.trak6
 
\ Silverstone
 
 EQUB &80+14
 EQUB 2:EQUB &80+1*4+2:\ Copse
 EQUB &80+8
 EQUB 2:EQUB 1*4+1:\ Maggots
 EQUB &80+6
 EQUB 1:EQUB &80+2*4+2:\ Becketts
 EQUB &80+13
 EQUB 2:EQUB 0*4+1:\ Chapel
 EQUB &80+18:\ Hangar straight
 EQUB 2:EQUB &80+2*4+1:\ Stowe
 EQUB &80+8
 EQUB 1:EQUB &80+2*4+1:\ Club
 EQUB &80+6
 EQUB 0:EQUB 2*4+0:\ Abbey
 EQUB &80+20
 EQUB 1:EQUB &80+0*4+2:\ Woodcote
 EQUB 1:EQUB 0*4+2:\ Woodcote 2
 EQUB 0:EQUB &80+2*4+1:\ Out of woodcote
 EQUB &80+5
 EQUB &FF
 
.trak4
 
\ Brands Hatch
 
 EQUB &80+18
 EQUB 2:EQUB &80+3*4+1:\ Paddock
 EQUB &80+7
 EQUB 1:EQUB &80+3*4+2:\ Druids
 EQUB &80+3
 EQUB 0:EQUB 2*4+1:\ Graham Hill 1
 EQUB &80+4
 EQUB 0:EQUB 0*4+1:\ Graham Hill 2
 EQUB &80+16
 EQUB 2:EQUB 4*4+1:\ Surtrees
 EQUB &80+10
 EQUB 0:EQUB &80+0*4+0:\ Gentle
 EQUB &80+17
 EQUB 2:EQUB &80+3*4+1:\ Hawthorns
 EQUB &80+18
 EQUB 2:EQUB &80+0*4+2:\ Westfield
 EQUB &80+9
 EQUB 0:EQUB &80+1*4+0:\ Gentle
 EQUB &80+6
 EQUB 1:EQUB &80+1*4+2:\ Dingle Dell
 EQUB &80+6
 EQUB 1:EQUB 1*4+2:\ Stirlings
 EQUB &80+21
 EQUB 2:EQUB &80+3*4+1:\ Clearways
 EQUB &80+13
 EQUB &FF
 
.trak3
 
\ Paul Ricard
 
 EQUB &80+13:\ Ligne Droite des stands
 EQUB 1:EQUB 1*4+0
 EQUB &80+1
 EQUB 1:EQUB &80+0*4+0
 EQUB &80+4
 EQUB 2:EQUB &80+0*4+2:\ La chicane
 EQUB 2:EQUB 0*4+2
 EQUB &80+3
 EQUB 1:EQUB &80+2*4+2:\ L'Ecole
 EQUB &80+4
 EQUB 1:EQUB &80+1*4+2:\ Sainte-Baume
 EQUB &80+2
 EQUB 0:EQUB 1*4+1
 EQUB &80+38:\ Mistral
 EQUB 1:EQUB &80+2*4+1:\ Signes
 EQUB &80+16
 EQUB 1:EQUB &80+5*4+1:\ Beausset
 EQUB &80+3
 EQUB 0:EQUB &80+2*4+0
 EQUB 0:EQUB 5*4+1:\ L'Epingle
 EQUB &80+2
 EQUB 0:EQUB &80+2*4+1
 EQUB 0:EQUB 3*4+1
 EQUB &80+2
 EQUB 0:EQUB &80+1*4+2
 EQUB &80+3
 EQUB &FF
 
 
.trak2
 
\ Anderstorp
 
 EQUB &80+6
 EQUB 1:EQUB &80+5*4+1:\ Start Kurvan
 EQUB &80+8
 EQUB 1:EQUB 5*4+1:\ Opel Kurvan
 EQUB &80+15
 EQUB 2:EQUB 1*4+2:\ Hansen Kurvan
 EQUB &80+13
 EQUB 0:EQUB &80+12*4+0:\ Karusell Kurvan
 EQUB &80+6
 EQUB 1:EQUB 1*4+2:\ Gislaved Kurvan
 EQUB &80+11
 EQUB 1:EQUB &80+3*4+1:\ Sodra Kurvan
 EQUB &80+8
 EQUB 0:EQUB &80+2*4+0
 EQUB &80+25
 EQUB 1:EQUB &80+1*4+0
 EQUB &80+11
 EQUB 1:EQUB &80+1*4+1:\ Norra Kurvan
 EQUB &80+11
 EQUB 2:EQUB &80+1*4+2:\ Laktar Kurvan
 EQUB &80+7
 EQUB &FF
 
.trak5
 
\ Misano
 
 EQUB &80+6
 EQUB 0:EQUB 0*4+0
 EQUB &80+6
 EQUB 1:EQUB &80+1*4+1:\ Into Curva Misano
 EQUB &80+2
 EQUB 1:EQUB &80+1*4+1:\ Out of Curva Misano
 EQUB &80+5
 EQUB 0:EQUB &80+0*4+0
 EQUB &80+1
 EQUB 0:EQUB &80+1*4+0
 EQUB &80+6
 EQUB 1:EQUB 2*4+2:\ Curva Cattolica
 EQUB &80+4
 EQUB 2:EQUB 1*4+1
 EQUB &80+5
 EQUB 2:EQUB 0*4+1
 EQUB &80+12
 EQUB 1:EQUB 1*4+1:\ Curva Bellaria
 EQUB &80+34
 EQUB 2:EQUB 3*4+2:\ Curva Gesenatico
 EQUB &80+6
 EQUB 0:EQUB &80+0*4+0
 EQUB &80+7
 EQUB 2:EQUB &80+2*4+2:\ Riccione
 EQUB &80+16
 EQUB 1:EQUB 0*4+2
 EQUB &80+2
 EQUB 0:EQUB 3*4+2:\ Curva Rimini
 EQUB 1:EQUB &80+2*4+0
 EQUB &80+6
 EQUB &FF
 
.trak1
 
\ Le Mans
 
 EQUB &80+24
 EQUB 1:EQUB &80+5*4+0
 EQUB &80+21:\ Dunlop Bridge Straight
 EQUB 1:EQUB &80+3*4+2:\ Virage De La Chapelle
 EQUB &80+10:\ Chapelle+
 EQUB 2:EQUB 6*4+1:\ Virage Du Musee
 EQUB &80+16
 EQUB 1:EQUB &80+3*4+2:\ Virage Garage Vert
 EQUB &80+26
 EQUB 1:EQUB 1*4+1
 EQUB &80+14
 EQUB 0:EQUB &80+2*4+2:\ Les S Du Garage Bleu
 EQUB &80+4
 EQUB 0:EQUB 1*4+2
 EQUB &80+6
 EQUB 1:EQUB &80+2*4+2:\ Virage Du Raccordement
 EQUB &80+5
 EQUB &FF
 
 
.trak7
 
\ Nurburgring
 
 EQUB &80+16
 EQUB 0:EQUB &80+0*4+2:\ Into Castrol Esses
 EQUB &80+2
 EQUB 0:EQUB 2*4+1
 EQUB &80+7
 EQUB 0:EQUB 1*4+1
 EQUB &80+4
 EQUB 0:EQUB &80+3*4+1:\ Ford Kurve
 EQUB &80+6
 EQUB 0:EQUB 2*4+0
 EQUB &80+3
 EQUB 1:EQUB &80+6*4+1:\ Dunlop Kehre
 EQUB &80+5
 EQUB 1:EQUB 1*4+1
 EQUB &80+1
 EQUB 1:EQUB &80+0*4+1
 EQUB &80+8
 EQUB 0:EQUB 1*4+2
 EQUB &80+11
 EQUB 0:EQUB &80+3*4+1:\ Bid-Kurve
 EQUB &80+9
 EQUB 1:EQUB &80+1*4+0
 EQUB &80+12
 EQUB 0:EQUB 1*4+2:\ Veedol Schikane
 EQUB 0:EQUB &80+1*4+2
 EQUB &80+5
 EQUB 1:EQUB &80+4*4+1:\ Romer Kurve
 EQUB &80+4
 EQUB &FF


\\ Re-map Back to normal ASCII
MAPCHAR ' ','Z', 32

\\ ]
\\ PRINT"Track 1    from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
 
\\ DEF FNmyasc2(oldasc$)
\\ IF pass>4 O%=O%+LEN(oldasc$):P%=P%+LEN(oldasc$):=pass
\\ FORL%=1TOLEN(oldasc$)
\\ ?(O%+L%-1)=ASC(MID$(oldasc$,L%,1))-32
\\ NEXT
\\ O%=O%+LEN(oldasc$)
\\ P%=P%+LEN(oldasc$)
\\ =pass
