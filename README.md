# ~~49~~ 36 Bytes [sic] x86-64 EFI App
Likely the world's smallest EFI application which is still able to shutdown your platform upon execution.

See https://github.com/microwave89-hv/te-sound-barrier/tree/master for general information and explanation.

MBP10,1 with MBP101.00F6.B00 BootROM.

Key updates to "nextlevel"-branch source include utilizing the StrippedSize field to move the EP to the first reasonably controllable field (AddressOfEntryPoint) and leveraging the zero-bytes of the directory sizes to form instructions which take an imm32.
This allowed for throwing away the highly ineffective bridge jumps.
Another key difference is splitting the "pRuntimeServices = pEfiSystemTable->RuntimeServices" code into two parts finally allowing placement in a dword field.

__I herewith openly challenge you to come up with a smaller EFI application which still does something fundamentally different from__

- immediately rebooting the machine
- returning control to the OS
- hanging

Reason is these are achievable even if your app doesn't even gain control or it somehow crashes the TE loader.
A platform shutdown without gaining control is much much more unlikely.

Your constraints are

- Your app must before the next reboot somehow prove that it has gained control over the program counter. That means you cannot manually edit your app between executions. You might for example leave a byte in the flash or in the memory.
- It must be a standalone EFI app able to run without bootloader, or EFI shell. It can, however, run in the version xyz of QEMU, bochs, VirtualBox, or a PC or Mac.

#efi #uefi #application #app #bootloader #bootx64 #terse #executable #intel #macbook #bios #boot #bds #helloworld #shutdown #world #record #tinypechallenge #x64
