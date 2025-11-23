# Debian development container
ARG VARIANT=ubuntu24.04
FROM mcr.microsoft.com/vscode/devcontainers/cpp:${VARIANT}

# Install typical build tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    echo "Acquire::Retries \"3\";" > /etc/apt/apt.conf.d/90retry && \
    apt-get -y install --no-install-recommends libusb-1.0-0 usbutils vim gcovr

# Setup some handy aliases
RUN echo "alias ll='ls -lA'" >> /home/vscode/.bash_aliases && \
    echo "alias lh='ls -lAh'" >> /home/vscode/.bash_aliases && \
    chown vscode:vscode /home/vscode/.bash_aliases

# Setup proper permissions for USB debugging
RUN usermod -aG sudo,plugdev,dialout vscode

ENTRYPOINT ["/usr/local/share/docker-init.sh"]
CMD ["sleep", "infinity"]
