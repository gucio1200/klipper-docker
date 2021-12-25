FROM python:3.9 as builder

ARG DEBIAN_FRONTEND=noninteractive

ARG USER=klippy
ARG HOME=/home/${USER}
ARG KLIPPER_VENV_DIR=${HOME}/klippy-env

RUN useradd -d ${HOME} -ms /bin/bash ${USER}
RUN apt-get update && \
    apt-get install -y locales git sudo wget gzip tar virtualenv python-dev libffi-dev libncurses-dev libusb-dev gpiod python3-virtualenv python3-dev libopenjp2-7 python3-libgpiod \
    build-essential avrdude gcc-avr binutils-avr avr-libc stm32flash libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0 liblmdb0 libsodium-dev
RUN sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen

ENV LC_ALL en_GB.UTF-8 
ENV LANG en_GB.UTF-8  
ENV LANGUAGE en_GB:en   

USER ${USER}
WORKDIR ${HOME}

### Klipper setup ###
RUN git clone https://github.com/Klipper3d/klipper.git
RUN [ ! -d ${KLIPPER_VENV_DIR} ] && virtualenv -p python2 ${KLIPPER_VENV_DIR}
RUN ${KLIPPER_VENV_DIR}/bin/python -m pip install pip -U
RUN ${KLIPPER_VENV_DIR}/bin/pip install wheel
RUN ${KLIPPER_VENV_DIR}/bin/pip install -r klipper/scripts/klippy-requirements.txt
RUN ${KLIPPER_VENV_DIR}/bin/pip install numpy matplotlib

WORKDIR ${HOME}/klipper

COPY klipper/.config-linux ${HOME}/klipper/.config
RUN make && mv out out_linux

COPY klipper/.config-s6 ${HOME}/klipper/.config
RUN make && mv out out_s6

WORKDIR ${HOME}

FROM python:3.9-slim as image

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    git \
    gcc \
    locales \
    libjpeg62-turbo \
    libtiff5 \
    gpiod \
    libopenjp2-7 \
    rsync \
    zlib1g-dev \
    curl \
    libsodium-dev \
    liblmdb0 \
    python3-libgpiod \
    python \
    libfreetype6 \
    bash && \
    sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV LC_ALL en_GB.UTF-8 
ENV LANG en_GB.UTF-8  
ENV LANGUAGE en_GB:en   

ARG USER=klippy
ARG HOME=/home/${USER}
ENV CONFIG_DIR=${HOME}/.config
ENV KLIPPER_VENV_DIR=${HOME}/klippy-env

ARG DEVICE_GROUP=device
ARG DEVICE_GID=987

RUN useradd --user-group --no-log-init --shell /bin/false -m -d ${HOME} ${USER} && \
    groupadd -g ${DEVICE_GID} ${DEVICE_GROUP} && \
    usermod -a -G ${DEVICE_GROUP} ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G dialout ${USER} && \
    mkdir -p /var/log/klipper && chown ${USER}:${USER} /var/log/klipper ${HOME} && \
    pip install --no-cache gpiod

RUN mkdir -p /usr/lib/python3 && ln -s /usr/local/lib/python3.9/site-packages /usr/lib/python3/dist-packages

USER ${USER}
WORKDIR ${HOME}

RUN mkdir -p ${HOME}/gcode_files && \
    mkdir -p ${CONFIG_DIR} && \
    mkdir -p ${HOME}/.moonraker_database
VOLUME ${HOME}/gcode_files
VOLUME ${CONFIG_DIR}

USER ${USER}

COPY --chown=${USER}:${USER} --from=builder ${HOME}/klipper ${HOME}/klipper
COPY --chown=${USER}:${USER} --from=builder ${KLIPPER_VENV_DIR} ${KLIPPER_VENV_DIR}
COPY --chown=${USER}:${USER} klipper/start-klipper.sh /start-klipper.sh

CMD ["/start-klipper.sh"]
