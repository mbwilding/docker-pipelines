FROM node:bookworm-slim

RUN npm install --global sirv-cli --force && npm cache clean --force

WORKDIR /app

EXPOSE 80

CMD [ "sirv", ".", "--host", "--port", "80", "--single", "--gzip", "--brotli", "--cors", "--quiet" ]
