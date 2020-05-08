ARG base_node=node:12-alpine
ARG base_nginx=nginxinc/nginx-unprivileged:1.17.10-alpine@sha256:40b127d1f07c23c380447595ef7241649f04a882435b6d9bf2a5c2934d3619d4

FROM $base_node AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV production
RUN yarn build:production

FROM $base_nginx
COPY --from=build /build/dist/ /app
