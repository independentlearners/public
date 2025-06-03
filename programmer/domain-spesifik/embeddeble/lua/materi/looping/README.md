# Kurikulum Lengkap Control Flow di Lua

## Overview Kurikulum

Kurikulum ini dirancang untuk memberikan pemahaman mendalam tentang control flow (alur kontrol) dalam bahasa pemrograman Lua. Materi disusun secara progresif dari konsep dasar hingga teknik advanced dengan banyak praktik dan studi kasus.

**Durasi:** 6-8 minggu (40-50 jam pembelajaran)
**Target:** Programmer pemula hingga menengah
**Prasyarat:** Pemahaman dasar tentang variabel dan tipe data di Lua

---

## Modul 1: Fondasi Control Flow (Minggu 1)

### 1.1 Pengenalan Control Flow

- **Teori (2 jam)**

  - Definisi dan pentingnya control flow
  - Perbedaan sequential vs conditional vs iterative execution
  - Overview struktur kontrol di Lua
  - Perbandingan dengan bahasa pemrograman lain

- **Konsep Dasar (2 jam)**

  - Block dan scope dalam Lua
  - Penggunaan `do...end` blocks
  - Nested blocks dan variable scoping
  - Local vs global variables dalam control structures

- **Praktik (2 jam)**
  - Membuat program sederhana dengan sequential execution
  - Eksperimen dengan block scoping
  - Latihan debugging scope issues

### 1.2 Boolean Logic dan Kondisi

- **Teori (2 jam)**

  - Boolean values: `true`, `false`, `nil`
  - Truthy dan falsy values di Lua
  - Logical operators: `and`, `or`, `not`
  - Short-circuit evaluation

- **Praktik (3 jam)**
  - Latihan evaluasi ekspresi boolean
  - Kombinasi kondisi kompleks
  - Truth table exercises
  - Studi kasus: validasi input pengguna

---

## Modul 2: Conditional Statements (Minggu 2)

### 2.1 If Statements

- **Sintaks Dasar (2 jam)**

  ```lua
  if condition then
    -- statements
  end
  ```

  - Single condition if
  - Nested if statements
  - Best practices untuk readability

- **If-Else Structures (2 jam)**

  ```lua
  if condition then
    -- statements
  elseif condition2 then
    -- statements
  else
    -- statements
  end
  ```

  - Multiple elseif chains
  - Optimasi kondisi ordering
  - Avoiding deep nesting

- **Praktik Intensif (4 jam)**
  - Program kalkulator sederhana
  - Sistem grading otomatis
  - Game "Guess the Number"
  - Validator form kompleks

### 2.2 Pattern Matching dan Switch Alternatives

- **Teori (2 jam)**

  - Lua tidak memiliki switch statement
  - Table-based dispatch patterns
  - Function lookup tables
  - Performance considerations

- **Implementasi (3 jam)**
  ```lua
  local actions = {
    ["add"] = function(a, b) return a + b end,
    ["sub"] = function(a, b) return a - b end,
    ["mul"] = function(a, b) return a * b end
  }
  ```
  - Menu-driven applications
  - Command processing systems
  - State machines sederhana

---

## Modul 3: Loops - Bagian 1 (Minggu 3)

### 3.1 While Loops

- **Sintaks dan Konsep (2 jam)**

  ```lua
  while condition do
    -- statements
  end
  ```

  - Pre-condition loops
  - Loop invariants
  - Infinite loops dan cara menghindarinya

- **Repeat-Until Loops (2 jam)**

  ```lua
  repeat
    -- statements
  until condition
  ```

  - Post-condition loops
  - Perbedaan dengan while
  - Use cases yang tepat

- **Praktik (4 jam)**
  - Input validation loops
  - Game loops sederhana
  - Menu systems
  - Data processing dengan unknown size

### 3.2 Loop Control

- **Break dan Continue Alternatives (2 jam)**

  - `break` statement
  - Lua tidak memiliki `continue`
  - Workarounds untuk continue behavior
  - Goto statements (Lua 5.2+)

- **Praktik Advanced (3 jam)**
  - Nested loops dengan proper exit strategies
  - Search algorithms implementation
  - Prime number generators
  - Pattern searching dalam strings

