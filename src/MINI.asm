\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE":2.MINI"
\\ B%=P%
\\ [OPT pass
 
\ On entry X=15 degree multiple value (0 to 23)
 
.minit
 LDA #&80:STA mingradder
 LDX degree
 LDA congrad,X:STA mingcon:\ gradient constant value for given angle
 LDY #1
 TXA:BNE minit3
 DEY:BEQ minit0:\ always
.minit3
 CPX #12:BCC minit0
 BNE minit4
 DEY:BEQ minit0:\ always
.minit4
 LDY #&FF
.minit0
 STY bkrelx:\ relative X change
 
 LDY #&FF
 CPX #6:BCC minit2
 BNE minit5
 INY:BEQ minit2
.minit5
 CPX #18:BCC minit1
 BNE minit2
 INY:BEQ minit2:\ always
.minit1 
 LDY #1
.minit2
 STY bkrely:\ relative Y change
 RTS
 
.minadd
 LDA mingradder:CLC
 ADC mingcon:STA mingradder:\ Add grad const to grad adder
 BCC miad0
.miad1
 LDA curx,Y:CLC:ADC bkrelx,Y:STA curx,Y
.miad
 CLC
.miad0
 LDA curx,X:ADC bkrelx,X:STA curx,X
 RTS
 
.minsub
 LDA mingradder:SEC:SBC mingcon:STA mingradder:\ Subtract grad const from grad adder
 BCS miad
 BCC miad1
 
.dmap
 JSR strxy
 LDA #0:STA track_fin
.dmap0
 JSR decode:BIT track_fin:BMI dmapex
 JSR minit:\ calculate new grad const,relx and rely
 LDA #0:STA curve_stage
.dmap1
 LDA #&11:\ opcode for ORA (ind),Y
 LDX #0:JSR promin:\ X=offset ORA value for white block
 BIT curve_stage:BPL dmap1
 JMP dmap0
 
.dmapex
 LDA #0:STA track_fin
 RTS
 
.stepblk
 LDY degree
 LDX #1:\ assume line follows Y axis
 CPY #21:BCS miaxis:\ 15 degree is 21 to 23
 CPY #3:BCC miaxis:\ 15 degree is 0 to 2
 CPY #15:BCS miaxi0
 CPY #9:BCS miaxis
.miaxi0
 DEX:\ line follows X axis so X=0
.miaxis
 TXA:EOR #1:TAY
 LDA degree:CMP #21:BCS usadr
 CMP #9:BCC usadr
 JMP minsub
.usadr
 JMP minadd
 
.pltmin
 STA indself
 STX temp2
 LDX curx:LDY cury:JSR xycalc
 STA temp1+1:STX temp1
 LDA curx:AND #3:ORA temp2:TAX
 LDA blkshf,X:STA temp2
 LDX #3:LDY #0
.pltm0
 LDA temp2
.indself
 ORA (temp1),Y:STA (temp1),Y
 LDA temp1:AND #7:BNE pltm1
 LDA temp1:SEC:SBC #&39:STA temp1
 BCS pltm2
 DEC temp1+1
.pltm2
 DEC temp1+1:BNE pltm3:\ always
.pltm1
 DEC temp1
.pltm3
 DEX:BNE pltm0
 RTS
 
.blkshf
 EQUB &88:EQUB &44:EQUB &22:EQUB &11:\ colour 3 blocks
 EQUB &80:EQUB &40:EQUB &20:EQUB &10:\ colour 1 blocks (2 EOR 3)=1
 
 
.congrad
 EQUB 0:EQUB &44:EQUB &94
 EQUB &FF:EQUB &94:EQUB &44
 EQUB 0:EQUB &44:EQUB &94
 EQUB &FF:EQUB &94:EQUB &44
 EQUB 0:EQUB &44:EQUB &94
 EQUB &FF:EQUB &94:EQUB &44
 EQUB 0:EQUB &44:EQUB &94
 EQUB &FF:EQUB &94:EQUB &44
 
.decode
 LDX secdel:STX sect_length
 LDX #&FF:STX new_sect
 INX
 STX restarted
 STX curve_stage
 STX curve_start
 LDY tdataoff:INC tdataoff:LDA (tdata),Y
 BPL deco0
 
 CMP #&FF:BNE deco
 STA track_fin:RTS
 
.deco
 STA road_direct:\ neg. value
 AND #&7F
 STA clen
 STA rlclen
 STX secparts:\ X=0
 STX degrel
 INC curve_stage:\ to 1
 RTS
 
.deco0
 AND #&1F:STA rlclen:STA clen
 INC tdataoff:INY
 LDA (tdata),Y:TAX
 AND #3:STA curve_dest:STA degrel
 TXA:LSR A:LSR A:AND #&1F:STA secparts
 LDY #0
 TXA:BPL deco1
 INY
.deco1
 STY road_direct
 
\ 'decode' drops through to 'grdstep'.
 
.grdstep
 LDA degree
 LDX road_direct:BMI grdst0:\ If straight
 BNE grdst1:\ If right curve
 
 CLC:SBC degrel
 BCS grdst2:\ Sub 1 more than curve type 0=1,1=2...
 ADC #24
.grdst2
 STA degree
 JMP minit
.grdst0
 RTS
 
.grdst1
 SEC:ADC degrel:\ add 1 more than curve type
 CMP #24:BCC grdst2
 SBC #24:BCS grdst2:\ always
 
 
.promin
 TAY:PHA:TXA:PHA:TYA
 JSR pltmin
 JSR stepblk
 PLA:TAX:PLA
 JSR pltmin
 DEC clen:BPL promex
 LDA rlclen:STA clen
 DEC secparts:BPL promex2
 LDX #&FF:STX curve_stage
 INX:STX curve_start
.promex
 RTS
.promex2
 JMP grdstep
 
\ Set up start line x,y coordinates and road 'degree' direction
 
.strxy
 JSR getrkoff
 LDA slinx,X:STA curx
 LDA sliny,X:STA cury
 LDA slind,X:STA degree
 RTS
 
\\ ]
\\ PRINT"Mini map   from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
