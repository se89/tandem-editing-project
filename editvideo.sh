#!/bin/bash

####
# edits raw files
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
echo -e "  |  ${YELLOW}TANDEM SKYDIVING EDITING PROCEDURE (v1.0)  ${GREEN}               |"
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


if [ -f filefrmt.txt ]; then read prefix formt < filefrmt.txt ; fi
parentdir=$(pwd)

while true
do
	read -p 'tell me the name of your tandem student:   ' namedir
	echo

############## check directory #############################################
  	if [[ -d $studentdir/$namedir && ! -z "$namedir" ]]; then
		cd $studentdir/$namedir

	
############## remove exixting files from an eventual previous run #########
	rm -f tmp_*
	#if ls tmp_trimlist* 1> /dev/null 2>&1 ; then rm tmp_trimlist* ; fi


############## devine the prefix and format of video files in use ##########
	fl=$(ls -S . | head -1)
	IFS="."
	read -r namefs formtdevined <<< "$fl" 
	while read -r -n1 c ; do if [[ $c = [0-9] ]] ; then break ; fi ; cntc=$(($cntc+1)) ; done <<< $namefs 
	read -r -n $cntc prefixdevined <<< "$namefs"


############# ask to user format of video files ############################
	if [[ "$prefixdevined" == "$prefix" ]] && [ "$formtdevined" == "$formt" ] ; then
		prefix=$prefixdevined
		formt=$formtdevined
	else
		while true; do
			read -p "are you using GOPRO formats?[y/n]  " answer
			echo
	    		case $answer in
        			[Yy]* ) prefix="GOPR"; formt="MP4"; break;;
        			[Nn]* ) echo "as an example in GOPR0194.MP4 the prefix would be 'GOPR' and the format would be 'MP4'"
					echo
					read -p "tell me the prefix of your files  " prefix
					echo
					read -p "tell me the format of your files  " formt
					echo
					break;;
        			* ) echo "Invalid choice. Please answer y for yes or n for no."; echo;;
    			esac
		done	

	if [ -f $parentdir/filefrmt.txt ]; then rm $parentdir/filefrmt.txt ; fi
	echo "$prefix $formt" >> $parentdir/filefrmt.txt
	fi

############## show files ##################################################
	echo "these are the $prefix video files in directory $studentdir/$namedir:   "
	if ls $prefix*.$formt ; then ls $prefix*.$formt >> tmp_playlist.txt
	echo 
	else echo "An error occurred. There aren't any $prefix.$formt files in $namedir folder."
		echo "Please check and start again"
		echo ; exit ; fi

############## recognize number of files and first file ####################
	cnt=0
	while read line           
	do
	if [[ $cnt = 0 ]] ; then 
	IFS="."
	read -r namefs formtdevined <<< "$line" 
	cntc=0
	while read -r -n1 c ; do if [[ $c = [0-9] ]] ; then break ; fi ; cntc=$(($cntc+1)) ; done <<< $namefs 
	read -r -n $cntc prefixdevined <<< "$namefs"
	str="$namefs"
	str2="$prefixdevined"
	numberlength=$(bc -l <<< "${#str} - ${#str2}")
	firstfile=${str:${#str} -$numberlength}
	IFS=
	fi
	cnt=$(($cnt+1))
	done < tmp_playlist.txt  
	break 
else 
	if [[ -z $namedir ]] ; then
	echo "Hey!you're supposed to type something..."
	else
	echo "Error! I cannot find a directory called $namedir in $studentdir. Please check mothafucka."
	fi
fi 
done

nclips=$cnt
############ if recognition didn't work ask to user #######################
while true; do
	read -p "i see $nclips files, the first of which is number $firstfile. is that correct?[y/n]   " answer
	echo
	case $answer in
        [Yy]* ) break;;
        [Nn]* ) while true; do
		read -p "how many clips do you have?   " nclips
		echo
		read -p "tell me the number of your first file:   " firstfile
		echo		
		lastfile=$(bc -l <<< "$firstfile + $nclips -1")
		if [ -f $prefix$lastfile.$formt ] ; then break;
		else echo "Error! I cannot find file $prefix$lastfile.$formt Please check!"
		fi
		done
		break;;
        * ) echo "Invalid choice. Please answer y for yes or n for no."; echo;;
	esac
done


