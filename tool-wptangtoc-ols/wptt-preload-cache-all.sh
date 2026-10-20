#!/bin/bash
# thư viện LiteSpeedtech fork lại bởi Gia Tuấn
# Author          : LiteSpeedtech & Gia Tuấn
# Date            : 20-10-2026
# Version         : 3.0.2
# Require         : Prepare sitemap XML & Allow LSCache crawler
# Description     : Thư viện lõi Preload Cache hiệu năng cao (Zero-Subshell & Adaptive Load Governor)
#=======================================================

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

AGENTDESKTOP='User-Agent: lscache_runner'
AGENTMOBILE='User-Agent: lscache_runner iPhone'
SVALUE="0.2"
WITH_MOBILE='OFF'
WITH_COOKIE='OFF'
COOKIE=''
CUSTUM_COOKIE=''
WITH_WEBP=''
XML_LIST=()
CURL_OPTS='--http1.1'
PROTECTOR='OFF'
ESCAPE='OFF'
VERBOSE='OFF'
DEBUGURL='OFF'
BLACKLIST='OFF'
CRAWLQS='OFF'
REPORT='OFF'
/bin/mkdir -p /etc/wptt/tmp 2>/dev/null || true
chmod 700 /etc/wptt/tmp 2>/dev/null || true
CRAWLLOG='/etc/wptt/tmp/crawler.log'
BLACKLSPATH='/etc/wptt/tmp/blk_crawler.txt'
CT_URLS=0
CT_NOCACHE=0
CT_CACHEHIT=0
CT_CACHEMISS=0
CT_BLACKLIST=0
CT_FAILCACHE=0
DETECT_NUM=0
DETECT_LIMIT=10
ERR_LIST="'400'|'401'|'403'|'404'|'407'|'500'|'502'"
EPACE='        '

SYS_CORES=0
if [[ -r /proc/cpuinfo ]]; then
  while IFS= read -r _line; do
    [[ "$_line" == processor* ]] && ((SYS_CORES++))
  done < /proc/cpuinfo
fi
((SYS_CORES == 0)) && SYS_CORES=1

function echoY {
  echo -e "\033[38;5;41m${1}\033[39m"
}
function echoG {
  echo -e "\033[38;5;71m${1}\033[39m"
}
function echoR {
  echo -e "\033[38;5;203m${1}\033[39m"
}
function echoB {
  echo -e "\033[1;3;94m${1}\033[0m"
}
function echoCYAN {
  local FLAG="$1"
  shift
  echo -e "\033[1;36m$FLAG\033[0m$*"
}
function echow {
  local FLAG="$1"
  shift
  echo -e "\033[1m${EPACE}${FLAG}\033[0m$*"
}

function help_message() {
  case "${1:-}" in
  "1")
    cat <<EOF
        Server crawler engine not enabled. Please check
        https://docs.litespeedtech.com/cp/cpanel/lscache/#crawler
        Stop crawling...
EOF
    ;;
  "2")
    echo -e "\033[1mIMPORTANT\033[0m"
    echow 'Valid xml file and allow LSCache crawler are needed'
    echo -e "\033[1mEXAMPLE\033[0m"
    echow "0. bash cachecrawler.sh -h                 ## help"
    echow "1. bash cachecrawler.sh SITE-MAP-URL       ## When desktop and mobile share same theme"
    echow "2. bash cachecrawler.sh -m SITE-MAP-URL    ## When desktop & mobile have different theme"
    echow "3. bash cachecrawler.sh -g -m SITE-MAP-URL ## Use general user-agent when mobile view not working"
    echow "4. bash cachecrawler.sh -c SITE-MAP-URL    ## For bringing cookies case"
    echow "5. bash cachecrawler.sh -b -c SITE-MAP-URL ## For bringing cookies case and blacklist check"
    ;;
  esac
  exit 1
}

