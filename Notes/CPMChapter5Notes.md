# Organization of CP/M



---

## Overview

- CP/M (Control Program for Microcomputers) is organized into layers that manage programs, devices, and disk operations.  
- The system relies on low-level routines to communicate with hardware before the operating system is fully loaded.  
- These hardware-specific routines, along with system software, form a compact and adaptable structure.

---

## Disk and I/O Access Primitives

- A **loader program** in ROM boots the system and loads CP/M into RAM.  
- **Cold start:** When power is turned on or the reset switch is pressed.  
- **Warm start:** Reloads CP/M without changing device mappings (used after program termination or CTRL+C).  
- Disk and I/O routines must be connected to CP/M through **vectors** (function jump addresses).

### CBIOS Vectors

| Address (16K System) | Vector | Function Description |
|----------------------:|:--------|:----------------------|
| 3E00H + b | BOOT | Cold start, display sign-on, initialize system |
| 3E03H + b | WBOOT | Warm start, reload CP/M, retain drive/IOBYT |
| 3E06H + b | CONST | Test console keyboard for input ready |
| 3E09H + b | CONIN | Read console character |
| 3E0CH + b | CONOUT | Output to console display |
| 3E0FH + b | LIST | Send character to list device |
| 3E12H + b | PUNCH | Send character to punch device |
| 3E15H + b | READER | Input character from reader device |
| 3E18H + b | HOME | Set drive head to track 0 |
| 3E1BH + b | SELDSK | Select current drive |
| 3E1EH + b | SETTRK | Select disk track |
| 3E21H + b | SETSEC | Select disk sector |
| 3E24H + b | SETDMA | Set DMA (RAM buffer) address |
| 3E27H + b | READ | Read disk sector into RAM buffer |
| 3E2AH + b | WRITE | Write RAM buffer to disk |

> `b = BIAS = 400H per 1K offset above 16K CP/M`

- Only **15 routines** are required to adapt CP/M to new hardware.  
- These routines link CP/M to device drivers in ROM or CBIOS.

---

## BDOS — Basic Disk Operating System

- BDOS handles **file management** and **disk I/O abstraction**.  
- Operates between user programs and low-level hardware routines.

### Storage Units
- **Record:** 128 bytes  
- **Block:** 256 bytes (2 records)  
- **Group:** 1K bytes (8 records)  

### Key Points
- Files are stored in 1K increments on disk.  
- BDOS manages file creation, reading, writing, and deletion.  
- Implements **dynamic disk space allocation** using directory entries and File Control Blocks (FCBs).  
- Displays all disk access errors (e.g., *BDOS ERR ON B: BAD SECTOR*).  
- Error handling:
  - **Carriage Return:** Ignore error.  
  - **CTRL+C:** Warm start.  
  - **READ ONLY:** Disk is write-protected or changed without notice.  
- BDOS ensures reliable file and disk operations for both programs and users.

---

## CBIOS — Customized Basic Input/Output System

- Provides hardware-dependent drivers for a specific computer.  
- Links hardware (disks, I/O ports) with BDOS.  
- Located at the top of CP/M memory space.

### Memory Map (Version 1.4, 16K System)

| Address Range | Symbol | Function |
|----------------|:---------|:----------|
| 0000H–0002H | JMP WBOOT | Warm start vector |
| 0003H | IOBYT | I/O selector byte |
| 0004H | DISK | Drive selector byte |
| 0005H–0007H | JMP BDOS | BDOS entry vector |
| 0038H | JMP DDT | Debug breakpoint |
| 005CH–007FH | TFCB | Transient File Control Block |
| 0080H–00FFH | TBUFF | Command line buffer |
| 0100H–28FFH + b | TPA | Transient Program Area |
| 2900H–30FFH + b | CCP | Console Command Processor |
| 3100H–3DFFH + b | BDOS | Disk operations |
| 3E00H–3FFFH + b | CBIOS | Device drivers and vectors |

> `b = BIAS = 400H per 1K increment above 16K`

### IOBYT (I/O Selector Byte)

- Defines which physical devices are linked to logical devices.  
- Each logical device uses 2 bits of the IOBYT:

| Bits | Logical Device | Example Physical Devices |
|:----:|:----------------|:--------------------------|
| 0–1 | Console (CON:) | TTY:, CRT:, BAT:, UC1: |
| 2–3 | Reader (RDR:) | TTY:, PTR:, UR1:, UR2: |
| 4–5 | Punch (PUN:) | TTY:, PTP:, UP1:, UP2: |
| 6–7 | List (LST:) | TTY:, CRT:, LPT:, UL1: |

- Example command:  
  `STAT VAL:` — Displays all logical/physical device assignments.

---

## CCP — Console Command Processor

- Provides the **user interface** for entering commands.  
- Prompts appear as `A>` indicating the active drive.  
- Commands may be:
  - **Resident functions** (built-in)
  - **Transient commands** (`.COM` files loaded from disk)

### Features
- Parses command lines with filenames, drive designators, and options.  
- Sets up default File Control Block (`TFCB`) and command buffer (`TBUFF`) before loading a program.  
- Executes commands or loads `.COM` files into the TPA for execution.

---

## Resident Commands

| Command | Function |
|:--------|:----------|
| `ERA FILENAME.TYP` | Erase file(s) |
| `DIR` | Display directory |
| `DIR FILENAME.TYP` | List specific file(s) |
| `REN NEWNAME=OLDNAME` | Rename file |
| `SAVE xx FILENAME` | Save memory pages to disk (xx = 256-byte blocks) |
| `TYPE FILENAME` | Display file contents |
| `STAT` | Display disk and file statistics |

### Notes
- `ERA *.BAK` removes all `.BAK` files.  
- `SAVE 12 TEST.COM` saves 12 blocks (3 KB) from memory as `TEST.COM`.  
- `CTRL+P`: Toggles printer output mirroring console output.  
- `CTRL+S`: Pauses and resumes scrolling text on the console.

---

## Transient Commands

| Command | Description |
|:---------|:-------------|
| `STAT FILENAME` | Show file statistics |
| `STAT VAL:` | Display all I/O devices |
| `STAT DEV:` | Show current device assignments |
| `ED FILENAME` | Edit text file |
| `ASM FILENAME` | Assemble program into `.HEX` file |
| `LOAD FILENAME` | Convert `.HEX` to `.COM` |
| `DUMP FILENAME` | Display file in memory dump format |
| `SUBMIT FILENAME x,y,z` | Execute batch processing from file |
| `MOVCPM yy w` | Resize CP/M system |
| `SYSGEN` | Write moved system to disk |

---

## User Programs

- **Transient utilities** and **user-written programs** both execute in the **TPA** (Transient Program Area).  
- User programs interact with BDOS and CCP via system calls.  
- When run, CCP:
  - Parses the command line.  
  - Loads specified filenames into the default FCB.  
  - Passes remaining arguments to the command buffer.  
- User programs can thus easily access files and command-line arguments through predefined memory areas.

---

## Summary

- CP/M is divided into three major components:
  1. **CCP (Console Command Processor):** Handles user input and command execution.  
  2. **BDOS (Basic Disk Operating System):** Manages files and disk access.  
  3. **CBIOS (Customized BIOS):** Interfaces CP/M with specific hardware.  
- This modular organization makes CP/M portable across different microcomputers with minimal modification.

---



