{
  echo "-----BEGIN OPENSSH PRIVATE KEY-----"
  echo "$CERT_PART_1" | sed 's/ /\n/g'
  echo "$CERT_PART_2" | sed 's/ /\n/g'
  echo "$CERT_PART_3" | sed 's/ /\n/g'
  echo "$CERT_PART_4" | sed 's/ /\n/g'
  echo "-----END OPENSSH PRIVATE KEY-----"
} > /tmp/certificate
ssh -D 1080 -N -o "ServerAliveInterval 60" -i /tmp/certificate ${USER}@${HOST} -p ${PORT}
