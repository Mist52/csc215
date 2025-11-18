# Chapter 15 — CP/M Assembly Language Programming (1983)

## Overview
- Chapter focuses on macros and macro processing.
- Shows how macros reduce repetition and improve structure.
- Covers macro definitions, parameters, expansion, and best practices.

## What Macros Are
- Macros are templates that generate assembly instructions.
- Expanded by the assembler before normal assembly.
- Used to repeat code patterns without rewriting them.

## Macro Definitions
- Defined with:
  MACRO
    <body>
  ENDM
- Can include parameters that act as placeholders.
- Parameters are replaced during macro expansion.

## Macro Invocation
- Use the macro name like an instruction:
  MYMAC ARG1, ARG2
- Assembler replaces the call with the full expanded code.

## Parameters
- Allow macros to behave like functions.
- Can be positional or named.
- Provide flexibility without rewriting code blocks.

## Advantages of Macros
- Reduce repetitive coding.
- Centralize changes and improve maintainability.
- Help document intent with meaningful names.
- Provide performance benefits since code is inlined.

## Macro vs Subroutine
- Macros:
  - Inline expansion.
  - Faster execution.
  - Increase program size.
- Subroutines:
  - Single shared code block.
  - Save memory.
  - Have call/return overhead.

## Conditional Assembly
- Macros may include IF/ELSE/ENDIF logic.
- Allows assembling different code paths based on parameters.
- Useful for configuration, debugging, and hardware variations.

## Local Labels
- Macros need local labels to avoid naming conflicts.
- Assemblers generate unique labels per macro expansion.

## Nested Macros
- Macros can call other macros.
- Some assemblers allow limited recursion.
- Supports building layered abstractions.

## Macro Libraries
- Collections of reusable macros.
- Common uses: I/O helpers, looping templates, data movement sequences.
- Helpful for larger CP/M projects.

## Debugging Macros
- Listing files show both the call and the expanded code.
- Important for understanding and debugging macro-generated instructions.

## Best Practices
- Use macros to simplify common patterns.
- Avoid overuse to prevent code bloat.
- Use descriptive names.
- Inspect expansions in listing files to catch issues.



