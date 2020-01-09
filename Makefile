# Notes:
# Only tested on High Sierra 13.6!
# Only tested with nasm 2.14.02! (obtained by brew install nasm)
# The -p switch to mkdir might not be available on your OS.
# Your OS might prevent you from messing with the mount directory.
# Your OS might prevent you from messing with the EFI partition.

TARGET	= te-sound-barrier.efi
SRC	= main.asm

AS=/usr/local/opt/nasm/bin/nasm
ASFLAGS+= \
	-w+all \

all: $(TARGET)

te-sound-barrier.efi:
	$(AS) -o te-sound-barrier.efi $(ASFLAGS) main.asm

.PHONY: clean install

clean:
	rm ./*.efi

MNTDIR = /Volumes/EFIMOUNT/
TARGETDIR = /Volumes/EFIMOUNT/EFI/BOOT/
TARGETFILE = BOOTX64.EFI
MNTDEV = /dev/disk0s1

install:
	sudo mkdir -p $(MNTDIR)
	sudo mount -t msdos $(MNTDEV) $(MNTDIR)
	sudo mkdir -p $(TARGETDIR)
	cp $(TARGET) $(TARGETDIR)/$(TARGETFILE)
	sync # From https://github.com/o-gs/DJI_FC_Patcher, step 4
	# sudo umount $(MNTDEV)
