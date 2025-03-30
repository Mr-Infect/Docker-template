# Dockerfile Template for an Ubuntu-based Container with Essential Services

# Use the latest Ubuntu image as the base
FROM ubuntu:latest

# Maintainer
LABEL maintainer="Your Name <your.email@example.com>"

# Environment Defaults
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV SSH_PUBLIC_KEY=""
ENV APACHE_ENABLE=false

# Update & Install Common Utilities
RUN apt-get update && apt-get install -y \
    # Basic tools
    vim \
    wget \
    curl \
    git \
    net-tools \
    iputils-ping \
    less \
    sudo \
    unzip \
    tar \
    nano \
    tree \
    htop \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    build-essential \
    python3 \
    python3-pip \
    openssh-server \
    apache2 \
    nginx \
    mysql-server \
    postgresql \
    openssl \
    rsync \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Set Timezone
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# SSH Configuration
RUN mkdir -p /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Create user "ghost"
RUN useradd -m ghost \
    && echo "ghost:ghost" | chpasswd \
    && usermod -aG sudo ghost \
    && mkdir -p /home/ghost/.ssh \
    && chmod 700 /home/ghost/.ssh \
    && chown -R ghost:ghost /home/ghost/.ssh

# Set public key during container runtime via volume or env
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Apache Configuration
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && a2enmod rewrite

# Expose Ports (can be enabled selectively)
EXPOSE 22     # SSH
EXPOSE 80     # Apache/Nginx
EXPOSE 443    # SSL
EXPOSE 3306   # MySQL
EXPOSE 5432   # PostgreSQL

# Healthcheck (on SSH and HTTP)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD nc -z localhost 22 || exit 1

# Entrypoint: configure runtime options
ENTRYPOINT ["/entrypoint.sh"]

# Default command (runs SSH daemon)
CMD ["/usr/sbin/sshd", "-D"]
