#Author          :LiteSpeedtech & Gia Tuấn
#date            :20250315
#version         :2.0.1
#Require         :Prepare site map XML
#                 Allow LSCache crawler
#=======================================================

AGENTDESKTOP='User-Agent: lscache_runner'
AGENTMOBILE='User-Agent: lscache_runner iPhone'
SVALUE="0.1"
WITH_MOBILE='OFF'
WITH_COOKIE='OFF'
COOKIE=''
CUSTUM_COOKIE=''
WITH_WEBP=''
XML_LIST=()
CURL_OPTS=''
PROTECTOR='OFF'
ESCAPE='OFF'
VERBOSE='OFF'
DEBUGURL='OFF'
BLACKLIST='OFF'
CRAWLQS='OFF'
REPORT='OFF'
CRAWLLOG='/tmp/crawler.log'
BLACKLSPATH='/tmp/blk_crawler.txt'
CT_URLS=0
CT_NOCACHE=0
CT_CACHEHIT=0
CT_CACHEMISS=0
CT_BLACKLIST=0
CT_FAILCACHE=0
DETECT_NUM=0
DETECT_LIMIT=10
ERR_LIST="'400'|'401'|'403'|'404'|'407|'500'|'502'"
EPACE='        '

function echoY
{
    echo -e "\033[38;5;41m${1}\033[39m"
}
function echoG
{
    echo -e "\033[38;5;71m${1}\033[39m"
}
function echoR
{
    echo -e "\033[38;5;203m${1}\033[39m"
}
function echoB
{
    echo -e "\033[1;3;94m${1}\033[0m"
}
function echoCYAN
{
    FLAG=$1
    shift
    echo -e "\033[1;36m$FLAG\033[0m$@"
}
function echow
{
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

function help_message() {
case ${1} in

    "1")
        cat <<EOF
        Server crawler engine not enabled. Please check
        https://docs.litespeedtech.com/cp/cpanel/lscache/#crawler
        Stop crawling...
EOF
    ;;
    "2")
       echo -e "\033[1mIMPORTANT\033[0m"
        echow 'Valid xml file and allow LSCache cawler are needed'

        echo -e "\033[1mEXAMPLE\033[0m"
        echow "0. bash cachecrawler.sh -h                 ## help"
        echow "1. bash cachecrawler.sh SITE-MAP-URL       ## When desktop and mobile share same theme"
        echow "2. bash cachecrawler.sh -m SITE-MAP-URL    ## When desktop & mobile have different theme"
        echow "3. bash cachecrawler.sh -g -m SITE-MAP-URL ## Use general user-agent when mobile view not working"
        echow "4. bash cachecrawler.sh -c SITE-MAP-URL    ## For brining cookies case"
        echow "5. bash cachecrawler.sh -b -c SITE-MAP-URL ## For brining cookies case and blacklist check"

        echo -e "\033[1mDEBUG EXAMPLE\033[0m"
        echow "1. bash cachecrawler.sh -v SITE-MAP-URL    ## To output details to crawler log"
        echow "2. bash cachecrawler.sh -d SITE-URL        ## Debug one URL directly"
        echow "3. bash cachecrawler.sh -b -c -d SITE-URL  ## Debug one URL with cookies and blacklist check"

        echo -e "\033[1mSITE MAP EXAMPLE\033[0m"
        echow "0. http://magento.com/sitemap.xml"
        echo "${EPACE}${EPACE}Please check LiteSpeed doc here for more information:"
        echoB "${EPACE}${EPACE}https://docs.litespeedtech.com/lscache/lscps/crawler/"

        echo -e "\033[1mOPTIONAL ARGUMENTS\033[0m"
        echow '-h, --help'
        echo "${EPACE}${EPACE}Show this message and exit"
        echow '-m, --with-mobile'
        echo "${EPACE}${EPACE}Crawl mobile view in addition to default view"
        echow '-c, --with-cookie'
        echo "${EPACE}${EPACE}Crawl with site's cookies"
        echow '-cc, --custom-cookie'
        echo "${EPACE}${EPACE}Crawl with site's cookies and custom cookie"        
        echow '-w, --webp'
        echo "${EPACE}${EPACE}Crawl with webp header"
        echow '-b, --black-list'
        echo "${EPACE}${EPACE}Page will be added to black list if html status error and no cache. Next run will bypas page"
        echow '-g, --general-ua'
        echo "${EPACE}${EPACE}Use general user-agent instead of lscache_runner"
        echow '-i, --interval'
        echo "${EPACE}${EPACE}Change request interval. '-i 0.2' changes from default 0.1s to 0.2s"
        echow '-e, --escape'
        echo "${EPACE}${EPACE}To escape URL with perl, use this when your URL has special character."   
        echow '-v, --verbose'
        echo "${EPACE}${EPACE}Show complete response header under /tmp/crawler.log"
        echow '-d, --debug-url'
        echo "${EPACE}${EPACE}Test one URL directly. sh cachecrawler.sh -v -d http://example.com/test.html"
        echow '-qs,--crawl-qs'
        echo "${EPACE}${EPACE}Crawl sitemap, including URLS with query strings"
        echow '-r, --report'
        echo "${EPACE}${EPACE}Display total count of crawl result"
    ;;
    esac
