ansible-galaxy collection install community.general.dconf
ansible-playbook -c local -i inventory setup.yml -vvv --ask-become-pass
