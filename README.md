With this image you can mount your Backblaze B2 Cloud Storage like a regular file system into host through FUSE.

**Requirements**

To use s3ql-b2 you need kernel with FUSE module in host system. 

----------
**Run**

Run prebuilt docker image form hub.docker.io:
```
docker run -d --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined --stop-timeout 3600 \
           --name nameofcontainer \
           -e S3QL_MODE=mount \
           -e S3QL_BUCKET=nameofyourbucket \
           -e S3QL_PREFIX=prefixinyourbucket \
           -e S3QL_ACCOUNTID=b2accountid \
           -e S3QL_APPLICATIONKEY=b2appkey \
           -e S3QL_PASSPHRASE=secretpass \
           -e S3QL_MAXOBJSIZE=10240 \
           -e S3QL_CACHESIZE=20971520 \
           -e S3QL_MAXCACHEENTRIES=50000 \
           -e S3QL_COMPRESS=lzma-2 \
           -e S3QL_THREADS=20 \
           -e S3QL_METAINTERVAL=86400 \
           -v /path/to/folder/in/host/system:/mnt/s3ql:shared \
           rez0n/s3ql-b2
```
Here you must change:

- `--name` name, that you want to give your container with s3ql-b2
- `S3QL_MODE` choose between `make` or `mount`. If `make` then s3ql-b2 will make a new file system in your Backblaze B2 Cloud Storage, or choose `mount` to mount existing file system
- `S3QL_BUCKET` name of your bucket in Backblaze B2 Cloud Storage
- `S3QL_PREFIX` name of prefix (folder) inside your bucket, where file system will be created or from where will be mounted
- `S3QL_ACCOUNTID` your Backblaze B2 Cloud Storage "AccoundId" or "applicationKeyId"
- `S3QL_APPLICATIONKEY` your Backblaze B2 Cloud Storage "Master Application Key or Application Key"
- `S3QL_PASSPHRASE` passphrase, used to encrypt keys in storage. If not set, then files in storage will be unencrypted
- `S3QL_MAXOBJSIZE` maximum size of storage objects in KiB. Files bigger than this will be spread over multiple objects in the storage backend
- `S3QL_CACHESIZE` cache size in KiB
- `S3QL_MAXCACHEENTRIES` maximum number of entries in cache
- `S3QL_COMPRESS` compression algorithm and compression level to use when storing new data. Algorithm may be lzma, bzip2, zlib, or none. Level may be any integer from 0 (fastest) to 9 (slowest)
- `S3QL_THREADS` number of parallel upload threads to use
- `S3QL_METAINTERVAL` interval in seconds between complete metadata uploads. Set to 0 to disable
- `/path/to/folder/in/host/system` path to folder in host, where will be mounted FUSE file system

----------

**Buld**
You can build docker image from source byself. 
```
git clone https://github.com/rez0n/s3ql-b2.git s3ql-b2/
cd s3ql-b2/
docker build -t s3ql-b2 .
```

**Disclaimer**

Use with caution! There are no guarantees, that image don't have bugs. :)

----------
**Credits**

- [S3QL](https://github.com/s3ql/s3ql) - [Backblaze B2 backend for S3QL](https://github.com/sylvainlehmann/s3ql) - [Original Author of this repo](https://gitlab.com/docks/s3ql-b2)
