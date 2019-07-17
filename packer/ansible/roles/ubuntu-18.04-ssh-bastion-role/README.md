# ansible-ubuntu-base-role

## Local development

### Pre-requirements

Runtimes:

- JDK
- Ruby
- Python

Tools:

- VirtualBox
- Vagrant
- Ansible
- test-kitchen

### test-kitchen quickstart

```bash
# Install dependencies:
vagrant plugin install vagrant-scp
gem install test-kitchen --no-document
gem install kitchen-ansible --no-document
gem install kitchen-vagrant --no-document

# Main test-kitchen commands:
kitchen converge # Bootstrap VM with role:
kitchen login # SSH to to VM
kitchen destroy # Destroy VM
```
