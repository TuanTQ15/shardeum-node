#!/bin/bash
mkdir backup
docker ps --format '{{.Names}}' | grep '^shardeum-node' | while read docker_name; do
  docker exec "${docker_name}" cat cli/build/secrets.json >  backup/"${docker_name}.json"
done
echo "Backup done ! check your folder backup"
ls backup/