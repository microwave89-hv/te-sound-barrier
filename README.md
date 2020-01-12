# ~~49~~ 36 Bytes [sic] x86-64 EFI App
Likely the world's smallest EFI application which is still able to shutdown your platform upon execution.

Also see https://github.com/microwave89-hv/te-sound-barrier/tree/master for general information and explanation.
Key updates to "nextlevel"-branch source include utilizing the StrippedSize field to move the EP to the first reasonably controllable field (AddressOfEntryPoint) and leveraging the 0 bytes of the directory sizes to form instructions which take an imm32.
This allowed for throwing away the highly ineffective bridge jumps.
Another key difference is splitting the "pRuntimeServices = pEfiSystemTable->RuntimeServices" code into two parts finally allowing placement in a dword field.

__I herewith openly challenge you to come up with a smaller EFI application which still does something fundamentally different from__

- immediately rebooting the machine
- returning control to the OS
- hanging

Reason is these are achievable even if your app doesn't even gain control or it somehow crashes the TE loader.
A platform shutdown without gaining control is much much more unlikely.

Your constraints are that you must somehow show your app executing (likewise to the machine shutdown) or having been executing (leaving something in the flash?, or in the memory?).

#efi #uefi #application #app #bootloader #bootx64 #terse #executable #intel #bios #boot #bds #helloworld #shutdown #world #record #tinypechallenge #x64
