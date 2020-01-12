# ~~49~~ 36 Bytes [sic] x86-64 EFI App
Likely the world's smallest EFI application which is still able to shutdown your platform upon execution.

Also see https://github.com/microwave89-hv/te-sound-barrier/tree/master for general information and explanation.
Key updates to "nextlevel"-branch source include utilizing the StrippedSize field to move the EP to the first reasonably controllable field (AddressOfEntryPoint) and leveraging the 0 bytes of the directory sizes to form instructions which take an imm32.
This allowed for throwing away the highly ineffective bridge jumps.
Another key difference is splitting the "pRuntimeServices = pEfiSystemTable->RuntimeServices" code into two parts finally allowing placement in a dword field.

I herewith openly challenge you to come up with a smaller EFI application which still does something fundamentally different from 

- rebooting the machine
- returning control to the OS
- hanging

#efi #uefi #application #app #bootloader #bootx64 #terse #executable #intel #bios #boot #bds #helloworld #shutdown #world #record #tinypechallenge #x64
