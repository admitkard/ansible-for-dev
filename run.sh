ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix
ansible-playbook -c local -i inventory setup.yml -vvv --ask-become-pass
