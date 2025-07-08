#!/bin/bash

# Set USER_UID and USER_GID environment variables for devcontainer build
export USER_UID=$(id -u)
export USER_GID=$(id -g)

echo "Setting environment variables for devcontainer:"
echo "USER_UID=$USER_UID"
echo "USER_GID=$USER_GID"