---

## Modul 4: Loops - Bagian 2 (Minggu 4)

### 4.1 Numeric For Loops

- **Sintaks Dasar (2 jam)**

  ```lua
  for i = start, finish, step do
    -- statements
  end
  ```

  - Forward dan backward iteration
  - Step values dan floating point
  - Scope dari loop variables

- **Advanced Numeric Loops (2 jam)**

  - Dynamic bounds calculation
  - Nested numeric loops
  - Matrix operations
  - Performance optimization tips

- **Praktik (4 jam)**
  - Array processing algorithms
  - Mathematical series calculations
  - Simple graphics dengan ASCII art
  - Sorting algorithms implementation

### 4.2 Generic For Loops

- **Iterator Concepts (3 jam)**

  - `pairs()` untuk tables
  - `ipairs()` untuk arrays
  - `next()` function
  - Custom iterators

- **String Iteration (2 jam)**
  ```lua
  for char in string.gmatch(str, ".") do
    -- process each character
  end
  ```
  - Pattern matching dalam loops
  - File reading line by line
  - Complex string processing

---

## Modul 5: Advanced Control Flow (Minggu 5)

### 5.1 Nested Structures

- **Complex Nesting (3 jam)**

  - Loops dalam conditions
  - Conditions dalam loops
  - Multiple level nesting
  - Refactoring nested code

- **Performance Considerations (2 jam)**

  - Time complexity analysis
  - Space complexity
  - Optimization techniques
  - Profiling nested structures

- **Praktik (4 jam)**
  - 2D array processing
  - Nested menu systems
  - Game board algorithms (Tic-tac-toe, Chess basics)
  - Data structure traversal

### 5.2 Goto Statements (Lua 5.2+)

- **Sintaks dan Penggunaan (2 jam)**

  ```lua
  ::label::
  -- statements
  goto label
  ```

  - Label declarations
  - Forward dan backward jumps
  - Restrictions dan limitations

- **Best Practices (1 jam)**
  - Kapan menggunakan goto
  - Alternatif yang lebih baik
  - Code maintainability issues

---

## Modul 6: Error Handling dan Control Flow (Minggu 6)

### 6.1 Error Handling Basics

- **Pcall dan Xpcall (3 jam)**

  ```lua
  local success, result = pcall(function()
    -- risky operations
  end)
  ```

  - Protected calls
  - Error propagation
  - Custom error messages

- **Assert Functions (2 jam)**
  ```lua
  assert(condition, "Error message")
  ```
  - Precondition checking
  - Debugging dengan assert
  - Performance impact

### 6.2 Control Flow dengan Error Handling

- **Integration Patterns (3 jam)**

  - Try-catch simulation
  - Error handling dalam loops
  - Graceful degradation
  - Recovery strategies

- **Praktik (3 jam)**
  - File processing dengan error handling
  - Network operations simulation
  - Robust input validation
  - Error logging systems

---

## Modul 7: Functional Control Flow (Minggu 7)

### 7.1 Higher-Order Functions

- **Functional Programming Concepts (3 jam)**

  - Functions sebagai first-class citizens
  - Closures dan lexical scoping
  - Callback patterns
  - Function composition

- **Control Flow Functions (2 jam)**
  ```lua
  local function map(func, tbl)
    local result = {}
    for i, v in ipairs(tbl) do
      result[i] = func(v)
    end
    return result
  end
  ```
  - Map, filter, reduce implementations
  - Custom control flow functions

### 7.2 Coroutines dan Flow Control

- **Coroutine Basics (4 jam)**

  ```lua
  local co = coroutine.create(function()
    -- coroutine body
  end)
  ```

  - Coroutine states
  - Yield dan resume
  - Collaborative multitasking
  - Generator patterns

- **Advanced Applications (2 ham)**
  - State machines dengan coroutines
  - Async-like programming
  - Producer-consumer patterns

---

## Modul 8: Optimization dan Best Practices (Minggu 8)

### 8.1 Performance Optimization

- **Profiling (2 jam)**

  - Measuring execution time
  - Memory usage analysis
  - Bottleneck identification
  - Benchmark creation

