## Indicator LEDS

| LED | Definition |
|--------|---------|
| ADDRESS | The ADDRESS LEDs are those designated A15-A0. The bit pattern shown on the ADDRESS LEDs denotes the memory address being examined or loaded with data.|
| DATA | The DATA LEDs are those designated D7-DO. The bit pattern shown on the DATA LEDs denotes the data in the specified memory address. |
| INTE | An INTERRUPT has been enabled when this LED is glowing. |
| PROT | The memory is PROTECTED when this LED is glowing. |
| WAIT | The CPU is in a WAIT state when this LED is glowing.|
| HLDA | A HOLD has been ACKNOWLEDGED when this LED is glowing. |


## C. Using Memory

-Memory's Vital Role: Memory is crucial for efficient computer operation.
-High-Level vs. Machine Language: Higher-level languages automate memory address tracking, while machine language requires manual programmer management .
-Memory Mapping Defined: Memory mapping is a technique for tracking what's stored in memory by assigning data types to specific memory blocks .
-Purpose of Memory Mapping: It organizes available memory into an efficient and accessible storage medium .
-Example Memory Map (ALTAIR 8800): Programs (first 100 words), subroutines (second 100 words), and data (remaining 56 words) in a 256-word memory . Blocks can be modified as needed .
-Creating and Updating Maps: Create a memory map each time you change the program, noting memory space for program, subroutines, and data in a table or chart, and update the table when the memory organization is modified . 
