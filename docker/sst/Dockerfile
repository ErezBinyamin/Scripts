# Use the official Ubuntu LTS image as a base
FROM i686/ubuntu

# Set the timezone to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Update the package list and install essential tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Clean up APT when done to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt update

# Download and configure sst
## Set working directory
WORKDIR /root
## Copy and unzip sst files
ADD https://almy.us/files/sstlinux.zip /root/
RUN unzip sstlinux.zip

# Entry point for the container
ENTRYPOINT ["/bin/bash"]
