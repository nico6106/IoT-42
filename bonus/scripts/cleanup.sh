#!/bin/sh

error_exit() {
  echo "Error: $1" >&2
  exit 1
}

echo "Deleting k3d cluster..."
k3d cluster delete bonus || error_exit "Failed to delete k3d cluster"

echo "Cleanup complete..."
