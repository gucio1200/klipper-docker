FROM arm64v8/python:slim as builder

ARG DEBIAN_FRONTEND=noninteractive

ARG HOME=/root
ARG KLIPPER_VENV_DIR=/root/klipperscreen-env

RUN apt-get update && \
    apt-get install -y locales git sudo wget gzip tar python3-distutils python3-gi \
    python3-gi-cairo python3-virtualenv gir1.2-gtk-3.0 virtualenv matchbox-keyboard python3-dev \
    libjpeg-dev zlib1g-dev libatlas-base-dev gobject-introspection libgirepository1.0-dev \
    libcairo2-dev wireless-tools x11-xserver-utils xdotool

RUN sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen

ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en

WORKDIR ${HOME}

### KlipperScreen setup ###
RUN git clone https://github.com/jordanruthe/KlipperScreen
RUN [ ! -d ${KLIPPER_VENV_DIR} ] && virtualenv -p /usr/bin/python3 ${KLIPPER_VENV_DIR}
RUN ${KLIPPER_VENV_DIR}/bin/python -m pip install pip -U
RUN ${KLIPPER_VENV_DIR}/bin/pip install setuptools wheel pep517 p5py PyGObject
RUN ${KLIPPER_VENV_DIR}/bin/pip install $(cat KlipperScreen/scripts/KlipperScreen-requirements.txt | sed -e /matplotlib/d )
RUN ${KLIPPER_VENV_DIR}/bin/pip install --upgrade --force-reinstall --no-binary :all: numpy $(cat KlipperScreen/scripts/KlipperScreen-requirements.txt | grep matplotlib)
RUN . ${KLIPPER_VENV_DIR}/bin/activate && pip install vext.gi==0.7.4
RUN ${KLIPPER_VENV_DIR}/bin/vext -e


FROM arm64v8/python:slim as image

ARG DEBIAN_FRONTEND=noninteractive

ARG HOME=/root
ARG KLIPPER_VENV_DIR=/root/klipperscreen-env

RUN apt-get update && \
    apt-get install -y locales git sudo libatlas-base-dev python3-distutils python3-gi \
    python3-gi-cairo python3-virtualenv gir1.2-gtk-3.0 virtualenv matchbox-keyboard \
    wireless-tools x11-xserver-utils xdotool

RUN sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen

ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en

COPY --chown=${USER}:${USER} --from=builder ${HOME}/KlipperScreen ${HOME}/KlipperScreen
COPY --chown=${USER}:${USER} --from=builder ${KLIPPER_VENV_DIR} ${KLIPPER_VENV_DIR}

WORKDIR ${HOME}/KlipperScreen

CMD ["/root/klipperscreen-env/bin/python","screen.py"]
