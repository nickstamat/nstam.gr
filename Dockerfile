FROM node:12.14.1-alpine3.11@sha256:0c4511861fe4ac25d5d84088f374f2678a8ea81f4ca8ca16299c37f62799f41c AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV production
RUN yarn build:production

FROM nginx:1.17.8-alpine@sha256:fa266689d339b47a4a9d1148015d4bc5c4914d3d7e3ec061d85aa8813dfd485c
COPY --from=build /build/dist/ /app
