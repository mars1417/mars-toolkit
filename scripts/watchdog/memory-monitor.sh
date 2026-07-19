#!/bin/bash
# Mars Toolkit — Memory Trend Monitor
# Logs memory stats to CSV every 10 minutes

VERSION="0.1.0"
LOG="$HOME/.hermes/logs/memory-trend.csv"
mkdir -p "$(dirname "$LOG")"

# Header if not exists
[ ! -f "$LOG" ] && echo "timestamp,available_mb,free_mb,inactive_mb,swap_mb" > "$LOG"

if [[ "$OSTYPE" == "darwin"* ]]; then
    page_size=$(vm_stat | awk '/page size of/ {print $8}' | tr -d '.')
    [ -z "$page_size" ] && page_size=16384
    
    free=$(vm_stat | awk '/Pages free/ {print $3}' | tr -d '.')
    inactive=$(vm_stat | awk '/Pages inactive/ {print $3}' | tr -d '.')
    active=$(vm_stat | awk '/Pages active/ {print $3}' | tr -d '.')
    wired=$(vm_stat | awk '/Pages wired/ {print $4}' | tr -d '.')
    
    free_mb=$(( free * page_size / 1048576 ))
    inactive_mb=$(( inactive * page_size / 1048576 ))
    available_mb=$(( free_mb + inactive_mb ))
    
    if command -v sysctl &> /dev/null; then
        swap=$(sysctl vm.swapusage 2>/dev/null | awk '{print $7}' | tr -d 'M')
    else
        swap=0
    fi
    
    timestamp=$(date '+%Y-%m-%d %H:%M')
    echo "$timestamp,$available_mb,$free_mb,$inactive_mb,$swap" >> "$LOG"
    echo "📊 Memory: ${available_mb}MB available (swap: ${swap}MB)"
fi
