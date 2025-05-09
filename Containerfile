FROM docker.io/qgis/qgis:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        git \
        g++-12 \
        libboost-all-dev \
        libeigen3-dev \
        libtiff-dev \
        python3-venv \
        python3-pip \
        make \
        --no-install-recommends

COPY build.sh .

RUN chmod +x build.sh && ./build.sh

ENV DISPLAY=:0

CMD ["/bin/bash", "-c", "source /root/venv/bin/activate && qgis"]
# CMD ["tail", "-f", "/dev/null"]
