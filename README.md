# ~~57~~ 49 Bytes [sic] x86-64 EFI App
Very small EFI application which can shutdown your platform upon execution.

Also see https://github.com/microwave89-hv/te-sound-barrier/tree/master for general information and explanation.
Key difference to the source code on the master branch is omitting the initialization of arguments which should not be interpreted by the platform FW in the first place. Owing to some constraints of code order being relaxed some instructions could be replaced by shorter ones and they could be arranged slightly more effective.

By only fiddling with 2 instead of 4 arguments the shutdown code has been greatly simplified. As of such it is highly unlikely that implementing the platform shutdown by yourself is going to yield code that is any shorter.

#efi #uefi #application #app #bootloader #bootx64 #terse #executable #intel #bios #boot #bds #helloworld #shutdown #reset #tinypechallenge #x64
