ARG base_node=node:12-alpine
ARG base_nginx=nginx:1.17.10-alpine@sha256:630d39f3970740583f96ec6b26cc7b0f531c35a5c2068c551f02f5236b1e373f

FROM $base_node AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV NODE_ENV production
RUN yarn build:production

FROM $base_nginx
COPY --from=build /build/dist/ /app
