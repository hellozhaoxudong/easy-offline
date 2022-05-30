#!/bin/bash
BLUE='\E[1;34m'
GREEN='\E[1;32m'
RES='\033[0m'

echo -e "${BLUE}\n离线安装 Mysql 8.0.29: ${RES}"

# 检查mariadb
checkMariadb(){
  mariadb=`rpm -qa|grep mariadb`;

  if [ -z "${mariadb}" ];
    then
      echo "未安装"
    else
      echo "系统已安装mariadb,请先卸载: ${mariadb}" 

      yum remove -y mariadb-libs
      exit
  fi
}

# 安装mysql
installMysql(){
  echo -e "${GREEN}\n开始解压mysql8.0.29离线安装包... ${RES}"
  mkdir mysql-8.0.29-rpms
  tar -xvf mysql-8.0.29-1.el7.x86_64.rpm-bundle.tar -C mysql-8.0.29-rpms
  cd mysql-8.0.29-rpms

  echo -e "${GREEN}\n开始安装: 服务器和客户端库的通用文件... ${RES}"
  yum install -y mysql-community-common-8.0.29-1.el7.x86_64.rpm
  yum install -y mysql-community-icu-data-files-8.0.29-1.el7.x86_64.rpm
  yum install -y mysql-community-client-plugins-8.0.29-1.el7.x86_64.rpm

  echo -e "${GREEN}\n开始安装: 数据库客户端应用程序的共享库... ${RES}"
  yum install -y mysql-community-libs-8.0.29-1.el7.x86_64.rpm

  echo -e "${GREEN}\n开始安装: 共享兼容性库... ${RES}"
  yum install -y mysql-community-libs-compat-8.0.29-1.el7.x86_64.rpm

  echo -e "${GREEN}\n开始安装: 客户端应用程序和工具... ${RES}"
  yum install -y mysql-community-client-8.0.29-1.el7.x86_64.rpm

  echo -e "${GREEN}\n开始安装: 数据库服务器及相关工具... ${RES}"
  yum install -y mysql-community-server-8.0.29-1.el7.x86_64.rpm

  echo -e "${GREEN}\n安装完毕! ${RES}"
  echo -e "${GREEN}-------------------------------------------------------- ${RES}"
  
  echo -e "${GREEN}\n添加配置: 忽略表名大小写(lower_case_table_names=1)、最大连接数(max_connections=2000) ${RES}"
  echo "lower_case_table_names=1" >> ./test.txt 
  echo "max_connections=2000" >> ./test.txt 

  echo -e "${GREEN}\n初始化数据库... ${RES}"
  chown -R mysql:mysql /var/lib/mysql
  mysqld --initialize --console

  echo -e "${GREEN}\n启动mysql服务... ${RES}"
  systemctl start mysqld

  echo -e "${GREEN}启动完毕! ${RES}"
  echo -e "${GREEN}-------------------------------------------------------- ${RES}"


  #grep 'temporary password' /var/log/mysqld.log
  #mysql -uroot -p'=*ftO)-GZ3By'
  #use mysql
  #ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
  #update user set host = '%' where user = 'root';
  #flush privileges;
}

checkMariadb;
installMysql;