FROM rsmmr/clang:8.0

RUN apt-get update && apt-get install -y --no-install-recommends \
        wget file unzip tar g++ make cmake gawk

COPY . /gcc_build
RUN cd /gcc_build && ./build-gcc.sh && cd .. && rm -rf /gcc_build

ENV PATH="/opt/cross/bin:${PATH}"
