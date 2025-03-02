#!/bin/sh
set -e
echo "Starting certificate and key sync to Samba..."
CERT_PATH="/certs/tls.crt"
KEY_PATH="/certs/tls.key"
TARGET_CERT="{{ .Values.samba.certTargetFile }}"
TARGET_KEY="{{ .Values.samba.keyTargetFile }}"
SAMBA_SERVER="{{ .Values.samba.server }}"
USERNAME=$(cat /secrets/username)
PASSWORD=$(cat /secrets/password)
echo "Uploading certificate..."
echo "put $CERT_PATH $TARGET_CERT" | smbclient "$SAMBA_SERVER" "$PASSWORD" -U "$USERNAME" -c "exit"
echo "Uploading key..."
echo "put $KEY_PATH $TARGET_KEY" | smbclient "$SAMBA_SERVER" "$PASSWORD" -U "$USERNAME" -c "exit"
echo "Sync completed successfully."