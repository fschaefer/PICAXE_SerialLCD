#no_data

'Initialization commands or responses.
symbol _SLCD_INIT        = $A3
symbol _SLCD_INIT_ACK    = $A5
symbol _SLCD_INIT_DONE   = $AA

'WorkingMode commands or responses.
symbol _SLCD_CONTROL_HEADER  = $9F
symbol _SLCD_CHAR_HEADER     = $FE
symbol _SLCD_CURSOR_HEADER   = $FF
symbol _SLCD_CURSOR_ACK      = $5A

symbol _SLCD_RETURN_HOME     = $61
symbol _SLCD_DISPLAY_OFF     = $63
symbol _SLCD_DISPLAY_ON      = $64
symbol _SLCD_CLEAR_DISPLAY   = $65
symbol _SLCD_CURSOR_OFF      = $66
symbol _SLCD_CURSOR_ON       = $67
symbol _SLCD_BLINK_OFF       = $68
symbol _SLCD_BLINK_ON        = $69
symbol _SLCD_SCROLL_LEFT     = $6C
symbol _SLCD_SCROLL_RIGHT    = $72
symbol _SLCD_NO_AUTO_SCROLL  = $6A
symbol _SLCD_AUTO_SCROLL     = $6D
symbol _SLCD_LEFT_TO_RIGHT   = $70
symbol _SLCD_RIGHT_TO_LEFT   = $71

symbol _SLCD_INVALIDCOMMAND  = $46

'Pins used as RX and TX.
symbol SLCD_TX              = c.1
symbol SLCD_RX              = c.2

'Temporary variables used by some "slcd_" subroutines.
symbol SLCD_REGISTER        = b10
symbol SLCD_CURSOR_COLUMN   = b11
symbol SLCD_CURSOR_ROW      = b12

'Test programm.
start0:
init:
    setfreq m8
main:
    wait 1
    call slcd_init
    call slcd_clear
    call slcd_display
    call slcd_home
    call slcd_blink
    SLCD_CURSOR_COLUMN = 5
    SLCD_CURSOR_ROW = 1
    call slcd_set_cursor
    call slcd_right_to_left
    call slcd_hello
    wait 60
    goto main

'Output "Hello World".
slcd_hello:
    serout SLCD_TX, T9600_8, (_SLCD_CHAR_HEADER, "Hello World") 
    return

'Initialize the Serial LCD Driver. SerialLCD Module initiates the communication.
slcd_init:
    SLCD_REGISTER = $FF
    do while SLCD_REGISTER != _SLCD_INIT
        serin SLCD_RX, T9600_8, SLCD_REGISTER
    loop
    serout SLCD_TX, T9600_8, (_SLCD_INIT_ACK) 
    SLCD_REGISTER = $FF
    do while SLCD_REGISTER != _SLCD_INIT_DONE
        serin SLCD_RX, T9600_8, SLCD_REGISTER
    loop
    debug
    return

'Clear the display.
slcd_clear:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_CLEAR_DISPLAY) 
    return

'Return to home (top-left corner of LCD).
slcd_home:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_RETURN_HOME) 
    pause 2
    return

'Set Cursor to (Column, Row) Position.
slcd_set_cursor:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_CURSOR_HEADER, SLCD_CURSOR_COLUMN, SLCD_CURSOR_ROW) 
    return

'Switch the display off without clearing RAM.
slcd_no_display:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_DISPLAY_OFF) 
    return

'Switch the display on.
slcd_display:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_DISPLAY_ON) 
    return

'Switch the underline cursor off.
slcd_no_cursor:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_CURSOR_OFF) 
    return

'Switch the underline cursor on.
slcd_cursor:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_CURSOR_ON) 
    return

'Switch off the blinking cursor.
slcd_no_blink:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_BLINK_OFF) 
    return

'Switch on the blinking cursor.
slcd_blink:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_BLINK_ON) 
    return

'Scroll the display left without changing the RAM.
slcd_scroll_left:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_SCROLL_LEFT) 
    return

'Scroll the display right without changing the RAM.
slcd_scroll_right:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_SCROLL_RIGHT) 
    return

'Set the text flow "left to right".
slcd_left_to_right:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_LEFT_TO_RIGHT) 
    return

'Set the text flow "right to left".
slcd_right_to_left:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_RIGHT_TO_LEFT) 
    return

'This will "right justify" text from the cursor.
slcd_no_auto_scroll:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_NO_AUTO_SCROLL) 
    return

'This will "left justify" text from the cursor.
slcd_auto_scroll:
    serout SLCD_TX, T9600_8, (_SLCD_CONTROL_HEADER, _SLCD_AUTO_SCROLL) 
    return

