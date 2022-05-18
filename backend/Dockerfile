FROM node:16-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3001
RUN npx tsc
CMD ["node", "./dist/server.js"]
