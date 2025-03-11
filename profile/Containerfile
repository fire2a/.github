FROM docker.io/qgis/qgis:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        git \
        g++-12 \
        libboost-all-dev \
        libeigen3-dev \
        libtiff-dev \
        make \
        --no-install-recommends

WORKDIR /root

ENV DISPLAY=:0

RUN chmod +x build.sh && ./build.sh

CMD ["/bin/bash", "-c", "source /root/venv/bin/activate && qgis"]
# CMD ["tail", "-f", "/dev/null"]
