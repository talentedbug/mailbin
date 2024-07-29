# MailBin generation program

# Check the existence of configuration file
if [[ ! -f ./mailbin.conf ]];
then
    echo "[ERROR] No configuration found: mailbin.conf"
    exit 1
fi

# Check the definition of important variables
source ./mailbin.conf
if [[ -z "${SITE_NAME+x}" || -z "${FROM_NAME+x}" || -z "${FROM_EMAIL+x}" || -z "${TIME_ZONE+x}" || -z "${LINE_LENGTH+x}" ]];
then
    echo "[ERROR] Some important variables not set: mailbin.conf"
    exit 1
fi

# Check the existence of at least one source file
if [[ ! -d "./src" ]];
then
    echo "[ERROR] Source directory not found: src"
    exit 1
fi
if [[ -z "$(ls -A ./src 2>/dev/null)" ]];
then
    echo "[ERROR] No source files was found in source directory: src"
    exit 1
fi

echo "[INFO] Basic checks passed. No error reported."

# Start dealing with texts
# Currently no CJK-support is implemented due to their complexity

# Clean old files
rm -rf ./site 2>/dev/null
echo "[INFO] Old ./site cleared."

# Create basic structure
mkdir ./site
touch ./site/index.html
mkdir ./site/asset
mkdir ./site/mail

# Write index.html
printf "<!DOCTYPE html>\n<head>\n    <title>${SITE_NAME}</title>\n<head>\n" >> ./site/index.html
printf "<body>\n" >> ./site/index.html
printf "    <h1>${SITE_NAME}</h1>\n" >> ./site/index.html
printf "    <h2>About</h2>\n" >> ./site/index.html
printf "    <pre>\n" >> ./site/index.html
fold -w $((LINE_LENGTH)) -s ./src/about.txt >> ./site/index.html
printf "    </pre>\n" >> ./site/index.html
printf "    <h2>Index</h2>\n" >> ./site/index.html
for doc in $(ls -t ./src);
do
    bn=$(basename "${doc}")
    if [[ "${bn}" = "about.txt" ]];
    then
        continue
    fi
    printf "    <h3><a href=\"./mail/${bn%.*}.html\">${bn%.*}</a></h3>\n" >> ./site/index.html
    printf "    <p style=\"font-family: monospace;\">\n" >> ./site/index.html
    printf "        <b>Subject</b> &nbsp;${doc%.*}<br>\n" >> ./site/index.html
    printf "        <b>From &nbsp;&nbsp;</b> &nbsp;${FROM_NAME} &lt;${FROM_EMAIL}&gt;<br>\n" >> ./site/index.html
    printf "        <b>Date &nbsp;&nbsp;</b> &nbsp;$(TZ=${TIME_ZONE} date -r "./src/${bn}" +"%Y-%m-%d %H:%M %Z")<br>\n" >> ./site/index.html
    printf "        <br>\n" >> ./site/index.html
    printf "    </p>\n" >> ./site/index.html
done
printf "</body>\n" >> ./site/index.html

echo "[INFO] index.html created."

# Write pages
cnt=0
for doc in ./src/*;
do
    if [[ $doc = "./src/about.txt" ]];
    then
        continue
    fi
    cnt=$((cnt + 1))
    if [[ $cnt = 1 ]];
    then
        s=$(basename "${doc}")
        lp=${s%.*}
        continue
    fi
    s=$(basename "${doc}")
    bn=${s%.*}
    if [[ $cnt = 2 ]];
    then
        llp="${lp}"
    fi
    touch "./site/mail/${lp}.html"
    echo "[INFO] ${lp}.html created."
    printf "<!DOCTYPE html>\n<head>\n    <title>${SITE_NAME} - ${lp}</title>\n<head>\n" >> "./site/mail/${lp}.html"
    printf "<body>\n" >> "./site/mail/${lp}.html"
    printf "    <p><a href=\"./${llp}.html\">[prev]</a> <a href=\"./${bn}.html\">[next]</a></p>\n" >> "./site/mail/${lp}.html"
    printf "    <p style=\"font-family: monospace;\">\n" >> "./site/mail/${lp}.html"
    printf "        <b>Subject</b> &nbsp;${lp}<br>\n" >> "./site/mail/${lp}.html"
    printf "        <b>From &nbsp;&nbsp;</b> &nbsp;${FROM_NAME} &lt;${FROM_EMAIL}&gt;<br>\n" >> "./site/mail/${lp}.html"
    printf "        <b>Date &nbsp;&nbsp;</b> &nbsp;$(TZ=${TIME_ZONE} date -r "./src/${lp}.txt" +"%Y-%m-%d %H:%M %Z")<br>\n" >> "./site/mail/${lp}.html"
    printf "        <br>\n" >> ./site/index.html
    printf "    </p>\n" >> ./site/index.html
    printf "    <pre style=\"font-family: monospace\">\n" >> "./site/mail/${lp}.html"
    fold -w $((LINE_LENGTH)) -s "./src/${lp}.txt" >> "./site/mail/${lp}.html"
    printf "    </pre>\n" >> "./site/mail/${lp}.html"
    llp="${lp}"
    lp="${bn}"
done
touch "./site/mail/${lp}.html"
echo "[INFO] ${lp}.html created."
printf "<!DOCTYPE html>\n<head>\n    <title>${SITE_NAME} - ${lp}</title>\n<head>\n" >> "./site/mail/${lp}.html"
printf "<body>\n" >> "./site/mail/${lp}.html"
printf "    <p><a href=\"./${llp}.html\">[prev]</a> <a href=\"./${bn}.html\">[next]</a></p>\n" >> "./site/mail/${lp}.html"
printf "    <p style=\"font-family: monospace;\">\n" >> "./site/mail/${lp}.html"
printf "        <b>Subject</b> &nbsp;${lp}<br>\n" >> "./site/mail/${lp}.html"
printf "        <b>From &nbsp;&nbsp;</b> &nbsp;${FROM_NAME} &lt;${FROM_EMAIL}&gt;<br>\n" >> "./site/mail/${lp}.html"
printf "        <b>Date &nbsp;&nbsp;</b> &nbsp;$(TZ=${TIME_ZONE} date -r "./src/${bn}.txt" +"%Y-%m-%d %H:%M %Z")<br>\n" >> "./site/mail/${lp}.html"
printf "        <br>\n" >> ./site/index.html
printf "    </p>\n" >> ./site/index.html
printf "    <pre style=\"font-family: monospace\">\n" >> "./site/mail/${lp}.html"
fold -w $((LINE_LENGTH)) -s "./src/${bn}.txt" >> "./site/mail/${lp}.html"
printf "    </pre>\n" >> "./site/mail/${lp}.html"

echo "[INFO] All done."
