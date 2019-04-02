\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"MODULE"
\\ B%=P%
\\ [OPT pass

\\ Re-map EQUS strings for this file - reset below!
MAPCHAR ' ','Z', 0
 
.framev
 BIT fjtype:BPL fraext:\ Exit if first byte selected
 
 BIT &FC72:BVS fraext:\ A to D not completed
 TYA:PHA
 LDA &FC70
.framjy
 LDY #0:STA joyval,Y
 TYA:EOR #1:STA framjy+1
 ORA #4:STA &FC70:\ Start next conversion
 PLA:TAY
 
.fraext
 LDA #4:PLP:RTS
 
.pstring
 LDA strptab,Y:STA temp1
 CLC:ADC #3:STA charloc+1
 LDA strptab+1,Y:STA temp1+1
 ADC #0:STA charloc+2
 
 LDY #0
 LDA (temp1),Y:TAX
 AND #&F8:STA temp2
 TXA:AND #3:STA temp3+1:\ pix.off.
 INY:LDA (temp1),Y:STA temp2+1
 INY:LDA (temp1),Y
 AND #&88:STA temp4+1:STA temp5
 LDX temp3+1:BEQ charloc
.pst0
 LSR temp5
 DEX:BNE pst0
 
.charloc
 LDA &FFFF
 BMI pst_pixright
 STA temp4
 LDX #charset DIV 256
 ASL A:ASL A:\ I assume A<64!
 ADC temp4:BCC pst1
 INX:CLC
.pst1
 ADC #charset MOD 256
 BCC pst2
 INX
.pst2
 STA charbase+1:STX charbase+2
 LDX #0
.charbase
 LDA &FFFF,X
 STA temp5+1:\ char. def. byte
 LDY #7
.pst3
 ASL temp5+1:\ test 1 in char.def.
 BCC pst4:\ Skip if pixel unset!
 LDA temp5:\ colour shift byte
 EOR (temp2),Y
 STA (temp2),Y
.pst4
 DEY:BPL pst3
 JSR pst_pixright
 INX:CPX #5:BNE charbase
 JSR pst_pixright
 INC charloc+1:BNE charloc
 INC charloc+2:JMP charloc
 
.pst_pixright
 LSR temp5
 INC temp3+1:LDA temp3+1
 CMP #4:BCC pst_pr0
 
 LDA #0:STA temp3+1
 LDA temp4+1:STA temp5
 LDA temp2:ADC #7:\ c=1 here!
 STA temp2
 BCC pst_pr0
 INC temp2+1
.pst_pr0
 RTS
 
.strptab
 EQUW gamename
 EQUW myname
 EQUW superior
 EQUW prespc
 EQUW timbon
 EQUW txbondig
 EQUW trkcomp
 EQUW younotqual
 EQUW txnewh
 EQUW todays
 EQUW trackvalue
 EQUW keylet
 EQUW txnam
 EQUW pwrd1:\      Passwords in 'TRACK1'
 EQUW pwrd2
 EQUW wdone:\ In 'TRACK1'
 EQUW txhsline:\ In 'HIGH'
 EQUW txent:\ In 'HIGH'
 EQUW txpal0:\ Text for palette changing
 EQUW txpal1
 EQUW txpal2
 EQUW txpal3
 EQUW txpal4
 EQUW txpal5
 EQUW pwrd3
 
.gamename
 EQUW &6118:EQUB &88
 EQUS "CRAZEE RIDER"
 EQUB &FF
 
.myname
 EQUW &6380:EQUB &80
 EQUS "BY KEVIN EDWARDS"
 EQUB &FF
 
.superior
 EQUW &74C8:EQUB &08
 EQUS "(C) SUPERIOR SOFTWARE '87"
 EQUB &FF
 
.prespc
 EQUW &7130:EQUB &88
 EQUS "PRESS SPACE TO PLAY"
 EQUB &FF
 
.timbon
 EQUW &64A8:EQUB &88
 EQUS "'HITS' BONUS :"
 EQUB &FF
 
.txbondig
 EQUW &6558:EQUB &80
.bonusdig
 EQUS "00000"
 EQUB &FF
 
.trkcomp
 EQUW &6108:EQUB &08
 EQUS "TRACK COMPLETED"
 EQUB &FF
 
.younotqual
 EQUW &725A:EQUB &88
 EQUS "YOU HAVE NOT QUALIFIED"
 EQUB &FF
 
.txnewh
 EQUW &60FA:EQUB &08
 EQUS "A NEW HIGH SCORE!"
 EQUB &FF
 
 
.todays
 EQUW &60F0:EQUB &08
 EQUS "TODAY'S BEST SCORES"
 EQUB &FF
 
.trackvalue
 EQUW &69EA:EQUB &80
 EQUS "TRACK "
.txttrknum
 EQUS "001"
 EQUB &FF
 
.keylet
 EQUW &FFFF:EQUB &80
.keychar
 EQUB 0:\ self modified
 EQUB &FF
 
.txnam
 EQUW &6C40:EQUB &88:\ Low byte is self modified
.ttnam
 EQUS "12345678901234"
 EQUB &FF
 
.txpal0
 EQUW &6110:EQUB &88
 EQUS "PRESS 1,2 OR 3"
 EQUB &FF
 
.txpal1
 EQUW &6381:EQUB &88
 EQUS "TO CYCLE COLOURS"
 EQUB &FF
 
.txpal2
 EQUW &68B0:EQUB &08
 EQUS "COLOUR 1"
 EQUB &FF
 
.txpal3
 EQUW &6B30:EQUB &80
 EQUS "COLOUR 2"
 EQUB &FF
 
.txpal4
 EQUW &6DB0:EQUB &88
 EQUS "COLOUR 3"
 EQUB &FF
 
.txpal5
 EQUW &7292:EQUB &80
 EQUS "SPACE TO EXIT"
 EQUB &FF
 
.sndskd
 EQUW &11:EQUW 2:EQUW 120:EQUW 10
.cbsndlit
 EQUW &11:EQUW -15:EQUW 0:EQUW 0
.cbsndbon
 EQUW &11:EQUW -15:EQUW 130:EQUW 1
 
.cbsndbrm
 EQUW &11:EQUW 1:EQUW 30:EQUW 12
 
.sndcrun
 LDX #cbcru MOD 256:LDY #cbcru DIV 256:BNE sound
.cbcru
 EQUW &11:EQUW 3:EQUW 160:EQUW 10
 
.brm
 JSR rand:BPL brm0
 RTS
.brm0
 AND #7:ADC #30:STA cbsndbrm+4:\ Randomish pitch value
 LDX #cbsndbrm MOD 256:LDY #cbsndbrm DIV 256:BNE sound
 
.sndlit
 STX cbsndlit+4
 LDA #6
 CPX #76:BEQ snlit0:\ was 60
 ASL A
.snlit0
 STA cbsndlit+6
 LDX #cbsndlit MOD 256
 LDY #cbsndlit DIV 256
 
.sound
 BIT fsound:BPL sndisoff
 LDA #7:JMP osword
.sndisoff
 RTS
 
.sndbon
 LDX #cbsndbon MOD 256
 LDY #cbsndbon DIV 256
 BNE sound:\ always
 
.sndrevs
 LDA myspeed:LDY #4
.snrev
 CMP spdtab,Y:BCS snrev0:DEY:BNE snrev
.snrev0
 LDA myspeed
 SEC:SBC spdtab,Y
 ASL A
 ADC spdbase,Y:TAX
 LDA curvol:SEC:SBC #12:\ was 8
 BCS snrev4
 LDA #0
.snrev4
 STA curvol:CPX curvol:BCC snrev3:STX curvol
.snrev3
 LDX curvol
 LDA myx:CMP #138:BCS adjpit
 CMP #12:TXA:BCS norpit
.adjpit
 LDA seed+1:AND #7:CMP #3:TXA:BCS norpit
 SBC #3
.norpit
 LSR A:STA cbsnd11+4
 LDA medisabled:BNE sndisoff
 LDA argdel:BNE fxdely
 LDA startoff:BNE stnosnd:\ No revs until lights erased/last beep over
 LDX #cbsnd11 MOD 256:LDY #cbsnd11 DIV 256:BNE sound
 
.cbsnd11
 EQUW &11:EQUW -9:EQUW 0:EQUW 4
 
.fxdely
 DEC argdel
.stnosnd
 RTS
 
.spdtab
 EQUB 0:EQUB 30:EQUB 60:EQUB 90:EQUB 120
.spdbase
 EQUB 30:EQUB 55:EQUB 100:EQUB 130:EQUB 155
 
.argh
 EQUW &11:EQUW 8:EQUW 80:EQUW 5
 
.boucr
 EQUW &11:EQUW 10:EQUW 100:EQUW 5
 
.bpass
 EQUW &11:EQUW -12:EQUW 1:EQUW 3
 

\\ Re-map Back to normal ASCII
MAPCHAR ' ','Z', 32

\\ ]
\\ PRINT"900 module from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ P%=&E00:O%=HIMEM+&400:C%=P%
\\ PAGE=PG%
\\ RETURN
 
\\ DEF FNmyascii(oldasc$)
\\ IF pass>4 O%=O%+LEN(oldasc$):P%=P%+LEN(oldasc$):=pass
\\ FORL%=1TOLEN(oldasc$)
\\ ?(O%+L%-1)=ASC(MID$(oldasc$,L%,1))-32
\\ NEXT
\\ O%=O%+LEN(oldasc$)
\\ P%=P%+LEN(oldasc$)
\\ =pass
