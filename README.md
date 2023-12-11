 #  AdGuard Home Port 53 Fix Script

The script is designed to free up port 53 on machiens with `systemd-resolved` using port 53.
 
This happens because the port 53 on `localhost`, which is used for DNS, is already taken by another program. Ubuntu comes with a local DNS called `systemd-resolved`, which uses the address `127.0.0.53:53` and thus prevents AdGuard Home from binding to `127.0.0.1:53`.

Please note that this script assumes that `systemd-resolved` is installed and running on your system. If it’s not, you may need to install or start it before running this script. Also, please remember to make this script executable by running `chmod +x scriptname.sh` before executing it with `./install.sh`.