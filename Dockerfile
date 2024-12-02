FROM node:alpine

RUN npm install --global sirv-cli --force
RUN npm cache clean --force

WORKDIR /app

EXPOSE 80

CMD [ "sirv", ".", "--host", "--port", "80", "--single", "--quiet" ]
