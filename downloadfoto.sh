#!/bin/bash

####
# extracts frames from a video called GOPR****.MP4 located in a folder in Desktop with the name of the student 
####


RED='\033[1;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m' 
BLUE='\033[0;34m'
echo
echo
echo -e "${GREEN}  .____________________________________________________________."
echo -e "  |                                                            |"
echo -e "  |              ${YELLOW}WELCOME TO${GREEN}                                    |"
echo -e "  |  ${RED}       _    _    ${YELLOW} _   ${RED}       _    _         __  _         ${GREEN}|"
echo -e "  |  ${RED}  ___ / /  __  __${YELLOW}/ \ ${RED}       / /__/ /__ __  /  |/ /__      ${GREEN}|"
echo -e "  |  ${RED}( _-</ _ \/ /\/ /${YELLOW} _ \ ${RED}     /  - /  - / -_)/ /|  / -_)     ${GREEN}|"
echo -e "  |  ${RED}/___/_//_/_/\__/${YELLOW}_/ \_\ ${RED}___/____/___ /\___/_/ |_/\___/     ${GREEN}|"
echo -e "  |  ${YELLOW}TANDEM SKYDIVING EMERGENCY PICTURE PROCEDURE (v1.0)  ${GREEN}     |"
echo -e "  |____________________________________________________________|"
echo
echo -e "${GREEN}
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Serena Di Santo wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return.
 * ----------------------------------------------------------------------------${NC}"
echo
echo


if [ -f studir.txt ]; then read studentdir < studir.txt ; else studentdir=~/Desktop ; fi

if [[ ! -d $studentdir ]]; then
rm -f studir.txt
while true
do
	read -p 'tell me the path to your Desktop directory:   ' studentdir2
	echo
	if [ -d $studentdir2 ] ; then break;
	else echo "i cannot find $studentdir2. please check"; echo
	fi
done
echo "$studentdir2" >> studir.txt
studentdir=$studentdir2;
fi

echo 'i will look for a folder in Desktop called with the name of your student'
read -p 'tell me the name of your tandem student ' name
echo

############## check directory #############################################
if [[ -d $studentdir/$name && ! -z "$name" ]]; then
	cd $studentdir/$name

	directory="$name"
	imgname="image"  

	echo "this is the content of $studentdir/$name "
	ls

	if [ -f image1.jpg ];
		then
   		echo "A file called $imgname already exists in this directory."
   		echo "tell me a new name for your image files"
   		read imgname
	fi
	
	echo "tell me the (complete) name of your video file"
	read filename
	#ffmpeg -i GOPR$filename.MP4 -r 1 -t 00:00:05 -s whuxga $imgname%d.jpg #
	#ffmpeg -i GOPR$filename.MP4 -r 1 -ss 00:00:05 -to 00:00:10 -s whuxga $imgname%d.jpg #-r 1 is take one frame per second (-r 2 is one frame in half a second). -ss is seek to second 40. -t is do it for 5 seconds. alternatively you can use -t 00:00:05. the further -ss points from the beginning, the more time it will take. whuxga is a standard setting for the resolution
	echo
	echo -e "${BLUE}...downloading pictures...${NC}"
	ffmpeg -i $filename -r 1 -s whuxga -loglevel 'fatal' $imgname%d.jpg
	echo -e "${GREEN}done${NC}";
	echo
	echo

else 
	if [[ -z $namedir ]] ; then
	echo "Hey!you're supposed to type something..."
	else
	echo "Error! I cannot find a directory called $name in $studentdir. Please check mothafucka."
	fi
fi 
