DECLARE SUB clearbot ()
DECLARE SUB savemap (filename$, timelim$, graphic$)
DECLARE SUB addtomap (atx%, aty%, atsel%)
DECLARE SUB makemap ()
DECLARE SUB clearwindow ()
DECLARE SUB page (field$)
DECLARE SUB ckbutton (nom%)
DECLARE SUB mkbutton (x!, y!, nom%, txt$)
DECLARE SUB cktxbox (nom%, typ$, masked%)
DECLARE SUB mktxbox (x!, y!, nom%, length%)
DECLARE SUB loadBMP (file$)
DECLARE SUB Zoom (x)
'ON ERROR GOTO fier


'********************************* INI *************************************

               
    DEFINT A-V
    DECLARE SUB mouse (cx, dx, bx)
    DIM SHARED mx, my, mz


    DECLARE SUB mousepointer (SW)
    DIM SHARED A(9)                 'Set up array for code
                                                     
    DIM SHARED putback(125)

    
    DIM SHARED wall1(100)
    DIM SHARED wall2(100)
    DIM SHARED wall3(100)
    DIM SHARED wall4(100)
    DIM SHARED wall5(100)
    DIM SHARED wall6(100)
    DIM SHARED wall7(100)
    DIM SHARED wall8(100)
    DIM SHARED wall9(100)
    DIM SHARED rock(100)
    DIM SHARED dimond(100)
    DIM SHARED Repton(100)
    DIM SHARED spirit(100)
    DIM SHARED cage(100)
    DIM SHARED bomb(100)
    DIM SHARED earth(100)
    DIM SHARED safe(100)
    DIM SHARED keyy(100)
    DIM SHARED egg(100)
    DIM SHARED tran(100)
    DIM SHARED skull(100)
    DIM SHARED crown(100)
    DIM SHARED space(100)
    DIM SHARED timecap(100)
   
sva = 20
del = 2

SCREEN 13
CLS

pause! = TIMER + 1
DO
LOOP UNTIL pause! > TIMER

x = 50: Xdelta = 8: r = 32: B = 0: g = 32

DO WHILE x < 680 AND x > 1
     
PALETTE 72, 65536 * B
     
      x = x + Xdelta
      CALL Zoom(x)
        FOR i = 1 TO 4000
        NEXT i
   
        B = B + 1
            IF B > 63 THEN B = 63

    'D
    LINE (-135, 100)-(-210, 100), 0
    LINE (-135, 100)-(-135, -100), 0
    LINE (-135, -100)-(-210, -100), 0
    LINE (-200, 100)-(-200, -100), 0
    'A
    LINE (-50, 100)-(25, 100), 0
    LINE (-50, 100)-(-50, -100), 0
    LINE (-50, 0)-(25, 0), 0
    LINE (25, 100)-(25, -100), 0
    'N
    LINE (105, 100)-(180, -100), 0
    LINE (180, 100)-(180, -100), 0
   
    LINE (105, 100)-(105, -100), 0

LOOP

B = 1

FOR A = 75 TO 1 STEP -1

    PALETTE B, 256 * B + B
    PALETTE 100, 18
    PALETTE 101, 10

    CIRCLE (-500, 0), A, B
    PAINT (-500, 0), B
COLOR 72
LOCATE 7, 15
PRINT "Extravaganza"
LOCATE 19, 17
PRINT "Presents..."
   
    LINE (-420, -10)-(450, 5), 101, BF
    LINE (-415, -3)-(445, -3), 100

    CALL Zoom(x)

    B = B + 1
        IF B > 63 THEN B = 63
NEXT
CALL Zoom(x)

pause! = TIMER + 1
DO
LOOP UNTIL pause! > TIMER

SCREEN 12

'Get Graghics
CALL loadBMP("reptoned.rep")

