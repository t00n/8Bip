#!/bin/sh

halfnote_length=250

halfsleep()
{
	usleep $(($halfnote_length * 1000)) 
}

onesleep()
{
	halfsleep
	halfsleep
}

twosleep()
{
	onesleep
	onesleep
}

foursleep()
{
	twosleep
	twosleep
}

G4 ()
{
	beep -l $halfnote_length -f 392
}

Adiese4 ()
{
	beep -l $halfnote_length -f 466.16
}

C5 ()
{
	beep -l $halfnote_length -f 523.25
}

E5 ()
{
	beep -l $halfnote_length -f 659.25
}

F5 ()
{
	beep -l $halfnote_length -f 698.46
}

intro()
{
	C5
	C5
	Adiese4
	C5
	halfsleep
	G4
	halfsleep
	G4
	C5
	F5
	E5
	C5
	twosleep
}

intro
intro
C5
C5
C5
Adiese4
