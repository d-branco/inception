#!/bin/sh

echo "Starting static website server on port 8080..."

exec python3 -m http.server 8080
