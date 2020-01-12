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
	push EfiResetShutdown	 						; 6A 02			  ; unsigned long long var1 = (unsigned long long)EfiResetShutdown;
	jmp DataDirectory0_Va 							; EB 08 		  ; Skip non-executable ImageBase

ImageBase: 				dq 0x0000000000001000	 		; 00 10 00 00 05 60 00 00 ; On my system this region is read-writeable. This might not hold true with your's.
DataDirectory0_Va:
	pop rcx 								; 59			  ; arg1 = var1;
	nop									; 90
	jmp DataDirectory1_Va 							; EB 04			  ; Skip required data fields in execution flow

DataDirectory0_Size: 			dd 0 ;xfedcba97 				; 00 00 00 00 		  ; If directory sizes are 0 it appears that the VA's allow for arbitrary values.
DataDirectory1_Va:
	xor edx, edx 								; 31 D2			  ; arg2 = EFI_SUCCESS;
	jmp goAhead								; EB 0A 		  ; Skip required data fields, and skip instructions which have already been executed.

DataDirectory1_Size: 			dd 0 					; 00 00 00 00
efi_miau:									; EntryPoint
	mov rax, [rdx + 0x58]							; 			  ; Firstly, save EFI_RUNTIME_SERVICES table pointer so rdx can already be zeroed.
	jmp BaseOfCode	 							; EB DE 		  ; Go to very first usable byte, whose address is lower than anything
													  ; AddressOfEntryPoint would allow for.
goAhead:
	jmp [rax + 0x68]							; FF 60 68 		  ; pRuntimeServices->fpResetSystem(arg1, arg2, arg3, arg4); Although the reset
													  ; call has 4 parameters only 2 arguments are supplied. The 2nd parameter allows
													  ; for providing a shutdown reason in terms of an EFI_STATUS. Implementers of
													  ; the EFI_RESET_SYSTEM IF might use this information for logging reasons or such.
													  ; According to the EFI spec, if the shutdown reason is EFI_SUCCESS the last 2
													  ; arguments must not be interpreted according to the EFI spec. Here, the status
													  ; provided is EFI_SUCCESS, and upon relying on the last parameters not being
													  ; interpreted the last 2 arguments are not initialized.

; 56 5A 64 86 00 0A 00 00 00 00 00 00 6A 02 EB 08 00 10 00 00 00 00 00 00 59 90 EB 04 00 00 00 00 31 D2 EB 0A 00 00 00 00 48 8B 42 58 EB DE FF 60 68
