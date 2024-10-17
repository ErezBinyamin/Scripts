# Use the official Ubuntu LTS image as a base
FROM ubuntu:20.04

# Set the timezone to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Update the package list and install essential tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    netcat \
    tcpdump \
    tshark \
    net-tools \
    dnsutils \
    iputils-ping \
    curl \
    wget \
    git \
    vim \
    python3 \
    python3-pip \
    build-essential \
    forensics-all \ 
    && rm -rf /var/lib/apt/lists/*

# Install additional Python packages for pentesting
RUN pip3 install --no-cache-dir \
    pwntools \
    chepy \
    requests

# Optional: Install Metasploit
#RUN curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall | sh

# Clean up APT when done to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt update

# Set working directory
WORKDIR /root

# Entry point for the container
ENTRYPOINT ["/bin/bash"]
