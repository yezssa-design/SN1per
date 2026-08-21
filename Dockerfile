FROM docker.io/kalilinux/kali-rolling:latest

LABEL org.label-schema.name="Sn1per - Kali Linux" \
      org.label-schema.description="Automated pentest framework for offensive security experts" \
      org.label-schema.usage="https://github.com/1N3/Sn1per" \
      org.label-schema.url="https://github.com/1N3/Sn1per" \
      org.label-schema.vendor="https://sn1persecurity.com" \
      org.label-schema.schema-version="1.0"

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/go/bin:/usr/local/go/bin:${PATH}"

RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" \
    > /etc/apt/sources.list

RUN apt-get update && \
    apt-get -y full-upgrade && \
    apt-get install -y \
        git \
        bash \
        curl \
        wget \
        ca-certificates \
        build-essential \
        golang \
        python3 \
        python3-pip \
        ruby \
        ruby-dev \
        metasploit-framework && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY . /usr/src/app

# Skip obsolete/broken Arachni download
RUN sed -i '/# Arachni (Linux only)/,/^    fi$/d' install.sh

# Install Sn1per non-interactively
RUN chmod +x install.sh && \
    ./install.sh force

WORKDIR /root

CMD ["sniper"]
