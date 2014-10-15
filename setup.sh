sudo apt-get -y install apache2 git python python-pip libffi-dev
sudo pip install pip install jenkins-job-builder python-novaclient python-glanceclient python-keystoneclient python-neutronclient python-cinderclient python-heatclient 

dpkg -s vagrant || (curl -L -o /tmp/vagrant.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb && sudo dpkg -i /tmp/vagrant.deb)
#vagrant plugin install vagrant-openstack

dpkg -s chef || ( curl -L https://www.opscode.com/chef/install.sh | sudo bash)
rm -rf /tmp/cookbooks
(git init /tmp/cookbooks && touch /tmp/cookbooks/README && cd /tmp/cookbooks && git add . && git commit -a -m "inital")


# setup jenkins
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins

mkdir /etc/jenkins_jobs
cat << EOF > /etc/jenkins_jobs/jenkins_jobs.ini
[job_builder]
ignore_cache=True
keep_descriptions=False
include_path=.:scripts:~/git/

[jenkins]
user=slowstack
password=pVu1VA1OvxsC
url=https://localhost
EOF


echo 'JENKINS_ARGS="--httpListenAddress=127.0.0.1 --httpPort=8081"' | sudo tee -a /etc/default/jenkins
sudo /etc/init.d/jenkins restart

#setup graphite
knife cookbook site install graphite -c ~/slowstack/config/solo.rb
sudo chef-solo -c ~/slowstack/config/solo.rb -o graphite::web,graphite::carbon

# setup grafana
curl -L -o /tmp/grafana.tar.gz http://grafanarel.s3.amazonaws.com/grafana-1.8.1.tar.gz
mkdir /opt/grafana ; tar zxvf /tmp/grafana.tar.gz -C /opt/grafana

# setup / restart apache
sudo cp config/apache-jenkins.conf /etc/apache2/sites-available/

sudo a2dissite 000-default
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2ensite apache2-jenkins

sudo service apache2 restart
