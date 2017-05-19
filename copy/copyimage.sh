#!/bin/bash
find ../  -name  "*.png" > image.file
cat image.file | while read line
do
    if [ `echo $line | grep -e '9.png'` ]
    then
        echo "file:${line}"
        echo "this is 9.png" 
    else
        cp -r h001.png ${line}
    fi
done
        
