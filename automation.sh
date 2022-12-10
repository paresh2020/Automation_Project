#!/bin/bash
USER_NAME=`uname`
TIMESTAMP=`(date '+%d%m%Y-%H%M%S')`
S3_BUCKET=upgrad-paresh
update_package()
{
	sudo apt update -y
}
install_apache2()
{
	sudo apt-get install apache2
}
archive_apache2_log()
{
	tar -cvf /tmp/${USER_NAME}-httpd-logs-${TIMESTAMP}.tar.gz /var/log/apache2
}
copy_log_s3()
{
	echo "hi"
	aws s3 \
	cp /tmp/${USER_NAME}-httpd-logs-${TIMESTAMP}.tar \
	s3://${S3_BUCKET}/${USER_NAME}-httpd-logs-${TIMESTAMP}.tar
}
#calling update package funtion
update_package
#checking if apache is running or not
dpkg -s apache2 &> /dev/null  
if [ $? != 0 ]
then
	{
		echo "Installing Apache2"
		install_apache2
	}
else
	{
		echo "apache alreadt insalled"
	}
fi
#calling archive funtion to copy logs to temp folder
archive_apache2_log
#copying archive log to s3 bocket 
copy_log_s3