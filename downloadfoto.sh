#!/bin/bash

####
# extracts frames from a video called GOPR****.MP4 located in a folder in Desktop with the name of the student 
####


echo 'i will look for a folder in Desktop called with the name of your student'
echo 'tell me the name of your tandem student'
read name
echo 'this is the content of ~/Desktop/dave'
ls ~/Desktop/$name
directory="$name"
imgname="image"  

# bash check if directory exists
if [ -d ~/Desktop/$directory ]; then
	cd ~/Desktop/$directory

if [ -f image1.jpg ];
then
   echo "File $FILE already exists."
   echo "tell me a new name for your image files"
   read imgname
fi
else 
	echo "Directory does not exists"
fi 
echo "tell me the number of your video file"
read filename
#ffmpeg -i GOPR$filename.MP4 -r 1 -t 00:00:05 -s whuxga $imgname%d.jpg #
#ffmpeg -i GOPR$filename.MP4 -r 1 -ss 00:00:05 -to 00:00:10 -s whuxga $imgname%d.jpg #-r 1 is take one frame per second (-r 2 is one frame in half a second). -ss is seek to second 40. -t is do it for 5 seconds. alternatively you can use -t 00:00:05. the further -ss points from the beginning, the more time it will take. whuxga is a standard setting for the resolution
ffmpeg -i GOPR$filename.MP4 -r 1 -s whuxga $imgname%d.jpg