function adaptive_governor() {
  local load1 _rest load_int
  read -r load1 _rest < /proc/loadavg
  load_int="${load1%%.*}"
  [[ ! "$load_int" =~ ^[0-9]+$ ]] && load_int=0

  local key val _unit total=0 avail=0 free_mem=0 buffers=0 cached=0
  while read -r key val _unit; do
    case "$key" in
      MemTotal:) total="${val:-0}" ;;
      MemAvailable:) avail="${val:-0}" ;;
      MemFree:) free_mem="${val:-0}" ;;
      Buffers:) buffers="${val:-0}" ;;
      Cached:) cached="${val:-0}" ;;
    esac
  done < /proc/meminfo
  ((avail == 0)) && avail=$((free_mem + buffers + cached))
  local avail_mb=$((avail / 1024))

  if ((avail_mb < 64 || load_int >= SYS_CORES * 2)); then
    echoR "   [Bảo vệ VPS] Máy chủ đang chịu tải cao (Load: ${load1}, RAM trống: ${avail_mb}MB) -> Tạm dừng 6s..."
    sleep 6
  elif ((avail_mb < 150 || load_int >= SYS_CORES)); then
    sleep 1.5
  fi
}

function duplicateck() {
  grep -qxF -- "${1}" "${2}" >/dev/null 2>&1
}

function cachecount() {
  case "${1:-}" in
    miss)  ((CT_CACHEMISS++)) ;;
    hit)   ((CT_CACHEHIT++)) ;;
    no)    ((CT_NOCACHE++)) ;;
    black) ((CT_BLACKLIST++)) ;;
    fail)  ((CT_FAILCACHE++)) ;;
    *)
      if [[ "${1:-}" =~ ^[0-9]+$ ]]; then
        ((CT_URLS += $1))
      else
        echoR "${1:-} no define to cachecount!"
      fi
      ;;
  esac
}

prttwostr() {
  printf "\033[38;5;71m%s\033[39m \t%s\t \033[1;30m%s\033[0m \n" "${1}" "${2}" "${3}"
}

function cachereport() {
  echoY '=====================Crawl result:======================='
  prttwostr "Total URLs :" "${CT_URLS}" ''
  prttwostr "Added      :" "${CT_CACHEMISS}" ''
  prttwostr "Existing   :" "${CT_CACHEHIT}" ''
  local TMPMESG=''
  if ((CT_NOCACHE > 0)); then
    TMPMESG="(Page with 'no cache', please check cache debug log for the reason)"
  fi
  prttwostr "Skipped    :" "${CT_NOCACHE}" "${TMPMESG}"
  if [[ "${BLACKLIST}" != 'OFF' ]]; then
    TMPMESG=''
    ((CT_BLACKLIST > 0)) && TMPMESG="(Pages with status code ${ERR_LIST} may add into blacklist)"
    prttwostr "Blacklisted:" "${CT_BLACKLIST}" "${TMPMESG}"
  fi
  TMPMESG=''
  ((CT_FAILCACHE > 0)) && TMPMESG="(Pages with status code ${ERR_LIST} may add into blacklist)"
  prttwostr "Failed     :" "${CT_FAILCACHE}" "${TMPMESG}"
}

function protect_count() {
  if [[ "${PROTECTOR}" = 'ON' ]]; then
    if [[ "${1}" -eq 1 ]]; then
      ((DETECT_NUM++))
      if ((DETECT_NUM >= DETECT_LIMIT)); then
        echoR "Hit ${DETECT_LIMIT} times 'page error' or 'no cache' in a row, abort !!"
        echoR "To run script with no abort, please set PROTECTOR from 'ON' to 'OFF'."
        exit 1
      fi
    elif [[ "${1}" -eq 0 ]]; then
      DETECT_NUM=0
    fi
  fi
}

function addtoblacklist() {
  echoB "Add ${1} to BlackList"
  printf '%s\n' "${1}" >>"${BLACKLSPATH}"
}

function escape_url() {
  export TMP_URL_ENV="${1}"
  URL=$(perl -MURI::Escape -e 'print uri_escape("$ENV{TMP_URL_ENV}", "^A-Za-z0-9\-\._~:?/")')
}

