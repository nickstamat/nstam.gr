ARG base_node=node:12-alpine
ARG base_nginx=nginxinc/nginx-unprivileged:1.18.0-alpine@sha256:a91139c25f03a1babe220de6bf351647d5ce944770f60443b37559bc89ff617c

FROM $base_node AS build
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ARG COMMIT_SHA
RUN sed -ri "s/COMMIT_SHA_PLACEHOLDER/$COMMIT_SHA/g" index.html
RUN sed -ri "s/COMMIT_SHA_SHORT_PLACEHOLDER/${COMMIT_SHA:0:7}/g" index.html
ENV NODE_ENV production
RUN yarn build:production

FROM $base_nginx
COPY --from=build /build/dist/ /app
