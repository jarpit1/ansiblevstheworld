Building Ansible host:
1. In this directory, run:
   vagrant up

Setting up Ansible:
1. Install Ansible
2. To provision the webserver, run:
   ansible-playbook -i hosts.yml webserver.yml -u root -k
   This will prompt you for the SSH password of the host, which is vagrant
3. Once it's done running, go to 172.16.0.2 in your browser to access your new web server.
