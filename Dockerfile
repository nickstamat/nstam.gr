FROM node:12.16.0-alpine3.11@sha256:aa52cfbaef33dc2f3bc41228072bce75705733d4d90cf086260df15fd7c65319 AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV production
RUN yarn build:production

FROM nginx:1.17.8-alpine@sha256:fa266689d339b47a4a9d1148015d4bc5c4914d3d7e3ec061d85aa8813dfd485c
COPY --from=build /build/dist/ /app