n = 0
FOR gy = 1 TO 47 STEP 15
    FOR gx = 2 TO 121 STEP 15
        n = n + 1
        IF n = 1 THEN GET (gx, gy)-(gx + 14, gy + 14), dimond
        IF n = 2 THEN GET (gx, gy)-(gx + 14, gy + 14), rock
        IF n = 3 THEN GET (gx, gy)-(gx + 14, gy + 14), Repton
        IF n = 4 THEN GET (gx, gy)-(gx + 14, gy + 14), wall8
        IF n = 5 THEN GET (gx, gy)-(gx + 14, gy + 14), wall2
        IF n = 6 THEN GET (gx, gy)-(gx + 14, gy + 14), wall6
        IF n = 7 THEN GET (gx, gy)-(gx + 14, gy + 14), wall4
        IF n = 8 THEN GET (gx, gy)-(gx + 14, gy + 14), wall5
        IF n = 9 THEN GET (gx, gy)-(gx + 14, gy + 14), wall9
        IF n = 10 THEN GET (gx, gy)-(gx + 14, gy + 14), wall7
        IF n = 11 THEN GET (gx, gy)-(gx + 14, gy + 14), wall3
        IF n = 12 THEN GET (gx, gy)-(gx + 14, gy + 14), wall1
        IF n = 13 THEN GET (gx, gy)-(gx + 14, gy + 14), earth
        IF n = 14 THEN GET (gx, gy)-(gx + 14, gy + 14), safe
        IF n = 15 THEN GET (gx, gy)-(gx + 14, gy + 14), keyy
        IF n = 16 THEN GET (gx, gy)-(gx + 14, gy + 14), timecap
        IF n = 17 THEN GET (gx, gy)-(gx + 14, gy + 14), egg
        IF n = 18 THEN GET (gx, gy)-(gx + 14, gy + 14), crown
        IF n = 19 THEN GET (gx, gy)-(gx + 14, gy + 14), cage
        IF n = 20 THEN GET (gx, gy)-(gx + 14, gy + 14), spirit
        IF n = 21 THEN GET (gx, gy)-(gx + 14, gy + 14), bomb
        IF n = 22 THEN GET (gx, gy)-(gx + 14, gy + 14), tran
        IF n = 23 THEN GET (gx, gy)-(gx + 14, gy + 14), skull
        IF n = 24 THEN GET (gx, gy)-(gx + 14, gy + 14), space
        
   
    NEXT gx
NEXT gy

CLS



    DEF SEG = VARSEG(A(0))          'Get array segment (nnnn:    )
                                    '    (two 8 bit)
    FOR i = 0 TO 17                 'length of DATA to
       READ r                       'read
       POKE VARPTR(A(0)) + i, r     'into array/2 (nnnn:iiii) (one 8 bit)
    NEXT i                          'until 17

'**************************** Machine Code *********************************

DATA &HB8,&H00,&H00   :   ' mov  AX,[n]       [Swap code-(L),(H)] in AX
DATA &H55             :   ' push BP           Save BP
DATA &H8B,&HEC        :   ' mov  BP,SP        Get BP to c Seg
DATA &HCD,&H33        :   ' int  33           Interrupt 33
DATA &H92             :   ' xchg AX,[reg]     [Swap code-reg] in AX
DATA &H8B,&H5E,&H06   :   ' mov  BX,[BP+6]    Point to (variable)
DATA &H89,&H07        :   ' mov  [BX],AX      Put AX in (variable)
DATA &H5D             :   ' pop  BP           Restore BP
DATA &HCA,&H02,&H00   :   ' ret  2            Far return

mousepointer 0: mousepointer 3:
'mousepointer 1

TYPE txboxsup
x1 AS INTEGER
y1 AS INTEGER
y2 AS INTEGER
x2 AS INTEGER
length AS INTEGER
nom AS INTEGER
masked AS INTEGER
END TYPE
DIM SHARED txbox(100) AS txboxsup
DIM SHARED txboxtxt$(100)

TYPE buttonsup
x1 AS INTEGER
y1 AS INTEGER
y2 AS INTEGER
x2 AS INTEGER
nom AS INTEGER
click AS INTEGER
END TYPE
DIM SHARED button(100) AS buttonsup

TYPE gridd
dat AS INTEGER
END TYPE
DIM SHARED mapgrid(810) AS gridd




mode$ = "start"


'Setup screen

setup:

CALL clearbot

FOR n = 1 TO 28
LOCATE n, 68
PRINT CHR$(186); SPC(11);
NEXT n



