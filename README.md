# 6502 PCB Computer

## INTRODUCTION
- I was in highschool in the eighties when the *home computer revolution* introduced the world to computers running the MOS6502 and Z80 microprocessors.
- My first computer was an Atari 400 which used a 6502.
- When I added two numbers together in BASIC for the first time on that computer, I was hooked.   To this day, I am fascinated with computers.
- I couldn't help feeling nostalgic when I stumbled upon Ben Eater's excellent https://eater.net/6502 webpage, in which he describes how to build a 6502 computer on a breadboard.
- I quickly found out how difficult working with breadboards can be RE: unreliable connections, etc.  One loose wire was all it took to make the computer unusable.
- I therefore abandoned the breadboard altogether and instead decided to build a PCB.
- I had no idea how to do this; I could not even solder.  But I figured all of that out, and eventually I had a PCB that can run *HELLO WORLD* and *WOZMON*.
- This repository has all of the files necessary to build that PCB.

## PCB DESCRIPTION

![Hello World](photos/hello_world.png)

|General Information||
|-|-|
|Microprocessor|WDC 65c02|
|I/O|65c22|
|UART|65c51|
|Clock|1MHz|
|ROM|32KB|
|RAM|32KB|
|Display|40x2 character LCD|
|Baud Rate|19200 8N1|

The upper left corner of the PCB has ports for +5V (barrel connector) and an RS-232 nine-pin serial cable.  
PWR and CLK LED's will illuminate when power and a clock signal (from the onboard 1MHz clock) are present, respectively.
The PCB can be reset via the RESET button directly below the RS-232 port.  The RESET LED will illuminate when the RESET button is pressed.

A column of output header pins is positioned immediately to the left of the LCD.  These output pins were primarily used for testing.  The top four pins are for GND.  (I used then when connecting the ground lead of an oscilloscope to the PCB.)  The bottom four pins are TxD, MAX232 pin 12, RESET*, and the CLOCK signal.  You can leave these pins unconnected if you don't want to use them.

## SOFTWARE 

The following software is included.

|Description|Files|Other Information|
|-|-|-|
|HELLO WORLD|xxx|Prints *HELLO WORLD 6502* on the LCD.|
|WOZMON|xxx|Runs Wozmon as described in Ben's *Running Apple 1 software on a breadboard computer (Wozmon)* YouTube video.|

The computer *does not  run the version of Microsoft BASIC* that Ben describes on his channel.  I have not figured (yet?) why that is so.  But it does run an alternate version of BASIC I found on Github.  See https://github.com/Fifty1Ford/BeEhBasic for more information.

## KICAD FILES

I used KiCad 6 to design the PCB.  
|Filename|Description|
|-|-|
|6502_wozmon.kicad_pro|KiCad 6 Project File|
|6502_wozmon.kicad_sch|KiCad 6 Schematic|
|6502_wozmon.kicad_pcb|KiCad 6 PCB File|
|6502_wozmon.csv|Bill of Materials|
|barrel_jack.pdf|Barrel Jack Power Connector|
|schematic.pdf|Schematic|
|photos/*.png|Photos|
|gerber/*|Gerber Files|

## CLOSING COMMENTS
- I am a hobbyist.  There are no doubt many ways to improve this design.  Feel free to do so! 
- I use a ZIF socket for the ROM chip to make it easier to remove.  
