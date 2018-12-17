Building Master/Agent
1. cd into Master/Agent
2. To build the VM:
```shell
   vagrant up
```
--------------------------------------------------------------------------------
1. Install puppet on Master
```shell
   sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
   sudo yum -y install puppetserver
```
2. Configure memory
```shell
   sudo vi /etc/sysconfig/puppetserver
   change JAVA_ARGS to: "-Xms500m -Xmx500m"
```
3. Start Puppet server
```shell
   sudo systemctl start puppetserver
   sudo systemctl enable puppetserver
```
--------------------------------------------------------------------------------
1. Install Puppet on Agent
```shell
   sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
   sudo yum -y install puppet-agent
```
2. Start the Agent
```shell
   sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
```
3.
```shell
  vi /etc/hosts
   insert: 172.16.0.5 puppet
```
--------------------------------------------------------------------------------
Cert setup:
The certs need to be cleared and the request must be re-sent with the new server set.
1. On Master:
```shell
   /opt/puppetlabs/bin/puppet cert clean localhost.localdomain
```
2. On agent:
```shell
   find /etc/puppetlabs/puppet/ssl -name localhost.localdomain.pem -delete
```
3. On agent:
```shell
   /opt/puppetlabs/bin/puppet agent --test
```
4. On Master:
```shell
   /opt/puppetlabs/bin/puppet cert sign --all
   systemctl restart puppetserver
```
5. Confirm connection to Master from agent by running:
```shell
   /opt/puppetlabs/bin/puppet agent --test
```
--------------------------------------------------------------------------------
Setup Puppet manifest on Master:
1. On Master:
```shell
   yum install rsync
   /opt/puppetlabs/bin/puppet module install puppetlabs-apache
```
On your computer:
2.
```shell
   copy manifests/site.pp to /etc/puppetlabs/code/environments/production/manifests/ on the Master
   rsync -v -e ssh manifests/site.pp root@172.16.0.5:/etc/puppetlabs/code/environments/production/manifests/
```
3.
```shell
   copy files/index.html to /etc/puppetlabs/code/environments/production/modules/apache/files on the Master
   rsync -v -e ssh files/index.html root@172.16.0.5:/etc/puppetlabs/code/environments/production/modules/apache/files
```
--------------------------------------------------------------------------------
(Finally) Setup the web server:
1. On the agent:
```shell
   /opt/puppetlabs/bin/puppet agent --test
```
2. Navigate to 172.16.0.5 in your browser to access your new web server
