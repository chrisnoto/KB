#!/bin/bash

[ -e Query.sh ] && rm -f Query.sh

token=`curl --insecure -d '{"auth":{"tenantName":"admin","passwordCredentials":{"username": "admin","password": "F0xconn!23"}}}' \
-H "Content-Type: application/json" https://10.67.44.66:5000/v2.0/tokens \
| python -m json.tool \
|jq .access.token.id `

addr_flv="https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/flavors"
addr_img="https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/images"
addr_inst="https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/servers"
addr_inst_dtl="https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/servers/detail"

cat >>Query.sh <<EOF
#!/bin/bash
echo "#################list flavors################"
curl --insecure -s -H "X-Auth-Token:$token" $addr_flv | python -m json.tool | jq '.flavors[] | {id,name}'

echo "#################list images#################"
curl --insecure -s -H "X-Auth-Token:$token" $addr_img | python -m json.tool | jq '.images[] | {id,name}'

echo "#################list instances##############"
curl --insecure -s -H "X-Auth-Token:$token" $addr_inst | python -m json.tool | jq '.servers[] | {id,name}'

echo "#################list instances detail ######"
curl --insecure -s -H "X-Auth-Token:$token" $addr_inst_dtl | python -m json.tool | jq '.servers[] | {id,name,addresses,key_name,security_groups,status}'



EOF
chmod +x Query.sh
