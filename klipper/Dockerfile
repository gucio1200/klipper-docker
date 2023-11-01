FROM gucio1200/klipper:base-latest as builder

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=klippy
ARG GROUP=device
ARG GID=987
ARG WORKDIR=/home/${USER}
ARG VENV_DIR=${WORKDIR}/venv

RUN mkdir -p printer_data/run printer_data/gcodes printer_data/logs printer_data/config
RUN groupadd -g ${GID} ${GROUP} && \
    useradd --user-group --no-log-init --shell /bin/false -m -d ${WORKDIR} ${USER} && \
    usermod -a -G ${GROUP} ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G dialout ${USER} && \
    chown -R ${USER}:${USER} ${WORKDIR}/*

USER ${USER}
WORKDIR ${WORKDIR}

### Klipper setup ###
RUN git clone https://github.com/Klipper3d/klipper.git && \
    [ ! -d ${VENV_DIR} ] && python3 -m venv ${VENV_DIR} && \
    ${VENV_DIR}/bin/pip install -r klipper/scripts/klippy-requirements.txt && \
    ${VENV_DIR}/bin/pip install matplotlib numpy==1.25.2 && \
    ${VENV_DIR}/bin/python -m compileall klipper/klippy && \
    ${VENV_DIR}/bin/python klipper/klippy/chelper/__init__.py

WORKDIR ${WORKDIR}/klipper

COPY klipper/config/linux.config .config
RUN make && \
    mv out/klipper.elf klipper.bin && \
    rm -rf out

COPY klipper/config/octopus.config .config
RUN make && \
    mv out/klipper.elf octopus.bin && \
    rm -rf out

COPY klipper/config/ebb.config .config
RUN make && \
    mv out/klipper.elf ebb.bin && \
    rm -rf out
    
USER ${USER}
VOLUME ["/home/klippy/printer_data/run", "/home/klippy/printer_data/gcodes", "/home/klippy/printer_data/logs", "/home/klippy/printer_data/config"]
ENTRYPOINT ["/home/klippy/venv/bin/python", "klipper/klippy/klippy.py"]
CMD ["-I", "printer_data/run/klipper.tty", "-a", "printer_data/run/klipper.sock", "printer_data/config/klipper.cfg", "-l", "printer_data/logs/klippy.log"]
