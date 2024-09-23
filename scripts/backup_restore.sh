
#!/bin/bash

# This script automates the process of backing up and restoring GitHub Enterprise repositories

# Variables
BACKUP_PATH="/data/backups"
RESTORE_PATH="/data/restore"
GHE_BACKUP_TOOL="/usr/local/share/ghe-backup"

# Function to perform a backup of all GHES repositories
backup_ghes() {
    echo "Starting GHES backup..."
    $GHE_BACKUP_TOOL -v -f $BACKUP_PATH
    if [ $? -eq 0 ]; then
        echo "Backup completed successfully and saved to $BACKUP_PATH."
    else
        echo "Backup failed!"
        exit 1
    fi
}

# Function to restore a specific repository from a backup snapshot
restore_repository() {
    local repository_name=$1
    echo "Restoring repository $repository_name..."
    ghe-restore -v $RESTORE_PATH/$repository_name
    if [ $? -eq 0 ]; then
        echo "Repository $repository_name restored successfully."
    else
        echo "Repository restoration failed!"
        exit 1
    fi
}

# Usage function to guide users
usage() {
    echo "Usage: $0 {backup|restore <repository_name>}"
    exit 1
}

# Main script logic
if [ "$1" == "backup" ]; then
    backup_ghes
elif [ "$1" == "restore" ] && [ -n "$2" ]; then
    restore_repository "$2"
else
    usage
fi
