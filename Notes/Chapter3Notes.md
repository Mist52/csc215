# Chapter 3

## CP/M System Basics
 - Exercises assume a minimum-size microcomputer running CP/M 1.4, 2.0, or 2.2.
 - Only a few physical devices are required for exercises; extra devices are optional.
 - CP/M uses logical and physical device names to simplify references.
## Logical vs. Physical Devices
 - Physical device: Actual hardware (CRT, printer, disk drive).
 - Logical device: Name CP/M uses to access hardware.
 - Example: Physical CRT terminal → logical device CON:
## Operator Console
 - CRT: physical terminal (keyboard + display tube).
 - Plugged into the correct port → acts as logical device CON:
 - Simplifies reference instead of saying “computer’s operator console.”
## Disk Drives
 - Physical drives numbered: 0, 1, 2… (Intel MDS tradition).
 - Logical names: A:, B:, etc.
 - Minimum system: logical → physical is 1-to-1 mapping.
 - No three-letter designations for disk drives in CP/M.


## Key Takeaways
 - CP/M standardizes device access using logical names.
 - CON:, LST:, RDR:, PUN: are standard logical devices.
 - Disk logical names (A:, B:) correspond to physical drives.
 - Understanding logical vs. physical devices is essential for program input/output.
 - IOBYT is CP/M’s software device selector.
 - Allows logical devices to flexibly use different physical devices.
 - Bit patterns in IOBYT → determine active device for each logical device.
 - Only CON: is bi-directional; others are one-way (input or output).



# Chapter 4
## File Handling
- CP/M organizes data on **disk drives**.  
- **Physical drives**: numbered 0, 1, 2…  
- **Logical drives**: named A:, B:, C:…  
- Minimum systems: logical drives map 1-to-1 with physical drives.  
- File input/output handled through **BDOS** (Basic Disk Operating System).  
- Files are referenced by their **name + extension**, e.g., `TEST.COM`.  

## Wildcards in File Names
- CP/M allows **wildcards** for flexible file operations.  
- `*` = matches **any string** of characters.  
- `?` = matches **a single character**.  
- Examples:  
  - `DIR *.ASM` → lists all files with `.ASM` extension.  
  - `ERA TEST?.TXT` → erases `TEST1.TXT`, `TEST2.TXT`, etc.  
- Useful for batch operations on groups of files.  

## Logical Unit Access
- CP/M separates **logical devices** from **physical devices**.  
- Logical devices:  
  - **CON:** → operator’s console (CRT terminal).  
  - **LST:** → line printer (LPT:).  
  - **RDR:** → input reader (card reader, paper tape reader, or modem Rx).  
  - **PUN:** → punch device (tape punch or modem Tx).  
- Logical devices can be **remapped** in software via **IOBYT**.  
- **IOBYT:** one-byte memory location; bit patterns select physical devices.  
- **CON:** is the only **bi-directional** logical device.  
- In minimum systems:  
  - **CON:** always CRT.  
  - **LST:** always LPT.  
  - IOBYT switching not needed.  

## Line Editing
- CP/M provides simple **line editing features** at the console.  
- Input typed at **CON:** can be corrected before being accepted.  
- Common editing controls:  
  - **Backspace (←)** → erase previous character.  
  - **Control-U** → delete entire line.  
  - **Control-C** → cancel operation / return to command prompt.  
- Editing happens **before** the line is passed to BDOS or a program.  
- Ensures clean, error-free input during file commands or program execution.  



