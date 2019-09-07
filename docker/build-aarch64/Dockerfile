FROM gcc:9.2.0

RUN apt-get update && apt-get install -y --no-install-recommends \
        wget file g++ make gawk python3 python3-pip python3-setuptools

COPY . /gcc_build
RUN cd /gcc_build && ./build-gcc.sh && cd .. && rm -rf /gcc_build
RUN pip3 install wheel && pip3 install meson

ENV PATH="/opt/cross/bin:${PATH}"
