ARG APP_HOME=/opt/whitebox

# Build stage
FROM rust:1.57.0-slim-buster as builder
ARG APP_HOME
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    python3 \
    python3-pip \
    git && \
    rm -rf /var/lib/apt/lists/*
    
RUN git clone https://github.com/jblindsay/whitebox-tools.git ${APP_HOME}/whitebox && \
    cd ${APP_HOME}/whitebox && \
    cargo build --release

# Prod stage
FROM debian:buster-slim
ARG APP_HOME
COPY --from=builder ${APP_HOME}/whitebox/target/release/whitebox_tools /usr/local/bin
COPY --from=builder ${APP_HOME}/whitebox/whitebox_tools.py ${APP_HOME}/whitebox/whitebox_tools.py
RUN useradd -ms /bin/bash -r -d ${APP_HOME} gis
ENV PYTHONPATH "$PYTHONPATH:${APP_HOME}"
USER gis
WORKDIR ${APP_HOME}
CMD ["whitebox_tools"]