exit 1
}


function checkcurlver(){
    curl --help | grep 'Use HTTP 2' > /dev/null
    if [ ${?} = 0 ]; then
        CURL_OPTS='--http1.1'
    fi
}
### Curl with version1 only
checkcurlver

function excludecookie(){
    ### Check if cloudflare
    if [[ $(echo "${1}" | grep -i 'Server: cloudflare') ]]; then
        CURLRESULT=$(echo "${1}" | grep -Ev 'Set-Cookie.*__cfduid')
    fi
}

function duplicateck(){
    grep -w "${1}" ${2} >/dev/null 2>&1
}

function cachecount(){
    if [ ${1} = 'miss' ]; then
        CT_CACHEMISS=$((CT_CACHEMISS+1))
    elif [ ${1} = 'hit' ]; then
        CT_CACHEHIT=$((CT_CACHEHIT+1))
    elif [ ${1} = 'no' ]; then
        CT_NOCACHE=$((CT_NOCACHE+1))
    elif [ ${1} = 'black' ]; then
        CT_BLACKLIST=$((CT_BLACKLIST+1))
    elif [ ${1} = 'fail' ]; then
        CT_FAILCACHE=$((CT_FAILCACHE+1))
    elif [[ ${1} =~ ^[0-9]+$ ]]; then
        CT_URLS=$((CT_URLS+${1}))
    else
        echoR "${1} no define to cachecount!"
    fi
}

prttwostr(){
    printf "\033[38;5;71m%s\033[39m \t%s\t \033[1;30m%s\033[0m \n" "${1}" "${2}" "${3}"
}

function cachereport(){
    echoY '=====================Crawl result:======================='
    prttwostr "Total URLs :" "${CT_URLS}" ''
    prttwostr "Added      :" "${CT_CACHEMISS}" ''
    prttwostr "Existing   :" "${CT_CACHEHIT}" ''
    if [ "${CT_NOCACHE}" -gt 0 ]; then
        TMPMESG="(Page with 'no cache', please check cache debug log for the reason)"
    else
        TMPMESG=''
    fi
    prttwostr "Skipped    :" "${CT_NOCACHE}" "${TMPMESG}"
    if [ "${BLACKLIST}" != 'OFF' ]; then
        if [ "${CT_BLACKLIST}" -gt 0 ]; then
            TMPMESG="(Pages with status code ${ERR_LIST} may add into blacklist)"
        else
            TMPMESG=''
        fi
        prttwostr "Blacklisted:" "${CT_BLACKLIST}" "${TMPMESG}"
    fi
    if [ "${CT_FAILCACHE}" -gt 0 ]; then
        TMPMESG="(Pages with status code ${ERR_LIST} may add into blacklist)"
    else
        TMPMESG=''
    fi
    prttwostr "Failed     :" "${CT_FAILCACHE}" "${TMPMESG}"
}

