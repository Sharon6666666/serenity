#!/bin/sh

set -e

: "${SERENITY_RAM_SIZE:='256M'}"
export SERENITY_RAM_SIZE

# set this to the Build directory in serenity
: "${SERENITY_BUILD:='/mnt/c/Users/Ragnarok/serenity-project/serenity/Build'}"
export SERENITY_BUILD

cd -P -- "$SERENITY_BUILD" || exit
make install
make image

# set this to point to qemu installation on windows
export SERENITY_QEMU_BIN='/mnt/c/Program Files/qemu/qemu-system-i386.exe'

export SERENITY_COMMON_QEMU_ARGS="
$SERENITY_EXTRA_QEMU_ARGS
-s -m $SERENITY_RAM_SIZE
-cpu max
-d cpu_reset,guest_errors
-smp 2
-device VGA,vgamem_mb=64
-hda _disk_image
-device ich9-ahci
-debugcon stdio
-soundhw pcspk
-soundhw sb16
"

"$SERENITY_ROOT/Meta/run.sh" "$@"
