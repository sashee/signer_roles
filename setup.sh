BUCKETNAME_1=signer-roles-test-bucket1-$(date +%s)
BUCKETNAME_2=signer-roles-test-bucket2-$(date +%s)

aws --region us-east-1 s3api create-bucket --bucket $BUCKETNAME_1
aws --region us-east-1 s3api create-bucket --bucket $BUCKETNAME_2

curl -s $(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url') --output cat.jpg
aws s3 cp cat.jpg s3://$BUCKETNAME_1/
rm cat.jpg

curl -s $(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url') --output cat.jpg
aws s3 cp cat.jpg s3://$BUCKETNAME_2/
rm cat.jpg

ROLENAME_1=signer-roles-test-role-1-$(date +%s)
ROLENAME_2=signer-roles-test-role-2-$(date +%s)

TRUST_POLICY=$(cat trust.json | sed "s/ACCOUNTID/$(aws sts get-caller-identity --query Account --output text)/")
aws iam create-role --role-name $ROLENAME_1 --assume-role-policy-document "$TRUST_POLICY"
aws iam create-role --role-name $ROLENAME_2 --assume-role-policy-document "$TRUST_POLICY"

aws iam put-role-policy --role-name $ROLENAME_1 --policy-name allow-bucket --policy-document "$(cat policy.json | sed "s/BUCKETNAME/$BUCKETNAME_1/")"
aws iam put-role-policy --role-name $ROLENAME_2 --policy-name allow-bucket --policy-document "$(cat policy.json | sed "s/BUCKETNAME/$BUCKETNAME_2/")"
