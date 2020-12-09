#!/bin/bash

FOLDERS=../tests/*
HW_PATH=com/apd/tema2/Main
ROOT=./src

lscpu
free -m

unzip artifact.zip
unzip archive.zip

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

		done
	done

	cd ..
	timeout 120 java -jar ./Tema2Checker_J8.jar

else
	echo "src not found"
fi
