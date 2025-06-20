FROM debian:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y util-linux parted && \
    rm -rf /var/lib/apt/lists/*

# Install additional required packages for the script
RUN apt-get update && \
    apt-get install -y iproute2 udev && \
    rm -rf /var/lib/apt/lists/*

# Create 4 empty files to simulate disks (each 1GB)
RUN mkdir /disks && \
    for i in 1 2 3 4; do \
      dd if=/dev/zero of=/disks/disk${i}.img bs=1M count=1024; \
    done

# Copy the pve-install.sh script into the Docker image
COPY scripts/pve-install.sh /root/pve-install.sh

# Make the script executable
RUN chmod +x /root/pve-install.sh

# Ensure loop devices are detached before setting them up
CMD ["bash", "-c", "for i in 1 2 3 4; do losetup -d /dev/loop$i 2>/dev/null || true; done; for i in 1 2 3 4; do losetup /dev/loop$i /disks/disk${i}.img; done && bash"]