SELECT CASE mode$
   
    CASE "start"
        'Graphics...
        CALL makemap
        LOCATE 27, 1
        PRINT "MAP Editor v1 "; : COLOR 7: PRINT "for Repton Returns v1   (C)2000"
        PRINT "From "; : COLOR 4: PRINT "Ex-D software development "; : COLOR 7: PRINT "(tm)"
       
        'Buttons...
        CALL mkbutton(70, 2, 1, "New")
        CALL mkbutton(70, 4, 2, "Open")
        CALL mkbutton(70, 6, 3, "Save")
              
        CALL mkbutton(70, 22, 4, "Help")
        CALL mkbutton(70, 24, 5, "About")

        CALL mkbutton(70, 28, 6, "Exit")

        CALL mkbutton(59, 2, 7, " ")
        CALL mkbutton(64, 2, 8, " ")
        CALL mkbutton(59, 4, 9, " ")
        CALL mkbutton(64, 4, 10, " ")
        CALL mkbutton(59, 6, 11, " ")
        CALL mkbutton(64, 6, 12, " ")
        CALL mkbutton(59, 8, 13, " ")
        CALL mkbutton(64, 8, 14, " ")
        CALL mkbutton(59, 10, 15, " ")
        CALL mkbutton(64, 10, 16, " ")
        CALL mkbutton(59, 12, 17, " ")
        CALL mkbutton(64, 12, 18, " ")
        CALL mkbutton(59, 14, 19, " ")
        CALL mkbutton(64, 14, 20, " ")
        CALL mkbutton(59, 16, 21, " ")
        CALL mkbutton(64, 16, 22, " ")
        CALL mkbutton(59, 18, 23, " ")
        CALL mkbutton(64, 18, 24, " ")
        CALL mkbutton(59, 20, 25, " ")
        CALL mkbutton(64, 20, 26, " ")
        CALL mkbutton(59, 22, 27, " ")
        CALL mkbutton(64, 22, 28, " ")
        CALL mkbutton(59, 24, 29, " ")
        CALL mkbutton(64, 24, 30, " ")
       
        dat = 0
        FOR cy = 0 TO 11
            FOR cx = 0 TO 1
                pcx = 468 + (cx * 40): pcy = 16 + (cy * 16 * 2): GOSUB putchrr
                dat = dat + 1
            NEXT cx
        NEXT cy
   
    CASE "new"
        'Buttons...
        CALL mkbutton(70, 2, 1, "Yes")
        CALL mkbutton(70, 4, 2, "No")
   
    CASE "open"
       
        'Buttons...
        CALL mkbutton(70, 26, 1, "Okay")
        CALL mkbutton(70, 28, 2, "Cancel")
   
    CASE "save"
        'Buttons...
        CALL mkbutton(70, 26, 1, "Okay")
        CALL mkbutton(70, 28, 2, "Cancel")

        LOCATE 27, 2: PRINT "MAP name:"
        CALL mktxbox(2, 28, 1, 8)

        LOCATE 27, 14: PRINT "Time Limit(sec/s):"
        CALL mktxbox(14, 28, 2, 4)

        LOCATE 27, 34: PRINT "Graphics:"
        CALL mkbutton(34, 28, 3, "Built-in")
       
END SELECT

pass = 0

DO
oldmode$ = mode$
typ$ = INKEY$

CALL mouse(my, mx, mz)
'Area Restriction...
 IF my > 445 THEN my = 445
 IF mx > 620 THEN mx = 620
IF typ$ <> "" OR lmy <> my OR lmx <> mx OR lmz <> mz THEN
IF pass = 1 THEN PUT (lmx, lmy), putback, PSET


