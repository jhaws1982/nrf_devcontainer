# Debian development container
ARG VARIANT=ubuntu24.04
FROM mcr.microsoft.com/vscode/devcontainers/cpp:${VARIANT}

# Install typical build tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    echo "Acquire::Retries \"3\";" > /etc/apt/apt.conf.d/90retry && \
    apt-get -y install --no-install-recommends \
        libusb-1.0-0 usbutils vim gcovr clang-format \
        wget udev libunistring5

# # Install Nordic nRF Command Line Tools (nrfjprog)
# # Check https://www.nordicsemi.com/Products/Development-tools/nRF-Command-Line-Tools/Download
# # for the latest version
ARG NRF_TOOLS_VERSION=10.24.2
RUN NRF_TOOLS_VERSION_URL=$(echo ${NRF_TOOLS_VERSION} | tr '.' '-') && \
    wget -q "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/${NRF_TOOLS_VERSION_URL}/nrf-command-line-tools_${NRF_TOOLS_VERSION}_amd64.deb" \
        -O /tmp/nrf-tools.deb && \
    apt-get -y install /tmp/nrf-tools.deb && \
    rm /tmp/nrf-tools.deb

# Install dependencies for SEGGER JLink tools
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends \
        fontconfig-config fonts-dejavu-core fonts-dejavu-mono \
        libfontconfig1 libfreetype6 libice6 libpng16-16t64 libsm6 \
        libx11-6 libx11-data libx11-xcb1 libxau6 libxcb-icccm4 \
        libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
        libxcb-render0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-util1 \
        libxcb-xfixes0 libxcb-xkb1 libxcb1 libxdmcp6 libxext6 \
        libxkbcommon-x11-0 libxkbcommon0 libxrender1 x11-common xkb-data

# Install SEGGER J-Link tools that is packaged with the nRF Command Line Tools.
# Check https://www.segger.com/downloads/jlink/ for the latest version.
ARG JLINK_VERSION=V794e
RUN dpkg --unpack /opt/nrf-command-line-tools/share/JLink_Linux_${JLINK_VERSION}_x86_64.deb && \
    rm -f /var/lib/dpkg/info/jlink.postinst && \
    dpkg --configure jlink

# Create runtime dirs to prevent VS Code startup errors
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix && \
    mkdir -p /tmp/user && chmod 1777 /tmp/user

# Setup some handy aliases
RUN echo "alias ll='ls -lA'" >> /home/vscode/.bash_aliases && \
    echo "alias lh='ls -lAh'" >> /home/vscode/.bash_aliases && \
    chown vscode:vscode /home/vscode/.bash_aliases

# Setup proper permissions for USB debugging
RUN usermod -aG sudo,plugdev,dialout vscode

ENTRYPOINT ["/usr/local/share/docker-init.sh"]
CMD ["sleep", "infinity"]