- **Optimization Techniques (3 jam)**
  - Loop optimization
  - Condition reordering
  - Table pre-allocation
  - Function call optimization

### 8.2 Code Quality dan Maintainability

- **Best Practices (3 jam)**

  - Readable control flow
  - Avoiding deep nesting
  - Meaningful variable names
  - Documentation standards

- **Testing (2 jam)**
  - Unit testing control flow
  - Edge case identification
  - Test-driven development
  - Debugging techniques

---

## Proyek Akhir dan Evaluasi

### Proyek Capstone (8-10 jam)

Pilih salah satu proyek berikut:

1. **Game Engine Sederhana**

   - Game loop implementation
   - State management
   - Input handling
   - Collision detection

2. **Text Processing Tool**

   - File parsing
   - Pattern matching
   - Data transformation
   - Report generation

3. **Interpreter Mini**
   - Tokenizer implementation
   - Parser dengan recursive descent
   - Expression evaluator
   - Control flow execution

### Evaluasi dan Assessment

- **Quiz Mingguan (20%)**
- **Praktik Coding (40%)**
- **Proyek Capstone (30%)**
- **Peer Review (10%)**

---

## Sumber Daya Pembelajaran

### Buku Referensi

- "Programming in Lua" oleh Roberto Ierusalimschy
- "Lua Programming Gems" - koleksi artikel advanced
- "Beginning Lua Programming" oleh Kurt Jung

### Tools dan Environment

- Lua standalone interpreter
- LuaJIT untuk performance
- VS Code dengan Lua extension
- Online REPL untuk eksperimen cepat

### Proyek Latihan Tambahan

1. Conway's Game of Life
2. Maze solver algorithms
3. Simple web server dengan control flow
4. Calculator dengan complex expressions
5. File system walker
6. Log analyzer
7. Simple compiler frontend
8. Chat bot dengan state machine

---

## Kriteria Kelulusan

Untuk menyelesaikan kurikulum ini, peserta harus:

1. **Menguasai semua konsep dasar (80% accuracy)**

   - If-else statements
   - All loop types
   - Basic error handling

2. **Implementasi proyek dengan baik (75% completeness)**

   - Code functionality
   - Code quality
   - Documentation

3. **Demonstrasi pemahaman advanced (70% proficiency)**

   - Nested control structures
   - Performance considerations
   - Best practices application

4. **Peer review dan collaboration**
   - Code review participation
   - Knowledge sharing
   - Problem-solving collaboration

---

## Pengembangan Lanjutan

Setelah menyelesaikan kurikulum ini, peserta dapat melanjutkan ke:

- **Advanced Lua Programming**
- **Lua C API Integration**
- **Game Development dengan Lua**
- **Web Development dengan OpenResty**
- **Embedded Systems Programming**
- **Domain-Specific Languages dengan Lua**

**Highlight Utama Kurikulum:**

🎯 **Struktur Progresif** - Dimulai dari konsep dasar hingga teknik advanced
📚 **8 Modul Komprehensif** - Setiap modul fokus pada aspek spesifik control flow
⏱️ **40-50 jam pembelajaran** dengan balance teori dan praktik
🛠️ **Hands-on Projects** - Dari calculator sederhana hingga game engine

**Cakupan Materi Lengkap:**

- Boolean logic dan conditional statements
- Semua jenis loops (while, repeat-until, for numeric, for generic)
- Nested structures dan optimization
- Error handling terintegrasi
- Functional programming approaches
- Coroutines untuk advanced flow control
- Performance optimization dan best practices

**Keunggulan Kurikulum:**
✅ Mencakup semua aspek control flow di Lua
✅ Praktik intensif dengan proyek nyata
✅ Assessment yang komprehensif
✅ Sumber daya pembelajaran lengkap
✅ Path pengembangan lanjutan yang jelas

Kurikulum ini cocok untuk programmer pemula hingga menengah yang ingin menguasai control flow di Lua secara mendalam. Setiap modul dilengkapi dengan teori, praktik, dan studi kasus yang relevan. Ini memberikan fondasi yang kuat untuk semua jalur pengembangan tersebut dengan fokus mendalam pada control flow sebagai inti dari programming logic.
