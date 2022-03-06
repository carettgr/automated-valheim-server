#! /bin/bash
## Valheim server starting script

echo "Starting server :"
cd /home/steam/valheim-server
./valheim.sh
sleep 60
echo "Server started, run 'valheim_stop.sh' to stop it"
