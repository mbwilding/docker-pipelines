FROM alpine:latest

RUN apk add --no-cache openssh-server

RUN { \
    echo "Include /etc/ssh/sshd_config.d/*.conf"; \
    echo "AddressFamily inet"; \
    echo "PasswordAuthentication yes"; \
    echo "Subsystem sftp /usr/lib/ssh/sftp-server"; \
    echo "Port 22"; \
} > /etc/ssh/sshd_config

RUN ssh-keygen -A

EXPOSE 22
COPY start.sh .
CMD ["sh", "start.sh"]
