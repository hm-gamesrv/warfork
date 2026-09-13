#!/bin/bash
set -euo pipefail 

export LD_LIBRARY_PATH="/app/bin:/app/bin/linux64"

cd /app && exec /app/wf_server.x86_64