# =======================================================================
# HÀM CÀO URL TỐI ƯU HÓA CỰC ĐẠI (FIX CỔNG 80/443 TÁCH BIỆT CHO HTTP/HTTPS)
# =======================================================================
function crawlreq() {
  local ua_header="$1"
  local target_url="$2"
  local cookie_str="${3:-}"
  local extra_accept="${4:-}"

  if [[ "${DEBUGURL}" != "OFF" && "${BLACKLIST}" = 'ON' ]]; then
    if duplicateck "${target_url}" "${BLACKLSPATH}"; then
      echoY "${target_url} is in blacklist"
      exit 0
    fi
  fi

  printf "%s -> " "${target_url}"

  local domain_host="${target_url#*://}"
  domain_host="${domain_host%%/*}"
  local base_host="${domain_host#www.}"

  # [FIXED]: Ghi rõ cổng nguồn :443 đi 443 và :80 đi 80 để HTTP không bị đẩy nhầm vào cổng 443
  local curl_args=(
    "$CURL_OPTS"
    --connect-to "${base_host}:443:127.0.0.1:443"
    --connect-to "www.${base_host}:443:127.0.0.1:443"
    --connect-to "${base_host}:80:127.0.0.1:80"
    --connect-to "www.${base_host}:80:127.0.0.1:80"
    -s -L -k
    --connect-timeout 5
    --max-time 15
    -o /dev/null
    -w "%{http_code}"
    -X GET
    -H "Accept-Encoding: gzip, deflate, br"
    -H "${ua_header}"
  )

  [[ -n "$cookie_str" ]] && curl_args+=(-b "name=${cookie_str}")
  if [[ -n "$extra_accept" ]]; then
    curl_args+=(-H "Accept: image/webp")
  fi

  local STATUS_CODE
  STATUS_CODE=$(curl "${curl_args[@]}" "${target_url}" 2>/dev/null || printf '000')

  if [[ "$STATUS_CODE" == "200" || "$STATUS_CODE" == "201" ]]; then
    echoY 'Đang tiến hành tạo cache'
    cachecount 'miss'
    protect_count 0
  else
    echoY 'Không tạo được cache'
    cachecount 'fail'
    protect_count 1
    if [[ "${BLACKLIST}" = 'ON' ]]; then
      addtoblacklist "${target_url}"
    fi
  fi
}

function runLoop() {
  local ua="$1"
  local cookie="$2"
  local webp_flag="${3:-}"
  local req_counter=0
  local URL

  for URL in "${URLLIST_ARR[@]}"; do
    [[ -z "$URL" ]] && continue
    local ONLIST='NO'
    if [[ "${ESCAPE}" = 'ON' ]]; then
      escape_url "${URL}"
    fi
    if [[ "${BLACKLIST}" = 'ON' ]]; then
      if duplicateck "${URL}" "${BLACKLSPATH}"; then
        ONLIST='YES'
        cachecount 'black'
      fi
    fi
    if [[ "${ONLIST}" = 'NO' ]]; then
      crawlreq "${ua}" "${URL}" "${cookie}" "${webp_flag}"
      ((req_counter++))
      if ((req_counter % 15 == 0)); then
        adaptive_governor
      fi
      sleep "${SVALUE}"
    fi
  done
}

function checkcrawler() {
  local TRYURL="${URLLIST_ARR[0]:-}"
  [[ -z "$TRYURL" ]] && return 0
  local domain_host="${TRYURL#*://}"
  domain_host="${domain_host%%/*}"
  local base_host="${domain_host#www.}"

  local CRAWLRESULT
  CRAWLRESULT=$(curl ${CURL_OPTS} \
    --connect-to "${base_host}:443:127.0.0.1:443" \
    --connect-to "www.${base_host}:443:127.0.0.1:443" \
    --connect-to "${base_host}:80:127.0.0.1:80" \
    --connect-to "www.${base_host}:80:127.0.0.1:80" \
    -skI --max-time 10 -X GET -H "${AGENTDESKTOP}" "$TRYURL" 2>/dev/null || true)
  if [[ "$CRAWLRESULT" == *"Precondition Required"* ]]; then
    help_message 1
  fi
}

function genrandom() {
  RANDOMSTR=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 16 || echo "wptt123456")
}

