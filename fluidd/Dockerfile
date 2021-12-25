FROM node:14.18.2-stretch-slim as build

ARG FRONTEND_GIT_URL=https://github.com/fluidd-core/fluidd.git

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /build

RUN apt-get update && apt-get install --no-install-recommends -y git
RUN git clone ${FRONTEND_GIT_URL} /build

RUN npm install --loglevel verbose \
   && npm run test:unit \
   && npm run build

#FROM nginx:alpine as image

#ENV KLIPPER_HOST moonraker
#ENV KLIPPER_API_PORT 7125
#ENV JPEG_STREAM_HOST localhost
#ENV JPEG_STREAM_PORT 8888

#ADD --chown=101:101 common_vars.conf /etc/nginx/conf.d/common_vars.conf 
#COPY --chown=101:101 upstreams.conf.template /etc/nginx/templates/upstreams.conf.template
#COPY --chown=101:101 client.conf /etc/nginx/conf.d/default.conf 
#COPY --from=build --chown=101:101 /frontend /usr/share/nginx/html
#EXPOSE 80
