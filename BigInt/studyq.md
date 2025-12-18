# Calculator and BigInt Design Questions — Answers

---

## Page 3

### Question 1  
Adding unary operations (e.g., unary minus `M`, absolute value `A`)

To support unary operations, the program must:
- Add new command symbols to the input handling logic.
- Modify the command-processing switch or if/else structure to recognize unary operators.
- Apply the operation directly to the current value instead of requiring a second operand.
- Ensure the parser does not prompt for an additional number when a unary operator is used.

---

### Question 2  
Using words instead of single-character operators

Changes would occur in:
- The input parsing section, where operators are read.
- Replacing `char` input for operators with `string` input.
- Updating comparisons in the command-processing logic (e.g., `"times"` instead of `'*'`).
- Possibly adjusting tokenization logic if input is read as a stream.

---

### Question 3  
Converting the calculator to use `double` instead of `int`

Required changes:
- Replace all `int` variables storing values with `double`.
- Update function parameter and return types.
- Adjust arithmetic operations to account for floating-point behavior.
- Modify input/output formatting for decimal values.
- Review error handling for floating-point edge cases (NaN and infinity).

---

### Question 4  
Graphical push-button calculator

High-level rewrite steps:
- Replace text-based input with a GUI framework.
- Create buttons for digits and operations.
- Maintain internal state for the current value and pending operations.
- Use event-driven programming for button clicks.
- Update the display after each interaction.

---

### Question 5  
Implementing a Clear (`C`) command

Implementation steps:
- Add `'C'` as a recognized command.
- In the command-processing logic, set the current value to zero.
- Do not request additional operands.
- Ensure the display or output reflects the reset value.

---

### Question 6 (AB only)  
Supporting parentheses for order of operations

Required changes:
- Implement a full expression parser.
- Use a stack-based approach such as the Shunting Yard algorithm.
- Store operators and operands separately.
- Evaluate expressions based on precedence and parentheses.
- Replace the simple left-to-right evaluation model.

---

## Page 6

### Question 1  
Largest and smallest integer values

In a typical C++ environment:
- `int` minimum: −2,147,483,648
- `int` maximum: 2,147,483,647  
Exact values depend on the system and compiler.

---

### Question 2  
Storing digits for arbitrarily large BigInt values

One method:
- Store digits in a dynamically sized container such as a vector or apvector.

Effect of limiting digits:
- Simplifies memory management.
- Restricts the range of representable values.
- Reduces flexibility and undermines the purpose of BigInt.

---

### Question 3  
Most difficult arithmetic operation to implement

Multiplication is typically the hardest because:
- It requires managing carries across many digits.
- Time complexity increases as numbers grow.
- Factorial relies on repeated multiplication, making it indirectly difficult as well.

---

### Question 4  
Invalid input behavior

- Input `abcd1234`: conversion fails immediately when a number is expected.
- Input `1234abcd`: the numeric portion is read first, then the stream fails.
- Invalid operator input: the program either rejects it or ignores it, depending on implementation.

---

### Question 5  
Integer operations not included in BigInt

Examples include:
- Bitwise operations
- Modulo
- Bit shifting
- Exponentiation
- Increment and decrement
- Division with remainder
- Logical operations

---

### Question 6 (AB only)  
When destructors and copy control are needed

They are required if:
- The class manages dynamic memory.
- Resources must be released explicitly.
- Deep copies are required.
- Assignment must avoid memory leaks or double deletion.

---

### Question 7  
Implementing `operator!` using `operator+`

The factorial operator:
- Initializes a result to 1.
- Repeatedly multiplies the result by decreasing integers.
- Relies on existing arithmetic operators such as `operator+` or `operator*`.
- Stops when the value reaches 1.

---

## Page 10

### Question 1  
C++ error handling behavior

Typical behavior:
- File not found: the input stream enters a fail state.
- Integer overflow: undefined behavior or wraparound.
- Divide by zero: undefined behavior or program termination.

Alternative approaches:
- Exceptions, which are safer and clearer.
- Error codes, which are simpler but easier to misuse.

---

### Question 2  
BigInt error enum

Example declaration:
```cpp
enum BigIntError {
    NO_ERROR,
    OVERFLOW_ERROR,
    DIVIDE_BY_ZERO,
    INVALID_DIGIT,
    NEGATIVE_FACTORIAL
};

3. Turning Off Error Checking
Circumstances preferred:
Performance-critical applications where speed outweighs safety (e.g., scientific simulations, graphics rendering).
Environments where input is guaranteed valid (e.g., controlled embedded systems).
When error checking overhead significantly impacts throughput.
4. Interactive Error-Handling Approach
Strengths:
User can immediately correct errors without restarting the program.
Provides flexibility (halt, ignore, or fix).
Useful in educational or debugging contexts.
Weaknesses:
Slows down automated or batch processes.
Requires user presence, unsuitable for background services.
Risk of inconsistent state if user chooses to ignore errors.
5. Global Variable for Error Results
Strengths:
Simple to implement.
Centralized error reporting.
Low overhead compared to exceptions.
Weaknesses:
Not thread-safe (global state can be overwritten).
Easy to forget to check the global variable.
Harder to manage in large systems with multiple modules.
Lacks granularity—only one error state at a time.



















## Page 17

### Question 1  
**Why is a `char` vector used to store digits instead of an `int` vector? How does this affect implementation?**

A `char` vector is used because each digit only needs to store values from 0–9. Using `char`:
- Uses less memory than `int`.
- Matches the digit-by-digit nature of manual arithmetic.
- Simplifies carry and borrow logic.

If the element type changes:
- All arithmetic logic must be rewritten.
- Carry/borrow calculations change.
- Memory usage and performance are affected.
- Every BigInt member function must be updated to match the new representation.

---

### Question 2  
**Alternatives to using an enum for the sign of a BigInt**

Two alternatives:
- A `bool` value (e.g., `true` = negative, `false` = positive).
- An `int` value (e.g., `-1` for negative, `+1` for positive).

Both are simpler but less self-documenting than an enum.

---

### Question 3  
**Write the `GetDigit` function and discuss possible errors**

Purpose of `GetDigit`:
- Return the digit at a specific index in the digit vector.

Errors to worry about:
- Index out of bounds.
- Accessing digits that do not exist.
- Invalid BigInt state.

The function should check bounds and handle invalid access safely.

---

### Question 4  
**Why are `operator==` and `operator<` difficult to write? Write `operator==` for positive BigInts**

Difficulty:
- Digits are accessed only through `GetDigit`.
- No direct access to internal storage.
- Requires repeated function calls and careful indexing.

Logic for `operator==` (positive BigInts):
- Compare the number of digits.
- If unequal, return false.
- Compare each digit from most significant to least.
- If all digits match, return true.

---

### Question 5 (optional)  
**Why is `apvector` better than built-in arrays for BigInt?**

Advantages of `apvector`:
- Automatically resizes.
- Manages memory safely.
- Supports copying and assignment.
- Reduces risk of memory leaks.
- Makes the BigInt class easier to maintain and extend.



