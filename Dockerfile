FROM ubuntu:22.04

# Empêche les prompts interactifs pendant l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour et installer Ansible, Python, SSH, sudo, curl, unzip, gnupg
RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3 \
    python3-pip \
    sshpass \
    sudo \
    curl \
    unzip \
    gnupg \
    git \
    && apt-add-repository --yes --update ppa:ansible/ansible \
    && apt-get install -y ansible \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 🔧 Installer Terraform (version 1.8.4 ou à adapter)
ENV TERRAFORM_VERSION=1.8.4

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "$VERSION_CODENAME") main" > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform=$TERRAFORM_VERSION && \
    terraform -install-autocomplete

# Créer un utilisateur non root
RUN useradd -ms /bin/bash ansible && echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ansible
WORKDIR /home/ansible

CMD [ "bash" ]
