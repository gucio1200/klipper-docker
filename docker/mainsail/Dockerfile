FROM debian as unzip

ARG FRONTEND_ZIP_URL=https://github.com/cadriel/fluidd/releases/latest/download/fluidd.zip

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /frontend

ADD ${FRONTEND_ZIP_URL} /tmp/frontend.zip
RUN apt-get update && apt-get install -y unzip
RUN unzip /tmp/frontend.zip -d /frontend

FROM nginx:alpine as image

ENV KLIPPER_HOST moonraker
ENV KLIPPER_API_PORT 7125
ENV JPEG_STREAM_HOST ustreamer
ENV JPEG_STREAM_PORT 8080

ADD --chown=101:101 common_vars.conf /etc/nginx/conf.d/common_vars.conf 
COPY --chown=101:101 upstreams.conf.template /etc/nginx/templates/upstreams.conf.template
COPY --chown=101:101 client.conf /etc/nginx/conf.d/default.conf 
COPY --from=unzip --chown=101:101 /frontend /usr/share/nginx/html
EXPOSE 80
