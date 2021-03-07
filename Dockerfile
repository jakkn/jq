FROM debian:buster-slim as builder

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

WORKDIR /app
COPY . .

RUN buildDeps="build-essential \
    automake \
    libtool \
    git \
    ca-certificates" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps
RUN autoreconf -fi
RUN ./configure --with-oniguruma=builtin --disable-maintainer-mode
RUN make -j$(nproc) \
    && make check \
    && make install

FROM debian:buster-slim
COPY --from=builder /usr/local/bin/jq /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/jq"]
CMD []
