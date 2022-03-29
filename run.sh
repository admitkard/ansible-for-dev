export CURRENT_USER=$USER
ansible-playbook -c local -i inventory setup.yml -vvv --ask-become-pass --extra-vars "user=$CURRENT_USER"
