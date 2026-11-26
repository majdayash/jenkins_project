#!/bin/sh
# Simple local deployment for the Python-CI-CD pipeline.
# Copies the application into a versioned release folder, points a
# "current" symlink at it, and runs a smoke test on the deployed copy.
set -eu

DEPLOY_ROOT="${DEPLOY_DIR:-$HOME/jenkins_deployments/python-ci-cd}"
RELEASE="${BUILD_NUMBER:-manual-$(date +%Y%m%d%H%M%S)}"
TARGET="$DEPLOY_ROOT/releases/$RELEASE"
PYTHON="${PYTHON:-python3}"

echo "Deploying release $RELEASE to $TARGET"
mkdir -p "$TARGET"
cp app.py requirements.txt "$TARGET/"

ln -sfn "$TARGET" "$DEPLOY_ROOT/current"
echo "Updated $DEPLOY_ROOT/current -> $TARGET"

echo "Smoke test of deployed app:"
OUTPUT="$("$PYTHON" "$DEPLOY_ROOT/current/app.py")"
echo "  $OUTPUT"
if [ "$OUTPUT" != "Hello, World from Majd Ayash!" ]; then
    echo "Smoke test FAILED" >&2
    exit 1
fi
echo "Deployment successful."
