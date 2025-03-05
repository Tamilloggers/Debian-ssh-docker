# Use the latest Debian base image
FROM debian:latest

# Install SSH server, curl, sudo, nano, Python3, OpenSSL, and unzip tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    nano \
    curl \
    python3 \
    python3-pip \
    openssl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Docker and Rclone
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && rm get-docker.sh \
    && curl https://rclone.org/install.sh | bash

# Set up the SSH server
RUN mkdir /var/run/sshd

# Set root password
RUN echo 'root:rootpassword' | chpasswd

# Allow SSH access to root
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose SSH and HTTPS ports
EXPOSE 22 80

# Create the directory for health check HTML page
RUN mkdir -p /var/www/html

# Create a simple HTML page for health check (optional)
RUN echo '<html><body><h1>Healthy</h1></body></html>' > /var/www/html/index.html

# Start the SSH server and Python HTTPS server for health check
CMD service ssh start && python3 -m http.server 80 --bind 0.0.0.0
