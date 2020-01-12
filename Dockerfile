FROM node:12.14.1-alpine3.11@sha256:fe2cd1b5a9faf21497b73b37f24ad391ac39e72167e435217e9009c836e6da5d AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV production
RUN yarn build:production

FROM nginx:1.17.7-alpine@sha256:2911ad2d54f4cf4dc7ad21af122c1eefce16836a34be751c63351ca1fb452d57
COPY ops/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /build/dist/ /app
