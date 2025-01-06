echo $CERT > /tmp/certificate
ssh -D 1080 -N -o "ServerAliveInterval 60" -i /tmp/certificate ${USER}@${HOST} -p ${PORT}
