#! /bin/bash
## Valheim server stopping script

echo "Stopping server :"
pkill -2 valheim_server
sleep 60
echo "Server stopped, run 'valheim_start' to start it"
