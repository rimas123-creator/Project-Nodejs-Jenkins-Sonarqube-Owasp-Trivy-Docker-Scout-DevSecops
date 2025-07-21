FROM node:alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

FROM node:alpine 

RUN addgroup -S node-app-group && adduser -S node-app-user -G node-app-group

COPY --from=build /app ./

USER node-app-user

CMD ["npm", "start"]