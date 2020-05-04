# Simplle Stroage Service (S3)
```
  Object-based Storage
  Serverless Storage
  No filesystem or diskspace
```
## What is Object Storage (Object-based Stroage) ?
```
  Data storage architecture that manages data as objects not like file systems and block storage.
```

Key components:

  S3 Object

    object contains data like file
    object may consists,
	Key - name
	Value - data itself
	Version ID - when versioning enabled
	Metadata - additional info of object

    Store data from 0 Bytes to 5 Terrabytes in size.

  S3 Bucket

    Bucket hold objects.
    It can also have folders.
    S3 names should be unique.

S3 Storage Classes

  Trade Retrieval Time, Accessibility and Durability for Cheaper Storage.

    1. Standard (default) 
	Fast 99.99 % availability, 119's Durability. Replicated across at least three AZs.
    2. Standard Infrequently Accessed (IA)
	50% of Standard
    3. One Zone IA 
	One AZ
    4. Intelligent Tiering
        Uses ML to analyze object
    5. Glacier
        For long-term cold storage. Data retrieval from mins to hours. Cheap
    6. Glacier Deep Archive
        Low Cost. Data retrival time 12 hours.
   

S3 Security

  Buckets are PRIVATE by default.
  Logging per request and saved in different bucket
  Access Control:
    Access Control Lists - Legacy Feature 
    Bucket policies - Complex Rules

S3 Encryption

  Encryption in Transit
    Traffic b/w your localhost and S3 is achieved via SSL/TLS

  Server Side Encryption (SSE) - Encryption at Rest
    Amazon help you encrypt the object data
    S3 Managed Keys - (Amazon manages all keys)
	SSE-AES - S3 handles key uses AES-256
	SSE-KMS - Envolope encryption, AWS KMS or our keys
	SSE-C   - Customer provided key

  Client-Side Encryption
    We shpuld encrypt the file locally and then upload. 

S3 Data Consistency

  New Objects (PUTS)
    Read After Write Consistency
	When you upload new object you are able
	to read immediately.
   
  Overwrite (PUTS) or Delete Objects (DELETES)
    Eventual Consistency
	When you overwrite or delete it takes time to
	replicate to AZs.

S3 Cross-Region Replication

  Useful when disater happens.

  When enabled and specify, Object replicated to another region
  with higher durability and potential disater recovery.

  Versioning should be enabled on both buckets
  Also for another AWS Account.

S3 Versioning

  All Objects have version ID.
  Versions all Objects.
  Once Enabled can't disabled, only suspend versioning.
  MFA Delete Feature provides extra protection against deletion

S3 Lifecycle Management

  Automate the process of moving objects to different Stroage Classes
  or deleting objects all together.

  Can be used together with versioning (Current & Previous Versions)

  S3 --------> Glacier ---------> Delete Objects

S3 Transfer Acceleration

  Fast and Secure transfer files over long distances b/w user & S3.
  Utilizes CloudFront's distributed Edge Locations (Data Center)
  Uploads Data using distinct URL for an Edge Location.

  USER --------> Edge Location ============> S3

S3 Presigned URLs

  Generate a URL that provides for upload and download object data.

  $ aws s3 presign s3://mybucket/myobject --expires-in 300

  URL ===> https://mybucket.s3.amazonaws.com/myobject?AWSAccessKeyId=ANHA&Signature=AJNJNK

S3 MFA Delete

  Ensures user can't delete file without MFA Code

  To implement:

  1. AWS CLI must be user to turn on MFA
  2. Bucket must be versioning enabled

   $ aws s3api put-bucket-versioning \
	--bucket bucketname \
	--versioning-configuration Status=Enabled,MFADelete=Enabled \
	--mfa "mfa-serial-number mfa-code"
