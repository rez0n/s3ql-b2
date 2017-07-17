#   Copyright 2017 Taras Pudiak
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM debian:stretch

WORKDIR /tmp/s3ql
# copy auth information and wrapper to container
COPY s3ql-b2.auth /etc/s3ql/s3ql-b2.auth
COPY s3ql-entrypoint.sh /usr/local/bin/s3ql-entrypoint.sh

# install s3ql with backblaze b2 patch
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install git wget psmisc procps fuse cython3 python3-setuptools python3-llfuse libsqlite3-dev python3-requests python3-crypto python3-dugong python3-defusedxml python3-apsw python3-pytest python3-pytest-catchlog python3-pytest-cov && \
    git clone https://github.com/s3ql/s3ql.git /tmp/s3ql && \
    wget https://github.com/sylvainlehmann/s3ql/raw/master/src/s3ql/backends/backblaze.py -O /tmp/s3ql/src/s3ql/backends/backblaze.py && \
    touch ./src/s3ql/backends/backblaze.py && \
    sed -i 's/import local, s3, gs, s3c, swift, rackspace, swiftks/import local, s3, gs, s3c, swift, rackspace, swiftks, backblaze/' ./src/s3ql/backends/__init__.py && \
    sed -i 's/rackspace.Backend }/rackspace.Backend,/' ./src/s3ql/backends/__init__.py && \
    sed -i "/rackspace.Backend/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 'b2': backblaze.Backend }" ./src/s3ql/backends/__init__.py && \
    python3 setup.py build_cython && \
    python3 setup.py build_ext --inplace && \
    python3 -m pytest tests/ --cov=s3ql && \
    python3 setup.py install && \
    rm -rf /tmp/s3ql && \
    chmod +x /usr/local/bin/s3ql-entrypoint.sh && \
    chmod 600 /etc/s3ql/s3ql-b2.auth && \
    mkdir /mnt/s3ql

ENTRYPOINT ["s3ql-entrypoint.sh"]
CMD mount.s3ql --authfile /etc/s3ql/s3ql-b2.auth --cachesize 20971520 --max-cache-entries 50000 --allow-other --compress lzma-2 --threads 2 --metadata-upload-interval 86400 b2://$S3QL_BUCKET/$S3QL_PREFIX /mnt/s3ql
