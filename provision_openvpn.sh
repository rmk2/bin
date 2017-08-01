#!/bin/bash

set -e

# Initialise easy-rsa and variables

function init() {
    cd /etc/openvpn/easy-rsa/
    touch keys/index.txt
    echo 01 > keys/serial
    . ./vars # set environment variables
    ./clean-all
}

# Generate CA certificate/key

function exec_ca() {
    ./build-ca 
}

# Build intermediate CA certificate/key

function exec_server() {
    ./build-key-server server
}

# Generate Diffie-Hellman Parameters

function exec_dh() {
    ./build-dh
}

# Generate key for each client (with password)

CLIENTS="ryko thistle nexus"

function exec_client() {   
    for i in $CLIENTS; do
	./build-key-pass $i
    done
}

# Main

exec_client
