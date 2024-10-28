#!/bin/bash


# Checking if there is argument provided and it is a directory
if [ $# -eq 0 ]; then
    echo "Error: Please provide a log directory"
    echo "Usage: $0 <log-directory>"
    exit 1
fi

log_dir=$1

if [ ! -d "$log_dir" ]; then
    echo "Error: $log_dir does not exist"
    exit 1
fi

timestamp=$(date '+%Y%m%d%H%M%S')

archive_dir="./archives"

if [ ! -d "$archive_dir" ]; then
    echo "Creating archive directory..."
    mkdir $archive_dir
fi

archive_name="logs_archive_${timestamp}.tar.gz"

echo "Preparing to archive logs from $log_dir to $archive_dir/$archive_name"

tar -czf "${archive_dir}/${archive_name}" -C "$(dirname "$log_dir")" "$(basename "$log_dir")"

if [ $? -eq 0 ]; then
    echo "Archive created successfully: ${archive_dir}/${archive_name}"    
    echo "${timestamp}: Created archive ${archive_name}" >> "${archive_dir}/archive_history.log"
else
    echo "Error: Failed to create archive"
    exit 1
fi