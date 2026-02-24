FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache python3 make g++

COPY package*.json ./

RUN npm install 

COPY . .

RUN npm run build

EXPOSE 1337

CMD ["npm","run","start"]
