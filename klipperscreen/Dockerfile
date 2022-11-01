FROM python:3.10 as builder

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

RUN useradd -d ${WORKDIR} -ms /bin/bash ${USER}

RUN apt update \
 && apt install -y \
      libgirepository1.0-dev \
 && apt clean

USER ${USER}
WORKDIR ${WORKDIR}

### KlipperScreen setup ###
RUN git clone https://github.com/jordanruthe/KlipperScreen.git klipperscreen
RUN [ ! -d ${VENV_DIR} ] && python3 -m venv ${VENV_DIR}
RUN ${VENV_DIR}/bin/python -m pip install pip -U
RUN ${VENV_DIR}/bin/pip install setuptools wheel pep517 p5py PyGObject
RUN ${VENV_DIR}/bin/pip install $(cat klipperscreen/scripts/KlipperScreen-requirements.txt | sed -E -e /matplotlib\|vext/d )
RUN ${VENV_DIR}/bin/pip install --upgrade --force-reinstall --no-binary :all: $(cat klipperscreen/scripts/KlipperScreen-requirements.txt | grep matplotlib)

FROM python:3-slim as run

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG GID=1000
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

WORKDIR ${WORKDIR}

RUN apt update && \
    apt install -y \
      git \
      xdotool \
      x11-xserver-utils \
      libglib2.0-0 \
      libgirepository-1.0-1 \
      gir1.2-gtk-3.0 \
      libopenjp2-7 \
      fonts-freefont-ttf \
      libcairo2 \
      libatlas3-base \
 && apt clean

RUN mkdir -p printer_data/config
RUN groupadd -g ${GID} ${USER} && \
    useradd --no-log-init --shell /bin/false --uid 1000 --gid ${USER} -m -d ${WORKDIR} ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G dialout ${USER} && \
    chown -R ${USER}:${USER} ${WORKDIR}/*

COPY --chown=${USER}:${USER} --from=builder ${WORKDIR}/klipperscreen ${WORKDIR}/klipperscreen
COPY --chown=${USER}:${USER} --from=builder ${VENV_DIR} ${VENV_DIR}

USER ${USER}
ENV DISPLAY=unix:0.0
VOLUME ["/home/klippy/printer_data/config"]
ENTRYPOINT ["/home/klippy/venv/bin/python", "klipperscreen/screen.py"]
CMD ["-c", "printer_data/config/klipperscreen.conf"]
