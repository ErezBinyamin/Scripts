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
## Create .bashrc with cool ascii art splash screen. base64 encode to avoid special chars in script
RUN echo "printf '** Welcome to the Super Star Trek Docker container! **\n\n'" >> ~/.bashrc
RUN echo "base64 -d <<< 'H4sIAAAAAAAAA1OIxwQKUABi6wGBLgiAGCABLg105T4+8ZpA1bZ4ARfMwPj4GCArBqoXaLa6noJC\
AsSCeKiNQJ46WEOCri7UcoSrwOIKOvpcCmggQVcvXkFXAYJqMKSRzVPnAgB8xCTg+AAAAA==' | gunzip" >> ~/.bashrc
RUN echo "printf '\n\n'" >> ~/.bashrc
RUN echo "printf 'To play SST just type: ./sst\n\n'" >> ~/.bashrc

# Entry point for the container
ENTRYPOINT ["/bin/bash"]
