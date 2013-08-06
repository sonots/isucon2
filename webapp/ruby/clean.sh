mysql -uroot < ../config/database/drop_isucon2.sql
mysql -uroot < ../config/database/isucon2.sql
mysql -uroot <  ../config/database/initial_data.sql
sudo /etc/init.d/mysqld restart
sudo /sbin/swapoff -a
sudo /sbin/swapon -a

