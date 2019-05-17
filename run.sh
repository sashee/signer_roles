npm ci

BUCKETNAME_1=$(aws s3api list-buckets | jq -r '[.Buckets[] | select(.Name | startswith("signer-roles-test-bucket1-")).Name][0]')
BUCKETNAME_2=$(aws s3api list-buckets | jq -r '[.Buckets[] | select(.Name | startswith("signer-roles-test-bucket2-")).Name][0]')

ROLEARN_1=$(aws iam list-roles | jq -r '[.Roles[] | select(.RoleName | startswith("signer-roles-test-role-1-")).Arn][0]')
ROLEARN_2=$(aws iam list-roles | jq -r '[.Roles[] | select(.RoleName | startswith("signer-roles-test-role-2-")).Arn][0]')

BUCKETNAME_1=$BUCKETNAME_1 BUCKETNAME_2=$BUCKETNAME_2 ROLEARN_1=$ROLEARN_1 ROLEARN_2=$ROLEARN_2 node index.js
