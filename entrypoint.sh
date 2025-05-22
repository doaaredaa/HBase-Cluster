#!/bin/bash
sudo service ssh start

if [[ $HOSTNAME == Master* || $HOSTNAME == Worker* ]]; then
    if hostname | grep -q 'Master'; then
        hdfs --daemon start journalnode
        /usr/local/zookeeper/bin/zkServer.sh start

        Node_Number=$(hostname | tail -c 2)
        echo $Node_Number > /usr/local/zookeeper/data/myid
        
        if [ "$Node_Number" -eq "1" ]; then
            hdfs namenode -format 
            hdfs zkfc -formatZK
        else
            hdfs namenode -bootstrapStandby 
        fi
        
        hdfs --daemon start namenode 
        yarn --daemon start resourcemanager 
        hdfs --daemon start zkfc
    else
        hdfs --daemon start datanode 
        hdfs --daemon start nodemanager 
    fi
    
    hdfs haadmin -getAllServiceState
fi

if [[ $HOSTNAME == HBase* ]]; then
    
    case $HBASE_ROLE in
        "master")
            if [ "$HBASE_MASTER_NUM" -eq "1" ]; then
                /usr/local/hbase/bin/hbase-daemon.sh start master
            else
                /usr/local/hbase/bin/hbase-daemon.sh start master --backup
            fi
            ;;
        "regionserver")
            echo "Starting HBase RegionServer..."
            /usr/local/hbase/bin/hbase-daemon.sh start regionserver
            ;;
        *)
            echo "Unknown HBASE_ROLE: $HBASE_ROLE"
            exit 1
            ;;
    esac
fi

sleep infinity