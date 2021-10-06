#!/bin/bash
user=$(whoami)
message_time=$(date)
table="Messages"
database="dd2144"
SQL_EXISTS=$(printf 'SHOW TABLES LIKE "%s"' "$table")

if [ "$1" = "all" ] && [ "$2" != "-h" ]; then
    wall "${@:2}"
        if [[ $(mysql --defaults-extra-file=permissions -e "$SQL_EXISTS" $database) ]]; then
            mysql --defaults-extra-file=permissions -e "USE dd2144; INSERT INTO Messages (sent_to,time_sent,message_content) VALUES ('$1','$message_time','${*:2}')"
        else
            mysql --defaults-extra-file=permissions -e "USE dd2144; CREATE TABLE Messages (id int NOT NULL PRIMARY KEY, sent_to VARCHAR(20), time_sent VARCHAR(40), message_content TEXT)"
            mysql --defaults-extra-file=permissions -e "USE dd2144; INSERT INTO Messages (sent_to,time_sent,message_content) VALUES ('$1','$message_time','${*:2}')"
        fi
elif [ "$2" != "-h" ] $$ [ -n "$2"]; then
    echo "${@:2}" | write "$1"
    if who | grep -q "^$1"; then
        if [[ $(mysql --defaults-extra-file=permissions -e "$SQL_EXISTS" $database) ]]; then
            mysql --defaults-extra-file=permissions -e "USE dd2144; INSERT INTO Messages (sent_to,time_sent,message_content) VALUES ('$1','$message_time','${*:2}')"
        else
            mysql --defaults-extra-file=permissions -e "USE dd2144; CREATE TABLE Messages (id int NOT NULL PRIMARY KEY, sent_to VARCHAR(20), time_sent VARCHAR(40), message_content TEXT)"
            mysql --defaults-extra-file=permissions -e "USE dd2144; INSERT INTO Messages (sent_to,time_sent,message_content) VALUES ('$1','$message_time','${*:2}')"
        fi
    fi
fi

if [ "$2" = "-h" ]; then
    echo $(mysql --defaults-extra-file=permissions -e "USE dd2144; SELECT * FROM Messages WHERE sent_to='$1'")
fi

if [ "$1" = "-h" ];then
    mysql --defaults-extra-file=permissions -e "USE dd2144; SELECT * FROM Messages"
fi