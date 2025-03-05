# Use Debian as the base image
FROM debian:latest

# Install SSH server and other utilities
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && rm get-docker.sh && curl https://rclone.org/install.sh | bash

# Set up the SSH server
RUN mkdir /var/run/sshd
RUN echo 'root:rootpassword' | chpasswd

# Allow SSH access to root
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 22

# Start the SSH server when the container runs
CMD ["/usr/sbin/sshd", "-D"]