SELECT CASE mode$
    CASE "start"
        
        CALL ckbutton(1): IF button(1).click = 1 THEN mode$ = "new"
        CALL ckbutton(2): IF button(2).click = 1 THEN mode$ = "open"
        CALL ckbutton(3): IF button(3).click = 1 THEN mode$ = "save"
       
        CALL ckbutton(4): IF button(6).click = 1 THEN mode$ = "help"
        CALL ckbutton(5): IF button(5).click = 1 THEN mode$ = "about"
       
        CALL ckbutton(6): IF button(6).click = 1 THEN END

        CALL ckbutton(7): IF button(7).click = 1 THEN selt = 0
        CALL ckbutton(8): IF button(8).click = 1 THEN selt = 1
        CALL ckbutton(9): IF button(9).click = 1 THEN selt = 2
        CALL ckbutton(10): IF button(10).click = 1 THEN selt = 3
        CALL ckbutton(11): IF button(11).click = 1 THEN selt = 4
        CALL ckbutton(12): IF button(12).click = 1 THEN selt = 5
        CALL ckbutton(13): IF button(13).click = 1 THEN selt = 6
        CALL ckbutton(14): IF button(14).click = 1 THEN selt = 7
        CALL ckbutton(15): IF button(15).click = 1 THEN selt = 8
        CALL ckbutton(16): IF button(16).click = 1 THEN selt = 9
        CALL ckbutton(17): IF button(17).click = 1 THEN selt = 10
        CALL ckbutton(18): IF button(18).click = 1 THEN selt = 11
        CALL ckbutton(19): IF button(19).click = 1 THEN selt = 12
        CALL ckbutton(20): IF button(20).click = 1 THEN selt = 13
        CALL ckbutton(21): IF button(21).click = 1 THEN selt = 14
        CALL ckbutton(22): IF button(22).click = 1 THEN selt = 15
        CALL ckbutton(23): IF button(23).click = 1 THEN selt = 16
        CALL ckbutton(24): IF button(24).click = 1 THEN selt = 17
        CALL ckbutton(25): IF button(25).click = 1 THEN selt = 18
        CALL ckbutton(26): IF button(26).click = 1 THEN selt = 19
        CALL ckbutton(27): IF button(27).click = 1 THEN selt = 20
        CALL ckbutton(28): IF button(28).click = 1 THEN selt = 21
        CALL ckbutton(29): IF button(29).click = 1 THEN selt = 22
        CALL ckbutton(30): IF button(30).click = 1 THEN selt = 23
      
                                                                 
        IF oldselt <> selt THEN
            pcx = 490: pcy = 410: dat = selt: GOSUB putchrr
        END IF

        oldselt = selt

        IF mx > 0 AND my > 0 AND mx < 450 AND my < 405 AND mz = 1 THEN
            ggxn = 1
            ggyn = 1
       
            FOR ggx = 0 TO 450 STEP 15
               IF mx > ggx AND mx < ggx + 16 THEN datx = ggxn: GOTO goutggx
               ggxn = ggxn + 1
            NEXT ggx
      
goutggx:

            FOR ggy = 0 TO 405 STEP 15
               IF my > ggy AND my < ggy + 16 THEN daty = ggyn: GOTO goutggy
               ggyn = ggyn + 1
            NEXT ggy
      
goutggy:

           
            CALL addtomap(ggxn, ggyn, selt)

            pcx = 15 * ggxn - 15: pcy = 15 * ggyn - 15: dat = selt: GOSUB putchrr

        END IF
         
   
    CASE "save"
        CALL ckbutton(1)
            IF button(1).click = 1 AND LEN(txboxtxt$(1)) > 0 AND LEN(txboxtxt$(2)) > 2 THEN
                IF othergr <> 1 THEN graphic$ = "perlude" ELSE graphic$ = txboxtxt$(3)
                CALL savemap(txboxtxt$(1), txboxtxt$(2), graphic$)
                mode$ = "start"
            END IF

        CALL ckbutton(2): IF button(2).click = 1 THEN mode$ = "start"

        CALL ckbutton(3)
            IF button(3).click = 1 THEN
                othergr = 1  'As in, other + gr=graphics  =  <other graphics>
                LOCATE 27, 46: PRINT "Folder:"
                CALL mktxbox(46, 28, 3, 8)
                CALL mkbutton(34, 28, 3, " Other: ")
            END IF
       
        CALL cktxbox(1, typ$, 0) 'Text box number, text to add, masked
        CALL cktxbox(2, typ$, 0)

        IF othergr = 1 THEN CALL cktxbox(3, typ$, 0)
END SELECT


'Handle mouse pointer
GET (mx, my)-(mx + 11, my + 11), putback
'Re/Make mouse pointer
LINE (mx, my)-(mx + 10, my + 5), 15
LINE (mx, my)-(mx + 5, my + 10), 15
LINE (mx + 10, my + 5)-(mx + 5, my + 5), 15
LINE (mx + 5, my + 10)-(mx + 5, my + 5), 15

'LOCATE 1, 1: PRINT mx, my, mz



pass = 1
END IF
lmx = mx
lmy = my
lmz = mz
LOOP UNTIL mode$ <> oldmode$
GOTO setup


'Gosubs/Gotos...

