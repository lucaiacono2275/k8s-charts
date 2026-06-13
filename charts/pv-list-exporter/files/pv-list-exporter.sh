#!/bin/sh
set -e
echo "Starting extraction of PV list..."

USERNAME=$(cat /secrets/username)
PASSWORD=$(cat /secrets/password)

kubectl get pv -o jsonpath='{.items[*].spec.csi.volumeHandle}' | tr ' ' '\n' > /data/pv-list.txt
echo "Uploading PV list to Samba..."
smbclient "$SAMBA_SERVER" "$PASSWORD" -U "$USERNAME" -c "put /data/pv-list.txt $TARGET_FILE; exit"
echo "Upload completed successfully."
