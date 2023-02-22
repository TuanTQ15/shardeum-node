#!/usr/bin/env bash

read -p "Enter the path to the file containing the private keys for the shardeum nodes (default is wallets.txt): " PRIV_KEYS_FILE
PRIV_KEYS_FILE=${PRIV_KEYS_FILE:-"wallets.txt"}

SHARDEUM_INSTANCE=$(wc -l < "$PRIV_KEYS_FILE")

SHMEXT=9001
SHMINT=10001
SERVERIP=$(curl https://ipinfo.io/ip)

while IFS= read -r line; do
  PRIV_KEY="$(echo "$line" | tr -d '[:space:]')"
  docker run -d --rm --name shardeum-node-$((SHARDEUM_INSTANCE-1)) -e SHMEXT=$((SHMEXT + SHARDEUM_INSTANCE - 1)) -e SHMINT=$((SHMINT + SHARDEUM_INSTANCE - 1)) \
  -p $((SHMEXT + SHARDEUM_INSTANCE - 1)):$((SHMEXT + SHARDEUM_INSTANCE - 1)) -p $((SHMINT + SHARDEUM_INSTANCE - 1)):$((SHMINT + SHARDEUM_INSTANCE - 1)) \
  -e APP_SEEDLIST="archiver-sphinx.shardeum.org" -e APP_MONITOR="monitor-sphinx.shardeum.org" -e APP_IP=auto \
  -e SERVERIP=$SERVERIP test-dashboard /bin/bash -c "export PRIV_KEY=$PRIV_KEY && operator-cli set rpc_ip sphinx.shardeum.org && operator-cli set rpc_port 443 && operator-cli stake 10.1" || continue
  echo "Started shardeum-node-$((SHARDEUM_INSTANCE-1)) successfully"
  SHARDEUM_INSTANCE=$((SHARDEUM_INSTANCE-1))
done < "$PRIV_KEYS_FILE"
