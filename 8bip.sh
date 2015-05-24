
BPM=100

# Frequencies of 3rd octave
declare -A pitches
pitches[c]=261.23
pitches[c_]=277.18
pitches[d]=293.66
pitches[d_]=311.13
pitches[e]=329.63
pitches[f]=349.23
pitches[f_]=369.99
pitches[g]=392.00
pitches[g_]=415.30
pitches[a]=440.00
pitches[a_]=466.16
pitches[b]=493.88

setBPM() {
    if [[ $1 =~ ^-?[0-9]+$ ]] && [ $1 -ge 1 ] && [ $1 -le 3000 ]; then
        BPM=$1
        return 0
    else
        echo "setBPM: BPM " $1 " is not an integer between 1 and 3000"
        return 1
    fi
}

silence() {
    if [[ $1 =~ ^-?[0-9]+$ ]] && [ $1 -ge 1 ]; then
        length=$1
        sleep $(( ($length * 60 / 16) / $BPM ))
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
            echo "note: " $1 " is not a note"
            return 1
        fi
        freq=${pitches[$pitch]}
        if [[ $freq == "" ]]; then
            echo "note: " $1 " is not a note"
            return 1
        fi
        echo caca1 $pitch $octave $length $freq
        if [[ $octave -lt 3 ]]; then
            echo caca2
            for i in {2..$octave..-1}; do
                echo caca2 boucle
                freq=$(bc <<< "scale=2;$freq/2")
            done
        elif [[ $octave -gt 3 ]]; then
            echo caca3
            for i in {4..$octave..1}; do
                echo caca3 boucle $freq
                freq=$(bc <<< "scale=2;$freq*2")
            done
        fi
        echo $freq
        return 0
    else
        echo "note: length " $2 " is not an integer greater or equal to 1"
        return 1
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