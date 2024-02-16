#!/bin/bash

HOST_SEARCH="app1.com"
HOST_FILE="/etc/hosts"

if grep -q "$HOST_SEARCH" "$HOST_FILE"; then
    echo "hosts exists"
else
    HOST_APP1="192.168.56.110   app1.com"
    HOST_APP2="192.168.56.110   app2.com"
    HOST_APP3="192.168.56.110   app3.com"
    echo "$HOST_APP1" | sudo tee -a "$HOST_FILE"
    echo "$HOST_APP2" | sudo tee -a "$HOST_FILE"
    echo "$HOST_APP3" | sudo tee -a "$HOST_FILE"
    echo "hosts added"
fi