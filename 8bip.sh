
BPM=100

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