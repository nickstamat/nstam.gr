ARG base_node=node:12-alpine
ARG base_nginx=nginx:1.17.8-alpine

FROM $base_node AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV production
RUN yarn build:production

FROM $base_nginx
COPY --from=build /build/dist/ /app
