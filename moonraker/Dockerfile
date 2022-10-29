FROM python:3.10 as builder

ARG DEBIAN_FRONTEND=noninteractive

ARG USER=klippy
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

RUN useradd -d ${WORKDIR} -ms /bin/bash ${USER}

USER ${USER}
WORKDIR ${WORKDIR}

# Install moonraker
RUN git clone https://github.com/Arksine/moonraker.git
RUN [ ! -d ${VENV_DIR} ] && python3 -m venv ${VENV_DIR}
RUN ${VENV_DIR}/bin/python -m pip install pip -U
RUN ${VENV_DIR}/bin/pip install -r moonraker/scripts/moonraker-requirements.txt

FROM python:3.10-slim as run

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG GID=1000
ARG WORKDIR=/home/${USER}
ENV VENV_DIR=${WORKDIR}/venv

RUN apt update && \
    apt install -y \
    git \
    libjpeg62-turbo \
    libtiff5 \
    zlib1g \
    curl \
    libsodium23 \
    liblmdb0 \
    iproute2 \
    python3-libgpiod && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*   

WORKDIR ${WORKDIR}
COPY --from=builder ${WORKDIR}/moonraker ${WORKDIR}/moonraker
COPY --from=builder ${WORKDIR}/venv ${WORKDIR}/venv

RUN mkdir -p printer_data/run printer_data/gcodes printer_data/logs printer_data/database printer_data/config
RUN groupadd -g ${GID} ${USER} && \
    useradd --no-log-init --shell /bin/false --uid 1000 --gid ${USER} -m -d ${WORKDIR} ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G dialout ${USER} \
    && chown -R ${USER}:${USER} ${WORKDIR}/*

RUN ln -s /bin/systemctl /sbin/shutdown \
 && ln -s /bin/systemctl /sbin/reboot \
 && echo -n "${USER} ALL = NOPASSWD: /bin/systemctl, /sbin/shutdown, /sbin/reboot" > /etc/sudoers.d/${USER}

USER ${USER}
EXPOSE 7125
VOLUME ["/home/klippy/printer_data/run", "/home/klippy/printer_data/gcodes", "/home/klippy/printer_data/logs", "/home/klippy/printer_data/database", "/home/klippy/printer_data/config"]
ENTRYPOINT ["/home/klippy/venv/bin/python", "moonraker/moonraker/moonraker.py"]
CMD ["-c", "/home/klippy/printer_data/config/moonraker.conf", "-d", "/home/klippy/printer_data"]
