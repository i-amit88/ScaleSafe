#!/bin/bash

# change the bucket name to get from the environment variable
if [ -z "$FILE_BUCKET_NAME" ]; then
  FILE_BUCKET_NAME=file-bucket
fi

# Create the initial bucket for file storage 
awslocal s3api create-bucket --bucket scalesafe-bucket-104

# Apply the CORS configuration
awslocal s3api put-bucket-cors --bucket scalesafe-bucket-104 --cors-configuration file://cors-config.json

# Create a bucket policy for the bucket
awslocal s3api put-bucket-policy --bucket scalesafe-bucket-104 --policy file://bucket-policy.json

#Set ACL to public
awslocal s3api put-bucket-acl --bucket scalesafe-bucket-104 --acl public-read


# Create CloudWatch log group
awslocal logs create-log-group --log-group-name /aws/s3/scalesafe-bucket-104

# Create CloudWatch log stream
awslocal logs create-log-stream --log-group-name /aws/s3/scalesafe-bucket-104 --log-stream-name s3-log-stream

awslocal s3api put-bucket-logging --bucket scalesafe-bucket-104 --bucket-logging-status '{"LoggingEnabled":{"TargetBucket":"scalesafe-bucket-104","TargetPrefix":"logs/","TargetGrants":[{"Grantee":{"Type":"Group","URI":"http://acs.amazonaws.com/groups/global/AllUsers"},"Permission":"FULL_CONTROL"}]}}'

echo "test log" | awslocal s3 cp - s3://scalesafe-bucket-104/logs/test-log-file.txt