################choose audio##############################################
while true; do
	echo "choose your audio settings:"
	read -p "How many songs do you want to use?[1/2]  " answer
	echo
	case $answer in
	[1]* ) while true; do
			read -p "tell me the name of your song: " song
			echo
			if [ -f $parentdir/$song ]; then break
			else echo "i found no files $song in $parentdir. Please select a valid audio file."; echo ; fi
			done
		break;;
	[2]* ) 	while true; do
			read -p "tell me the name of your first song: " song1
			#if [ $song1 = y ]; then song1="1.mp3"; fi 
			if [ -f $parentdir/$song1 ]; then break
			else echo "i found no files $song1 in $parentdir. Please select a valid audio file for song 1."; echo ; fi
			done
		while true; do
			read -p "tell me the name of your second song: " song2
			echo
			#if [ $song2 = y ]; then song2="2.mp3"; fi 
			if [ -f $parentdir/$song2 ]; then break
			else echo "i found no files $song2 in $parentdir. Please select a valid audio file for song 2."; echo ; fi
			done
		while true; do
			read -p "tell me the number of the clip in which you want song2 to start (i will take care of trimming) " song2start
			echo
			if [ $song2start -le $nclips ]; then break
			else echo "Something must be wrong!i have $nclips clips. Please select a valid value."; echo ; fi
			done
		ds1=0
		flagsong2=1
		break;;

	* ) echo "Invalid choice. Please select option 1 or 2."; echo;;
esac
done


############## choose output device ###################################
echo "where do you want to write the finished file? "
while true; do
	read -p "type 0 for nowhere, 1 if for usb, 2 for dvd  " odevice
	echo
	case $odevice in
	[0]* ) break;;
        [1]* ) while true; do
		read -p "tell me the name of your usb device and make sure it is plugged in: " usbdv
		if [ -d /Volumes/$usbdv ] ; then break
		else echo "I cannot find the device $usbdv. Please check"
		fi
		done
		break;;
        [2]* ) read -p "please insert a blank dvd, then press return key " dummy; break;;
        * ) echo "Invalid choice.  Please select option 0 1 or 2."; echo;;
	esac
done


filenamec=$firstfile
############## trim clips ###############################################

while true; do
read -p "Do you want to trim the files?[y/n]   " answer
echo
case $answer in
[Yy]* )
#	satisfiedoverall=0
	aa="_"
	ci=0 #clipindex
	told=0
#	while [ $satisfiedoverall -ne 1 ]
#	do
		#if [ -f tmp_newtrims.txt ]; then rm tmp_newtrims.txt ; fi
	for (( COUNTER=1; COUNTER<=$nclips; COUNTER+=1 ))
	do
	
		satisfied=0	
		while [ $satisfied -ne 1 ] #
		do #
			#newtrim=1
			#if [ -f tmp_newStream$filenamec$aa$ci.$formt ]; then
			#	read -p "$filenamec trimmed file already exists, overwrite?[y/n]   " answer
			#	if [[ $answer = n ]]; then newtrim=0; fi
			#fi
			#if [[ $newtrim = 1 ]]; then
			if [[ $told = 0 ]] ; then read -p "Important: press 'i' when you want to start/stop the trimmed clip [Enter to continue]" dummy; told=1; fi
			mplayer -nosound -framedrop -really-quiet -edlout tmp_trimlist$filenamec $prefix$filenamec.$formt 
			#fi
			#echo $newtrim >> tmp_newtrims.txt
			echo "trim settings for file $filenamec"
			cat tmp_trimlist$filenamec
			echo

			while true; do
				read -p "Enter to continue, n to trim this file again   " answer
				echo
				case $answer in
				[Nn]* )  rm tmp_trimlist$filenamec; break;; #filenamec=$firstfile; break;;
				* ) satisfied=1; break;;
				esac
			done
		done #
		filenamec=$(($filenamec+1))
	done

#		while true; do
#			read -p "are you satisfied with your trimming?[y/n]   " answer
#			echo
#			case $answer in
#			[Yy]* ) satisfiedoverall=1; break;;
#			[Nn]* )  filenamec=$firstfile; break;;
#			* ) echo "Invalid choice. Please answer y for yes or n for no."; echo;;
#			esac
#		done
#	done

	echo -e "${GREEN}YOU CAN GO NOW, I'LL DO THE JOB.${NC}"
	echo
	echo

	STARTTIME=$(date +%s)
	filenamec=$firstfile
	IFS=" "

	for (( COUNTER=1; COUNTER<=$nclips; COUNTER+=1 ))
	do
		ci=0 #clipindex
		#nt=$(head -$COUNTER tmp_newtrims.txt | tail -1 ) #its a flag that tells if its a newtrim
		#if [ $nt = 1 ]; then
			while IFS='' read -r var || [[ -n "$var" ]]
			do 
				read -r trimstart trimend dummy <<< "$var"
				echo -e "${BLUE}...trimming file $filenamec from $trimstart to $trimend...${NC}"
				if [ -f tmp_newStream$filenamec$aa$ci.$formt ]; then rm tmp_newStream$filenamec$aa$ci.$formt ; fi
				echo"" | ffmpeg -i $prefix$filenamec.$formt -ss $trimstart -to $trimend -loglevel 'fatal' -an tmp_newStream$filenamec$aa$ci.$formt #subshell problem..
				echo "file tmp_newStream$filenamec$aa$ci.$formt" >> tmp_list.txt
				ci=$(($ci+1))
				if [[ $flagsong2 = 1 ]] && [[ $COUNTER < $song2start ]] ; then 
					dc=$(bc -l <<< "$trimend - $trimstart"); ds1=$(bc -l <<< "$ds1 + $dc"); fi
			done < tmp_trimlist$filenamec
			echo "$filenamec trimmed"
		#else
		#	while [ -f tmp_newStream$filenamec$aa$ci.$formt ] 
		#	do
		#		echo "file tmp_newStream$filenamec$aa$ci.$formt" >> tmp_list.txt
		#		ci=$(($ci+1))
		#	done
		#fi

		filenamec=$(($filenamec+1))

	done
