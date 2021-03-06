#! /usr/bin/env bash

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

set -eo pipefail

_term() {
    umount.s3ql /mnt/s3ql
    exit 0
}

_config() {
    sed -i "s/S3QL_BUCKET/$S3QL_BUCKET/" /etc/s3ql/s3ql-b2.auth
    sed -i "s/S3QL_PREFIX/$S3QL_PREFIX/" /etc/s3ql/s3ql-b2.auth
    sed -i "s/S3QL_ACCOUNTID/$S3QL_ACCOUNTID/" /etc/s3ql/s3ql-b2.auth
    sed -i "s/S3QL_APPLICATIONKEY/$S3QL_APPLICATIONKEY/" /etc/s3ql/s3ql-b2.auth
    if [ "$S3QL_PASSPHRASE" != "" ]; then
        sed -i "s/#fs-passphrase/fs-passphrase/" /etc/s3ql/s3ql-b2.auth
        sed -i "s/S3QL_PASSPHRASE/$S3QL_PASSPHRASE/" /etc/s3ql/s3ql-b2.auth
    fi
    touch /etc/s3ql/configured.flag
}

_make() {
    if [ "$S3QL_PASSPHRASE" != "" ]; then
        echo $S3QL_PASSPHRASE | mkfs.s3ql --authfile /etc/s3ql/s3ql-b2.auth --max-obj-size $S3QL_MAXOBJSIZE b2://$S3QL_BUCKET/$S3QL_PREFIX
    else
        mkfs.s3ql --authfile /etc/s3ql/s3ql-b2.auth --max-obj-size $S3QL_MAXOBJSIZE --plain b2://$S3QL_BUCKET/$S3QL_PREFIX
    fi
}

trap _term SIGTERM

if [ ! -e /etc/s3ql/configured.flag ]; then
    if [ "$S3QL_MODE" = "make" ]; then
        _config
        _make
    elif [ "$S3QL_MODE" = "mount" ]; then
        _config
    else
        echo "Unknown S3QL_MODE."
        exit 1
    fi
fi

"$@"

while true; do
    sleep 5s
done
