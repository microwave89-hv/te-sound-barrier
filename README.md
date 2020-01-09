# te-sound-barrier EFI App
Unlikely small EFI application, which will reset your platform if it could be loaded successfully.
See http://archive.is/w01DO for the general idea of shrinking down a (P)E until the sound barrier is reached.

_What is it?_ It is an attempt to gain a basic understanding of how one can write smaller EFI apps by leveraging the less-known "Terse Executable" (TE) format.
TE files are PE's with an adapted header, the size of which has strongly been reduced, by stripping fields that do not apply to an EFI environment. There is for instance no import or export directory in an EFI app as there isn't such thing as dynamic linking. TE files are readily used in both the SEC and PEI phases of FW execution.

_How use i this???? i can haz halp plz!!!!!_ See https://github.com/microwave89-hv/min-hello-world, and use Google if you cannot make sense out of the term "EFI Application". Attempting to simply launch this file from the EDK EfiShell will likely result in an error.

_Why didn't you go for a Hello World?_ A Hello world needs a considerably large piece of code just to switch back to text mode from the graphics mode the Apple BDS screen runs in. Without switching to text mode the "Hello World" string won't going to be visible. At that point, "Hello World!" hasn't even been put out yet which will take yet another dozens of bytes to accomplish.

_What's so special about this one then?_ It is an executable which does something visible on your Macbook Pro Retina 15" from Mid-2012 while boasting a file size of merely 75 bytes [sic]. Bytes, not Kilobytes. This can be made into the classic "Hello World" program but it is going to be much bigger in size.

_How could you improve it?_ Maybe reset the machine by means of sending 0xFE to PS/2 keyboard port 0x60(?) 0x64(?). This has been discussed in the book "Windows Rootkits", from Hoglund and Butler. Unfortunately, with the proprietary HID solution of Macbook Pro keyboards I haven't seemed to be able to reset the machine yet. Using the PS/2 way would allow for omitting most of the machine code that is currently used. Another way might be to set the number of sections to 0. This hasn't been tried yet. 

#efi #uefi #bootloader #bootx64 #terse #executable #intel #bios #boot #bds #helloworld #reset #tinype
