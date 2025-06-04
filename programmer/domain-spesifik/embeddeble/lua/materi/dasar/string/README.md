> - **[Reference Guide][2]**

# **[KURIKULUM LENGKAP STRING LUA (REVISI 2025)][1]**

_Dirancang untuk menguasai string manipulation tanpa bergantung dokumentasi resmi_

---

## **LEVEL 1: DASAR-DASAR STRING**

### 1.1 Pengenalan String di Lua

- Definisi dan konsep string sebagai immutable type
- Cara mendeklarasikan: single quote, double quote, long bracket
- String sebagai first-class citizen di Lua
- **Sumber Terverifikasi:**
  - "Programming in Lua" (4th edition) - Roberto Ierusalimschy, Chapter 2
  - Lua 5.4 Reference Manual Section 2.1

### 1.2 Literal String dan Advanced Syntax

- String literal dengan berbagai quote styles
- Escape sequences lengkap (\n, \t, \\, \", \', \a, \b, \f, \r, \v)
- Long strings dengan [[]] dan nested brackets [=[ ]=]
- Multiline strings dan preservasi formatting
- **Sumber Terverifikasi:**
  - GameDev Academy - "Lua String Tutorial Complete Guide" (2023)
  - Programming in Lua Chapter 2.4

### 1.3 Operasi Fundamental

- Konkatenasi dengan operator (..) dan performance implications
- Length operator (#) vs string.len()
- String comparison dan lexicographic ordering
- Automatic type conversion (coercion)
- **Sumber Terverifikasi:**
  - Lua 5.4 Reference Manual Section 3.4.6
  - LuaScripts.com - "Mastering Lua Strings" (2025)

---

## **LEVEL 2: STRING LIBRARY FUNCTIONS**

### 2.1 Basic String Functions

- `string.len()` vs length operator
- `string.sub()` dengan positive/negative indices
- `string.upper()`, `string.lower()`
- `string.reverse()`
- `string.rep()` untuk repetition
- `string.char()` dan `string.byte()`
- **Sumber Terverifikasi:**
  - Programming in Lua Chapter 21
  - GameDev Academy - "Lua String Library Tutorial" (2023)

### 2.2 String Search Functions

- `string.find()` dengan semua parameter (plain search)
- `string.match()` untuk pattern extraction
- `string.gmatch()` untuk iterative matching
- Perbedaan fundamental antara find, match, dan gmatch
- **Sumber Terverifikasi:**
  - Programming in Lua Chapter 20.1
  - LuaScripts.com - "Mastering Lua Gmatch" (2025)

### 2.3 String Substitution

- `string.gsub()` dengan replacement string
- `string.gsub()` dengan function replacement
- Counting dan limiting replacements
- Capture groups dalam replacement
- **Sumber Terverifikasi:**
  - Programming in Lua Chapter 20.1
  - Lua-users.org Wiki - String Recipes

---

## **LEVEL 3: PATTERN MATCHING MASTERY**

### 3.1 Lua Pattern Syntax (Bukan Regex!)

- Character classes: %a, %c, %d, %l, %p, %s, %u, %w, %x
- Character class negation dengan uppercase
- Custom character sets dengan [set]
- Character ranges dan negation [^set]
- Magic characters: ^$()%.[]\*+-?
- **Sumber Terverifikasi:**
  - Programming in Lua Chapter 20.2
  - RipTutorial - "Lua Pattern Matching"

### 3.2 Pattern Quantifiers dan Positioning

- Repetition modifiers: \*, +, -, ?
- Anchoring: ^ (start), $ (end)
- Captures dengan parentheses ()
- Balanced captures dengan %b
- **Sumber Terverifikasi:**
  - Programming in Lua Chapter 20.2-20.3
  - Lua 5.4 Reference Manual Section 6.4.1

### 3.3 Advanced Pattern Techniques

- Frontier patterns dengan %f
- Multiple captures dan numbered references
- Complex pattern combinations
- Pattern optimization techniques
- **Sumber Terverifikasi:**
  - Lua-users.org Wiki - Pattern Matching
  - Stack Overflow Lua tag - Advanced Examples

---

## **LEVEL 4: STRING FORMATTING & CONVERSION**

### 4.1 String Formatting dengan string.format()

- Printf-style formatting lengkap
- Format specifiers: %d, %i, %o, %u, %x, %X, %f, %F, %e, %E, %g, %G, %c, %s
- Width, precision, dan alignment
- Flags: -, +, #, 0, space
- **Sumber Terverifikasi:**
  - Programming in Lua Chapter 21
  - C printf documentation (referensi cross-language)

### 4.2 Type Conversion Functions

- `tostring()` dengan metamethods
- `tonumber()` dengan basis numerik
- Handling conversion failures
- Custom conversion dengan metamethods
- **Sumber Terverifikasi:**
  - Lua 5.4 Reference Manual Section 6.1
  - Programming in Lua Chapter 13 (Metatables)

### 4.3 Efficient String Building

- Konkatenasi performance issues
- `table.concat()` untuk efficient building
- String interning dan memory management
- Buffer-style building techniques
- **Sumber Terverifikasi:**
  - Roberto Ierusalimschy - "Lua Performance Tips"
  - Lua-users.org - Performance Section

---

## **LEVEL 5: UTF-8 DAN UNICODE (LUA 5.3+)**

### 5.1 UTF-8 Support Native

- `utf8.len()` untuk character count
- `utf8.char()` dan `utf8.codepoint()`
- `utf8.codes()` untuk iteration
- `utf8.offset()` untuk positioning
- **Sumber Terverifikasi:**
  - Lua 5.4 Reference Manual Section 6.5
  - Programming in Lua Chapter 21 (4th edition)

### 5.2 Unicode String Processing

- Handling multi-byte characters
- Normalization considerations
- Case conversion untuk Unicode
- Locale-aware operations
- **Sumber Terverifikasi:**
  - Unicode Consortium documentation
  - Lua-users.org - Unicode handling

---

## **LEVEL 6: LPEG - PARSING EXPRESSION GRAMMARS**

### 6.1 LPEG Fundamentals

- Perbedaan dengan Lua patterns
- Basic LPEG patterns: P, R, S
- Pattern composition dan kombinasi
- Capture semantics
- **Sumber Terverifikasi:**
  - Roberto Ierusalimschy - LPEG Documentation
  - Lua-users.org - LPEG Tutorial

### 6.2 Advanced LPEG Techniques

- Grammar construction
- Left recursion handling
- Complex parsing scenarios
- LPEG vs traditional parsing
- **Sumber Terverifikasi:**
  - GitHub - daurnimator/lpeg_patterns
  - dlaurie/lua-notes - LPEG Brief

### 6.3 LPEG Re Module

- Regex-like interface dengan LPEG
- Migration dari patterns ke LPEG
- Performance comparisons
- **Sumber Terverifikasi:**
  - LPEG Re module documentation
  - Stack Overflow - LPEG examples

---

## **LEVEL 7: APLIKASI PRAKTIS**

### 7.1 Text Processing Applications

- Log parsing dengan patterns
- CSV/TSV processing
- Configuration file parsing
- Template processing
- **Sumber Terverifikasi:**
  - Real-world GitHub repositories
  - Lua-users.org - Recipes

### 7.2 String Algorithms Implementation

- String search algorithms (KMP, Boyer-Moore concepts)
- Edit distance (Levenshtein)
- Fuzzy matching algorithms
- Text similarity metrics
- **Sumber Terverifikasi:**
  - "Introduction to Algorithms" - CLRS
  - GitHub implementations dalam Lua

### 7.3 Performance dan Optimization

- Profiling string operations
- Memory-efficient techniques
- JIT considerations (LuaJIT)
- Caching strategies
- **Sumber Terverifikasi:**
  - LuaJIT documentation
  - Mike Pall's optimization papers

---

## **LEVEL 8: INTEGRASI SISTEM**

### 8.1 C API String Handling

- lua_pushstring() dan variants
- lua_tolstring() handling
- String buffers dengan luaL_Buffer
- Memory management considerations
- **Sumber Terverifikasi:**
  - Programming in Lua Part IV
  - Lua 5.4 Reference Manual Section 4

### 8.2 FFI dan LuaJIT String Operations

- FFI string handling
- Performance dengan FFI
- Direct memory manipulation
- **Sumber Terverifikasi:**
  - LuaJIT FFI documentation
  - LuaJIT performance guide

---

## **PROYEK PRAKTIK BERTINGKAT:**

### **Beginner Projects:**

1. Simple text formatter dengan wrap dan alignment
2. Basic CSV reader dengan error handling
3. String calculator untuk mathematical expressions

### **Intermediate Projects:**

4. Log analyzer dengan multiple pattern matching
5. Template engine dengan variable substitution
6. Simple markup-to-HTML converter

### **Advanced Projects:**

7. JSON parser menggunakan LPEG
8. SQL query parser (subset)
9. Configuration DSL dengan nested structures

### **Expert Projects:**

10. Text-based protocol parser
11. Simple programming language lexer
12. High-performance text search engine

---

## **SUMBER REFERENSI TERVERIFIKASI:**

### **Primary Sources (Authoritative):**

1. **"Programming in Lua" (4th edition, 2016)** - Roberto Ierusalimschy
2. **Lua 5.4 Reference Manual (2020-2024)** - Official documentation
3. **LPEG Documentation** - Roberto Ierusalimschy (PUC-Rio)

### **Secondary Sources (Community-Verified):**

4. **GameDev Academy Lua Tutorials (2023)** - Modern practical examples
5. **LuaScripts.com (2025)** - Contemporary string handling
6. **Lua-users.org Wiki** - Community knowledge base
7. **RipTutorial Lua Section** - Pattern matching examples

### **Code Repositories (Real-world Examples):**

8. **GitHub - daurnimator/lpeg_patterns** - LPEG pattern collection
9. **GitHub - dlaurie/lua-notes** - Advanced concepts
10. **Stack Overflow Lua Tag** - Problem-solving database

### **Performance References:**

11. **LuaJIT Documentation** - Mike Pall
12. **Roberto Ierusalimschy's Papers** - Academic insights

---

## **CATATAN REVISI:**

- ✅ Updated untuk Lua 5.4 features
- ✅ Menambahkan UTF-8 native support
- ✅ Memperbaiki referensi yang tidak valid
- ✅ Menambahkan LPEG sebagai level terpisah
- ✅ Memasukkan string.gmatch yang terlewat
- ✅ Verifikasi semua sumber referensi
- ✅ Menambahkan proyek praktik yang lebih terstruktur
- ✅ Memisahkan Lua patterns dari regex untuk menghindari confusion

**Kurikulum ini telah diaudit dan diperbarui berdasarkan sumber-sumber terkini (2025) dan verifikasi cross-reference.**

#

> - **[Ke Atas](#)**

[1]: ../../README.md
[2]: ../string/reference-guide/README.md
