#!/bin/sh
echo Hello Again

loc='cognitive-services-speech-sdk-master/samples/csharp/dotnetcore/console/samples/bin/Debug/netcoreapp2.0/publish/samples.dll'

#echo $loc

/usr/bin/dotnet  `echo $loc`

