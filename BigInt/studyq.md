# Study Questions



## 1. What are the largest and smallest integer values in the programming
environment you use?
## 2. Each BigInt object will need to store the digits that represent the BigInt
value. The decision to allow arbitrarily large BigInt values affects the
choices for storing digits. Name one method for storing digits that will
permit an arbitrary number of digits to be stored. What effect would
a limit on the number of digits in a BigInt have in the design of the
BigInt class?
## 3. Based on your knowledge of pencil-and-paper methods for doing
arithmetic, what do you think will be the most difficult arithmetic
operation (+, *, !) to implement for the BigInt class? Why?
## 4. Experiment with the calculator. If you enter abcd1234 when a number
is expected, what happens? If you enter 1234abcd is the behavior
different? What happens if you enter an operator that’s not one of the
three that are implemented?
## 5. List as many operations as you can that are performed on integers, but
that are not included in the list of BigInt functions and operators above.
## 6. (AB only) What implementation decisions would require providing a
destructor, a copy constructor, and an assignment operator?
## 7. Consider the headers for operator! and operator+ given below.
BigInt operator - (const BigInt & big, int small);
// postcondition: returns big - small
BigInt operator + (const BigInt & big, int small);
// postcondition: returns big + small
Write the body of operator! assuming that operator+ has been written.
