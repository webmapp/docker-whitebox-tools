FROM rust:1.26.2-slim-stretch

ENV APP_HOME /opt/whitebox
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    python3 \
    python3-pip \
    git && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash -r -d ${APP_HOME} gis

RUN git clone https://github.com/jblindsay/whitebox-tools.git ${APP_HOME}/whitebox && \
    cd ${APP_HOME}/whitebox && \
    cargo build --release && \
    mv target/release/whitebox_tools /usr/local/bin

ENV PYTHONPATH "$PYTHONPATH:/opt/whitebox"
USER gis
WORKDIR ${APP_HOME}
CMD ["whitebox_tools"]

