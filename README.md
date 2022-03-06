# Automated Valheim dedicated server :

This project is about building a virtual machine which will run a Valheim dedicated server in a fully automated way.

## Requirements
### Machine specifications :

Minimum : 
- CPU -> Quad-Core (4 cores) 
- CPU Frequency -> 2.8 GHz 
- RAM -> 2 GB
- Storage -> 2 GB

Recommended :
- CPU -> Hexa-Core (6 cores) 
- CPU Frequency -> 3.4 GHz 
- RAM -> 4 GB+
- Storage -> 4 GB+

Edit the Vagrantfile to change these values. Virtualization needs to be enabled on host machine.

### Network configuration :

The server won't work without internet connection. 

Ports 2456 to 2458 need to be open on your modem (both TCP/UDP). 

See <https://portforward.com/> for more details on port forwarding.

### Applications :

- Oracle Virtualbox -> <https://www.virtualbox.org/wiki/Downloads>
- Oracle VM VirtualBox Extension Pack, chose the same version as Virtualbox
- HashiCorp Vagrant -> <https://www.vagrantup.com/>


### Necessary files :

The zip file of the project, which can be found [here](https://github.com/carettgr/automated-valheim-server.git).

This project contains the following :
- `./README` : this files gives explanations on the project.
- `./Vagrantfile`: the file which declares, describes and configures the virtual machine specifications.
- `./data`: the directory where backups and worlds saves are stored.
- `./scripts`: the directory which contains the scripts used to install/start/stop/backup the server.
- `./files`: *yet to come*
- `./logs`: *yet to come*

## Description

The Valheim dedicated server will be installed on one virtual machine, based on the **ubuntu/xenial64** box.

Its default local IP is 192.168.0.50 but it can be modified as explained below.

In order to connect to your server, open valheim and go to the server list. 
You can either search for your server's name (if the -public option is set to 1, see **Server configuration** below) or join by IP : use the format `X.X.X.X:2456` where X.X.X.X is your public IP.

You can get your public IP by typing *[what is my ip](https://www.google.com/search?q=what+is+my+ip)* in google's search bar.

## Installation

Before running your server, make you sure you have configured the project and adapted your environnement according to your needs (see details in the **Usage** section.)

1. Create a directory for your server.
2. Open a cmd. 
3. Run the command `cd *path/to/folder*` where *path/to/folder* is the path to the directory previously created.
4. Clone the files of this project into this directory (download manually and copy/paste them or use `git clone https://github.com/carettgr/automated-valheim-server.git`).
5. Run the command `vagrant up`. Your server will be up and ready in a couple of minutes.

If you failed the configuration part before installing, make sure to do it well and then rebuild the virtual machine to apply changes :

1. Open a cmd.
2. Go to the directory where you extracted the project.
3. Run the command `vagrant destroy -f`.
4. Run the command `vagrant up`.

## Usage
### Port forwarding :

The *Vagrantfile* can be modified to change local guest IP and MAC address. Both are used in port forwarding.
Simply change the line :
```bash
	config.vm.network "public_network", ip: "192.168.0.50", mac: "080027353062", use_dhcp_assigned_default_route: true
```
Default values are 192.168.0.50 for the local guest IP and 08:00:27:35:30:62 for the MAC address.
Caution, the default gateway might need to be modified too, if so : 
1. Open the file *./scripts/valheim_install_server.sh*.
2. Go to the "# Setting up default gateway" section and adapt the two lines within it.

### Server configuration :

Open *./scripts/valheim_install_server.sh* and search for the line :

```bash
printf '#! /bin/bash\nexport templdpath=$LD_LIBRARY_PATH\nexport LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH\nexport SteamAppID=892970\n/home/steam/valheim-server/valheim_server.x86_64 -name "My server" -port 2456 -world "Dedicated" -password "password" -public 1 &\nexport LD_LIBRARY_PATH=$templdpath' > /home/steam/valheim-server/valheim.sh

```
Put the desired parameters between quotes after the following options :
- `-name` : the name of the server which will appear on Valheim lists.
- `-world` : the name of the world that you imported or chose.
- `-password` : the password that will be required in order to connect to your server (at least 5 characters).
- `-public` : the visibility level of your server (1 for a public server, 0 for a private one)

### Backups

There is an automated backup of your worlds which occurs every day at 6:00. It stores your world as an archive file (.tgz) in the ./data/valheim-backups directory. 
This archive file contains a directory named *worlds*, extract its content to get your world saves and chose the files related to the world you want to import. Then make an archive of these files, which you will be able to import as explained below.
The maximum amount of backups is 10 by default.

You can change these values by following these steps :
1. Edit the variable `MAX_BACKUPS_AMOUNT` in  *./scripts/valheim_backup.sh*.
2. Edit the variable `INTERVAL` in  *./scripts/valheim_backup_automation.sh* after having understood the [cron syntax](https://crontab.guru/).

Then rebuild the virtual machine to apply changes :

3. Open a cmd.
4. Go to the directory where you extracted the project.
5. Run the command `vagrant destroy -f`.
6. Run the command `vagrant up`.

### Imports

N.B. : The server must have been started at  least once before importing a world.
In order to import an existing Valheim world to your server, follow these steps :

1. Open *./scripts/valheim_install_server.sh* and search for the variable:
`IMPORT`, then set this variable to *true*. Save and quit.
2. Open *./scripts/valheim_world_import.sh* and edit the following variables :
- `WORLD_NAME` : which is the name of the world you want to import
- `FORMAT` : which is the format of the file to import. 3 formats are accepted : "1" for a tgz, "2" for a zip, "3" for a folder. 

Then save and quit.

3. Put the file you want to import in the folder *./data/worlds*

Then rebuild the virtual machine to apply changes :

4. Open a cmd.
5. Go to the directory where you extracted the project.
6. Run the command `vagrant destroy -f`.
7. Run the command `vagrant up`.

### Starting or stopping the server

If you need to start/stop your machine :
1. Open a cmd
2. Go to the directory where you extracted the project (c.f. 3rd step of the **Installation section**).
3. Run the command `vagrant ssh srv-val` to connect to your virtual machine via ssh.
4. Run the command `sudo sh /vagrant/scripts/valheim_start.sh` to start the server **OR** `sudo sh /vagrant/scripts/valheim_stop.sh` to stop it.

## Project status
> Still in developpment.

## References and documentation

- Steamdcmd installation -> <https://developer.valvesoftware.com/wiki/SteamCMD>
- Valheim dedicated installation guide -> <https://valheim.fandom.com/wiki/Valheim_Dedicated_Server>
- Backup solution inspiration -> <https://github.com/Wdrussell1/Valheim-Backup-Script>
- Finding your public IP -> <https://www.google.com/search?q=what+is+my+ip>
- Port forwarding guide -> <https://portforward.com/>
