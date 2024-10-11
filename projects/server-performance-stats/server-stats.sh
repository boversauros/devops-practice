#!/bin/bash


print_empty_lines() {
    for ((i=0; i<$1; i++)); do
        echo
    done
}

print_header () {
    echo '-------------------------'
    echo "$1"
    echo '-------------------------'
}

print_header 'CPU usage'

top -l 1 -n 0 | grep 'CPU usage' | awk '{for(i=3;i<=NF;i++) printf "%s ", $i;}'

print_empty_lines 2

print_header 'Memory Usage'
page_size=$(pagesize)
vm_stat_output=$(vm_stat)

total_mem=$(sysctl -n hw.memsize)
free_mem=$(echo "$vm_stat_output" | awk '/Pages free/ {print $3}' | tr -d '.')
inactive_mem=$(echo "$vm_stat_output" | awk '/Pages inactive/ {print $3}' | tr -d '.')

total_mem_mb=$(echo "scale=2; $total_mem / 1024 / 1024 " | bc)
total_mem_gb=$(echo "scale=2; $total_mem_mb / 1024" | bc)
free_mem_mb=$(echo "scale=2; ($free_mem + $inactive_mem) * $page_size / 1024 / 1024" | bc)
free_mem_gb=$(echo "scale=2; $free_mem_mb / 1024" | bc)
used_mem_mb=$(echo "scale=2; $total_mem_mb - $free_mem_mb" | bc)
used_mem_gb=$(echo "scale=2; $used_mem_mb / 1024" | bc)

used_percent=$(echo "scale=2; $used_mem_mb * 100 / $total_mem_mb" | bc)
free_percent=$(echo "scale=2; 100 - $used_percent" | bc)

echo "Total Memory: ${total_mem_gb} GB"
echo "Used Memory: ${used_mem_gb} GB (${used_percent}%)"
echo "Free Memory: ${free_mem_gb} GB (${free_percent}%)"

print_empty_lines 2

print_header 'Disk Usage'

disk_info=$(df -h /)

total_space=$(echo "$disk_info" | awk 'NR==2 {print $2}')
used_space=$(echo "$disk_info" | awk 'NR==2 {print $3}')
free_space=$(echo "$disk_info" | awk 'NR==2 {print $4}')

used_percent=$(echo "$disk_info" | awk 'NR==2 {print $5}' | tr -d '%')
free_percent=$(echo "scale=2; 100 - $used_percent" | bc)

echo "Total Disk Space: $total_space"
echo "Used Disk Space: $used_space (${used_percent}%)"
echo "Free Disk Space: $free_space (${free_percent}%)"

print_empty_lines 2

print_header 'Top 5 Processes by CPU Usage'

ps -eo pcpu,pid,user,comm | sort -k1 -nr | head -n 6 | tail -n 5 | awk '
    BEGIN {printf "%-6s %-5s %-12s %s\n", "CPU%", "PID", "USER", "COMMAND"}
    {printf "%-6.1f %-5s %-12s %s\n", $1, $2, $3, $4}'
