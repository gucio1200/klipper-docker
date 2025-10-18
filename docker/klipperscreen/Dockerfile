FROM arm64v8/python:slim as builder

ARG DEBIAN_FRONTEND=noninteractive

ARG USER=klippy
ARG HOME=/home/${USER}
ARG KLIPPER_VENV_DIR=${HOME}/klipperscreen-env


RUN useradd -d ${HOME} -ms /bin/bash ${USER}
RUN apt update \
 && apt install -y \
      libgirepository1.0-dev \
      libdbus-glib-1-dev \
      cmake \
      libsystemd-dev \
 && apt clean

USER ${USER}
WORKDIR ${HOME}

### KlipperScreen setup ###
RUN git clone https://github.com/jordanruthe/KlipperScreen.git klipperscreen
RUN python -m venv ${KLIPPER_VENV_DIR}
RUN ${KLIPPER_VENV_DIR}/bin/pip install -r klipperscreen/scripts/KlipperScreen-requirements.txt

WORKDIR ${HOME}

FROM arm64v8/python:slim as image

ARG DEBIAN_FRONTEND=noninteractive

ARG USER=klippy
ARG HOME=/home/${USER}
ARG KLIPPER_VENV_DIR=${HOME}/klipperscreen-env

RUN useradd --user-group --no-log-init --shell /bin/false -m -d ${HOME} ${USER}

RUN apt update \
 && apt install -y \
      git \
      xdotool \
      x11-xserver-utils \
      libglib2.0-0t64 \
      libgirepository-1.0-1 \
      gir1.2-gtk-3.0 \
      libopenjp2-7 \
      fonts-freefont-ttf \
      libcairo2 \
      libatlas3-base \
      libdbus-glib-1-2 \
 && apt clean

COPY --chown=${USER}:${USER} --from=builder ${HOME}/klipperscreen ${HOME}/klipperscreen
COPY --chown=${USER}:${USER} --from=builder ${KLIPPER_VENV_DIR} ${KLIPPER_VENV_DIR}

USER ${USER}
WORKDIR ${HOME}/klipperscreen

CMD ["/home/klippy/klipperscreen-env/bin/python","screen.py"]
