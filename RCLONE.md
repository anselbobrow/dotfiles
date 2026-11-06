1. link `com.rclone.ubuntu.plist` to `~/Library/LaunchAgents/com.rclone.ubuntu.plist`
2. make sure it points to the right script to launch rclone (rclone-mount.sh) which is executable (`chmod +x`)
3. use these commands to start, enable, stop, and force restart, respectively
    - `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.rclone.ubuntu.plist`
    - `launchctl enable gui/$(id -u)/com.rclone.ubuntu`
    - `launchctl bootout gui/$(id -u)/com.rclone.ubuntu`
    - `launchctl kickstart -k gui/$(id -u)/com.rclone.ubuntu`
4. some commands to test that the service has successfully started
    - `launchctl print gui/$(id -u)/com.rclone.ubuntu | grep -E "state|pid"`
    - `mount | grep ubuntu`
