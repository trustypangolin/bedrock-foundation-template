#!/bin/bash
yum update -y && yum upgrade -y
timedatectl set-timezone Australia/Brisbane
localectl set-locale LANG=en_AU.utf8

fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.conf

iptables -A INPUT -p tcp --dport http -j ACCEPT
iptables -A INPUT -p tcp --dport https -j ACCEPT
iptables -A INPUT -p udp --dport openvpn -j ACCEPT
service iptables save

#Install mongodb and pritunl
tee /etc/yum.repos.d/mongodb-org-4.2.repo << EOF
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
EOF

tee /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=https://repo.pritunl.com/stable/yum/amazonlinux/2/
gpgcheck=1
enabled=1
EOF

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
yum -y install pritunl mongodb-org amazon-cloudwatch-agent
systemctl start mongod pritunl
#Configure Service Restart always
sed -i '/\[Service\]/ a Restart=always\nRestartSec=5s\nStartLimitInterval=500\nStartLimitBurst=5' /usr/lib/systemd/system/mongod.service
sed -i '/\[Service\]/ a Restart=always\nRestartSec=5s\nStartLimitInterval=500\nStartLimitBurst=5' /etc/systemd/system/pritunl.service
systemctl daemon-reload
#Increase Open File Limit - prevent connection issues on servers with high load
echo "* hard nofile 64000" >> /etc/security/limits.conf
echo "* soft nofile 64000" >> /etc/security/limits.conf
echo "root hard nofile 64000" >> /etc/security/limits.conf
echo "root soft nofile 64000" >> /etc/security/limits.conf
#Configure Service start on reboot/restart
systemctl enable mongod
systemctl start mongod 

aws s3 cp s3://${unique_prefix}-pritunl-backups/backup.sh  /root/backup.sh
aws s3 cp s3://${unique_prefix}-pritunl-backups/restore.sh /root/restore.sh

tee /root/backup.sh <<EOF
#!/bin/bash
aws s3 cp ~/backup.sh  s3://${unique_prefix}-pritunl-backups/backup.sh
aws s3 cp ~/restore.sh s3://${unique_prefix}-pritunl-backups/restore.sh
#Create tmp work directory
mkdir /pritunl-backup
cd /pritunl-backup
#The following command will create a dump directory for mongo backup
mongodump
#Upload backup to S3
aws s3 cp --recursive /pritunl-backup/dump s3://${unique_prefix}-pritunl-backups/pritunl/dump/
aws s3 cp /var/lib/pritunl/pritunl.uuid    s3://${unique_prefix}-pritunl-backups/pritunl-$(curl -s http://169.254.169.254/latest/meta-data/placement/region).uuid
#Clean up
rm -rf /pritunl-backup
EOF

tee /root/restore.sh <<EOF
#!/bin/bash
aws s3 cp s3://${unique_prefix}-pritunl-backups/backup.sh  backup.sh
aws s3 cp s3://${unique_prefix}-pritunl-backups/restore.sh restore.sh
chmod a+x backup.sh
chmod a+x restore.sh
systemctl stop pritunl
mkdir /pritunl-restore
cd /pritunl-restore
aws s3 cp /var/lib/pritunl/pritunl.uuid    s3://${unique_prefix}-pritunl-backups/pritunl-$(curl -s http://169.254.169.254/latest/meta-data/placement/region).uuid
aws s3 cp --recursive s3://${unique_prefix}-pritunl-backups/pritunl/dump/ /pritunl-restore/dump/.
mongorestore --drop --nsInclude "*" /pritunl-restore/dump/
systemctl start pritunl
systemctl enable pritunl
#Clean up
rm -rf /pritunl-restore
EOF

chmod a+x /root/*.sh

tee /var/spool/cron/root <<EOF
5 9 * * * /root/backup.sh
EOF

chmod 600 /var/spool/cron/root
curl https://inspector-agent.amazonaws.com/linux/latest/install --output /tmp/inspector_install
chmod 700 /tmp/inspector_install
/tmp/inspector_install

systemctl enable pritunl
systemctl start pritunl