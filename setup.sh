#!/bin/bash

echo "Setting up Contain Urself container runtime..." 

# Path setup 
CONTAINER_ROOT="/tmp/mycontainer-root"
LIB_DIR="$CONTAINER_ROOT/lib/aarch64-linux-gnu"

echo "Creating container filesystem structure..." 
mkdir -p $CONTAINER_ROOT/{bin,usr/bin,lib,lib64,etc,proc,sys,dev,tmp}
mkdir -p $LIB_DIR

echo "Copying binaries..."
cp /bin/{bash,ls,echo,ps,mount,cat,top} $CONTAINER_ROOT/bin/ 2>/dev/null || {
    echo "Some binaries might not exist, continuing..."
}

# Add networking tools
cp /usr/sbin/ip $CONTAINER_ROOT/bin/ 2>/dev/null || echo "ip command not found"
cp /usr/bin/ping $CONTAINER_ROOT/bin/ 2>/dev/null || echo "ping command not found"

echo "Copying ARM64 libraries..."
# Core libraries
cp /lib/aarch64-linux-gnu/libc.so.6 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libtinfo.so.6 $LIB_DIR/
cp /lib/ld-linux-aarch64.so.1 $CONTAINER_ROOT/lib/

# ls command
cp /lib/aarch64-linux-gnu/libselinux.so.1 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libpcre2-8.so.0 $LIB_DIR/

# mount command
cp /lib/aarch64-linux-gnu/libmount.so.1 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libblkid.so.1 $LIB_DIR/

# ps command
cp /lib/aarch64-linux-gnu/libproc2.so.0 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libsystemd.so.0 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libcap.so.2 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libgcrypt.so.20 $LIB_DIR/
cp /lib/aarch64-linux-gnu/liblzma.so.5 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libzstd.so.1 $LIB_DIR/
cp /lib/aarch64-linux-gnu/liblz4.so.1 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libgpg-error.so.0 $LIB_DIR/

# networking libraries
echo "Copying networking libraries..."
# Networking libraries for ip command
cp /lib/aarch64-linux-gnu/libbpf.so.1 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libelf.so.1 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libmnl.so.0 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libbsd.so.0 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libz.so.1 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libmd.so.0 $LIB_DIR/

# Networking libraries for ping command  
cp /lib/aarch64-linux-gnu/libidn2.so.0 $LIB_DIR/
cp /lib/aarch64-linux-gnu/libunistring.so.2 $LIB_DIR/


echo "Creating container-init script..."
cat > $CONTAINER_ROOT/bin/container-init << 'EOF'
#!/bin/bash

# Mount /proc filesystem for process information
mount -t proc proc /proc 2>/dev/null || true

# Mount /sys filesystem for system information  
mount -t sysfs sysfs /sys 2>/dev/null || true

# Execute the user's actual program
exec "$@"
EOF

chmod +x $CONTAINER_ROOT/bin/container-init

echo "Setup complete!"
echo ""
echo "You can now run: go run main.go run /bin/bash"
echo "Try these commands in your container:"
echo "   ps aux     - See isolated processes"
echo "   ls /       - See container filesystem" 
echo "   echo \$\$    - See PID (should be 1)"
