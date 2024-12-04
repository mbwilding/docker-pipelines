adduser -D -s /bin/ash $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
/usr/sbin/sshd -D
