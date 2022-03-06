#! /bin/bash
## Automation of backups

# Time between each backup (Default is every 30 min). See cron documentation if you want to modify it.
INTERVAL="0 6 * * *"

echo "[--- Setting automatic backups ---]"
# Creating a cronjob that executes valheim's backup script every 30 minutes
crontab -l | { cat; echo "$INTERVAL /vagrant/scripts/valheim_backup.sh"; } | crontab -
