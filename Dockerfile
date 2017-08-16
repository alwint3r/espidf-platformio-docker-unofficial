FROM ubuntu:16.04
MAINTAINER Alwin Arrasyid <alwin.ridd@gmail.com>

RUN mkdir -p /esp/project /esp/toolchain
WORKDIR /esp/project

# ESP-IDF toolchain installation layer
RUN apt-get -q update && \
    apt-get install -y git wget make libncurses-dev flex bison gperf python python-serial python-pip && \
    wget -O /esp/xtensa-esp32-elf.tar.gz https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-61-gab8375a-5.2.0.tar.gz && \
    tar -xzf /esp/xtensa-esp32-elf.tar.gz -C /esp/toolchain && \
    rm /esp/xtensa-esp32-elf.tar.gz && \
    pip install platformio && \
    apt-get remove -y python-pip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ESP-IDF & PlatformIO's Espressif32 platform download
RUN git clone --recursive https://github.com/espressif/esp-idf.git /esp/idf && \
    platformio platform install espressif32

ENV PATH /esp/toolchain/xtensa-esp32-elf/bin:$PATH
ENV IDF_PATH /esp/idf

CMD ["/bin/bash"]

