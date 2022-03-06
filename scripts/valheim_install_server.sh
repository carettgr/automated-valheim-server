#! /bin/bash
## Valheim server installation

#Set this to true if you want to import a world ; default is false
IMPORT=false

echo "[0] - Pre-configuration"
# Forcing IPv4
echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4

# Setting up default gateway
route del default gw 10.0.2.2
route add default gw 192.168.0.1

# Creating directories for installation
mkdir /home/steam
mkdir /home/steam/valheim-server
cd /home/steam


echo "[1] - Steamcmd installation"
# Downloading packages
add-apt-repository multiverse
dpkg --add-architecture i386
apt-get update
apt install -y lib32gcc1 lib32stdc++6 libc6-i386 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386
apt install -y libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-net-2.0-0 libsdl2-ttf-2.0-0

# Downloading steamcmd
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz

# Removing compressed steamcmd
rm steamcmd_linux.tar.gz


echo "[2] - Downloading Valheim Dedicated Server steam app"
# Steamcmd command as anonymous user
./steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /home/steam/valheim-server +login anonymous +app_update 896660 validate +quit


echo "[3] - Server's starting script creation"
# Line to edit for your server name, world, password and visibility
printf '#! /bin/bash\nexport templdpath=$LD_LIBRARY_PATH\nexport LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH\nexport SteamAppID=892970\n/home/steam/valheim-server/valheim_server.x86_64 -name "My server" -port 2456 -world "Dedicated" -password "password" -public 1 &\nexport LD_LIBRARY_PATH=$templdpath' > /home/steam/valheim-server/valheim.sh
# Execution right attribution
chmod +x /home/steam/valheim-server/valheim.sh


echo "[4] - Finishing server configuration"
# Starting and stopping and restarting server to complete configuration (e.g. world generation)
sh /vagrant/scripts/valheim_start.sh
sh /vagrant/scripts/valheim_stop.sh

# Importing world if IMPORT is set to true
if [ $IMPORT = true ]; then
    sh /vagrant/scripts/valheim_world_import.sh
elif [ $IMPORT = false ]; then
    echo "IMPORT is set to false, starting the server"
else 
    echo "Wrong value for IMPORT, please set to true or false."
fi

