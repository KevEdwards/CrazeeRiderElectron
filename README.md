# Crazee Rider ( Acorn Electron )

**Version V1.00**

(c) Kevin Edwards 1986-2019

![Screenshot](screenshot.png)

In 1986 I began writing a motorcycle racing game for the BBC Micro, Electron and Master 128 home computers. This game was published by Superior Software in 1987 under the name Crazee Rider.

The game is written entirely in 6502 assemmbly language. The target computers had only 32K bytes of RAM. Of which 10K bytes was required for the video memory.

Over 30 years have passed and I have decided to preserve this code for the future by making it public.

Originally, the BBC BASIC in-line assembler was used to build the code. However, I decided to make the codebase assemble using 'beebasm' on a PC. This required me to re-work the original source code. This involved de-tokenizing all of the BBC BASIC files and adapting the code to use beebasm friendly directives / commands. This now allows Visual Code or other IDEs to be used to build the code in a nice development environment.

The code here is for the Acorn Electron version of the game. I had slightly different code for the BBC Micro and Master 128 versions. You can also find the BBC Micro source code on my GitHub account.

Due to the Electron's slower hardware it had fewer bike riders on screen at any one time. It also lacked the palette change part way down the screen that was present on the BBC Micro version. However, you can re-define the colour palette for the three main colours ( press C when on the title page ).

I hope it is useful to people who have an interest in 6502 assembly language programming and to those who wish to know how games were made in the 1980s.


# Build Tools required ( PC )

To build the game you first need to install the following tools:-

* [beebasm](https://github.com/stardot/beebasm)


# Build Steps ( PC )

Run 'make.bat' from a command prompt whilst in the project's root folder. This will assemble the code and output 'CrazeeRiderElectron.ssd' in the same folder. This disk image file can be loaded by many different BBC Micro Emulators, including B-em and BeebEm. The game is much quicker when running on a BBC Micro compared to the Electron due to hardware differences.

Alternatively, you could use 'Visual Studio Code' with the 'Beeb VSC' extension. I hope to include the required workspace and .json files required to do this.


# Additional Notes

You can find me on Twitter @KevEdwardsRetro where I ramble on about all kinds of retro computer and video game things. Please drop by and say hello.

Many thanks to Rich Talbot-Watkins for his great work on BeebAsm.

Thank you for reading this far.
