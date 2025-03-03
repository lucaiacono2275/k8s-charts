#!/bin/sh
set -e
echo "Starting certificate and key sync to Samba..."
CERT_PATH="/certs/tls.crt"
KEY_PATH="/certs/tls.key"
#TARGET_CERT="{{ .Values.samba.certTargetFile }}"
#TARGET_KEY="{{ .Values.samba.keyTargetFile }}"
#SAMBA_SERVER="{{ .Values.samba.server }}"
USERNAME=$(cat /secrets/username)
PASSWORD=$(cat /secrets/password)
echo "Uploading certificate..."
smbclient "$SAMBA_SERVER" "$PASSWORD" -U "$USERNAME" -c "put $CERT_PATH $TARGET_CERT; exit"
echo "Uploading key..."
smbclient "$SAMBA_SERVER" "$PASSWORD" -U "$USERNAME" -c "put $KEY_PATH $TARGET_KEY; exit"
echo "Sync completed successfully."