function protect_count(){
    if [ "${PROTECTOR}" = 'ON' ]; then
        if [ ${1} -eq 1 ]; then
            DETECT_NUM=$((DETECT_NUM+1))
            if [ ${DETECT_NUM} -ge ${DETECT_LIMIT} ]; then
                echoR "Hit ${DETECT_LIMIT} times 'page error' or 'no cache' in a row, abort !!"
                echoR "To run script with no abort, please set PROTECTOR from 'ON' to 'OFF'."
                exit 1
            fi
        elif [ ${1} -eq 0 ]; then
            DETECT_NUM=0
        fi
    fi
}
function addtoblacklist(){
    echoB "Add ${1} to BlackList"
    echo "${1}" >> ${BLACKLSPATH}
}

function escape_url(){
    export TMP_URL_ENV="${1}"
    URL=$(perl -MURI::Escape -e 'print uri_escape("$ENV{TMP_URL_ENV}", "^A-Za-z0-9\-\._~:?/")')
}

function debugurl_display(){
    echo ''
    echoY "-------Debug curl start-------"
    echoY "URL: ${2}"
    echoY "AGENTDESKTOP: ${1}"
    echoY "COOKIE: ${3}"
    echo "${4}"
    echoY "-------Debug curl end-------"
    echoY "Header Match: ${5}"
}

function crawl_verbose(){
    echo "URL: ${2}" >> ${CRAWLLOG}
    echo "AGENTDESKTOP: ${1}" >> ${CRAWLLOG}
    echo "COOKIE: ${3}" >> ${CRAWLLOG}
    echo "${4}" >> ${CRAWLLOG}
    echo "Header Match: ${5}" >> ${CRAWLLOG}
    echo "----------------------------------------------------------" >> ${CRAWLLOG}
}


# hàm được sửa lại cho tương thích với toàn bộ preload cache
function crawlreq() {
    if [ "${DEBUGURL}" != "OFF" ] && [ "${BLACKLIST}" = 'ON' ]; then
        duplicateck ${2} ${BLACKLSPATH}
        if [ ${?} = 0 ]; then
            echoY "${2} is in blacklist"
            exit 0
        fi    
    fi
    echo "${2} -> " | tr -d '\n'
	domain_host=$(echo ${2}| sed 's/https\?:\/\///g'| cut -f1 -d '/'| sed 's/^www.//g')
    if [ ! -z "${WITH_WEBP}" ]; then

        CURLRESULT=$(curl ${CURL_OPTS} --connect-to "${domain_host}::127.0.0.1:443" --connect-to "${domain_host}::127.0.0.1:80" -siLk -b name="${3}" -X GET -H "Accept-Encoding: gzip, deflate, br" -H "${1}" -H "Accept: image/webp" ${2} \
         | sed '/^HTTP\/1.1 3[0-9][0-9]/,/^\r$/d' | tac | tac | sed '/Server: /Iq' | tr '\n' ' ')
    else     
        CURLRESULT=$(curl ${CURL_OPTS} --connect-to "${domain_host}::127.0.0.1:443" --connect-to "${domain_host}::127.0.0.1:80" -siLk -b name="${3}" -X GET -H "Accept-Encoding: gzip, deflate, br" -H "${1}" ${2} \
         | sed '/^HTTP\/1.1 3[0-9][0-9]/,/^\r$/d' | tac | tac |  sed '/Server: /Iq'|tr '\n' ' ')
    fi     
    excludecookie "${CURLRESULT}"
    STATUS_CODE=$(echo "${CURLRESULT}" | grep HTTP | awk '{print $2}')
if [[ $STATUS_CODE = '200' ]];then
            echoY 'Đang tiến hành tạo cache'
            cachecount 'miss'
            protect_count 0
else
            echoY 'Không tạo được cache'
            cachecount 'fail'
            protect_count 1
fi
}


