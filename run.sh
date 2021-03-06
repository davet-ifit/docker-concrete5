#!/bin/bash

# set the default DB_USER if it's not already set
if [ -z "$DB_USER" ];
then
        DBUSER=root
fi

if [ -f /.mysql_db_created ];
then
        exec supervisord -n
        exit 1
fi

sleep 5
DB_EXISTS=$(mysql -u$DB_USER -p$DB_PASSWORD -h$DB_1_PORT_3306_TCP_ADDR -P$DB_1_PORT_3306_TCP_PORT -e "SHOW DATABASES LIKE 'concrete5';" | grep "concrete5" > /dev/null; echo "$?")

if [[ DB_EXISTS -eq 1 ]];
then
        echo "=> Creating database concrete5"
        RET=1
        while [[ RET -ne 0 ]]; do
                sleep 5
                mysql -u$DB_USER -p$DB_PASSWORD -h$DB_1_PORT_3306_TCP_ADDR -P$DB_1_PORT_3306_TCP_PORT -e "CREATE DATABASE $DB_NAME"
                RET=$?
        done
        echo "=> Done!"
else
        echo "=> Skipped creation of database concrete5 – it already exists."
fi

touch /.mysql_db_created
exec supervisord -n
