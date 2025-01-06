{
  echo "-----BEGIN OPENSSH PRIVATE KEY-----"
  echo "$CERT_PART_1" | sed 's/ /\n/g'
  echo "$CERT_PART_2" | sed 's/ /\n/g'
  echo "$CERT_PART_3" | sed 's/ /\n/g'
  echo "$CERT_PART_4" | sed 's/ /\n/g'
  echo "-----END OPENSSH PRIVATE KEY-----"
} > /tmp/certificate
chmod 600 /tmp/certificate

while true; do ssh -o "StrictHostKeyChecking=no" -D 0.0.0.0:1080 -N -o "ServerAliveInterval 60" -i /tmp/certificate ${USER}@${HOST} -p ${PORT}; sleep 5; done
