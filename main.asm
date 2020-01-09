 ; Copyright (c) 2020 microwave89-hv
 ;
 ; Licensed under the Apache License, Version 2.0 (the "License");
 ; you may not use this file except in compliance with the License.
 ; You may obtain a copy of the License at
 ;
 ;      http://www.apache.org/licenses/LICENSE-2.0
 ;
 ; Unless required by applicable law or agreed to in writing, software
 ; distributed under the License is distributed on an "AS IS" BASIS,
 ; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ; See the License for the specific language governing permissions and
 ; limitations under the License.

 ; Derived from actual TE file in SPI ROM dump of MBP101.00F6.B00 starting at offset 0x7ff33c,
 ; with help of the Intel® Platform Innovation Framework for EFI Pre-EFI Initialization Core Interface Specification (PEI CIS) 0.91,
 ; and the Extensible Firmware Interface Specification V 1.10.
 ; Thanks go to @Intel for creating and publishing those specifications.

BITS 64

EFI_TE_IMAGE_HEADER_SIGNATURE 		equ 0x5A56    				; 'VZ' 			  ; Magic for Terse Executables
IMAGE_FILE_MACHINE_AMD64		equ 0x8664
IMAGE_SUBSYSTEM_EFI_APPLICATION		equ 0xa					; EFI app
EfiResetShutdown			equ 2					; In C this would be of type long
size_of_te_hdr				equ 0x28				; Inofficial...

Signature: 				dw EFI_TE_IMAGE_HEADER_SIGNATURE 	; 56 5A
Machine: 				dw IMAGE_FILE_MACHINE_AMD64 		; 64 86
NumberOfSections: 			db 0 					; 00			  ; Don't interpret a section header any longer, this permits one finally
													  ; to put code in all of the fields of the former section header.
Subsystem: 				db IMAGE_SUBSYSTEM_EFI_APPLICATION 	; 0A
StrippedSize: 				dw 0 					; 00 00 		  ; Not needed ==> EntryPoint = AddressOfEntryPoint + sizeof(EFI_TE_IMAGE_HEADER);
AddressOfEntryPoint: 			dd (efi_miau - size_of_te_hdr)		; 00 		  	  ; EntryPoint is "efi_miau"
BaseOfCode:
	push 0 									; 6A 00			  ; unsigned long long var4 = 0;
	jmp DataDirectory0_Va 							; EB 08 		  ; Skip non-executable ImageBase

ImageBase: 				dq 0x1000 				; 00 10 00 00 00 00 00 00 ; This region is usable on my system.
DataDirectory0_Va:
	push 0 									; 6A 00			  ; unsigned long long var3 = 0;
	jmp DataDirectory1_Va 							; EB 04

DataDirectory0_Size: 			dd 0 					; 00 00 00 00 		  ; If directory sizes are 0 it appears that the VA's allow for arbitrary values.
DataDirectory1_Va:
	push 0 									; 6A 00			  ; unsigned long long var2 = 0;
	jmp goAhead								; EB 06 		  ; Skip needed fields and the init jmp

DataDirectory1_Size: 			dd 0 					; 00 00 00 00

efi_miau:									; EntryPoint
	jmp BaseOfCode 								; EB E2 		  ; Go to very first usable byte, whose address is lower than anything
													  ; AddressOfEntryPoint would allow for.
goAhead:
	push EfiResetShutdown 							; 6A 02 		  ; unsigned long long var1 = (unsigned long long)EfiResetShutdown;
	mov rax, [rdx + 0x58] 							; 48 8B 42 58 		  ; EFI_RUNTIME_SERVICES* pRuntimeServices = pEfiSystemTable->pRuntimeServices;
	pop rcx 								; 59 			  ; Retrieve the values which have been stored on the stack 
	pop rdx 								; 5A 			  ; Pushing imm8 and following up by popping target registers requires less	
	pop r8 									; 41 58 		  ; machine code than xoring 3 registers and pre-loading one with imm8.
	pop r9 									; 41 59 		  ; Even more important so, loading registers by pushing to and popping values
													  ; from the stack reduces the size of the instructions needed.
													  ; With a size of just 2 bytes per instruction unused dword fields can be
													  ; made use of by allowing for a connecting jmp in the remaining 2 bytes.
	jmp [rax + 0x68]							; FF 60 68 		  ; pRuntimeServices->fpResetSystem(var1, var2, var3, var4);


; 56 5A 64 86 00 0A 00 00 00 00 00 00 6A 00 EB 08 00 10 00 00 00 00 00 00 6A 00 EB 04 00 00 00 00 6A 00 EB 06 00 00 00 00 EB E2 6A 02 48 8B 42 58 59 5A 41 58 41 59 FF 60 68

