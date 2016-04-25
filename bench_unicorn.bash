HOST='http://localhost:8082'

echo $'\e[32m========================\e[m'
echo $'\e[32m== Unicorn bench mark ==\e[m'
echo $'\e[32m========================\e[m'
echo ''

echo $'\e[32m== Connection => 1, Request => GET /\e[m'
wrk -t 1 -c 1 -d 10s -H 'Accept-Encoding: gzip' $HOST
sleep 5
echo ''
echo $'\e[32m== Connection => 5, Request => GET /\e[m'
wrk -t 5 -c 5 -d 10s -H 'Accept-Encoding: gzip' $HOST
sleep 5
echo ''
echo $'\e[32m== Connection => 25, Request => GET /\e[m'
wrk -t 5 -c 25 -d 10s -H 'Accept-Encoding: gzip' $HOST
sleep 5
echo ''
echo $'\e[32m== Connection => 1, Request => GET /users\e[m'
wrk -t 1 -c 1 -d 10s -H 'Accept-Encoding: gzip' $HOST/users
sleep 5
echo ''
echo $'\e[32m== Connection => 5, Request => GET /users\e[m'
wrk -t 5 -c 5 -d 10s -H 'Accept-Encoding: gzip' $HOST/users
sleep 5
echo ''
echo $'\e[32m== Connection => 25, Request => GET /users\e[m'
wrk -t 5 -c 25 -d 10s -H 'Accept-Encoding: gzip' $HOST/users
sleep 5
echo ''
echo $'\e[32m== Connection => 1, Request => GET /proxy\e[m'
wrk -t 1 -c 1 -d 10s -H 'Accept-Encoding: gzip' $HOST/proxy
sleep 5
echo ''
echo $'\e[32m== Connection => 5, Request => GET /proxy\e[m'
wrk -t 5 -c 5 -d 10s -H 'Accept-Encoding: gzip' $HOST/proxy
sleep 5
echo ''
echo $'\e[32m== Connection => 25, Request => GET /proxy\e[m'
wrk -t 5 -c 25 -d 10s -H 'Accept-Encoding: gzip' $HOST/proxy

echo ''
echo $'\e[32mFinish!!\e[m'