putchrr:
      IF dat = 0 THEN PUT (pcx, pcy), space, PSET
      IF dat = 1 THEN PUT (pcx, pcy), dimond, PSET
      IF dat = 2 THEN PUT (pcx, pcy), wall8, PSET
      IF dat = 3 THEN PUT (pcx, pcy), wall2, PSET
      IF dat = 4 THEN PUT (pcx, pcy), wall6, PSET
      IF dat = 5 THEN PUT (pcx, pcy), wall4, PSET
      IF dat = 6 THEN PUT (pcx, pcy), wall5, PSET
      IF dat = 7 THEN PUT (pcx, pcy), wall9, PSET
      IF dat = 8 THEN PUT (pcx, pcy), wall7, PSET
      IF dat = 9 THEN PUT (pcx, pcy), wall3, PSET
      IF dat = 10 THEN PUT (pcx, pcy), wall1, PSET
      IF dat = 11 THEN PUT (pcx, pcy), rock, PSET
      IF dat = 12 THEN PUT (pcx, pcy), Repton, PSET
      IF dat = 13 THEN PUT (pcx, pcy), spirit, PSET
      IF dat = 14 THEN PUT (pcx, pcy), cage, PSET
      IF dat = 15 THEN PUT (pcx, pcy), bomb, PSET
      IF dat = 16 THEN PUT (pcx, pcy), earth, PSET
      IF dat = 17 THEN PUT (pcx, pcy), safe, PSET
      IF dat = 18 THEN PUT (pcx, pcy), keyy, PSET
      IF dat = 19 THEN PUT (pcx, pcy), egg, PSET
      IF dat = 20 THEN PUT (pcx, pcy), tran, PSET
      IF dat = 21 THEN PUT (pcx, pcy), skull, PSET
      IF dat = 22 THEN PUT (pcx, pcy), crown, PSET
      IF dat = 23 THEN PUT (pcx, pcy), timecap, PSET
RETURN

DEFSNG A-V
SUB addtomap (atx%, aty%, atsel%)
n = 0
FOR y = 1 TO 27
    FOR x = 1 TO 30
        n = n + 1
        IF x = atx% AND y = aty% THEN GOTO getoutatm
    NEXT x
NEXT y

getoutatm:

mapgrid(n).dat = atsel%
END SUB

DEFINT A-V
SUB ckbutton (nom)

button(nom).click = 0

'Check for mouse is in area, if so, then put box around box
LINE (button(nom).x1 - 1, button(nom).y1 - 1)-(button(nom).x2 + 1, button(nom).y2 + 1), 0, B
IF mx > button(nom).x1 AND mx < button(nom).x2 AND my < button(nom).y2 AND my > button(nom).y1 THEN
LINE (button(nom).x1 - 1, button(nom).y1 - 1)-(button(nom).x2 + 1, button(nom).y2 + 1), 14, B

'Check for click
IF mz <> 0 THEN button(nom).click = 1

END IF

END SUB

SUB cktxbox (nom, typ$, masked)

LINE (txbox(nom).x1 - 1, txbox(nom).y1 - 1)-(txbox(nom).x2 + 1, txbox(nom).y2 + 1), 0, B

IF mx > txbox(nom).x1 AND mx < txbox(nom).x2 AND my < txbox(nom).y2 AND my > txbox(nom).y1 THEN
LINE (txbox(nom).x1 - 1, txbox(nom).y1 - 1)-(txbox(nom).x2 + 1, txbox(nom).y2 + 1), 14, B

lgh = LEN(txboxtxt$(nom))

IF typ$ <> "" THEN

'Detect backspace
IF typ$ = CHR$(8) THEN
IF lgh = 0 THEN BEEP: EXIT SUB
txboxtxt$(nom) = LEFT$(txboxtxt$(nom), lgh - 1)
LOCATE txbox(nom).y1 / 16 + 1, (txbox(nom).x1) / 8 + lgh
PRINT " "
GOTO outt
END IF

'Detect 'enter key'
IF typ$ = CHR$(13) THEN
BEEP
EXIT SUB
END IF

'Limit text length
IF lgh > txbox(nom).length - 1 THEN BEEP: EXIT SUB
IF lgh > txbox(nom).length - 2 AND masked = 1 THEN BEEP: EXIT SUB
                                            
'Add the key to string$
txboxtxt$(nom) = txboxtxt$(nom) + typ$

'Print the string$
outt:

LOCATE txbox(nom).y1 / 16 + 1, (txbox(nom).x1) / 8 + 1

