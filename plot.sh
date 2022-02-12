#!/bin/bash
pauseFile=/home/$(whoami)/final/pause
logPathFile=/home/$(whoami)/plot.log

printingDevice="/dev/sda1 "

Pool_Contract_Address="xch19q55klhyk60anylsqfwyxudzdvafntcn3ltefed5cnnfnxatk5xsp4hmzf"
pca=$Pool_Contract_Address
Farmer_Public_Key="b3c6f9f303a9823a933b5cec1e30e3c22bc163eeae7a79e9ffe743abbf9fdf3f1273168df0886523c6f42f2f6a2607ca"
fpk=$Farmer_Public_Key
# chia plotters madmax
#command="chia plots create -r 6 -n 3 -k 33 -b 12000 -t $1 -d $2 -c $pca -f $fpk"
if [ ${1+x} ] && [ ${2+x} ] && [ ${3+x} ]; then
	tmp1=$1
	tmp2=$2
	final=$3 
	echo param1: $tmp1
	echo param2: $tmp2
	echo param3: $final
	# files=$(ls $path | grep plot-k33)
    # echo $files
    while true; do
        # // if file exists do pause
        if [ -f $pauseFile ]; then
            echo $(date +"%y/%m/%d %H:%M:%S")": Pausing until file is deleted -> $pauseFile" | tee -a $logPathFile
            sleep 100
        else
            echo "delete Plots $(ls $tmp1 | wc -l) tmp files" | tee -a $logPathFile
            rm -rf $tmp1/*
            echo "delete Plots $(ls $tmp2 | wc -l) tmp files" | tee -a $logPathFile
            rm -rf $tmp2/*

            availSpace=$(df | grep $printingDevice | sed -E 's/\ {2,}/\ /g' | cut -d ' ' -f4 | head 1)
            df -h | grep $printingDevice | tee -a $logPathFile

            if [[ $availSpace -gt 481408204 ]]; then
                chia plotters madmax -r 4 -n 1 -k 33 -t $tmp1 -2 $tmp2 -d $final -c $pca -f $fpk | tee -a $logPathFile
            else
                echo $(date +"%y/%m/%d %H:%M:%S")": not enough availSpace" | tee -a $logPathFile
                sleep 1000
            fi
        fi
    done
else 
    echo $(date +"%y/%m/%d %H:%M:%S")": tmp1 tmp2 or final not set" | tee -a $logPathFile

	echo param1: $1
	echo param2: $2
	echo param3: $3
fi