function getcookie() {
  local URL=""
  for URL in "${URLLIST_ARR[@]}"; do
    if [[ "${BLACKLIST}" = 'ON' ]]; then
      if ! duplicateck "${URL}" "${BLACKLSPATH}"; then
        break
      fi
    else
      break
    fi
  done
  [[ -z "$URL" ]] && return 0
  local domain_host="${URL#*://}"
  domain_host="${domain_host%%/*}"
  local base_host="${domain_host#www.}"

  COOKIESTRING=$(curl ${CURL_OPTS} \
    --connect-to "${base_host}:443:127.0.0.1:443" \
    --connect-to "${base_host}:80:127.0.0.1:80" \
    -sILk --max-time 10 -X GET "${URL}" | awk 'tolower($1)=="set-cookie:" {printf "%s ", $2}')
  if [[ -z "${COOKIESTRING}" ]]; then
    genrandom
    COOKIESTRING=$(curl ${CURL_OPTS} \
      --connect-to "${base_host}:443:127.0.0.1:443" \
      --connect-to "${base_host}:80:127.0.0.1:80" \
      -sILk --max-time 10 -X GET "${URL}?${RANDOMSTR}" | awk 'tolower($1)=="set-cookie:" {printf "%s ", $2}')
  fi
  COOKIE="${COOKIESTRING}"
  if [[ -n "${CUSTUM_COOKIE}" ]]; then
    COOKIE="${COOKIE} ${CUSTUM_COOKIE}"
  fi
}

function debugurl() {
  URL="${1}"
  if [[ "${WITH_COOKIE}" = 'ON' ]]; then
    getcookie
  fi
  if [[ "${ESCAPE}" = 'ON' ]]; then
    escape_url "${URL}"
  fi
  if [[ "${WITH_MOBILE}" = 'ON' ]]; then
    crawlreq "${AGENTMOBILE}" "${URL}" "${COOKIE}" "${WITH_WEBP}"
  else
    crawlreq "${AGENTDESKTOP}" "${URL}" "${COOKIE}" "${WITH_WEBP}"
  fi
}

function fetch_xml_stream() {
  local xml_url="$1"
  local domain_host="${xml_url#*://}"
  domain_host="${domain_host%%/*}"
  local base_host="${domain_host#www.}"

  if [[ "$xml_url" == *.gz ]]; then
    curl ${CURL_OPTS} \
      --connect-to "${base_host}:443:127.0.0.1:443" \
      --connect-to "www.${base_host}:443:127.0.0.1:443" \
      --connect-to "${base_host}:80:127.0.0.1:80" \
      --connect-to "www.${base_host}:80:127.0.0.1:80" \
      -sLk --max-time 30 -A "WPTangToc OLS preload cache" "$xml_url" 2>/dev/null | gzip -dc 2>/dev/null || true
  else
    curl ${CURL_OPTS} \
      --connect-to "${base_host}:443:127.0.0.1:443" \
      --connect-to "www.${base_host}:443:127.0.0.1:443" \
      --connect-to "${base_host}:80:127.0.0.1:80" \
      --connect-to "www.${base_host}:80:127.0.0.1:80" \
      -sLk --max-time 30 -A "WPTangToc OLS preload cache" "$xml_url" 2>/dev/null || true
  fi
}

function extract_locs_from_xml() {
  sed -e 's/<loc>/\n<loc>/g' -e 's/<\/loc>/<\/loc>\n/g' | awk '
    /<loc>.*<\/loc>/ {
      sub(/.*<loc>/, "")
      sub(/<\/loc>.*/, "")
      gsub(/<!\[CDATA\[|\]\]>/, "")
      gsub(/^[[:space:]]+|[[:space:]]+$/, "")
      if ($0 != "" && $0 !~ /xmlns=/) print $0
    }
  '
}

function storexml() {
  local target_map="$1"
  if [[ "$target_map" =~ \.xml(\.gz)?$ ]]; then
    local sub_xmls
    sub_xmls=$(fetch_xml_stream "$target_map" | extract_locs_from_xml | grep -E '\.xml(\.gz)?$' || true)

    if [[ -n "$sub_xmls" ]]; then
      local u
      while IFS= read -r u; do
        [[ -n "$u" ]] && XML_LIST+=("$u")
      done <<< "$sub_xmls"
    else
      XML_LIST+=("$target_map")
    fi
  else
    echo "SITEMAP: $target_map is not a valid xml"
    help_message 2
  fi
}

