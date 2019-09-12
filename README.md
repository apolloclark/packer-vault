# packer-vault

Packer based project for provisioning a "HashiCorp Vault" image using Ansible, 
and Serverspc, for Docker, AWS, or Virtualbox.

## Requirements

To use this project, you must have installed:
- [Packer](https://www.packer.io/downloads.html)
- [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)
- [Serverspec](http://serverspec.org/)

(Optional)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

## Deploy to AWS, with Packer
```shell
git clone --recurse-submodules https://github.com/apolloclark/packer-vault
cd ./packer-vault/base

# update submodules
git submodule update --recursive --remote
```



## Deploy to Docker
```shell
# build both the Ubuntu 16.04 and Centos 7.6 images
./build_packer_docker_all.sh



# clean up ALL previous builds
./clean_packer_docker.sh

# Gradle, clean up previous builds, from today
gradle clean --parallel --project-dir gradle-build

# Gradle, build only specific OS images
gradle ubuntu18.04:test --project-dir gradle-build --rerun-tasks
gradle ubuntu16.04:test --project-dir gradle-build --rerun-tasks
gradle debian10:test    --project-dir gradle-build --rerun-tasks
gradle debian9:test     --project-dir gradle-build --rerun-tasks

gradle rhel8:test     --project-dir gradle-build --rerun-tasks
gradle rhel7:test     --project-dir gradle-build --rerun-tasks
gradle centos7:test   --project-dir gradle-build --rerun-tasks
gradle amzlinux2:test   --project-dir gradle-build --rerun-tasks

gradle test --parallel --max-workers 4 --project-dir gradle-build

gradle test --parallel --max-workers 4 --project-dir gradle-build --rerun-tasks

# Gradle, publish images
gradle push --parallel --max-workers 4 --project-dir gradle-build

# Gradle, list tasks, and dependency graph
gradle tasks --project-dir gradle-build
gradle tasks --all --project-dir gradle-build
gradle test taskTree --project-dir gradle-build

# Gradle, debug
gradle properties
gradle ubuntu16.04:info --project-dir gradle-build
gradle ubuntu16.04:test --project-dir gradle-build --info --rerun-tasks
rm -rf ~/.gradle
```



## Deploy to Virtualbox, with Vagrant
```shell
vagrant up
vagrant ssh
```



## Deploy to AWS, with Packer
```shell
# create a keypair named "packer" or change lines 26, 27 in build_packer_aws.sh
./build_packer_aws.sh

cd ./packer-vault/config

./build_packer_aws.sh
```



## Ansible

Ansible Roles:
- [apolloclark.vault](https://github.com/apolloclark/ansible-role-vault)
<br/><br/><br/>



## Log Files

*vault*
```
service vault status
/usr/share/vault/bin/vault --version
nano /etc/vault/vault.yml
nano /var/log/vault/vault.log
```