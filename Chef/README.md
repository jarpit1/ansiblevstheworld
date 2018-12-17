Build Node and Server:
1. cd into Node/Server
2. to build the VM:
   vagrant up

Server setup:
1. Install Chef server
   wget https://packages.chef.io/files/stable/chef-server/12.18.14/el/7/chef-server-core-12.18.14-1.el7.x86_64.rpm
   rpm -ivh chef-server-core-*.rpm                                                                                                                       
2. Reconfigure the Chef server
   chef-server-ctl reconfigure
3. Check the status
   chef-server-ctl status
4. Setup user for Chef
   chef-server-ctl user-create admin admin admin email@email.address password -f /etc/chef/admin.pem
5. Create organization to hold configurations
   chef-server-ctl org-create co-op "Co-op, Inc" --association_user admin -f /etc/chef/co-op-validator.pem

Workstation setup (your computer)(Ubuntu):
1. cd ~
2. wget https://packages.chef.io/files/stable/chefdk/3.5.13/debian/9/chefdk_3.5.13-1_amd64.deb
3. sudo dpkg -i chefdk_3.5.13-1_amd64.deb
4. Verify install
   chef verify

Workstation setup (your computer)(CentOS):
1. cd ~
2. wget https://packages.chef.io/files/stable/chef-workstation/0.2.41/el/7/chef-workstation-0.2.41-1.el6.x86_64.rpm
3. rpm -ivh chefdk-*.rpm
4. Verify install
   chef verify

RSA Key stuff:
1. copy the generated RSA keys from the server to the .chef directory
   scp -pr root@172.16.0.4:/etc/chef/admin.pem .chef/
   scp -pr root@172.16.0.4:/etc/chef/co-op-validator.pem .chef/
2. Now to do a questionable workaround to get the certs to work. Open /etc/hosts and change the localhost entry to 172.16.0.4
   This is because the vagrant box creates its cert with the localhost name so if you try to connect to just 172.16.0.4, the
   name doesn't match the cert and will fail.
   *************REMEMBER TO CHANGE THIS BACK AFTER******************************
3. Test connectivity to the server
   knife client list
4. If the previous step fails, fetch the SSL cert from the Chef server
   knife ssl fetch
5. Run knife client list again and it should work.

Node setup:
1. Questionable workaround part 2: change the localhost entry on the node as well (you don't need to remember to change this back, just destroy the VM)
2. bootstrapping the Chef node:
   knife bootstrap 172.16.0.3 -x root -P vagrant --sudo
3. Check the current Chef node list. It should be localhost (localhost = node in this case)
   knife node list

--------------------------------------------------------------------------------
Actually using Chef to configure the node:
1. Upload the httpd cookbook to the Chef server:
   sudo knife cookbook upload httpd
2. Confirm the cookbook was uploaded properly:
   knife cookbook list
   Output:
   httpd 0.1.0
3. Add the cookbook to the run_list of the node:
   knife node run_list add localhost httpd (localhost = node in this case)
4. On the node itself, run chef-client to retrieve the new run_list with the new httpd cookbook.
5. Navigate to 172.16.0.3 to access your new Chef provisioned web server :)

********************************IMPORTANT***************************************
On your own machine, make sure to change the localhost entry in /etc/hosts back to normal
