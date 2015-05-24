#!/bin/bash

BPM=100

# Frequencies of 3rd octave
declare -A pitches
pitches[c]=261.23
pitches[c+]=277.18
pitches[d-]=${pitches[c+]}
pitches[d]=293.66
pitches[d+]=311.13
pitches[e-]=${pitches[d+]}
pitches[e]=329.63
pitches[f-]=${pitches[e]}
pitches[f]=349.23
pitches[e+]=${pitches[f]}
pitches[f+]=369.99
pitches[g-]=${pitches[f+]}
pitches[g]=392.00
pitches[g+]=415.30
pitches[a-]=${pitches[g+]}
pitches[a]=440.00
pitches[a+]=466.16
pitches[b-]=${pitches[a+]}
pitches[b]=493.88
pitches[c-]=${pitches[b]}


setBPM() {
    if [[ $1 =~ ^-?[0-9]+$ ]] && [ $1 -ge 1 ] && [ $1 -le 3000 ]; then
        BPM=$1
        return 0
    else
        echo "setBPM: BPM " $1 " is not an integer between 1 and 3000"
        return 1
    fi
}

getDuration() {
    if [[ $1 =~ ^-?[0-9]+$ ]] && [ $1 -ge 1 ]; then
        length=$1
        echo $(bc <<< "scale=3;($length * 60 / 16) / $BPM")
        return 0
    else
        return 1
    fi
}

getDurationMS() {
    length=$1
    durationSec=$(getDuration $length)
    float=$(bc <<< "scale=0;$durationSec*1000")
    echo ${float%.*}
    return 0
}

silence() {
    if [[ $1 =~ ^-?[0-9]+$ ]] && [ $1 -ge 1 ]; then
        length=$1
        sleep $(getDuration $length)
        return 0
    else
        echo "silence: length " $1 " is not an integer greater or equal to 1"
        return 1
    fi
}

note() {
    if [[ $2 =~ ^-?[0-9]+$ ]] && [[ $2 -ge 1 ]]; then
        length=$2
        # normal note
        if [[ ${#1} -eq 2 ]]; then
            pitch=${1:0:1}
            octave=${1:1:1}
        # altered note
        elif [[ ${#1} -eq 3 ]]; then
            pitch=${1:0:2}
            octave=${1:2:1}
        else
            echo "note: "$1" is not a note"
            return 1
        fi
        freq=${pitches[$pitch]}
        if [[ $freq == "" ]]; then
            echo "note: "$1" is not a note"
            return 1
        fi
        if [[ $octave -lt 3 ]]; then
            for (( j=2; j >= $octave; j-- )); do
                freq=$(bc <<< "scale=2;$freq/2")
            done
        elif [[ $octave -gt 3 ]]; then
            for (( j=4; j <= $octave; j++ )); do
                freq=$(bc <<< "scale=2;$freq*2")
            done
        fi
        if [[ $DEBUG == 1 ]]; then
            echo beep $(getDurationMS $length) $freq
        else
            beep -l $(getDurationMS $length) -f $freq
        fi
        return 0
    else
        echo "note: length " $2 " is not an integer greater or equal to 1"
        return 1
    fi
}

parse() {
    partition=$1
    i=0
    while [[ $i -lt ${#partition} ]]; do
        char=${partition:$i:1}
        ((i=i+1))
        if [[ $char == "b" ]]; then
            # change bpm
            bpm=
            while [[ ${partition:$i:1} =~ ^[0-9]$ ]]; do
                bpm+=${partition:$i:1}
                ((i=i+1))
            done
            setBPM $bpm
        elif [[ $char == "s" ]]; then
            # silence
            length=
            while [[ ${partition:$i:1} =~ ^[0-9]$ ]]; do
                length+=${partition:$i:1}
                ((i=i+1))
            done
            silence $length
        else
            # note
            nextchar=${partition:$i:1}
            ((i=i+1))
            if [[ $nextchar == "+" ]] || [[ $nextchar == "-" ]]; then
                # altered note
                octave=${partition:$i:1}
                ((i=i+1))
                note=$char$nextchar$octave
            else
                note=$char$nextchar
            fi
            length=
            while [[ ${partition:$i:1} =~ ^[0-9]$ ]]; do
                length+=${partition:$i:1}
                ((i=i+1))
            done
            note $note $length
        fi
    done
}

test() {
    setBPM -1
    setBPM 1
    setBPM 5
    setBPM 3000
    setBPM 4500
    setBPM caca
}

parse $1
