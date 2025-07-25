# Contain Yourself - Minimal Container Runtime

A Docker-like container runtime built from scratch in Go.

## Quick Start

1. **Prerequisites**: Docker installed
2. **Start environment**:
   ```bash
   docker run -it --rm --privileged -v $(pwd):/app -w /app golang:1.24 bash
   ```
3. **Setup**:
   ```bash
   bash setup.sh
   ```
4. **Run containers**:
   ```bash
   go run main.go run /bin/bash
   ```

## Features

- Process isolation (PID namespaces)
- Filesystem isolation (chroot + mount namespaces)
- Automatic /proc mounting
- ARM64 support