#ham mặc định
function crawlreq_mac_dinh() {
    if [ "${DEBUGURL}" != "OFF" ] && [ "${BLACKLIST}" = 'ON' ]; then
        duplicateck ${2} ${BLACKLSPATH}
        if [ ${?} = 0 ]; then
            echoY "${2} is in blacklist"
            exit 0
        fi
    fi
    echo "${2} -> " | tr -d '\n'
    if [ ! -z "${WITH_WEBP}" ]; then
        CURLRESULT=$(curl ${CURL_OPTS} -siLk -b name="${3}" -X GET -H "Accept-Encoding: gzip, deflate, br" -H "${1}" -H "Accept: image/webp" ${2} \
         | sed '/^HTTP\/1.1 3[0-9][0-9]/,/^\r$/d' | tac | tac | sed '/Server: /Iq')
    else
        CURLRESULT=$(curl ${CURL_OPTS} -siLk -b name="${3}" -X GET -H "Accept-Encoding: gzip, deflate, br" -H "${1}" ${2} \
         | sed '/^HTTP\/1.1 3[0-9][0-9]/,/^\r$/d' | tac | tac | sed '/Server: /Iq')
    fi

    excludecookie "${CURLRESULT}"
    STATUS_CODE=$(echo "${CURLRESULT}" | grep HTTP | awk '{print $2}')

    CHECKMATCH=$(echo ${STATUS_CODE} | grep -Eio "$(echo ${ERR_LIST} | tr -d "'")")
    if [ "${CHECKMATCH}" == '' ]; then
        CHECKMATCH=$(grep -Eio '(x-lsadc-cache: hit,litemage|x-lsadc-cache: hit|x-lsadc-cache: miss|x-qc-cache: hit|x-qc-cache: miss)'\
        <<< ${CURLRESULT} | tr -d '\n')
    fi
    if [ "${CHECKMATCH}" == '' ]; then
        CHECKMATCH=$(grep -Eio '(X-LiteSpeed-Cache: miss|X-Litespeed-Cache: hit|X-Litespeed-Cache-Control: no-cache)'\
        <<< ${CURLRESULT} | tr -d '\n')
    fi
    if [ "${CHECKMATCH}" == '' ]; then
        CHECKMATCH=$(grep -Eio '(lsc_private|HTTP/1.1 201 Created|HTTP/2 201|HTTP/3 201)'\
        <<< ${CURLRESULT} | tr -d '\n')
    fi
    if [ ${VERBOSE} = 'ON' ]; then
        crawl_verbose "${1}" "${2}" "${3}" "${CURLRESULT}" "${CHECKMATCH}"
    fi
    if [[ ${DEBUGURL} != "OFF" ]]; then
        debugurl_display "${1}" "${2}" "${3}" "${CURLRESULT}" "${CHECKMATCH}"
    fi
    case ${CHECKMATCH} in
        'CreatedSet-CookieSet-CookieSet-Cookie'|[Xx]-[Ll]ite[Ss]peed-[Cc]ache:\ miss|'X-LSADC-Cache: miss'|[Xx]-[Qq][Cc]-[Cc]ache:\ miss)
            echoY 'Đang tiến hành tạo cache'
            cachecount 'miss'
            protect_count 0
        ;;
        'HTTP/1.1 201 Created'|'HTTP/2 201 Created'|'HTTP/2 201'|'HTTP/3 201 Created'|'HTTP/3 201')
            if [ $(echo ${CURLRESULT} | grep -i 'Cookie' | wc -l ) != 0 ]; then
                if [[ ${DEBUGURL} != "OFF" ]]; then
                    echoY "Set-Cookie found"
                fi
                echoY 'Đang tiến hành tạo cache'
                cachecount 'miss'
            else
                echoY 'Cache đã được tạo trước đó rồi'
                cachecount 'hit'
            fi
            protect_count 0
        ;;
        [Xx]-[Ll]ite[Ss]peed-Cache:\ hit|'x-lsadc-cache: hit'|'x-lsadc-cache: hit,litemage'|'x-qc-cache: hit')
            echoY 'Cache đã được tạo trước đó rồi'
            cachecount 'hit'
            protect_count 0
        ;;
        'HTTP/1.1 201 Createdlsc_private'|'HTTP/2 201lsc_private'|'HTTP/3 201lsc_private')
            echoY 'Đang tiến hành tạo cache'
            cachecount 'miss'
            protect_count 0
        ;;
        '400'|'401'|'403'|'404'|'407'|'500'|'502')
            echoY "STATUS: ${CHECKMATCH}, không thể lưu cache"
            cachecount 'fail'
            protect_count 1
            if [ "${BLACKLIST}" = 'ON' ]; then
                addtoblacklist ${2}
            fi
        ;;
        [Xx]-[Ll]ite[sS]peed-Cache-Control:\ no-cache)
            echoY 'Trang web không cần bộ nhớ cache'
            cachecount 'no'
            protect_count 1
            ### To add 'no cache' page to black list, remove following lines' comment
            #if [ "${BLACKLIST}" = 'ON' ]; then
            #    addtoblacklist ${2}
            #fi
        ;;
        *)
            echoY 'Trang web không cần bộ nhớ cache'
            cachecount 'no'
        ;;
    esac
}

