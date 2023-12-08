FROM ubuntu:focal AS base
WORKDIR /app

FROM ubuntu:focal as build
WORKDIR /app
ADD https://www.modbusdriver.com/downloads/modpoll.tgz /tmp/modpoll.tgz
RUN case "${TARGETPLATFORM}" in \
         "linux/amd64")  TARGET_DIR=x86_64-linux-gnu  ;; \
         "linux/arm64")  TARGET_DIR=aarch64-linux-gnu  ;; \
         "linux/arm/v7")  TARGET_DIR=arm-linux-gnueabihf  ;; \
         *) TARGET_DIR=x86_64-linux-gnu ;; \
    esac; \
    tar xzf /tmp/modpoll.tgz --strip-components 2 -C /app modpoll/$TARGET_DIR/modpoll

FROM base AS final
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT [ "/app/modpoll" ]