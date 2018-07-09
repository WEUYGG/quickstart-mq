#!/bin/sh

# �ʼ�:guozq5@asiainfo.com
# ����ʱ��:2016-10-12
# �ű�Ŀ��:msgframe broker����

# *************************************************************************
# JAVA_OPT - java����ѡ��
# JAVA_VM      - jvmѡ��
# MEM_ARGS     - �ڴ����
# *************************************************************************

VARS=$#
if [ $VARS -lt 2 ];
then
        echo "���봫��2������,��һ�������ǽ�������,�ڶ���������broker�����ļ�"
        exit 0;
fi

BASEBIN="${BASH_SOURCE-$0}"
BASEBIN="$(dirname "${BASEBIN}")"
BASE_APP_DIR="$(cd "${BASEBIN}"; pwd)"

MAIN=com.alibaba.rocketmq.broker.BrokerStartup
SERVERNAME=$1
CONFIGFILE=$2
#�жϽ����Ƿ��ظ�����
${BASE_APP_DIR}/monitor.sh ${MAIN} ${SERVERNAME} | read PROCESS_ALIVE_STATUS
if [ "$PROCESS_ALIVE_STATUS" = "PROCESS_EXIST" ];
then
        echo "�˽����Ѿ�������,�����ظ�����"
        exit 0;
fi
#�жϽ����Ƿ��ظ���������

. ${BASE_APP_DIR}/setEnv.sh

echo "CLASSPATH=${CLASSPATH}"

MEM_ARGS="-server -Xms8g -Xmx8g -Xmn4g -XX:PermSize=512m -XX:MaxPermSize=1024m"

echo "\n"
echo "MEM_ARGS=${MEM_ARGS}"

#===========================================================================================
# JVM Configuration
#===========================================================================================
JAVA_OPT="${JAVA_OPT} -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled"
JAVA_OPT="${JAVA_OPT} -verbose:gc -Xloggc:${APP_HOME}/logs/rmq_bk_gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps"
JAVA_OPT="${JAVA_OPT} -XX:-OmitStackTraceInFastThrow"
JAVA_OPT="${JAVA_OPT} -Djava.ext.dirs=${APP_HOME}/lib"
#JAVA_OPT="${JAVA_OPT} -Xdebug -Xrunjdwp:transport=dt_socket,address=9555,server=y,suspend=n"
echo "\n"
echo "JAVA_OPT=${JAVA_OPT}"
#����������
numactl --interleave=all pwd > /dev/null 2>&1
if [ $? -eq 0 ]
then
        if [ -z "$RMQ_NUMA_NODE" ] ; then
                numactl --interleave=all java ${MEM_ARGS} -Dserver.name=${SERVERNAME} ${JAVA_OPT} -cp ${CLASSPATH} ${MAIN} -c ${CONFIGFILE} > /dev/null &
        else
                numactl --cpunodebind=$RMQ_NUMA_NODE --membind=$RMQ_NUMA_NODE java ${MEM_ARGS} -Dserver.name=${SERVERNAME} ${JAVA_OPT} -cp ${CLASSPATH} ${MAIN} -c ${CONFIGFILE} > /dev/null &
        fi
else
        java ${MEM_ARGS} -Dserver.name=${SERVERNAME} ${JAVA_OPT} -cp ${CLASSPATH} ${MAIN} -c ${CONFIGFILE} > /dev/null &
fi



echo "\n"
echo "�������,��鿴��־"
