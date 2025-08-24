#!/bin/zsh

KAFKA_CLUSTER_ID="$(/Users/tymalik/kafka/bin/kafka-storage.sh random-uuid)"
/Users/tymalik/kafka/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /Users/tymalik/kafka/config/kraft/server.properties
