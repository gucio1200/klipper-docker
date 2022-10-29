FROM python:3.10 as builder

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
RUN ${VENV_DIR}/bin/python -m pip install pip -U
RUN ${VENV_DIR}/bin/pip install wheel
RUN ${VENV_DIR}/bin/pip install -r klipper/scripts/klippy-requirements.txt
RUN ${VENV_DIR}/bin/pip install --upgrade --force-reinstall --no-binary :all: numpy matplotlib

FROM python:3.10-slim as run

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG GID=1000
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

WORKDIR ${WORKDIR}
COPY --from=builder ${WORKDIR}/klipper ${WORKDIR}/klipper
COPY --from=builder ${VENV_DIR} ${VENV_DIR}

RUN mkdir -p printer_data/run printer_data/gcodes printer_data/logs printer_data/config
RUN groupadd -g ${GID} ${USER} && \
    useradd --no-log-init --shell /bin/false --uid 1000 --gid ${USER} -m -d ${WORKDIR} ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G dialout ${USER} && \
    chown -R ${USER}:${USER} ${WORKDIR}/*
    
USER ${USER}
VOLUME ["${WORKDIR}/printer_data/run", "${WORKDIR}/printer_data/gcodes", "${WORKDIR}/printer_data/logs", "${WORKDIR}/printer_data/config"]
ENTRYPOINT ["${VENV_DIR}/bin/python", "klipper/klippy/klippy.py"]
CMD ["-I", "printer_data/run/klipper.tty", "-a", "printer_data/run/klipper.sock", "printer_data/config/printer.cfg"]
