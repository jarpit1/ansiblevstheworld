Building Master/Agent
1. cd into Master/Agent
2. To build the VM:
   vagrant up
--------------------------------------------------------------------------------
1. Install puppet on Master
   sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
   sudo yum -y install puppetserver
2. Configure memory
   sudo vi /etc/sysconfig/puppetserver
   change JAVA_ARGS to: "-Xms500m -Xmx500m"
3. Start Puppet server
   sudo systemctl start puppetserver
   sudo systemctl enable puppetserver
--------------------------------------------------------------------------------
1. Install Puppet on Agent
   sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
   sudo yum -y install puppet-agent
2. Start the Agent
   sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
3. vi /etc/hosts
   insert: 172.16.0.5 puppet
--------------------------------------------------------------------------------
Cert setup:
The certs need to be cleared and the request must be re-sent with the new server set.
1. On Master:
   /opt/puppetlabs/bin/puppet cert clean localhost.localdomain
2. On agent:
   find /etc/puppetlabs/puppet/ssl -name localhost.localdomain.pem -delete
3. On agent:
   /opt/puppetlabs/bin/puppet agent --test
4. On Master:
   /opt/puppetlabs/bin/puppet cert sign --all
   systemctl restart puppetserver
5. Confirm connection to Master from agent by running:
   /opt/puppetlabs/bin/puppet agent --test
--------------------------------------------------------------------------------
Setup Puppet manifest on Master:
1. On Master:
   yum install rsync
   /opt/puppetlabs/bin/puppet module install puppetlabs-apache
On your computer:
2. copy manifests/site.pp to /etc/puppetlabs/code/environments/production/manifests/ on the Master
   rsync -v -e ssh manifests/site.pp root@172.16.0.5:/etc/puppetlabs/code/environments/production/manifests/
3. copy files/index.html to /etc/puppetlabs/code/environments/production/modules/apache/files on the Master
   rsync -v -e ssh files/index.html root@172.16.0.5:/etc/puppetlabs/code/environments/production/modules/apache/files
--------------------------------------------------------------------------------
(Finally) Setup the web server:
1. On the agent:
   /opt/puppetlabs/bin/puppet agent --test
2. Navigate to 172.16.0.5 in your browser to access your new web server
