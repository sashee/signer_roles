## Overview

This module creates a bucket with a file and a role which can read the bucket. The trust policy allows another role, the trusted_role variable, to assume it.

trusted_role --[allows assume]--> role --[allows read]--> bucket

## Inputs

* file: the file to upload into the bucket
* trusted_role: the ARN of a role that will be allowed to assume the created role

## Outputs

* bucket: the name of the created bucket
* role: the ARN of the created role
