FROM arm64v8/ubuntu as build
WORKDIR /build


RUN apt-get update && \
    apt-get install -y git libwebp-dev ca-certificates build-essential libevent-dev libjpeg62-dev uuid-dev libbsd-dev make gcc libjpeg8 libjpeg-turbo8 libuuid1 libbsd0

RUN apt install -y libjpeg-turbo8-dev gpiod libgpiod-dev

RUN git clone --depth=1 https://github.com/pikvm/ustreamer

WORKDIR /build/ustreamer/
RUN make WITH_GPIO=1

FROM arm64v8/ubuntu as RUN

RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        libevent-2.1 \
        libevent-pthreads-2.1-7 \
        libjpeg8 \
        uuid \
        libbsd0 \
        gpiod \
        libgpiod-dev

WORKDIR /ustreamer
COPY --from=build /build/ustreamer/ustreamer .

EXPOSE 8080
CMD [ "./ustreamer", "--host=0.0.0.0", "--slowdown"]
