FROM alpine:latest

RUN apk add --no-cache \
  openssh-client \
  ca-certificates \
  bash \
  sed

EXPOSE 1080
COPY start.sh .
CMD ["sh", "start.sh"]
