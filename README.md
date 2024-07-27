# My x86 K8s Installer

## Prerequisites

- Setup SSH to the target machine.
  - Ansible reuqired SSH connection to control target machine.
- `pyenv` and `poetry` is installed
  - Ansible reuqired Python to run, this project using pyenv and poetry to isolated the Python runtime.

```shell
pyenv install 3.11.9
poetry install
```

## Ansible

Entry the Poetry shell to using ansible.

```shell
poetry shell
ansible --version
```

