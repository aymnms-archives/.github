FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global --add safe.directory '*'

COPY push.sh /usr/local/bin/push.sh
RUN chmod +x /usr/local/bin/push.sh

WORKDIR /workspace

ENTRYPOINT ["push.sh"]
