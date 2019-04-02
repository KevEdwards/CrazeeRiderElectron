\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.DOWN"
\\ MODE7:HIMEM=&6300

HIMEM=&6300
downaddr = HIMEM
osbyte = &FFF4
 
\\ FORpass=0TO2STEP2:P%=HIMEM
\\ B%=P%
\\ [OPT pass
 
 ORG downaddr
 
.download
 LDA #&8C:LDX #&C:JSR osbyte
 LDA #15:LDX #0:JSR osbyte:\ Flush all buffers
 LDA #26:JSR &FFEE:\ Remove text window (tape needs this!)
 LDA #4:LDX #1:JSR osbyte
 LDA #16:LDX #0:JSR osbyte:\ No A to D sampling
 LDA #163:LDX #128:LDY #1:JSR osbyte:\ No Plus 1 irqs etc
 LDA #178:LDX #0:LDY #0:JSR osbyte:\ Kbd irqs off!
 
 SEI
 LDX #&F:LDA #0
.zaproms
 STA &2A1,X:DEX:BPL zaproms
 
 LDX #&9F
.killzp
 STA 0,X:DEX:BNE killzp
 STA 0
 CLI
 
.clrabsram
 STA &400,X
 STA &500,X
 STA &600,X
 STA &700,X
 INX:BNE clrabsram
 
\ Copy &127 bytes at HIMEM+&100 to &6D9 ( end byte to &7FF )
 
.downfnt
 LDA HIMEM+&100,X:STA &6D9,X
 INX:BNE downfnt
 LDX #&26
.downfnt0
 LDA HIMEM+&200,X:STA &7D9,X
 DEX:BPL downfnt0
 
 LDX #22*6-1
.downames
 LDA HIMEM+&227+&A0,X:STA &655,X
 DEX:CPX #&FF:BNE downames
 
 INX:\ X=0!
 LDY #&58-&E:\ program length
.download2
 LDA &1900,X:STA &E00,X
 INX:BNE download2
 INC download2+2
 INC download2+5
 DEY:BNE download2
 
 LDA #0:TAY:LDX #5
.erasetop
 STA &5800,Y
 INY:BNE erasetop
 INC erasetop+2
 DEX:BNE erasetop
 
.dispscr
 LDA HIMEM+&227,X:STA &5808,X
 LDA HIMEM+&227+&50,X:STA &5948,X
 INX:CPX #&50:BCC dispscr
 
 
 LDX #&FF:TXS
 CLI:CLD
 JMP &E00:\ Game start address
 
 
\\ ]NEXT
\\ *LOAD O.CHARDAT 6400
\\ *LOAD :2.O.SCORE 6527
\\ *LOAD :2.O.ENTRIES 65C7

 ORG &6400
 INCBIN "object\O.CHARDAT"

 ORG &6527
 INCBIN "object\O.SCORE"

 ORG &65C7
 INCBIN "object\O.ENTRIES"

\\ PRINT" *SAVE :2.O.DOWN ";~HIMEM;" ";~HIMEM+&227+&A0+22*6

