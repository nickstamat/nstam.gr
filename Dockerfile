FROM node:12.14.0-alpine3.11@sha256:57a34fed5fd5f18879c5915e3d0daad5d03825c997763e78a72d3c96a7f1476f AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV production
RUN yarn build:production

FROM nginx:1.17.6-alpine@sha256:2993f9c9a619cde706ae0e34a1a91eb9cf5225182b6b76eb637392d2ce816538
COPY ops/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /build/dist/ /app