break;;
[Nn]* ) echo -e "${GREEN}YOU CAN GO NOW, I'LL DO THE JOB.${NC}"
	echo
	echo
	for (( COUNTER=1; COUNTER<=$nclips; COUNTER+=1 ))
	do
		echo "file $prefix$filenamec.$formt" >> tmp_list.txt
		filenamec=$(($filenamec+1))
		if [[ $flagsong2 = 1 ]] && [[ $COUNTER < $song2start ]] ; then
		dc=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 $prefix$filenamec.$formt); ds1=$(bc -l <<< "$ds1 + $dc"); fi
	done
	STARTTIME=$(date +%s)
break;;
* ) echo "Invalid choice. Please answer y for yes or n for no."; echo;;
esac
done


################concatenate video files without audio##################
echo
echo -e "${BLUE}...concatenating video files...${NC}"
ffmpeg -f concat -i tmp_list.txt -c copy -loglevel 'fatal' -an tmp_output.mp4
if [[ -f tmp_output.mp4 ]] ; then echo -e "${GREEN}done${NC}"; else echo -e "${RED} UOPS!AN ERROR OCCURRED HERE! ${NC}"; fi

################add audio##############################################
#rm -f tmp_out.mp4
if [[ $flagsong2 = 1 ]] ; then
	echo
	echo -e "${BLUE}...concatenating audio files...${NC}"
	fadeduration=2;
	ds1m=$(bc -l <<< "$ds1 - $fadeduration")
	rm -f tmp_s1.mp3
	rm -f tmp_audio.mp3
	ffmpeg -i $parentdir/$song1 -t $ds1 -af afade=t=out:st=$ds1m:d=$fadeduration -loglevel 'fatal' tmp_s1.mp3
	ffmpeg -i "concat:tmp_s1.mp3|$parentdir/$song2" -acodec copy -loglevel 'fatal' tmp_audio.mp3
	if [[ -f tmp_audio.mp3 ]] ; then echo -e "${GREEN}done${NC}"; else echo -e "${RED} UOPS!AN ERROR OCCURRED HERE! ${NC}"; fi

	echo
	echo -e "${BLUE}...merging video and audio...${NC}"
	ffmpeg -i tmp_audio.mp3 -i tmp_output.mp4 -map 0:a:0 -map 1:v:0 -c:v copy -c:a copy -loglevel 'fatal' -shortest tmp_out.mp4
else
	echo
	echo -e "${BLUE}...merging video and audio...${NC}"
	ffmpeg -i $parentdir/$song -i tmp_output.mp4 -map 0:a:0 -map 1:v:0 -c:v copy -c:a copy -loglevel 'fatal' -shortest tmp_out.mp4
fi
if [[ -f tmp_out.mp4 ]] ; then echo -e "${GREEN}sounds good${NC}"; else echo -e "${RED} UOPS!AN ERROR OCCURRED HERE! ${NC}"; fi


################learn video properties of raw files#####################
mysar=$(ffprobe -v error -select_streams v:0 -show_entries stream=sample_aspect_ratio -of default=noprint_wrappers=1:nokey=1 tmp_output.mp4)
myw=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 tmp_output.mp4)
myh=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 tmp_output.mp4)
mypf=$(ffprobe -v error -select_streams v:0 -show_entries stream=pix_fmt -of default=noprint_wrappers=1:nokey=1 tmp_output.mp4)
myfr=$(ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of default=noprint_wrappers=1:nokey=1 tmp_output.mp4)
myd=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 tmp_output.mp4)