function runLoop() {
    for URL in ${URLLIST}; do
        local ONLIST='NO'
        if [ "${ESCAPE}" = 'ON' ]; then
            escape_url "${URL}"
        fi
        if [ "${BLACKLIST}" = 'ON' ]; then
            duplicateck ${URL} ${BLACKLSPATH}
            if [ ${?} -eq 0 ]; then
                ONLIST='YES'
                cachecount 'black'
            fi
        fi
        if [ "${ONLIST}" = 'NO' ]; then
            crawlreq "${1}" "${URL}" "${2}"
            sleep ${SVALUE}
        fi
    done
}

function validmap(){
	domain_host=$(echo ${SITEMAP}| sed 's/https\?:\/\///g'| cut -f1 -d '/'| sed 's/^www.//g')
	CURL_CMD="curl -IkL -w httpcode=%{http_code}"
	CURL_MAX_CONNECTION_TIMEOUT="-m 100"
	CURL_RETURN_CODE=0
	CURL_OUTPUT=$(${CURL_CMD} ${CURL_MAX_CONNECTION_TIMEOUT} ${SITEMAP} --connect-to "${domain_host}::127.0.0.1:443" --connect-to "${domain_host}::127.0.0.1:80"  -A "WPTangToc OLS preload cache check" 2> /dev/null) || CURL_RETURN_CODE=$?

	if [ ${CURL_RETURN_CODE} -ne 0 ]; then
. /etc/wptt/.wptt.conf
if [[ $ngon_ngu = '' ]];then
	ngon_ngu='vi'
fi
. /etc/wptt/lang/$ngon_ngu.sh

echo "Kết nối không thành công với không có code mã nào được trả về - ${CURL_RETURN_CODE}, exit"
echo "========================================================================="
echo " Preload cache $da_xay_ra_loi_vui_long_thu_lai_sau	                       "
echo "========================================================================="
		wptangtoc 1

		exit 1

	else
		HTTPCODE=$(echo "${CURL_OUTPUT}" | grep 'HTTP'| tail -1 | awk '{print $2}')
		if [ "${HTTPCODE}" != '200' ]; then


. /etc/wptt/.wptt.conf
if [[ $ngon_ngu = '' ]];then
	ngon_ngu='vi'
fi
. /etc/wptt/lang/$ngon_ngu.sh

echo "Kết nối không thành công do mã trả về khác 200 HTTP - ${HTTPCODE}, exit"
echo "========================================================================="
echo " Preload cache $da_xay_ra_loi_vui_long_thu_lai_sau	                       "
echo "========================================================================="
			wptangtoc 1
			exit 1


		fi
		echoG "Kết với sitemap thành công \n"
	fi
}

