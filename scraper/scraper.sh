#!/bin/sh
# This is a comment! h0e2HAPTGF4
echo Hello World
$play_session=""
curl 'https://echo360.org/section/0f681b91-e357-4c4b-9607-4e2e302d2245/syllabus' -H "Cookie: PLAY_SESSION=8961c8563522d5688b547963849b2d999bdc0fc5-role=Instructor&institution=d422df75-c848-4e5e-b375-e46893d4de8a&classesGraphId=&questionQuery=%7B%22sectionId%22%3A%220f681b91-e357-4c4b-9607-4e2e302d2245%22%2C%22lessonId%22%3A%22G_fc164d0a-fc39-46f6-a95f-7b6755bb995e_0f681b91-e357-4c4b-9607-4e2e302d2245_2018-09-14T09%3A00%3A00.000_2018-09-14T09%3A53%3A00.000%22%2C%22sortDirection%22%3A%22desc%22%2C%22isClassroom%22%3Atrue%2C%22pageNumber%22%3A0%7D&roles=Instructor%2CStudent&csrfToken=43afcf0ea29e1778df19a16b5ce98129edab2edc-1538025010593-848003bf49dcf75333695789&user=2143bda1-7bed-4aac-ac6b-bbb15c2e86f2;"  --compressed | python -m json.tool | grep "s3Url" | grep "audio" | awk  -F": |\"" '{print $5}' > audio_url.txt
echo $play_session


