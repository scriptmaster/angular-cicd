FROM node:lts as ci
WORKDIR /app
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
RUN npm ci



FROM ci as builder
WORKDIR /app/

COPY src ./src

COPY tsconfig.json .
COPY tsconfig.app.json .
COPY angular.json .

EXPOSE 5553
RUN npm run build
ENTRYPOINT [ "npm", "start" ]



FROM nginx:alpine as web
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/dist/ngdeno1/ .
