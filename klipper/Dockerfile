FROM python:3.11-bookworm as builder

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

RUN useradd -d ${WORKDIR} -ms /bin/bash ${USER}

RUN apt update && \
    apt install -y git sudo wget gzip tar virtualenv libffi-dev pkg-config libncurses-dev gpiod python3-virtualenv python3-dev libopenjp2-7 python3-libgpiod \
    build-essential cmake avrdude gcc-avr binutils-avr avr-libc stm32flash dfu-util libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi liblmdb0 libsodium-dev libusb-1.0-0 libusb-1.0-0-dev

USER ${USER}
WORKDIR ${WORKDIR}

### Klipper setup ###
RUN git clone https://github.com/Klipper3d/klipper.git
RUN [ ! -d ${VENV_DIR} ] && python3 -m venv ${VENV_DIR}
#RUN ${VENV_DIR}/bin/pip install wheel && \
RUN ${VENV_DIR}/bin/pip install -r klipper/scripts/klippy-requirements.txt | sed -e /matplotlib/d | sed -e /numpy/d
RUN ${VENV_DIR}/bin/pip install --upgrade --force-reinstall --no-binary :all: numpy==1.25.2 matplotlib -v --config-settings=setup-args="-Dallow-noblas=true" 
RUN ${VENV_DIR}/bin/python -m compileall klipper/klippy
RUN ${VENV_DIR}/bin/python klipper/klippy/chelper/__init__.py

WORKDIR ${WORKDIR}/klipper

COPY klipper ${WORKDIR}/klipper

FROM python:3.11-slim-bookworm as run

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG GROUP=device
ARG GID=987
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

RUN apt update && \
    apt install -y git sudo wget gzip tar virtualenv libjpeg62 libtiff6 pkg-config libncurses-dev gpiod python3-virtualenv python3-dev libopenjp2-7 python3-libgpiod \
    build-essential cmake avrdude gcc-avr binutils-avr avr-libc stm32flash dfu-util libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi liblmdb0 libsodium-dev libusb-1.0-0 libusb-1.0-0-dev

WORKDIR ${WORKDIR}
COPY --from=builder ${WORKDIR}/klipper ${WORKDIR}/klipper
COPY --from=builder ${VENV_DIR} ${VENV_DIR}

RUN mkdir -p printer_data/run printer_data/gcodes printer_data/logs printer_data/config
RUN groupadd -g ${GID} ${GROUP} && \
    useradd --user-group --no-log-init --shell /bin/false -m -d ${WORKDIR} ${USER} && \
    usermod -a -G ${GROUP} ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G dialout ${USER} && \
    chown -R ${USER}:${USER} ${WORKDIR}/*
    
USER ${USER}
VOLUME ["/home/klippy/printer_data/run", "/home/klippy/printer_data/gcodes", "/home/klippy/printer_data/logs", "/home/klippy/printer_data/config"]
ENTRYPOINT ["/home/klippy/venv/bin/python", "klipper/klippy/klippy.py"]
CMD ["-I", "printer_data/run/klipper.tty", "-a", "printer_data/run/klipper.sock", "printer_data/config/klipper.cfg", "-l", "printer_data/logs/klippy.log"]
