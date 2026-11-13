FROM node:20-alpine

WORKDIR /app .

COPY package.json server.js ./

CMD npm ci

EXPOSE 8080

CMD ["node", "server.js"]
