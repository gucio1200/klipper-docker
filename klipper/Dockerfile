FROM gucio1200/klipper:base-latest as builder

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

RUN useradd -d ${WORKDIR} -ms /bin/bash ${USER}

USER ${USER}
WORKDIR ${WORKDIR}

### Klipper setup ###
RUN git clone https://github.com/Klipper3d/klipper.git
RUN [ ! -d ${VENV_DIR} ] && python3 -m venv ${VENV_DIR}
RUN ${VENV_DIR}/bin/pip install -r klipper/scripts/klippy-requirements.txt
RUN ${VENV_DIR}/bin/pip install matplotlib numpy==1.25.2
RUN ${VENV_DIR}/bin/python -m compileall klipper/klippy
RUN ${VENV_DIR}/bin/python klipper/klippy/chelper/__init__.py

WORKDIR ${WORKDIR}/klipper

COPY klipper ${WORKDIR}/klipper

FROM gucio1200/klipper:base-latest as run

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG GROUP=device
ARG GID=987
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

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

FROM builder as build-hostmcu
WORKDIR /home/klippy
COPY config/linux.config klipper/.config
RUN cd klipper && \
    make flash

FROM debian:bullseye-slim as hostmcu
WORKDIR /home/klippy
RUN apt update \
 && apt install -y gpiod \
 && apt clean
COPY --from=build-hostmcu /usr/local/bin/klipper_mcu /usr/local/bin/klipper_mcu
ENTRYPOINT ["/usr/local/bin/klipper_mcu"]
CMD ["-I", "printer_data/run/klipper_host_mcu.tty"]
