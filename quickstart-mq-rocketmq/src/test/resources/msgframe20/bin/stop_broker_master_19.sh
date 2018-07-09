#!/bin/sh

# �ʼ�:guozq5@asiainfo.com
# ����ʱ��:2016-12-05
# �ű�Ŀ��:ֹͣ����

pid=`ps ax | grep -i 'com.alibaba.rocketmq.broker.BrokerStartup' |grep java |grep msg_broker_master_19 | grep -v grep | awk '{print$1}'`
if [ -z "$pid" ] ; then
   echo "No mqbroker running."
   exit -1;
fi

echo "The mqbroker(${pid}) is running..."

kill ${pid}

echo "Send shutdown request to mqbroker(${pid}) OK"
