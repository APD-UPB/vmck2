#!/bin/bash

echo "Start time: $(date)"

FOLDERS=../tests/*
HW_PATH=com/apd/tema2/Main
ROOT=./src
ERR=./err

echo -e "Show CPU info (lscpu)\n\n"
lscpu

echo -e "\n\nShow memory info (free -m)\n\n"
free -m
echo -e "\n\n"

echo -e "Unzip tests and student solution\n\n"

unzip artifact.zip
unzip archive.zip

source /etc/profile.d/jdk14.0.2.sh
echo -e "\n\nRunning the checker\n\n"

if [ -d "$ROOT" ]; then
	rm -rf out err src/bin
	mkdir out err
	cd src

	javac -g $HW_PATH.java -d bin

	for d in $FOLDERS
	do	
		for f in $d/*
		do
    			echo "Processing $f file..."
    		
			fullpath=`echo "${f%.*}"`
			filename="${fullpath##*/}"

			timeout 120 java -cp bin/ $HW_PATH $f > ../out/$filename.out
			
			if [ $? != 0 ]
			then
				echo "Timer exceeded"
			fi
		done
	done

	cd ..
	timeout 120 java -jar ./Tema2Checker_J8.jar

	for f in $ERR/*
        do
               	if [[ -s $f ]]
		then
			echo "Contents of the file $f"
			cat $f
		fi
	done

else
	echo "src not found"
fi

echo "End time: $(date)"
