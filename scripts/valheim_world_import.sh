#! /bin/bash
## Valheim world import

# Valheim server's worlds directory
WORLD_DIR=/root/.config/unity3d/IronGate/Valheim/worlds/
# World name i.e name of the file to import
WORLD_NAME="Dedicated"
# Format of the file to import : "1" for a tgz, "2" for a zip, "3" for a folder.
FORMAT=2

if [ $FORMAT -eq 1 ]; then
        FORMAT_EXTENSION=.tgz
    elif [ $FORMAT -eq 2 ]; then
        FORMAT_EXTENSION=.zip
    elif [ $FORMAT -eq 3 ]; then
        FORMAT_EXTENSION=/
else
    echo "Not a valid world format"
fi

# World file
WORLD_TO_IMPORT=/vagrant/data/worlds/$WORLD_NAME$FORMAT_EXTENSION


echo " --- Importing $WORLD_NAME$FORMAT_EXTENSION ---"

echo "[1] - Removing old files if existing"
# Checking if the world already exists and deleting old files if it does
cd $WORLD_DIR
if [ -f "$WORLD_NAME.db" ]; then
    rm $WORLD_NAME.db
    echo "Removed $WORLD_NAME.db"
fi
if [ -f "$WORLD_NAME.db.old" ]; then
    rm $WORLD_NAME.db.old
    echo "Removed $WORLD_NAME.db.old"
fi
if [ -f "$WORLD_NAME.fwl" ]; then
    rm $WORLD_NAME.fwl
    echo "Removed $WORLD_NAME.fwl"
fi
if [ -f "$WORLD_NAME.fwl.old" ]; then
    rm $WORLD_NAME.fwl.old
    echo "Removed $WORLD_NAME.fwl.old"
fi


echo "[2] - Importing files in valheim server's worlds directory"
# Extracting the world.tgz in valheim server's worlds directory
cd $WORLD_DIR
if [ $FORMAT -eq 1 ]; then
        tar xvzf $WORLD_TO_IMPORT
        echo "Files succesfully imported, continuing"
    elif [ $FORMAT -eq 2 ]; then
        apt install unzip
        unzip -q $WORLD_TO_IMPORT
        echo "Files succesfully imported, continuing"
    elif [ $FORMAT -eq 3 ]; then
        cp -R $WORLD_TO_IMPORT* ./
        echo "Files succesfully imported, continuing"
else
    echo "Not a valid world format, continuing"
fi
