#!/bin/bash
file_path=`pwd`
service_path="/etc/systemd/system/$1.service"
if [ -f "$service_path" ]
then
    echo "Service file already exists"
    echo "Stopping service..."
    systemctl stop $1.service
else
    touch "$service_path"
    service_contents="
[Unit]
Description=Stage Flask App
After=network.target
[Service]
User=$2
WorkingDirectory=/home/$2/PythonApp
ExecStart=/home/$2/PythonApp/venv/bin/flask run
Restart=always
[Install]
WantedBy=multi-user.target"
    echo "$service_contents" >> "$service_path"
    systemctl start $1.service
    systemctl enable $1.service
fi
