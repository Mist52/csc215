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

## 3A. Status LEDS
| LED | Definition |
|--------|---------|
| MEMR | The memory bus will be used for memory read data. |
| INP | The address bus containing the address of an input device. The input data should be placed on the data bus when the data bus is in the input mode. |
| M1 | The CPU is processing the first machine cycle of an instruction. |
| OUT | The address contains the address of an output device and the data bus will contain the output data when the CPU is ready. |
| HLTA | A HALT instruction has been executed and acknowledged. |
| STACK | The address bus holds the Stack Pointer’s push-down stack address. |
| WO | Operation in the current machine cycle will be a WRITE memory or OUTPUT function. Otherwise, a READ memory or INPUT operation will occur. |
| INT | An INTERRUPT request has been acknowledged. |



## B. LOADING A SAMPLE PROGRAM

### Simple Addition Program
 - Purpose: Adds two numbers from memory and stores the sum.
 - Code (Mnemonics): LDA, MOV (A→B), LDA, ADD (B+A), STA, JMP
 - Key Mnemonics:
   - LDA: Load Accumulator from Memory
   - MOV: Move Accumulator to Register B
   - ADD: Add Register B to Accumulator
   - STA: Store Accumulator to Memory
   - JMP: Jump to Address
 - JMP Use: Loops the program continuously.
 - Memory Map: Program starts at 0. Example: Number 1 at 128, Number 2 at 129, Result at 130.
 - Loading the Program:
   - RESET.
   - Enter bit pattern via DATA/ADDRESS switches.
   - DEPOSIT.
   - Repeat with DEPOSIT NEXT for each step.
 - Loading Data:
   - Set DATA/ADDRESS switches to memory address.
   - EXAMINE.
   - Enter the number.
   - DEPOSIT.
   - Use DEPOSIT NEXT for sequential addresses.
 - Running:
   - RESET.
   - RUN.
   - STOP.
   - EXAMINE the result address to see the answer.
 - Binary Multiply Program

 - Multiplies two numbers.
 - Uses registers A, D, E, B, H, L.
 - Involves shifting, rotating, conditional jumps.
 - Result stored at memory locations 100 and 101 (octal).

## C. Using Memory

 - Memory's Vital Role: Memory is crucial for efficient computer operation.
 - High-Level vs. Machine Language: Higher-level languages automate memory address tracking, while machine language requires manual programmer management .
 - Memory Mapping Defined: Memory mapping is a technique for tracking what's stored in memory by assigning data types to specific memory blocks .
 - Purpose of Memory Mapping: It organizes available memory into an efficient and accessible storage medium .
 - Example Memory Map (ALTAIR 8800): Programs (first 100 words), subroutines (second 100 words), and data (remaining 56 words) in a 256-word memory . Blocks can be modified as needed .
 - Creating and Updating Maps: Create a memory map each time you change the program, noting memory space for program, subroutines, and data in a table or chart, and update the table when the memory organization is modified .



## D. Memory Addresing 

 - ALTAIR 8800 supports Direct, Register Pair, Stack Pointer, Immediate, and Stack Addressing (for subroutines).
 - Direct Addressing: Instruction includes the full memory address (2 bytes).
 - Register Pair Addressing:
    - Register pair (usually H/L) holds the memory address.
    - STAX/LDAX allow B/C or D/E pairs.
 - Stack Pointer Addressing:
    - Uses PUSH (store to stack) and POP (retrieve from stack) operations.
    - Programmer reserves stack space; LXI instruction sets Stack Pointer.
    - Stack address should be in memory map.
 - Immediate Addressing:
    - Data loaded with the program; stored in program memory.
    - No need to alter the memory map.
 - Stack Addressing (Subroutines):
    - CALL pushes return address to stack; RETURN pops it to resume the main program.

## E. Operating Hints

 - Proofreading Programs:
   - Always proofread after entering a program.
   - RESET (if program starts at address 0) or set the ADDRESS switches and EXAMINE the starting address.
   - Check the DATA LEDs against the expected bit pattern.
   - Use EXAMINE NEXT to check subsequent steps.
   - To correct errors: Re-enter the correct bit pattern on DATA switches, actuate DEPOSIT, and continue proofreading with EXAMINE NEXT.
 - Using NOPs (No Operation):
   - NOPs are seemingly useless instructions that do nothing.
   - Scatter NOPs in a complicated program to save time when debugging.
   - If a new instruction is needed, replace a NOP with it.
   - Use multiple NOPs in a row if a multi-byte instruction might be needed (e.g., use three NOPs for a potential LDA instruction).
 - Debugging Programs:
   - Debugging is needed when a program fails to execute correctly due to errors ("bugs").
   - Use the SINGLE STEP switch to step through the program machine cycle by machine cycle.
   - Observe the eight STATUS LEDs to detect illegal entries, improper program organization, and other errors.
 