'Consider masking...
IF masked = 1 THEN
    lgh = LEN(txboxtxt$(nom))
    FOR ma = 0 TO lgh: PRINT " "; : NEXT ma
    LOCATE txbox(nom).y1 / 16 + 1, (txbox(nom).x1) / 8 + 1
    FOR mb = 0 TO lgh - 1: PRINT "*"; : NEXT mb
ELSE
    PRINT txboxtxt$(nom)
END IF

END IF

END IF

END SUB

SUB clearbot

LOCATE 27, 1: PRINT SPC(60);
LOCATE 28, 1: PRINT SPC(60);

LINE (1, 448)-(640, 480), 0, BF

END SUB

SUB loadBMP (file$)
DIM byte AS STRING * 1
CLS
data$ = file$

IF LTRIM$(RTRIM$(data$)) = "" THEN END
OPEN data$ FOR BINARY AS #1
IF LOF(1) = 0 THEN PRINT "File not found!": CLOSE : KILL data$: END

table$ = INPUT$(54, #1)
DIM table&(30)
DEF SEG = VARSEG(table&(1))
pointer% = VARPTR(table&(1))

FOR x% = 0 TO 51
 POKE pointer% + x%, ASC(MID$(table$, x% + 3, 1))
NEXT
DEF SEG

IF MID$(table$, 1, 2) <> "BM" OR table&(4) <> 40 THEN
   PRINT "Not a valid *.BMP file!": END
END IF
IF table&(8) <> 0 THEN
   PRINT "This program will not diplay RLE encoded files": END
END IF

IF (table&(5) < 321) AND (table&(6) < 201) THEN
'   SCREEN 13
ELSE
'   SCREEN 12
END IF

thecolors$ = INPUT$(table&(3) - 54, #1)

DEF SEG = VARSEG(pal&)
pointer% = VARPTR(pal&)

FOR x% = 0 TO 63 STEP 4
 POKE pointer%, (ASC(MID$(thecolors$, x% + 3, 1))) \ 4
 POKE pointer% + 1, (ASC(MID$(thecolors$, x% + 2, 1))) \ 4
 POKE pointer% + 2, (ASC(MID$(thecolors$, x% + 1, 1))) \ 4
 POKE pointer% + 3, 0
PALETTE x% \ 4, pal&
NEXT
DEF SEG

y% = table&(6) 'Put number of vertical pixels into y%
DO
  data$ = INPUT$((((table&(5) - 1) OR 7) + 1) \ 2, #1)
    IF (table&(5) \ 2) < LEN(data$) THEN
       linelength% = table&(5) \ 2
    ELSE
       linelength% = LEN(data$)
    END IF
    FOR x% = 1 TO linelength%
      pixel% = ASC(MID$(data$, x%, 1))
      PSET (x% * 2 + 1, y%), pixel% AND 15
      PSET (x% * 2, y%), pixel% \ 16
     NEXT
    y% = y% - 1
LOOP UNTIL EOF(1) OR INKEY$ <> ""
CLOSE #1
END SUB

DEFSNG A-V
SUB makemap


FOR mgx = 0 TO 450 STEP 15
    LINE (mgx, 0)-(mgx, 405), 7
NEXT mgx


FOR mgy = 0 TO 405 STEP 15
    LINE (0, mgy)-(450, mgy), 7
NEXT mgy

END SUB

DEFINT A-V
SUB mkbutton (x, y, nom, txt$)

'Crop text, to get rid of unwanted spaces
length = LEN(txt$)
FOR ch = length TO 0 STEP -1
IF MID$(txt$, ch, 1) <> "a" THEN cg = 16 - ch: GOTO getout
NEXT ch
getout:

length = cg
txt2$ = LEFT$(txt$, length)

'Add spaces ether side of string$ for presentation
txt$ = " " + txt2$ + " "

'Display text...
LOCATE y, x
COLOR 15
PRINT txt$

x = x - 1
y = y - 1

'Get graphic coordinates
button(nom).x1 = x * 8 - 1
button(nom).y1 = y * 16 - 1'8 for screen 13

'Length
length = LEN(txt$)
button(nom).x2 = (x + length) * 8
button(nom).y2 = y * 16 + 16  '8 for screen 13

'Display box...
LINE (button(nom).x1, button(nom).y1)-(button(nom).x2, button(nom).y2), 15, B

END SUB

SUB mktxbox (x, y, nom, length)
x = x - 1
y = y - 1

'Get graphic coordinates
txbox(nom).x1 = x * 8 - 1
txbox(nom).y1 = y * 16 - 1'8 for screen 13

'Length
txbox(nom).x2 = (x + length) * 8
txbox(nom).y2 = y * 16 + 16  '8 for screen 13
txbox(nom).length = length

LINE (txbox(nom).x1, txbox(nom).y1)-(txbox(nom).x2, txbox(nom).y2), 15, B
END SUB

SUB mouse (cx, dx, bx)
         
           POKE VARPTR(A(4)), &H92           'Swap code,Get CX setup
          CALL absolute(cx, VARPTR(A(0)))     'Run Code
                                   'Adjust 25x80
           POKE VARPTR(A(4)), &H91           'Swap code,Get DX setup
          CALL absolute(dx, VARPTR(A(0)))     'Run Code
                                 'Adjust 25x80
           POKE VARPTR(A(4)), &H93           'Swap code,Get BX setup
          CALL absolute(bx, VARPTR(A(0)))     'Run Code

                                   'Note :
                                   'Remove the /8
                                   'for graphics modes.

END SUB

DEFINT W-Z
SUB mousepointer (SW)
         
           POKE VARPTR(A(0)) + 1, SW         'Swap code,Set AX = (SW)
          CALL absolute(C, VARPTR(A(0)))     'Run Code

                                          'Note:
                                             'SW = 0-reset
                                             'SW = 1-on
                                             'SW = 2-off
                                             'SW = 3-coordinates


END SUB

DEFSNG A-Z
SUB savemap (filename$, timelim$, graphic$)

OPEN filename$ FOR OUTPUT AS #1

WRITE #1, graphic$
WRITE #1, timelim$
WRITE #1, "non"

n = 0

FOR y = 1 TO 27

line$ = ""

FOR x = 1 TO 30

n = n + 1
SELECT CASE mapgrid(n).dat
    CASE 0
        line$ = line$ + "0 "
    CASE 1
        line$ = line$ + "d "
    CASE 2
        line$ = line$ + "8 "
    CASE 3
        line$ = line$ + "2 "
    CASE 4
        line$ = line$ + "6 "
    CASE 5
        line$ = line$ + "4 "
    CASE 6
        line$ = line$ + "5 "
    CASE 7
        line$ = line$ + "9 "
    CASE 8
        line$ = line$ + "7 "
    CASE 9
        line$ = line$ + "3 "
    CASE 10
        line$ = line$ + "1 "
    CASE 11
        line$ = line$ + "r "
    CASE 12
        line$ = line$ + "i "
    CASE 13
        line$ = line$ + "p "
    CASE 14
        line$ = line$ + "c "
    CASE 15
        line$ = line$ + "b "
    CASE 16
        line$ = line$ + "e "
    CASE 17
        line$ = line$ + "s "
    CASE 18
        line$ = line$ + "k "
    CASE 19
        line$ = line$ + "g "
    CASE 20
        line$ = line$ + "o "
    CASE 21
        line$ = line$ + "u "
    CASE 22
        line$ = line$ + "t "
    CASE 23
        line$ = line$ + "m "
END SELECT



NEXT x

WRITE #1, line$

NEXT y

CALL clearbot
LOCATE 27, 1: PRINT "There are "; dc; " Dimonds, "; rc; " Rocks, "; gc; " eggs, and "; pc; " spirits!"
LOCATE 28, 1: PRINT filename$; " has been saved!"
SLEEP 5

CLOSE #1

END SUB

SUB Zoom (x) 'STATIC
   'IF X = 0 THEN BEEP: END
   WINDOW (-x, -x)-(x, x)
    'D
    LINE (-135, 100)-(-210, 100), 72
    LINE (-135, 100)-(-135, -100), 72
    LINE (-135, -100)-(-210, -100), 72
    LINE (-200, 100)-(-200, -100), 72
   
    'A
    LINE (-50, 100)-(25, 100), 72
    LINE (-50, 100)-(-50, -100), 72
    LINE (-50, 0)-(25, 0), 72
    LINE (25, -100)-(25, 100), 72
    'N
    LINE (105, 100)-(180, -100), 72
    LINE (180, 100)-(180, -100), 72
    
    LINE (105, 100)-(105, -100), 72

END SUB