function checkcrawler() {
    TRYURL=$(echo ${URLLIST} | cut -d " " -f1)
    CRAWLRESULT=$(curl ${CURL_OPTS} -sI -X GET -H "${AGENTDESKTOP}" $TRYURL| grep -o "Precondition Required")
    if [ "${CRAWLRESULT}" = 'Precondition Required' ]; then
        help_message 1
    fi
}

function genrandom(){
    RANDOMSTR=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16 ; echo '')
}

function getcookie() {

    for URL in ${URLLIST}; do
        local ONLIST='NO'
        if [ "${BLACKLIST}" = 'ON' ]; then
            duplicateck ${URL} ${BLACKLSPATH}
            if [ ${?} -eq 1 ]; then
                break
            fi
        fi
    done
    COOKIESTRING=$(curl ${CURL_OPTS} -sILk -X GET ${URL} | grep -i 'Set-Cookie' | awk '{print $2}' | tr '\n' ' ')
    if [ "${COOKIESTRING}" = '' ]; then
        genrandom
        COOKIESTRING=$(curl ${CURL_OPTS} -sILk -X GET ${URL}?${RANDOMSTR} | grep -i 'Set-Cookie' | awk '{print $2}' | tr '\n' ' ')
    fi
    COOKIE="${COOKIESTRING}"
    if [ ! -z "${CUSTUM_COOKIE}" ]; then
        COOKIE="${COOKIE} ${CUSTUM_COOKIE}"
    fi
}

function debugurl() {
    URL="${1}"
    if [ "${WITH_COOKIE}" = 'ON' ]; then
        getcookie
    fi
    if [ "${ESCAPE}" = 'ON' ]; then
        escape_url "${URL}"
    fi
    if [ "${WITH_MOBILE}" = 'ON' ]; then
        crawlreq "${AGENTMOBILE}" "${URL}" "${COOKIE}"
    else
        crawlreq "${AGENTDESKTOP}" "${URL}" "${COOKIE}"
    fi
}

function storexml() {
#bình luận validmap không cần phải check điêu kiện vì preload-cache2 đã check điều kiện rooiff
    # validmap
    if [ $(echo ${1} | grep '\.xml$'|wc -l) != 0 ]; then
		#thêm sed 's/<loc>/\n<loc>/g' để tương thích với wp sitemap vì wp sitemap nó nén, nên phải giải mã kiểu này mới tương thích
        XML_URL=$(curl ${CURL_OPTS} -sk ${1}| grep '<loc>' | grep '\.xml' | sed 's/<loc>/\n<loc>/g'| sed -e 's/.*<loc>\(.*\)<\/loc>.*/\1/'| sed '/ xmlns=/d')
        XML_NUM=$(echo ${XML_URL} | grep '\.xml' | wc -l)
        if [ ${XML_NUM} -gt 0 ]; then
            for URL in $XML_URL; do
                XML_LIST=(${URL} "${XML_LIST[@]}")
            done
        else
            XML_LIST=(${1} "${XML_LIST[@]}")
        fi
    else
        echo "SITEMAP: $SITEMAP is not a valid xml"
        help_message 2
    fi
}

function maincrawl() {
    checkcrawler
    echoY "Có ${URLCOUNT} urls trong sitemap này"
    if [ ${URLCOUNT} -gt 0 ]; then
        START_TIME="$(date -u +%s)"
        echoY 'Bắt đầu Preload Cache...'
        if [ "${WITH_COOKIE}" = 'ON' ]; then
            getcookie
        fi
        cachecount ${URLCOUNT}
        runLoop "${AGENTDESKTOP}" "${COOKIE}"
        if [ "${WITH_MOBILE}" = 'ON' ]; then
            echoY 'Starting to view with mobile agent...'
            cachecount ${URLCOUNT}
            runLoop "${AGENTMOBILE}" "${COOKIE}"
        fi
        END_TIME="$(date -u +%s)"
        ELAPSED="$((${END_TIME}-${START_TIME}))"
        echoY "***Tổng ${ELAPSED} giây hoàn thành tiến trình***"
    fi
}

