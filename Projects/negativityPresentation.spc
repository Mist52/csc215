# Negativity Presentation
# By Dylan and Alessandra
# Checks if the number is even or odd
3A # 00 LDA 40      Load A from 0040
40 # 01 (address)   Low byte
00 # 02 (address)   High byte
21 # 03 LXI         Load HL from 0050
50 # 04 (address)   Low byte
00 # 05 (address)   High Byte
96 # 06 SUB M       Subtract the value pointed by HL -> store in A
FA # 07 JM          Jump to address 0010 IF the Sign flag is set to 1
10 # 08 (address)   Low
00 # 09 (address)v  High
3E # 0A MVI         A = 02 (positive)
02 # 0B 02          
32 # 0C STA         Store A at 0060
60 # 0D (address)   Low Byte     
00 # 0E (address)   High Byte
76 # 0F HLT         Halt
3E # 10 MVI         A = 01 (negative)
01 # 11 01          the location of the jump
32 # 12 STA         Store A at 0060
60 # 13 (address)   Low byte     
00 # 14 (address)   High byte
76 # 15 HLT         Halt
===
40:03
50:01
