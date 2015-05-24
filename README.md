8Bip
=========

Small lib and script in bash to use computer speakers as a music instrument

# Requirements
 * bash
 * bc
 * beep

# Use
`bash 8bip.sh <partition>`

8Bip uses a semiquaver as the smallest unit of note value

A partition is a string without space that contains commands : 
 * b\<number\>    set bpm to \<number\> (between 1 and 3000)
 * s\<number\>    silence of \<number\>*semiquaver
 * \<note\>\<octave\>\<number\>   play \<note\> in \<octave\> for \<number\>*semiquaver

Notes are in english notation in lower case (a to g). A sharp note is described with a '+' appended (e.g. 'a+' for A#) and a flat note with a '-' appended (e.g. (b-) for B flat)

