#!/bin/sh

# �ʼ�:liuqq@asiainfo.com
# ����ʱ��:2015-07-30
# �ű�Ŀ��:�¼���������ͨ�û�������

# *************************************************************************
# JAVA_OPT - java����ѡ��
# JAVA_VM      - jvmѡ��
# MEM_ARGS     - �ڴ����
# *************************************************************************

echo "��ʼ��ͨ�û�������"

JAVA_HOME="/home/itframe/jdk"


echo "JAVA_HOME=${JAVA_HOME}"

APP_HOME="${HOME}/aimsg/msgframe"
#echo "APP_HOME=${APP_HOME}"

#ʹ��ROCKETMQʱ��ROCKETMQ_HOME ��������
ROCKETMQ_HOME=${APP_HOME}
export ROCKETMQ_HOME

COMMON_LIB_HOME="${APP_HOME}/lib"
export COMMON_LIB_HOME
#echo "COMMON_LIB_HOME=${COMMON_LIB_HOME}"

COMMON_CONFIG_HOME="${APP_HOME}/conf"
#echo "COMMON_CONFIG_HOME=${COMMON_CONFIG_HOME}"


#UNIX����������libĿ¼�µ�ÿһ��jar�ļ���windows�������޸�
CP=
for file in ${COMMON_LIB_HOME}/*;
do CP=${CP}:$file;
done



CLASSPATH="${COMMON_CONFIG_HOME}:${CP}"
export CLASSPATH

JAVA_OPT=" -Dfile.encoding=UTF-8  -Doracle.jdbc.V8Compatible=true -Djava.net.preferIPv4Stack=true -Dsun.net.inetaddr.ttl=10 "

MEM_ARGS="-Xms512m -Xmx512m"


#echo $CLASSPATH

#echo "*************************************************"
#echo "\n"
