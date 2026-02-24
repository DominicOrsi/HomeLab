#!/bin/bash
set -e

PUB_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICumJVEXy4KM+SOvPnqmq+NAMuA7GiUuKOoE6HrWbMp5 dominic@DMBP"

# 2. Install dependencies
if command -v dnf >/dev/null; then
    PKGMGR="dnf"
elif command -v apt-get >/dev/null; then
    PKGMGR="apt-get"
    export DEBIAN_FRONTEND=noninteractive
fi
$PKGMGR update -y && $PKGMGR install -y vim openssh-server sudo

# 3. Create ansible user
if ! id "ansible" &>/dev/null; then
    useradd -m -s /bin/bash ansible
    echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
    chmod 0440 /etc/sudoers.d/ansible
fi

# 4. Setup SSH ONLY for ansible user
mkdir -p /home/ansible/.ssh
echo "$PUB_KEY" > /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
chmod 600 /home/ansible/.ssh/authorized_keys

# 5. OPTIONAL: Remove the key from root for security
# If you want root to no longer be accessible via this SSH key:
rm -f /root/.ssh/authorized_keys

# 6. Ensure SSH service is active
systemctl enable sshd
systemctl start sshd
systemctl restart sshd

echo "Ansible user is ready. Key placed in /home/ansible/.ssh/authorized_keys."

echo "REBOOTING NOW"
reboot now