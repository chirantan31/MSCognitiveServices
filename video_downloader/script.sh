#!/bin/sh
# This is a comment! h0e2HAPTGF4
echo Hello World
youtube-dl -f 140,133 --output $1".%(ext)s" "https://www.youtube.com/watch?v="$1
file_name=`ls | grep $1`
echo "$file_name"
loc=$PWD/$file_name
output=$1'.wav'
echo \'$loc\'
# -c:a pcm_s16le -ac 1 -ar 16000 '1.wav'
ffmpeg -nostdin -i `ls | grep $1` -c:a pcm_s16le -ac 1 -ar 16000 $output
echo Hello Again
loc='cognitive-services-speech-sdk-master/samples/csharp/dotnetcore/console/samples/bin/Debug/netcoreapp2.0/publish/samples.dll'
#echo $loc
/usr/bin/dotnet  `echo $loc` $output