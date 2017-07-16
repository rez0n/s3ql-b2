**s3ql-b2** 
==========
With this image you can mount your Backblaze B2 Cloud Storage like a regular file system into host through FUSE.

----------

**Prepare**
-----------
To use s3ql-b2 you need kernel with FUSE module in host system. 

----------

**Run**
-------
Command to run container:
```
docker run -d --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined --stop-timeout 3600 \
           --name nafeofcontainer \
           -e S3QL_MODE=mount \
           -e S3QL_BUCKET=nameofyourbucket \
           -e S3QL_PREFIX=prefixinyourbucket \
           -e S3QL_ACCOUNTID=b2accountid \
           -e S3QL_APPLICATIONKEY=b2appkey \
           -v /path/to/folder/in/host/system:/mnt/s3ql:shared \
           zdce/s3ql-b2
```
Here you must change:

- `--name` name, that you want to give your container with s3ql-b2
- `S3QL_MODE` choose between `make` or `mount`. If `make` then s3ql-b2 will make a new file system in your Backblaze B2 Cloud Storage, or choose `mount` to mount existing file system
- `S3QL_BUCKET` name of your bucket in Backblaze B2 Cloud Storage
- `S3QL_PREFIX` name of prefix (folder) inside your bucket, where file system will be created or from where will be mounted
- `S3QL_ACCOUNTID` your Backblaze B2 Cloud Storage Account ID
- `S3QL_APPLICATIONKEY` your Backblaze B2 Cloud Storage Application Key
- `/path/to/folder/in/host/system` path to folder in host, where will be mounted FUSE file system

----------

**Disclaimer**
--------------
Use with caution! There are no guarantees, that image don't have bugs. :)
