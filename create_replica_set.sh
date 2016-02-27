#!/usr/bin/env bash


echo "killing mongod"
killall mongod

echo "removing data files"
rm -rf /data/rs1
rm -rf /data/rs2
rm -rf /data/rs3

mkdir -p /data/rs1 /data/rs2 /data/rs3

mongod --replSet m101 --logpath "1.log" --dbpath /data/rs1 --port 27017 --oplogSize 64 --smallfiles --fork
mongod --replSet m101 --logpath "2.log" --dbpath /data/rs2 --port 27018 --oplogSize 64 --smallfiles --fork
mongod --replSet m101 --logpath "3.log" --dbpath /data/rs3 --port 27019 --oplogSize 64 --smallfiles --fork

sleep 5
# Configura Replica Set
echo "Configuring s0 replica set"
mongo --port 27017 << 'EOF'
config = { _id: "m101", members:[
          { _id : 0, host : "127.0.0.1:27017"},
          { _id : 1, host : "127.0.0.1:27018"},
          { _id : 2, host : "127.0.0.1:27019"} ]
};
rs.initiate(config);
EOF
