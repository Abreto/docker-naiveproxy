FROM ubuntu:18.04 AS builder

WORKDIR /build
RUN apt-get update \
 && apt-get install -y git ninja-build python pkg-config libnss3-dev ccache  \
        curl unzip \
 && git clone -b v85.0.4183.83-3 --depth 1 https://github.com/klzgrad/naiveproxy.git \
 && cd naiveproxy/src \
 && ./get-clang.sh \
 && ./build.sh

FROM ubuntu

COPY --from=builder /build/naiveproxy/src/out/Release/naive /usr/local/bin/naive

RUN apt-get update \
 && apt-get install -y libnss3 \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "naive" ]
CMD [ "--listen=http://0.0.0.0:1080", "--log" ]
