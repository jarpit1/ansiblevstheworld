Location for Saltstack code.

For the purposes of this, salt will be run with SSH, instead of the traditional minion master.

Setup:
 1. install salt-ssh (yum install salt-ssh)
 2. Create the roster file in /etc/salt
 3. in the roster file, insert:
    web1:
      host: 172.16.0.5
      user: root
      passwd: vagrant
 4. Test that it's working properly by running:
    sudo salt-ssh -i 'web1' test.ping
 5. To ensure salt knows where to look for your states, open /etc/salt/master and insert:
    files_roots:
      base:
        - /path/to/checked/out/repo/Saltstack/states

Running salt:
 1. Run 'vagrant up' to build the machine
 2. Run 'sudo salt-ssh 'web1' state.apply webserver' to configure the web server.
 3. In your browser, go to 172.16.0.5 to view the contents of the index.html file.
