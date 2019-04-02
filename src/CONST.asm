\\
\\ Crazee Rider ( Acorn Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\ (c) Kevin Edwards 1986-2019
\\ Twitter @KevEdwardsRetro

\\ REM SAVE"CONST"
 
road_height=80
leftx=0
rightx=159-leftx
 
ybase=&FF-12*8
ytop=ybase-(road_height-1)
consoletop=&FF-6*8
 
pantopy=127 \\ :REM top of control panel 'Y' coord. minus 1 from top of road
 
centre=80
 
maxspeed=150
 
myy=115
 
\\ REM size of sprite graphics for sizes 0 to 3
spsiz=5*30
spsiz1=4*24
spsiz2=3*18
spsiz3=2*12
 
 
maxbikes=3      \\ :REM max. no. of other bikes allowed on screen together
obikesracing=59 \\ :REM no. of other bikes in race
maxstep=7       \\ :REM max. no of pixels the bike moves up/down, was 3 then 4
obatstart=2     \\ :REM no. of other bikes at start line
 
ymin=23     \\ :REM min Y value for bike, was 26
ymax=162    \\ :REM If bike Y>= to this it's out of bounds, was 166
xmin=19     \\ :REM Min. acceptable xoff at 'ymax'
xmax=140    \\ :REM Max. acceptable xoff at 'ymax'
xmiddle=75  \\ :REM 'xoff' value at 'ymin'
 
 
charset=&800-&127   \\ :REM Start address of my character set
hsbase=charset-22*6 \\ :REM High score entries just below character set!
 
osasci=&FFE3
osbyte=&FFF4
oswrch=&FFEE
osword=&FFF1
osrdch=&FFE0
 
\\ PAGE=PG%
\\ RETURN
