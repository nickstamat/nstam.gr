FROM node:12-alpine AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV production
RUN yarn build:production

FROM nginx:1.17-alpine
COPY ops/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /build/dist/ /app
