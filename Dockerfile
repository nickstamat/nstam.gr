FROM node:12-alpine AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build:production

FROM nginx:1.17-alpine
COPY --from=build /build/dist /usr/share/nginx/html