################check Intro file has the same properties#################
alrdn=0
if [ -f $parentdir/Intro0.mp4 ] ; then
Isar=$(ffprobe -v error -select_streams v:0 -show_entries stream=sample_aspect_ratio -of default=noprint_wrappers=1:nokey=1 $parentdir/Intro0.mp4)
Iw=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 $parentdir/Intro0.mp4)
Ih=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 $parentdir/Intro0.mp4)
Ipf=$(ffprobe -v error -select_streams v:0 -show_entries stream=pix_fmt -of default=noprint_wrappers=1:nokey=1 $parentdir/Intro0.mp4)
if [ "$Isar" = "$mysar" ] && [ "$Iw" = "$myw" ] && [ "$Ih" = "$myh" ]; then alrdn=1 ; fi
fi

if [ "$alrdn" = 0 ] ; then
echo
echo -e "${BLUE}...creating intro file...${NC}"
rm -f $parentdir/Intro0.mp4
rm -f $parentdir/Outro0.mp4
ffmpeg -i $parentdir/Intro.mp4 -vf scale=${myw}:${myh},setsar=$mysar -r ${myfr} -loglevel 'fatal' $parentdir/Intro0.mp4
if [[ -f $parentdir/Intro0.mp4 ]] ; then echo -e "${GREEN}nice${NC}"; else echo -e "${RED} UOPS!AN ERROR OCCURRED HERE! ${NC}"; fi
echo
echo -e "${BLUE}...creating outro file...${NC}"
ffmpeg -i $parentdir/Outro.mp4 -vf scale=${myw}:${myh},setsar=$mysar -r ${myfr} -loglevel 'fatal' $parentdir/Outro0.mp4
if [[ -f $parentdir/Outro0.mp4 ]] ; then echo -e "${GREEN}very nice${NC}"; else echo -e "${RED} UOPS!AN ERROR OCCURRED HERE! ${NC}"; fi
fi


################fading###################################################
echo
echo -e "${BLUE}...creating fad${NC}e out ${BLUE}effect...${NC}"
fadeduration=2
if [ "${myd%.*}" -lt "$fadeduration" ] ; then
echo
echo -e "${YELLOW} cannot create fadeout effect: input file too short!${NC}"
mv tmp_out.mp4 tmp_outfade.mp4
else
myd=$(bc -l <<< "$myd - $fadeduration")
mydv=$(bc -l <<< "$myd * $myfr")
myddv=$(bc -l <<< "$fadeduration * $myfr")
ffmpeg -i tmp_out.mp4 -filter:v fade=out:$mydv:$myddv -af "afade=t=out:st=$myd:d=$fadeduration" -preset veryfast -loglevel 'fatal' tmp_outfade.mp4
fi
if [[ -f tmp_outfade.mp4 ]] ; then echo -e "${GREEN}almost there${NC}"; else echo -e "${RED} UOPS!AN ERROR OCCURRED HERE! ${NC}"; fi

################all together##############################################
echo
echo -e "${BLUE}...creating final file...${NC}"

rm -f TANDEMJUMP.mp4
ffmpeg -i $parentdir/Intro0.mp4 -i tmp_outfade.mp4 -i $parentdir/Outro0.mp4 -filter_complex "[0:v:0] [0:a:0] [1:v:0] [1:a:0] [2:v:0] [2:a:0] concat=n=3:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" -loglevel 'fatal' TANDEMJUMP.mp4 

if [[ -f TANDEMJUMP.mp4 ]] ; then echo -e "${GREEN}perfect!${NC}"; else echo -e "${RED} UOPS!AN ERROR OCCURRED HERE! ${NC}"; fi


################write on chosen device####################################
if [ "$odevice" = 1 ] ; then
echo
echo "${BLUE}...copying the file to your usb device...${NC}"
cp TANDEMJUMP.mp4 /Volumes/"$name"/
fi
if [ "$odevice" = 2 ] ; then
echo
echo -e "${BLUE}...creating dvd file...${NC}"
ffmpeg -i TANDEMJUMP.mp4 -target pal-dvd -loglevel 'fatal' dvd.mpg
#-preset ultrafast
dvdauthor -o dvd/ -t dvd.mpg
export VIDEO_FORMAT=PAL
dvdauthor -o dvd/ -T
mkisofs -dvd-video -o dvd.iso dvd/
cdrecord -v -dao speed=4 dev=/dev/dvd dvd.iso
fi


echo
ENDTIME=$(date +%s)
echo "Elapsed time is $(($ENDTIME - $STARTTIME)) seconds"
echo
echo -e "${BLUE}editing procedure complete!${NC}"
say "editing procedure complete"
echo

rm -f tmp_*

#test dvd making