function maincrawl() {
  checkcrawler
  echoY "Có ${URLCOUNT} urls trong sitemap này"
  if ((URLCOUNT > 0)); then
    local START_TIME END_TIME ELAPSED
    printf -v START_TIME '%(%s)T' -1
    echoY 'Bắt đầu Preload Cache...'
    if [[ "${WITH_COOKIE}" = 'ON' ]]; then
      getcookie
    fi

    cachecount "${URLCOUNT}"
    runLoop "${AGENTDESKTOP}" "${COOKIE}" ""

    if [[ -n "${WITH_WEBP}" ]]; then
      echoY 'Starting to view with WebP header...'
      cachecount "${URLCOUNT}"
      runLoop "${AGENTDESKTOP}" "${COOKIE}" "ENABLE"
    fi

    if [[ "${WITH_MOBILE}" = 'ON' ]]; then
      echoY 'Starting to view with mobile agent...'
      cachecount "${URLCOUNT}"
      runLoop "${AGENTMOBILE}" "${COOKIE}" "${WITH_WEBP}"
    fi

    printf -v END_TIME '%(%s)T' -1
    ELAPSED=$((END_TIME - START_TIME))
    echoY "***Tổng ${ELAPSED} giây hoàn thành tiến trình***"
  fi
}

function main() {
  if [[ "${DEBUGURL}" != 'OFF' ]]; then
    URLLIST_ARR=("${DEBUGURL}")
    debugurl "${DEBUGURL}"
  else
    local XMLURL
    for XMLURL in "${XML_LIST[@]}"; do
      echoCYAN "Chuẩn bị quét ${XMLURL} XML file"
      local raw_urls
      raw_urls=$(fetch_xml_stream "${XMLURL}" | extract_locs_from_xml | awk -v crawl_qs="${CRAWLQS}" '
        {
          if (crawl_qs != "ON") {
            sub(/\?.*/, "")
          }
          low = tolower($0)
          if (low ~ /^https?:\/\// && low !~ /\.(png|jpg|jpeg|webp|gif|svg|css|js|woff|woff2|ttf|eot|ico|pdf|zip|mp4|mp3)$/) {
            print $0
          }
        }
      ' | sort -u)

      URLLIST_ARR=()
      if [[ -n "$raw_urls" ]]; then
        mapfile -t URLLIST_ARR <<< "$raw_urls"
      fi
      URLCOUNT="${#URLLIST_ARR[@]}"
      maincrawl
    done
    if [[ "${REPORT}" != 'OFF' ]]; then
      cachereport
    fi
  fi
}

while [[ -n "${1:-}" ]]; do
  case "${1}" in
  -h | --help)
    help_message 2
    ;;
  -m | --with-mobile | --mobile)
    WITH_MOBILE='ON'
    ;;
  -c | --with-cookie | --cookie)
    WITH_COOKIE='ON'
    ;;
  -cc | --custom-cookie)
    shift
    WITH_COOKIE='ON'
    CUSTUM_COOKIE="${1:-}"
    ;;
  -i | --interval)
    shift
    SVALUE="${1:-0.2}"
    ;;
  -w | --WITH_WEBP | --webp)
    WITH_WEBP='ENABLE'
    ;;
  -g | --general-ua)
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
    [[ ! -e "${BLACKLSPATH}" ]] && touch "${BLACKLSPATH}"
    ;;
  -d | --debug-url)
    shift
    if [[ -z "${1:-}" ]]; then
      help_message 2
    else
      DEBUGURL="${1}"
      [[ ! -e "${CRAWLLOG}" ]] && touch "${CRAWLLOG}"
    fi
    ;;
  -qs | --crawl-qs)
    CRAWLQS='ON'
    ;;
  -r | --report)
    REPORT='ON'
    ;;
  *)
    SITEMAP="${1}"
    storexml "${SITEMAP}"
    ;;
  esac
  shift
done
main
