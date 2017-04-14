#!/bin/bash

while [ true ]
do
	MATLAB=$(ps aux | grep lm_TMW)
		if [ ! "$MATLAB" ]
		then
			/usr/local/MatLab/2017a/etc/lmstart -v -u matlab
		fi
sleep 15
MATLAB=""
done
