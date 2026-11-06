#!/bin/bash
MP="$HOME/ubuntu-webdav/"
umount "$MP" 2>/dev/null || diskutil unmount force "$MP" 2>/dev/null

# wait for network
until /sbin/ping -c1 -t2 1.1.1.1 >/dev/null 2>&1; do sleep 5; done

exec /opt/homebrew/bin/rclone nfsmount ubuntu: "$MP" \
  --vfs-cache-mode full \
  --vfs-cache-max-age 72h
