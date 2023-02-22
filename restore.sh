
#!/bin/bash
#!/bin/bash
cd backup
for file in $(ls shardeum-node-*.json | sed 's/\.json$//'); do
  echo "$(pwd)/$file.json"
  docker cp "$(pwd)/$file.json" "$file":/node/cli/build/secrets.json

done
echo "Done"