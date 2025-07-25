cat > /tmp/mycontainer-root/bin/container-init << 'EOF'
#!/bin/bash

mount -t proc proc /proc 2>/dev/null || true

mount -t sysfs sysfs /sys 2>/dev/null || true

exec "$@"
EOF

chmod +x /tmp/mycontainer-root/bin/container-init