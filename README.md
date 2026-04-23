# 🖥️ MASM Assembly Portfolio
### x86 Assembly Language | CS271 Computer Architecture & Assembly Language | Oregon State University

A collection of x86 MASM Assembly projects demonstrating progressive mastery of low-level programming — from sorting algorithms and array manipulation to string primitive I/O and macro design.

---

## 📂 Projects

| Project | Title | Key Concepts |
|---------|-------|-------------|
| [Project 5](#-project-5--random-number-generator-sorter--analyzer) | Random Number Generator, Sorter & Analyzer | Bubble sort, median, frequency analysis, Register Indirect addressing |
| [Project 6](#-project-6--string-primitives--macro-io-portfolio-capstone) | String Primitives & Macro I/O | LODSB/STOSB, string conversion, overflow detection, custom macros |

---

## 🔢 Project 5 — Random Number Generator, Sorter & Analyzer

**Score: Full marks + Extra Credit**

A 377-line x86 MASM program that generates 200 random integers, sorts them, finds the median, and produces a frequency count — all implemented with proper stack-based parameter passing and reusable procedure design.

### ✨ What It Does

1. Generates 200 random integers between 15 and 50
2. Displays the **unsorted list** (20 numbers per line)
3. **Sorts the array** in ascending order using bubble sort
4. Calculates and displays the **median** value
5. Displays the **sorted list**
6. Counts and displays the **frequency** of each possible number in the range

### 🛠️ Technical Highlights

**Bubble Sort in Assembly**
- `sortList` procedure implements a bubble sort using `ESI`/`EDI` for array traversal
- `exchangeElements` sub-procedure swaps adjacent elements using Register Indirect addressing (`[EDI+EDX*4]`)

**Median Calculation**
- Handles both odd and even array sizes correctly
- For even arrays: averages the two middle values with proper rounding logic using `IDIV` and remainder checking

**Frequency Analysis**
- `countList` procedure uses nested loops to count instances of each number in the range `[LO..HI]`
- Builds a separate counts array using Base+Offset addressing

**Reusable Procedure Design**
- `displayList` is called three times with different arrays and sizes — demonstrating clean parameter-driven procedure design
- Clean procedure hierarchy: `main` → `introduction`, `fillArray`, `displayList`, `sortList`, `displayMedian`, `countList`, `goodbye`

**Low-Level Requirements Met**
- ✅ All parameters passed on the runtime stack (STDCALL)
- ✅ Register Indirect addressing for array elements (`[ESI+EDX*4]`)
- ✅ Base+Offset addressing for stack parameters
- ✅ All registers saved and restored by called procedures
- ✅ Stack cleaned up by called procedures (`RET n`)

---

## 🔤 Project 6 — String Primitives & Macro I/O (Portfolio Capstone)

**Score: 51/50 — Full marks plus extra credit 🎉**

A 533-line x86 MASM Assembly program demonstrating mastery of low-level I/O procedures, string primitive instructions, macro design, and stack-based parameter passing — the portfolio capstone project for CS271.

### 📸 Program Output

![Program output showing sum, average, goodbye message, and ASCII holiday art](outupt.jpg)

> *Yes, that ASCII art "HAPPY HOLIDAYS" is rendered entirely in raw byte values — because why not?* 😄

### ✨ What It Does

Collects 10 signed 32-bit integers from the user, validates each one, stores them in an array, and displays:

- The list of entered numbers
- Their sum
- Their truncated average
- A running subtotal after each entry *(extra credit)*
- Line numbers for each prompt *(extra credit)*

### 🛠️ Technical Highlights

**Custom Macros**
- **`mGetString`** — displays a prompt and reads user keyboard input into memory using `ReadString`, with `PUSHAD/POPAD` register preservation
- **`mDisplayString`** — prints a string at a given memory address using `WriteString`

**Custom Procedures**
- **`ReadVal`** — converts user string input to a signed 32-bit integer (`SDWORD`) using `LODSB` string primitives, with full input validation
- **`WriteVal`** — converts a signed 32-bit integer back to an ASCII string using `STOSB` string primitives, then displays it
- **`Convert`** — sub-procedure of `ReadVal` handling place-value arithmetic of ASCII-to-integer conversion

**Input Validation**
- Rejects non-numeric characters
- Handles `+` and `-` sign prefixes
- Detects and rejects numbers too large for a 32-bit register using overflow detection (`JO`)
- Re-prompts user on any invalid input including empty input

**Low-Level Requirements Met**
- ✅ `LODSB` and `STOSB` used for all string primitive operations
- ✅ All parameters passed on the runtime stack using STDCALL calling convention
- ✅ All registers saved and restored by called procedures and macros
- ✅ Stack cleaned up by called procedures (`RET n`)
- ✅ No global variable references outside of `main`
- ✅ Register Indirect addressing for array elements
- ✅ Base+Offset addressing for stack parameters
- ✅ Local variables used appropriately via `LOCAL` directive

**Extra Credit Implemented**
- **Line numbering** — each user prompt is numbered sequentially using `WriteVal`
- **Running subtotal** — displays a running total after each valid entry using `WriteVal`

---

## 📖 Program Flow

### Project 5
```
main
├── introduction
├── Randomize
├── fillArray (200 random integers)
├── displayList (unsorted)
├── sortList
│   └── exchangeElements (bubble sort swap)
├── displayMedian
├── displayList (sorted)
├── countList (frequency analysis)
├── displayList (counts)
└── goodbye
```

### Project 6
```
main
├── mDisplayString (intro, directions)
├── Loop 10x:
│   ├── WriteVal (line number)
│   ├── ReadVal
│   │   ├── mGetString (get user input)
│   │   ├── Validate input character by character (LODSB)
│   │   └── Convert (ASCII → SDWORD)
│   └── WriteVal (running total)
├── Display array (WriteVal per element)
├── Display sum (WriteVal)
├── Display average (WriteVal)
└── ASCII art farewell 🎄
```

---

## 🎓 What I Learned

These projects pushed me to think at the hardware level — every byte matters, every register has a purpose, and there is no abstraction to hide behind. Key takeaways:

- **Sorting at the register level** — implementing bubble sort with direct memory manipulation gave me a deep appreciation for what `Array.sort()` does under the hood
- **String primitives** — `LODSB`/`STOSB` are elegant tools once you understand the direction flag and how ESI/EDI advance automatically
- **Stack discipline** — managing the runtime stack manually, including cleaning up with `RET n`, gave me a deep appreciation for what high-level languages handle automatically
- **Overflow detection** — using `JO` to catch 32-bit register overflow during conversion was one of the most satisfying debugging moments of the project
- **Reusable procedures** — designing `displayList` to work with multiple arrays taught me how parameter-driven design works at the lowest level

---

## 🚀 Running the Programs

### Requirements
- Windows
- Visual Studio with MASM support
- Irvine32 library

### Setup
1. Clone the repo
2. Open the desired `.asm` file in Visual Studio
3. Ensure Irvine32.inc is configured in your include path
4. Build and run

---

## 👩‍💻 Author

**Aimee Wirick**
Oregon State University — B.S. Computer Science, Expected June 2026
[LinkedIn](https://www.linkedin.com/in/aimee-wirick-170765122) • [AimeeWirick.com](https://AimeeWirick.com) • [GitHub](https://github.com/aimeewirick)
