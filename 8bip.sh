
BPM=100

declare -A pitches
pitches[c]=261.23
pitches[c_]=277,18
pitches[d]=293,66
pitches[d_]=311,13
pitches[e]=329,63
pitches[f]=349,23
pitches[f_]=369,99
pitches[g]=392,00
pitches[g_]=415,30
pitches[a]=440,00
pitches[a_]=466,16
pitches[b]=493,88

setBPM() {
    if [[ $1 =~ ^-?[0-9]+$ ]] && [ $1 -ge 1 ] && [ $1 -le 3000 ]; then
        BPM=$1
    else
        echo "setBPM: BPM " $1 " is not an integer between 1 and 3000"
    fi
}

silence() {
    if [[ $1 =~ ^-?[0-9]+$ ]] && [ $1 -ge 1 ]; then
        length=$1
        sleep $(( ($length * 60 / 16) / $BPM )) 
    else
        echo "silence: length " $1 " is not an integer greater or equal to 1"
    fi
}

parse() {
    partition=$1
}

test() {
    setBPM -1
    setBPM 1
    setBPM 5
    setBPM 3000
    setBPM 4500
    setBPM caca
}