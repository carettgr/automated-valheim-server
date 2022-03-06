#! /bin/bash
## Valheim server backup script

# Valheim worlds directory
WORLD_DIR=/root/.config/unity3d/IronGate/Valheim/worlds/
# Backup directory
BACKUP_DIR=/vagrant/data/valheim-backups/

# Date and maximum amount of backups -1 (Default is 10, so 9)
DATE=$(date -d '+1 hour' '+%d-%m-%y-%H-%M')
MAX_BACKUPS_AMOUNT=10

echo "[--- Backuping server ---]"

echo "[1] - Creating backup directory if not existing"
if ! [ -d "$BACKUP_DIR" ]; then
    mkdir $BACKUP_DIR
fi

# echo "[2] - Restarting server to apply world save"
sh /vagrant/scripts/valheim_stop.sh
sh /vagrant/scripts/valheim_start.sh

echo "[3] - Creating the backup file"
tar -cvzf $BACKUP_DIR/world-backups-$DATE.tgz -C $WORLD_DIR/.. worlds/

echo "[4] - Removing old backup files"
# Remove world save files greater than the retention value
ls -dt $BACKUP_DIR/* | tail -n +$MAX_BACKUPS_AMOUNT | xargs rm -rf