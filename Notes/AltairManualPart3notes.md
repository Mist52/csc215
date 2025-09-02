# OPERATION OF THE ALTAIR 8800

## 1A. THE FRONT PANEL SWITCHES AND LEDs

### General Overview
 - The ALTAIR 8800 (256 words of memory) can be operated with 15 switches and monitoring 16 LEDs, despite having 25 switches and 36 LEDs.
### Front Panel Switches
 - ON-OFF: ON applies power; OFF cuts power and erases memory.
 - STOP-RUN: STOP halts program execution; RUN executes the program.
 - SINGLE STEP: Executes one machine language instruction per actuation (can take up to 5 machine cycles).
 - EXAMINE-EXAMINE NEXT: EXAMINE displays memory address content (set via DATA/ADDRESS switches) on data LEDs; EXAMINE NEXT displays the content of the next sequential address upon each actuation.
 - DEPOSIT-DEPOSIT NEXT: DEPOSIT loads data byte (from DATA switches) into the designated memory address; DEPOSIT NEXT loads the data byte into the next sequential memory address upon each actuation. Data byte can be changed before actuating DEPOSIT or DEPOSIT NEXT.
 - RESET-CLR: RESET sets the Program Counter to the first memory address (0 000 000 000 000 000); CLR is a CLEAR command for external I/O equipment.
 - PROTECT-UNPROTECT: PROTECT prevents changes to memory contents; UNPROTECT allows memory alteration.
 - AUX Switches: Two auxiliary switches are included but not yet connected, intended for use with peripherals.
 - DATA/ADDRESS Switches: DATA Switches: Designated 7-0.
 - ADDRESS Switches: Designated 15-0.
 - UP position = 1 bit; DOWN position = 0 bit.
 - ADDRESS Switches 8-15 are not used in the basic 256-word ALTAIR 8800 and should be set to 0 when entering an address.


## 2A. Indicator LEDS

| LED | Definition |
|--------|---------|
| ADDRESS | The ADDRESS LEDs are those designated A15-A0. The bit pattern shown on the ADDRESS LEDs denotes the memory address being examined or loaded with data.|
| DATA | The DATA LEDs are those designated D7-DO. The bit pattern shown on the DATA LEDs denotes the data in the specified memory address. |
| INTE | An INTERRUPT has been enabled when this LED is glowing. |
| PROT | The memory is PROTECTED when this LED is glowing. |
| WAIT | The CPU is in a WAIT state when this LED is glowing.|
| HLDA | A HOLD has been ACKNOWLEDGED when this LED is glowing. |


## C. Using Memory

 - Memory's Vital Role: Memory is crucial for efficient computer operation.
 - High-Level vs. Machine Language: Higher-level languages automate memory address tracking, while machine language requires manual programmer management .
 - Memory Mapping Defined: Memory mapping is a technique for tracking what's stored in memory by assigning data types to specific memory blocks .
 - Purpose of Memory Mapping: It organizes available memory into an efficient and accessible storage medium .
 - Example Memory Map (ALTAIR 8800): Programs (first 100 words), subroutines (second 100 words), and data (remaining 56 words) in a 256-word memory . Blocks can be modified as needed .
 - Creating and Updating Maps: Create a memory map each time you change the program, noting memory space for program, subroutines, and data in a table or chart, and update the table when the memory organization is modified . 
