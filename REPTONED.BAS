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
    DIM chrrr(5000)
    
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
    DIM SHARED repton(100)
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

'LINE (0, 0)-(640, 480), , B

'END
GET (0, 0)-(120, 45), chrrr

GET (1, 2)-(16, 17), dimond
GET (1, 17)-(16, 22), rock
GET (1, 22)-(16, 27), repton
GET (1, 27)-(16, 32), wall8
GET (1, 32)-(16, 37), wall2
GET (1, gy)-(16, 1), wall6
GET (1, gy)-(16, gy + 15), wall4
GET (1, gy)-(16, gy + 15), wall5
GET (gx, gy)-(gx, gy + 15), wall9
GET (gx, gy)-(gx, gy + 15), wall7
GET (gx, gy)-(gx, gy + 15), wall3
GET (gx, gy)-(gx, gy + 15), wall1
GET (gx, gy)-(gx, gy + 15), earth
GET (gx, gy)-(gx, gy + 15), safe
GET (gx, gy)-(gx, gy + 15), timecap
GET (gx, gy)-(gx, gy + 15), egg
GET (gx, gy)-(gx, gy + 15), crown
GET (gx, gy)-(gx, gy + 15), cage
GET (gx, gy)-(gx, gy + 15), spirit
GET (gx, gy)-(gx, gy + 15), bomb
GET (gx, gy)-(gx, gy + 15), tran
GET (gx, gy)-(gx, gy + 15), skull
GET (gx, gy)-(gx, gy + 15), space





CLS

FOR n = 1 TO 29
LOCATE n, 68
PRINT CHR$(186)
NEXT n


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

mode$ = "start"


'Setup screen

setup:

SELECT CASE mode$
   
    CASE "start"
        'Graphics...
        CALL makemap

        'Buttons...
        CALL mkbutton(70, 2, 1, "New")
        CALL mkbutton(70, 4, 2, "Open")
        CALL mkbutton(70, 6, 3, "Save")
        CALL mkbutton(70, 8, 4, "Save As")
       
        CALL mkbutton(70, 14, 5, "Set MAP")
       
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
        CALL mkbutton(64, 24, 29, " ")
dat = 2
    FOR cy = 0 TO 11
        FOR cx = 0 TO 1
            pcx = 470 + (cx * 10): pcy = 16 + (cy * 16): GOSUB putchrr
            dat = dat + 1
          NEXT cx
    NEXT cy
'dat = 1: pcx = 320: pcy = 200: GOSUB putchrr

PUT (320, 200), dimond
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
        
        CALL ckbutton(1): IF button(1).click = 1 THEN END
        CALL ckbutton(2): IF button(2).click = 1 THEN END
        CALL ckbutton(3): IF button(3).click = 1 THEN END
        CALL ckbutton(4): IF button(4).click = 1 THEN END
        CALL ckbutton(5): IF button(5).click = 1 THEN END
        CALL ckbutton(6): IF button(6).click = 1 THEN END

        CALL ckbutton(7): IF button(6).click = 1 THEN END
        CALL ckbutton(8): IF button(6).click = 1 THEN END
        CALL ckbutton(9): IF button(6).click = 1 THEN END
        CALL ckbutton(10): IF button(6).click = 1 THEN END
        CALL ckbutton(11): IF button(6).click = 1 THEN END
        CALL ckbutton(12): IF button(6).click = 1 THEN END
        CALL ckbutton(13): IF button(6).click = 1 THEN END
        CALL ckbutton(14): IF button(6).click = 1 THEN END
        CALL ckbutton(15): IF button(6).click = 1 THEN END
        CALL ckbutton(16): IF button(6).click = 1 THEN END

    CASE "set"
        CALL cktxbox(1, typ$, 0) 'Text box number, text to add, masked
END SELECT


'Handle mouse pointer
GET (mx, my)-(mx + 11, my + 11), putback
'Re/Make mouse pointer
LINE (mx, my)-(mx + 10, my + 5), 15
LINE (mx, my)-(mx + 5, my + 10), 15
LINE (mx + 10, my + 5)-(mx + 5, my + 5), 15
LINE (mx + 5, my + 10)-(mx + 5, my + 5), 15

LOCATE 1, 1: PRINT mx, my



pass = 1
END IF
lmx = mx
lmy = my
lmz = mz
LOOP UNTIL mode$ <> oldmode$
GOTO setup


'Gosubs/Gotos...
putchrr:    
      'IF dat = 0 THEN PUT (pcx, pcy), space
      IF dat = 1 THEN PUT (pcx, pcy), wall1
      IF dat = 2 THEN PUT (pcx, pcy), wall2
      IF dat = 3 THEN PUT (pcx, pcy), wall3
      IF dat = 4 THEN PUT (pcx, pcy), wall4
      IF dat = 5 THEN PUT (pcx, pcy), wall5
      IF dat = 6 THEN PUT (pcx, pcy), wall6
      IF dat = 7 THEN PUT (pcx, pcy), wall7
      IF dat = 8 THEN PUT (pcx, pcy), wall8
      IF dat = 9 THEN PUT (pcx, pcy), wall9
      IF dat = 10 THEN PUT (pcx, pcy), rock
      IF dat = 11 THEN PUT (pcx, pcy), dimond
      IF dat = 12 THEN PUT (pcx, pcy), repton
      IF dat = 13 THEN PUT (pcx, pcy), spirit
      IF dat = 14 THEN PUT (pcx, pcy), cage
      IF dat = 15 THEN PUT (pcx, pcy), bomb
      IF dat = 16 THEN PUT (pcx, pcy), earth
      IF dat = 17 THEN PUT (pcx, pcy), safe
'      IF dat = 18 THEN PUT (pcx, pcy), keyy
      IF dat = 19 THEN PUT (pcx, pcy), egg
      IF dat = 20 THEN PUT (pcx, pcy), tran
'      IF dat = 21 THEN PUT (pcx, pcy), skull
      IF dat = 22 THEN PUT (pcx, pcy), crown
      IF dat = 23 THEN PUT (pcx, pcy), timecap
RETURN

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

END SUB

DEFSNG A-V
SUB makemap


FOR mgx = 0 TO 450 STEP 15
    LINE (mgx, 0)-(mgx, 405)
NEXT mgx


FOR mgy = 0 TO 405 STEP 15
    LINE (0, mgy)-(450, mgy)
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

DEFSNG B-V
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

DEFINT B-Z
SUB mousepointer (SW)
         
           POKE VARPTR(A(0)) + 1, SW         'Swap code,Set AX = (SW)
          CALL absolute(c, VARPTR(A(0)))     'Run Code

                                          'Note:
                                             'SW = 0-reset
                                             'SW = 1-on
                                             'SW = 2-off
                                             'SW = 3-coordinates


END SUB

DEFSNG A-Z
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

