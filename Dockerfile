FROM rust:1.26.2-stretch

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    python \
    git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/jblindsay/whitebox-tools.git /tmp/git && \
    cd /tmp/git && \
    cargo build --release

CMD ["/bin/bash"]

