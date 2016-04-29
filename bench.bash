echo $'\e[32m====================\e[m'
echo $'\e[32m= Start bench mark =\e[m'
echo $'\e[32m====================\e[m'
echo ''

HOST='http://54.199.205.117'
ACTIONS=(/ /users /proxy)
CONNECTION_COUNTS=(1 10 50 100)

for action in ${ACTIONS[@]}; do
  for connection in ${CONNECTION_COUNTS[@]}; do
    if [ $connection -eq 1 ]; then
      thread=1
    else
      thread=5
    fi

    echo $'\e[32m* Request => \e[m'GET ${action}$'\e[32m\tConnection => \e[m'${connection}
    wrk -t ${thread} -c ${connection} -d 10s -H 'Accept-Encoding: gzip' ${HOST}${action}
    echo ''
    sleep 5
  done
done

echo $'\e[32mFinish!!\e[m'
