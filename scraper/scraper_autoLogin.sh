cookie1=$(curl -sSL -D - 'https://echo360.org/directLogin' -o /dev/null | grep "Set-Cookie: ")
cookie1=${cookie1#*:}
cookie1=${cookie1%%; *}
echo $cookie1
csrfToken=${cookie1#*-}
echo $csrfToken
cookie2=$(curl -D - "https://echo360.org/login?${csrfToken}" -H 'Referer: https://echo360.org/directLogin' -H "Cookie: ${cookie1}" --data 'institutionId=&userId=&afterLoginUrl=&email=hongyuw2%40illinois.edu&password=JmjlfZYERRIvbYjb&captchaBypassKey=&action=Save' --compressed  | grep "Set-Cookie: ")
cookie2=${cookie2#*:}
cookie2=${cookie2%%; *}
echo $cookie2
echo $(curl -D cookie3.txt 'https://echo360.org/home' -H "Cookie: ${cookie2}" --compressed > home.html)
cookie3=$(cat cookie3.txt)
CloudFront_Policy=${cookie3#*Set-Cookie:}
CloudFront_Policy=${CloudFront_Policy#*:}
CloudFront_Signature=${CloudFront_Policy#*:}
CloudFront_Signature=${CloudFront_Signature%%;*}
CloudFront_Policy=${CloudFront_Policy%%;*}
CloudFront_Key_Pair_Id='CloudFront-Key-Pair-Id=APKAIPMYRDQXV3PXG2XA'
echo $CloudFront_Key_Pair_Id
echo $CloudFront_Policy
echo $CloudFront_Signature
echo Start getting section ids...
html=$(cat home.html)
html=${html#*<div class=\"course-dropdown-panel\">}
html=${html%%</div>*}
args=$(echo $html | awk -F "section/" 'BEGIN{i=2} {while(i<=NF) {print $i; i++}}')
arr=()
i=0
for elem in ${args[@]}
do
    temp=${elem%%/home\"*}
    if [ "${elem}" != "${temp}" ]; then
      echo $temp
      arr[i]=$temp
      ((i+=1))
    fi
done
i=1
for elem in ${arr[@]}
do
    echo $elem
    echo Start getting audio urls...
    $play_session=""
    curl "https://echo360.org/section/${elem}/syllabus" -H "Cookie: ${cookie2}"  --compressed | python -m json.tool | grep "s3Url" | grep "audio" | awk  -F": |\"" '{print $5}' > audio_url_temp.txt
    echo $play_session
    IFS=$'\n' read -d '' -r -a urls < audio_url_temp.txt
    echo Start downloading audio...
    n=1
    for url in ${urls[@]}
    do
        wget --header="Cookie: ${CloudFront_Key_Pair_Id}; ${CloudFront_Policy}; ${CloudFront_Signature}" --header="Connection: keep-alive" "${url}" -O "audio${i}_${n}.mp3" -c
        ((n+=1))
    done
    ((i+=1))
done
