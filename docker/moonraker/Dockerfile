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
RUN ${VENV_DIR}/bin/pip install lmdb==1.7.5
RUN ${VENV_DIR}/bin/pip install -r moonraker/scripts/moonraker-requirements.txt

FROM python:3.10-slim as run

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG GROUP=device
ARG GID=987
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

RUN apt update && \
    apt install -y \
      libopenjp2-7 \
      python3-libgpiod \
      curl \
      libcurl4t64 \
      libssl3t64 \
      liblmdb0 \
      libsodium23 \
      libjpeg62-turbo \
      libtiff6 \
      libxcb1 \
      zlib1g \
      iproute2 \
      systemd \
      sudo \
      git \
      jq \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*   

WORKDIR ${WORKDIR}
COPY --from=builder ${WORKDIR}/moonraker ${WORKDIR}/moonraker
COPY --from=builder ${VENV_DIR} ${VENV_DIR}

RUN mkdir -p printer_data/run printer_data/gcodes printer_data/logs printer_data/database printer_data/config
RUN groupadd -g ${GID} ${GROUP} && \
    useradd --user-group --no-log-init --shell /bin/false -m -d ${WORKDIR} ${USER} && \
    usermod -a -G ${GROUP} ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G dialout ${USER} && \
    chown -R ${USER}:${USER} ${WORKDIR}/*

RUN ln -s /bin/systemctl /sbin/shutdown && \
    ln -s /bin/systemctl /sbin/reboot && \
    echo -n "${USER} ALL = NOPASSWD: /bin/systemctl, /sbin/shutdown, /sbin/reboot" > /etc/sudoers.d/${USER}

USER ${USER}
EXPOSE 7125
VOLUME ["/home/klippy/printer_data/run", "/home/klippy/printer_data/gcodes", "/home/klippy/printer_data/logs", "/home/klippy/printer_data/database", "/home/klippy/printer_data/config"]
ENTRYPOINT ["/home/klippy/venv/bin/python", "moonraker/moonraker/moonraker.py"]
CMD ["-d", "/home/klippy/printer_data"]
