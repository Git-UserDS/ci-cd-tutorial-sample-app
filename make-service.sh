#!/bin/bash
file_path=`pwd`
service_path="/etc/systemd/system/$1.service"

if (systemctl -q is-active $1.service)
then
    systemctl stop $1.service
    echo "Stopping existing service..."
fi
    touch "$service_path"
    service_contents="
[Unit]
Description=Python Web App
After=network.target
[Service]
User=$2
WorkingDirectory=/home/$2/PythonApp
ExecStart=/home/$2/PythonApp/venv/bin/gunicorn app:app -b 0.0.0.0:8000
Restart=always
[Install]
WantedBy=multi-user.target"

echo "Creating new service..."
echo "$service_contents" > "$service_path"

systemctl daemon-reload
systemctl start $1.service
systemctl enable $1.service
systemctl status $1.service
