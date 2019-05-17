BUCKETNAME_1=$(aws s3api list-buckets | jq -r '[.Buckets[] | select(.Name | startswith("signer-roles-test-bucket1-")).Name][0]')
BUCKETNAME_2=$(aws s3api list-buckets | jq -r '[.Buckets[] | select(.Name | startswith("signer-roles-test-bucket2-")).Name][0]')

aws s3 rm s3://$BUCKETNAME_1 --recursive
aws s3 rm s3://$BUCKETNAME_2 --recursive

aws s3api delete-bucket --bucket $BUCKETNAME_1
aws s3api delete-bucket --bucket $BUCKETNAME_2

ROLENAME_1=$(aws iam list-roles | jq -r '[.Roles[] | select(.RoleName | startswith("signer-roles-test-role-1-")).RoleName][0]')
ROLENAME_2=$(aws iam list-roles | jq -r '[.Roles[] | select(.RoleName | startswith("signer-roles-test-role-2-")).RoleName][0]')

aws iam delete-role-policy --role-name $ROLENAME_1 --policy-name allow-bucket
aws iam delete-role-policy --role-name $ROLENAME_2 --policy-name allow-bucket

aws iam delete-role --role-name $ROLENAME_1
aws iam delete-role --role-name $ROLENAME_2

