source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
 echo "variable roboshop_rabbitmq_password_missing"
 exit 1
fi

print_head "config erlang yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "installing rlang"
yum install erlang -y &>>${LOG}
status_check

print_head "config rabit mq repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "install rabitmq"
yum install rabbitmq-server -y &>>${LOG}
status_check

print_head "enable Rabbitmq server"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "start server"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "setting up username and password"
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
fi

status_check

print_head "setting up user tagss"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check

print_head " setting up permission"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check