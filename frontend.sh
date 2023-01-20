#!/bin/bash
#author:kiran
#description:shell script for automation

source common.sh

print_head "install nginx"
yum install nginx -y &>>${LOG}
status_check

systemctl enable nginx &>>${LOG}
systemctl start nginx &>>${LOG}

print_head "remove old content"

rm -rf /usr/share/nginx/html/* &>>${LOG}

status_check

print_head "Download Frontend content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
cd /usr/share/nginx/html &>>${LOG}

status_check

print_head "unziping frontend contenet in html"
unzip /tmp/frontend.zip &>>${LOG}

status_check

print_head "copying roboshop nginxfile"
cp ${script_location}/files/nginxroboshop.conf /etc/nginx/default.d/roboshop.conf
status_check

systemctl restart  nginx &>>${LOG}