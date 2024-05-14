#!/bin/bash

# Concatenate base configuration with frontend and backend configurations
cat /etc/haproxy/base/haproxy.cfg.base /etc/haproxy/frontends/*.cfg /etc/haproxy/backends/*.cfg > /etc/haproxy/haproxy.cfg

# Check for configuration file syntax errors
haproxy -c -f /etc/haproxy/haproxy.cfg
if [ $? -ne 0 ]; then
    echo "Error in HAProxy configuration."
    exit 1
fi

# Start HAProxy in the foreground
exec haproxy -f /etc/haproxy/haproxy.cfg -db