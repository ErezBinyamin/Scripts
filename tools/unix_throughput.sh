# Generate 1GB random file in the "shared memory" (i.e. RAM disk)
# https://unix.stackexchange.com/questions/326510/local-unix-socket-rough-idea-of-throughput
echo "# Generating random data file..."
dd if=/dev/urandom of=/dev/shm/data.dump bs=1M count=1024

echo "# [1/4] Memory -> disk"
socat -u -b32768 UNIX-LISTEN:/tmp/unix.sock ./data.dump &
socat -u -b32768 "SYSTEM:dd if=/dev/shm/data.dump bs=1M count=1024" UNIX:/tmp/unix.sock

echo "# [2/4] Memory -> memory"
socat -u -b32768 UNIX-LISTEN:/tmp/unix.sock /dev/shm/data.dump.out &
socat -u -b32768 "SYSTEM:dd if=/dev/shm/data.dump bs=1M count=1024" UNIX:/tmp/unix.sock

echo "# [3/4] Memory -> /dev/null"
socat -u -b32768 UNIX-LISTEN:/tmp/unix.sock /dev/null &
socat -u -b32768 "SYSTEM:dd if=/dev/shm/data.dump bs=1M count=1024" UNIX:/tmp/unix.sock

echo "# [4/4] /dev/zero -> /dev/null"
socat -u -b32768 UNIX-LISTEN:/tmp/unix.sock /dev/null &
socat -u -b32768 "SYSTEM:dd if=/dev/zero bs=1M count=1024" UNIX:/tmp/unix.sock

# Clean up
rm ./data.dump
