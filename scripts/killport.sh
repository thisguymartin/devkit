#!/bin/bash

# killport: Kill process on a given port

PORT=$1

if [ -z "$PORT" ]; then
  echo "Usage: killport <port>"
  exit 1
fi

PID=$(lsof -ti :$PORT)

if [ -z "$PID" ]; then
  echo "Nothing running on port $PORT"
else
  echo "Killing PID $PID on port $PORT"
  kill -9 $PID
  echo "Done"
fi
