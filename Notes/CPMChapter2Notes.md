# Chapter 2 Notes

## Introduction
 -  Core memory can retain its contents even with power off. (A programming error could wipe the memory)
 - Semiconductor memory replaced Core memory. Semiconductor RAM loses its memory when the
power goes down. 


## Firmware Monitor 
 - When a microproccessor is reset it begins operation by fetching an instruction from
memory location zero.
 -  CP/M operating system requires read/write memory (RAM) at the bottom of the memory address space.
 - A "shadow PROM" temporarily replaces RAM at location zero during bootup.
 - First instructions load from there during startup to fix loading order and power cycles which cause Ram to reset. This shadow is connected in steps before the memory begins loading to RAM.
 - In a simple implementation, the first instruction from the shadow PROM is an unconditional jump to a monitor program in ROM (typically at the top of memory).
 - The CPU decodes the jump instruction, placing the monitor's address on the address bus (16 signal lines indicating the memory location to access).
 - The bootup circuitry detects the most significant bit being asserted on the address bus, disables the shadow PROM, and reenables RAM at location zero. The firmware is in control of everything from start


 - A monitor program (often in ROM) allows the operator to interact with the computer hardware for diagnostics and debugging.
 - If a monitor program is absent, CP/M provides DDT (Dynamic Debugging Tool) to perform the same functions.
 - Monitor PROMs may include peripheral driver programs (an IOCS or Input/Output Control System) that offer access to peripherals without needing hardware-specific addresses.


## The Operating System
 - CP/M is highly adaptable and has been implemented on a wide range of computers from different manufacturers.
 - Unlike some other computer components, I/O port assignments (addresses and busy bit configurations) are not standardized across different computer systems.
 - To send characters to a console, a driver program must check the status of the output port and wait for it to be ready, then output the character.
 - Embedding hardware-specific drivers in programs restricts their portability.
 - CP/M simplifies operations by handling details of disk accesses and I/O ports, making assembly language programs "hardware independent" and portable.
## Customizing CP/M
 - There are user-to-system conventions built in to make it more efficent.
 - All disk and I/O accesses are passed through a single entry which means the function codes are passed in one register.
 - CP/M relieves users/programmers from needing to know hardware details; this hardware-specific interfacing is handled once during operating system adaptation.
 - the importance of writing completely portable assembly language programs that avoid hardware-specific dependencies.
 - By adhering to CP/M's conventions, programs can be written to run on any CP/M system without modification.


## Application Programs
 - Firmware monitor and the resident portion of CP/M take up main memory space. CP/M uses specific areas at the bottom of RAM.
 - The remaining memory address space is available for user programs.
 - The 8080 family of microprocessors can address 64K of RAM, but systems often have less than the full amount.
 - A 16K RAM CP/M system is sufficient for the programming exercises in the book.
 - CP/M loads and executes user programs in RAM within an area called the TPA.
 - The TPA starts at a fixed address and encompasses all available RAM not used by CP/M itself.
 - In smaller systems, part of CP/M may need to be overlaid (temporarily replaced) to create enough user workspace in the TPA. The operating system is designed to allow this without disrupting disk/I/O access.
 - Non-system software (user programs) are referred to as application programs.
 - CP/M's editor (ED), assembler (ASM), loader (LOAD), and debugger (DDT) are used for editing, assembling, and debugging application programs.
 - These tools are loaded into the TPA as needed. Only DDT (the debugger) shares main memory with user programs (until the program is fully operational).
 - Only DDT shares the program, the rest are loaded as needed, and only 16 ram is mentioned. 

## Special Memory Areas
 - The lowest memory addresses in RAM are dedicated to vectors.
 - Vectors are unconditional jump instructions that direct the CPU to specific routines (like the monitor). They handle hardware interrupts.
 - The 8080 family uses 8 memory locations for interrupt vectors. The Z80 and 8085 use more. - Above the vectors, CP/M sets up buffer areas used for interfacing programs with the operating system.
 - The TPA begins after the vectors and buffer areas.
 - CP/M loads and executes user programs (application programs) within the TPA.
 - There is another specific area dedicated to functions. Varies between PC and depends on memory. The system is required to map and make sure it has an equal use.See what the computer functions require.





## Acronyms

 - ROM - Read-only memory
 - RAM - Random access memory
 - CPU - Central processing unit
 - CP/M - Control program for Microcomputer
 - PROM - Programmable Read Only Memory - saves memory even when off - firmware are the instructions in the PROM


