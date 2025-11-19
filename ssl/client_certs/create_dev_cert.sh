#!/bin/bash
# ------------------------------------------------------------------
# Create and sign a new device certificate using your local CA
# Usage: ./create-device-cert.sh esp32-001
# Output: certs/esp32-001.{key,csr,crt}
# ------------------------------------------------------------------

set -e

DEVICE_NAME="$1"

if [ -z "$DEVICE_NAME" ]; then
    echo "Usage: $0 <device-name>"
    exit 1
fi

CA_DIR="../myCA"        # where your ca.crt and ca.key live
OUT_DIR="./certs/$DEVICE_NAME"
DAYS_VALID=3650                  # 10 years validity

mkdir -p "$OUT_DIR"

echo "Creating key and certificate for device: $DEVICE_NAME"

# 1️⃣ Generate a new private key
openssl genrsa -out "$OUT_DIR/$DEVICE_NAME.key" 2048

# 2️⃣ Create certificate signing request (CSR)
openssl req -new \
    -key "$OUT_DIR/$DEVICE_NAME.key" \
    -out "$OUT_DIR/$DEVICE_NAME.csr" \
    -subj "/C=US/ST=NA/L=Local/O=IoT Devices/OU=Devices/CN=$DEVICE_NAME"

# 3️⃣ Sign the CSR with your CA to create a device certificate
openssl x509 -req \
    -in "$OUT_DIR/$DEVICE_NAME.csr" \
    -CA "$CA_DIR/ca.crt" \
    -CAkey "$CA_DIR/ca.key" \
    -CAcreateserial \
    -out "$OUT_DIR/$DEVICE_NAME.crt" \
    -days "$DAYS_VALID" \
    -sha256

# 4️⃣ (Optional) Combine into a PEM for MQTT clients
cat "$OUT_DIR/$DEVICE_NAME.crt" "$OUT_DIR/$DEVICE_NAME.key" > "$OUT_DIR/$DEVICE_NAME.pem"

rm $OUT_DIR/$DEVICE_NAME.csr

echo
echo "✅ Device certificate generated:"
echo "  Key : $OUT_DIR/$DEVICE_NAME.key"
echo "  Cert: $OUT_DIR/$DEVICE_NAME.crt"
echo "  PEM : $OUT_DIR/$DEVICE_NAME.pem"
echo
echo "Remember to copy $CA_DIR/ca.crt to the device for TLS verification."

