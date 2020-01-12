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
StrippedSize: 				dw 0x2d9 				; d9 02 		  ; Needed to adjust address of AddressOfEntryPoint to AddressOfEntryPoint
AddressOfEntryPoint: 			mov    ecx, 2
	nop
	jmp DataDirectory0_Va 							; EB 08 		  ; Skip non-executable ImageBase

ImageBase: 				dq 0xffffffffffffffff	 		; 00 10 00 00 05 60 00 00 ; On my system this region is read-writeable. This might not hold true with your's.
DataDirectory0_Va:
	push qword [rdx + 0x58] 						; 59			  ; arg1 = var1;
	mov    edx, 0								; 90
	
DataDirectory1_Va:
	pop rax 								; 31 D2			  ; arg2 = EFI_SUCCESS;
	call [rax + 0x68]
	
; 56 5A 64 86 00 0A D9 02 B9 02 00 00 00 90 EB 08 FF FF FF FF FF FF FF FF FF 72 58 BA 00 00 00 00 58 FF 50 68
