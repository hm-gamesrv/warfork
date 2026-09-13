#!/bin/bash
set -euo pipefail 

export LD_LIBRARY_PATH="/app/linux64"

cd /app && exec /app/wf_server.x86_64
