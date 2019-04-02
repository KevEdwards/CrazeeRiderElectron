\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.MUSIC1"
\\ REM "Crazee Rider" Music Program
\\ REM 28th March 1987.
\\ REM Beware! LIMITED FLEXIBILITY VERSION!
 
 D1=0*64
 D2=1*64
 D3=2*64
 D4=3*64
 Rest=63
 
\\ B%=P%
\\ [OPT pass
 
 \===================================================================
 .StartTune
      STY WK:LDA LT+0,Y:STA get+1:LDA LT+1,Y:STA get+2:LDA #0:STA IX
 
      LDX LT+2,Y:LDY #3
 .SL  LDA SPT,X:STA SPD,Y:DEX:DEY:BPL SL:LDY WK
 
      LDA LT+3,Y:STA SND+2
 
      LDA #1:STA CNT
 
      LDX LT+4,Y
 .DL  LDA DURATAB,X:STA DUR
      RTS
 
 .Refresh
 .RL  DEC CNT:BNE NOC:LDY IX
 .get LDA &DDDD,Y:BEQ NOC:INC IX:PHA:AND #Rest:CMP #Rest:BEQ ST:PLA:PHA
      ASL A:ASL A
      STA SND+4:LDA DUR
      STA SND+6:LDX #SND MOD 256:LDY #SND DIV 256:JSR sound
 .ST  PLA:ROL A:ROL A:ROL A:AND #3:TAX:LDA SPD,X:STA CNT
 .NOC RTS
 
 .MusicTest
      LDA get+1:STA dat+1:LDA get+2:STA dat+2
 .ML  LDY IX
 .dat LDA &FFFF,Y:RTS
 
 .Stop
      LDX #HAL MOD 256:LDY #HAL DIV 256:STX get+1:STY get+2:LDA #0:TAX
 .SL2  STA IX:LDA #15:JMP &FFF4
 
 \====================================================================
 
 .SND EQUW &11:EQUW &DD:EQUW &DD:EQUW &DD
 .WK  EQUB 0
 .CNT EQUB 0
 .IX  EQUB 0
 .SPD EQUS "0123"
 .SPT EQUB 5:EQUB 10:EQUB 15:EQUB 20\In Between Levels
      EQUB 3:EQUB 6:EQUB 9:EQUB 12\Every 6 Levels
      EQUB 3:EQUB 6:EQUB 18:EQUB 36\New High Score
 .DUR EQUB 0
 .DURATAB
      EQUB 2:\In Between Levels, was 5
      EQUB 2:\Every 6 Levels, was 3
      EQUB 15:\New High Score
 
 \Data Look-up Table
 \Contains all the gen pertaining to each individual tune.
 
 \Order is as follows:
 
 \Address of channel 1 data.         2
 \Index into speeds table            1
 \Envelope to use on ALL 3 channels  1
 \Index into durations table         1
 
 \      Addr1    Speed    Env    Dur   Two dummy values for 0,7,14 index
 .LT  EQUW BETW3:EQUB 03:EQUB 6:EQUB 0:EQUB 0:EQUB 0
      EQUW HIGH2:EQUB 11:EQUB 5:EQUB 2:EQUB 0:EQUB 0
      EQUW EVRY63:EQUB 7:EQUB 7:EQUB 0:EQUB 0:EQUB 0
 
 \Between Levels Music
 
 .BETW3
      EQUB 19+D2:EQUB 31+D2:EQUB 31+D1:EQUB 19+D1:EQUB 19+D1:EQUB 19+D1
      EQUB 31+D2:EQUB 19+D2:EQUB 31+D1:EQUB 19+D1:EQUB 19+D2
      EQUB 18+D2:EQUB 30+D2:EQUB 30+D1:EQUB 18+D1:EQUB 18+D1:EQUB 18+D1
      EQUB 30+D2:EQUB 18+D2:EQUB 30+D1:EQUB 18+D1:EQUB 18+D2
      EQUB 17+D2:EQUB 29+D2:EQUB 29+D1:EQUB 17+D1:EQUB 17+D1:EQUB 17+D1
      EQUB 29+D2:EQUB 17+D2:EQUB 29+D1:EQUB 17+D1:EQUB 17+D2
      EQUB 16+D1
.HAL  EQUB 0
 
 \Highest Score Fanfare
 
 .HIGH2
      EQUB 19+D2:EQUB 19+D1:EQUB 19+D1:EQUB 19+D1:EQUB 19+D1
      EQUB 21+D2:EQUB 19+D2:EQUB 21+D2
      EQUB 22+D2:EQUB 22+D1:EQUB 22+D1:EQUB 22+D1:EQUB 22+D1
      EQUB 24+D2:EQUB 22+D2:EQUB 24+D2
      EQUB 25+D2:EQUB 25+D1:EQUB 25+D1:EQUB 25+D1:EQUB 25+D1
      EQUB 27+D2:EQUB 25+D2:EQUB 27+D2
      EQUB 28+D2:EQUB 28+D1:EQUB 28+D1:EQUB 28+D1:EQUB 28+D1
      EQUB 30+D2:EQUB 28+D2:EQUB 30+D2
      EQUB 32+D1
      EQUB 0
 
 \Every 6 levels Music
 
 .EVRY63
      EQUB 19+D4:EQUB Rest+D4:EQUB 19+D2:EQUB 19+D2:EQUB 19+D2:EQUB 19+D2
      EQUB 19+D4:EQUB 19+D4:EQUB 7+D4:EQUB 7+D4
      EQUB 19+D4:EQUB 19+D2:EQUB 19+D2:EQUB 19+D4:EQUB 19+D4:EQUB Rest+D4
      EQUB 19+D4:EQUB 7+D4:EQUB 7+D2
      EQUB 0
 
 
\ Plays Tune given in Y, Checks for end AFTER a note is played!
 
.tune
 JSR StartTune
.tune0
 JSR spcts0:BEQ tune1:\ Check for space key
 JSR fx19:JSR Refresh
 JSR MusicTest:BNE tune0
 RTS
 
.tune1
 JMP Stop
 
\\ ]
\\ PRINT"Music 1    from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%:RETURN
