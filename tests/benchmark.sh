#!/bin/bash

for i in $(seq 1 10)
do
    N=$(($i*20000))
    ./nc $N a > $(($i*20))ka.txt
    ./nc $(($N/2)) ab > $(($i*10))kab.txt
done

PROGS=(re2 haskell-regexp grep igrep)

declare -a COMMANDS=(
    "/usr/bin/time -f \"%e\" ./re2 \"(a + b + ab)*\" < \$N"
    "/usr/bin/time -f \"%e\" ./haskell-regexp \"(a|b|ab)*\" < \$N"
    "/usr/bin/time -f \"%e\" grep -x -E \"(a|b|ab)*\" \$N"
    "/usr/bin/time -f \"%e\" ./igrep \"(a + b + ab)*\" \$N"
)

for c in a ab
do
    echo -n \#thousands of $c's|'

    for p in ${PROGS[@]}
    do
        echo -n $p'|'
    done
    echo -n -e '\n'

    for i in $(seq 1 10)
    do
        N=$(($i*20/${#c}))k$c".txt"
        echo -n ${N%k*}
        for ((p=0;p<${#PROGS[@]};p++))
        do
            echo -n -e '\t'
            echo -n $(eval ${COMMANDS[$p]} 2>&1 1>/dev/null)
        done
        echo -n -e '\n'

    done
    echo -ne "\n"

done

rm *ka.txt
rm *kab.txt