function main(){
    if [ "${DEBUGURL}" != 'OFF' ]; then
        debugurl ${DEBUGURL}
    else
        for XMLURL in "${XML_LIST[@]}"; do
            echoCYAN "Chuẩn bị quét ${XMLURL} XML file"
			domain_host=$(echo ${XMLURL}| sed 's/https\?:\/\///g'| cut -f1 -d '/'| sed 's/^www.//g')
            if [ "${CRAWLQS}" = 'ON' ]; then
                URLLIST=$(curl ${CURL_OPTS} -Lk --silent ${XMLURL} --connect-to "${domain_host}::127.0.0.1:443" --connect-to "${domain_host}::127.0.0.1:80" -A "WPTangToc OLS preload cache" | sed -e 's/\/url/\n/g'| grep '<loc>' |  sed 's/<loc>/\n<loc>/g'|\
                    sed -e 's/.*<loc>\(.*\)<\/loc>.*/\1/' | sed 's/<!\[CDATA\[//;s/]]>//' | \
                    grep -iPo '^((?!png|jpg|webp).)*$' | sort -u| sed '/ xmlns=/d'| sed '/><url>/d')
            else
                URLLIST=$(curl ${CURL_OPTS} -Lk --silent ${XMLURL} --connect-to "${domain_host}::127.0.0.1:443" --connect-to "${domain_host}::127.0.0.1:80" -A "WPTangToc OLS preload cache" | sed -e 's/\/url/\n/g'| grep '<loc>' |  sed 's/<loc>/\n<loc>/g'| \
                    sed -e 's/.*<loc>\(.*\)<\/loc>.*/\1/' | sed 's/<!\[CDATA\[//;s/]]>//;s/.*?.*//' | \
                    grep -iPo '^((?!png|jpg|webp).)*$' | sort -u| sed '/ xmlns=/d'| sed '/><url>/d')
            fi
            URLCOUNT=$(echo "${URLLIST}" | grep -c '[^[:space:]]')
            maincrawl
        done
        if [ "${REPORT}" != 'OFF' ]; then
            cachereport
        fi
    fi
}

while [ ! -z "${1}" ]; do
    case ${1} in
        -h | --help)
            help_message 2
        ;;
        -m | --with-mobile | --mobile)
            WITH_MOBILE='ON'
        ;;
        -c | --with-cookie | --cookie)
            WITH_COOKIE='ON'
        ;;
        -cc | --custom-cookie) shift
            WITH_COOKIE='ON'
            CUSTUM_COOKIE="${1}"
        ;;
        -i | --interval)  shift
            SVALUE=${1}
        ;;
        -w | --WITH_WEBP | --webp)
            WITH_WEBP='ENABLE'
        ;;
        -g| --general-ua)
            AGENTDESKTOP='User-Agent: General'
            AGENTMOBILE='User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1'
        ;;
        -e | --escape)
            ESCAPE='ON'
            export LC_CTYPE=en_US.UTF-8
            export LC_ALL=en_US.UTF-8
        ;;
        -v | --verbose)
            VERBOSE='ON'
        ;;
        -b | --black-list)
            BLACKLIST='ON'
            if [ ! -e ${BLACKLSPATH} ]; then
                touch ${BLACKLSPATH}
            fi
        ;;
        -d | --debug-url) shift
            if [ "${1}" = '' ]; then
                help_message 2
            else
                DEBUGURL="${1}"
                URLLIST="${1}"
                if [ ! -e ${CRAWLLOG} ]; then
                    touch ${CRAWLLOG}
                fi
            fi
        ;;
        -qs | --crawl-qs)
            CRAWLQS='ON'
        ;;
        -r | --report)
            REPORT='ON'
        ;;
        *)
            SITEMAP=${1}
            storexml ${SITEMAP}
        ;;
    esac
    shift
done
main




