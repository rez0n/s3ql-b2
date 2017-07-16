#! /usr/bin/bash
set -eo pipefail

_term() {
        umount.s3ql /mnt/s3ql
	exit 0
}

trap _term SIGTERM

if [ ! -e /etc/s3ql/configured.flag ]; then
	if [ $S3QL_MODE = "make" ]; then
		sed -i "s/S3QL_BUCKET/$S3QL_BUCKET/" /etc/s3ql/s3ql-b2.auth
		sed -i "s/S3QL_PREFIX/$S3QL_PREFIX/" /etc/s3ql/s3ql-b2.auth
		sed -i "s/S3QL_ACCOUNTID/$S3QL_ACCOUNTID/" /etc/s3ql/s3ql-b2.auth
		sed -i "s/S3QL_APPLICATIONKEY/$S3QL_APPLICATIONKEY/" /etc/s3ql/s3ql-b2.auth
		sed -i "s/S3QL_PASSPHRASE/$S3QL_PASSPHRASE/" /etc/s3ql/s3ql-b2.auth
		#echo -e "$S3QL_PASSPHRASE\n$S3QL_PASSPHRASE\n" | mkfs.s3ql --authfile /etc/s3ql/s3ql-b2.auth --max-obj-size 10240 b2://$S3QL_BUCKET/$S3QL_PREFIX
		mkfs.s3ql --authfile /etc/s3ql/s3ql-b2.auth --max-obj-size 10240 --plain --force b2://$S3QL_BUCKET/$S3QL_PREFIX
		touch /etc/s3ql/configured.flag
	elif [ $S3QL_MODE = "mount" ]; then
		sed -i "s/S3QL_BUCKET/$S3QL_BUCKET/" /etc/s3ql/s3ql-b2.auth
		sed -i "s/S3QL_PREFIX/$S3QL_PREFIX/" /etc/s3ql/s3ql-b2.auth
		sed -i "s/S3QL_ACCOUNTID/$S3QL_ACCOUNTID/" /etc/s3ql/s3ql-b2.auth
		sed -i "s/S3QL_APPLICATIONKEY/$S3QL_APPLICATIONKEY/" /etc/s3ql/s3ql-b2.auth
		sed -i "s/S3QL_PASSPHRASE/$S3QL_PASSPHRASE/" /etc/s3ql/s3ql-b2.auth
		touch /etc/s3ql/configured.flag
	else
		echo "Unknown S3QL_MODE."
		exit 1
	fi
fi

"$@"

while true; do
	sleep 5s
done
