# Kurikulum Lengkap Numbers & Math di Lua

_Dari Pemula hingga Mahir_

## 🔍 **LEVEL 1.5: VERSION COMPATIBILITY & DIFFERENCES**

### 1.5.1 Lua Version Math Differences

- **Topik**: Perbedaan implementasi matematika antar versi Lua
- **Materi**:
  - Lua 5.1: Number sebagai double precision floating point
  - Lua 5.2: Tambahan math.ult untuk unsigned comparison
  - Lua 5.3: Integer subtype, bitwise operators, math.maxinteger/mininteger
  - Lua 5.4: Tidak ada perubahan signifikan dari 5.3
  - Backward compatibility considerations
- **Sumber**:
  - [Lua Version History](http://lua-users.org/wiki/LuaVersionCompatibility)
  - [Lua 5.3 Changes](https://www.lua.org/manual/5.3/readme.html)

### 1.5.2 Number Representation Changes

- **Topik**: Evolusi sistem number di Lua
- **Materi**:
  - Lua 5.1/5.2: Pure floating point (double)
  - Lua 5.3+: Integer dan float subtypes
  - Automatic coercion rules
  - Performance implications
  - Migration strategies
- **Sumber**:
  - [Number System Evolution](http://lua-users.org/wiki/LuaFiveThree)
  - [Integer Implementation](https://www.lua.org/manual/5.3/manual.html#3.1)

## 🔢 **LEVEL 1: FUNDAMENTAL NUMBERS**

### 1.1 Pengenalan Number Types di Lua

- **Topik**: Integer vs Float, Number representation
- **Materi**:
  - Lua hanya memiliki satu tipe number (sejak Lua 5.3: integer dan float)
  - Automatic conversion antara integer dan float
  - Hexadecimal, octal, dan binary literals
- **Sumber**:
  - [Lua 5.4 Reference Manual - Numbers](https://www.lua.org/manual/5.4/manual.html#3.1)
  - [Programming in Lua - Numbers](https://www.lua.org/pil/2.3.html)

### 1.2 Basic Arithmetic Operations

- **Topik**: +, -, \*, /, //, %, ^, unary minus
- **Materi**:
  - Operator precedence: `^` > `not - (unary)` > `* / //` > `+ -` > `..` > relational > `and` > `or`
  - Associativity: Left-to-right kecuali `^` dan `..` (right-to-left)
  - Integer division (//) vs float division (/)
  - Modulo operation dengan negative numbers
  - Exponentiation dengan operator ^ (right associative)
  - Unary minus dan precedence-nya
- **Sumber**:
  - [Lua Tutorial - Arithmetic Operators](https://www.tutorialspoint.com/lua/lua_operators.htm)
  - [Programming in Lua - Operator Precedence](https://www.lua.org/pil/3.5.html)
  - [Learn Lua in Y Minutes - Math](https://learnxinyminutes.com/docs/lua/)

### 1.3 Number Literals dan Formats

- **Topik**: Berbagai cara menulis angka di Lua
- **Materi**:
  - Decimal: 123, 123.45, 1.23e4
  - Hexadecimal: 0x1A, 0x1.Ap4
  - Binary dan Octal (Lua 5.2+)
  - Scientific notation
- **Sumber**:
  - [Lua Users Wiki - Number Literals](http://lua-users.org/wiki/LuaTypesTutorial)
  - [Rosetta Code - Lua Numbers](https://rosettacode.org/wiki/Category:Lua)

## 🔀 **LEVEL 2.5: COMPREHENSIVE MATH LIBRARY FUNCTIONS**

### 2.5.1 Complete Function Inventory

- **Topik**: Semua fungsi math library di Lua 5.1-5.4
- **Materi**:
  - **Lua 5.1**: math.abs, math.acos, math.asin, math.atan, math.atan2, math.ceil, math.cos, math.cosh, math.deg, math.exp, math.floor, math.fmod, math.frexp, math.huge, math.ldexp, math.log, math.log10, math.max, math.min, math.modf, math.pi, math.pow, math.rad, math.random, math.randomseed, math.sin, math.sinh, math.sqrt, math.tan, math.tanh
  - **Lua 5.2**: + math.ult (unsigned less than)
  - **Lua 5.3**: + math.maxinteger, math.mininteger, math.tointeger, math.type, math.ult
  - **Lua 5.4**: Semua fungsi 5.3 tetap sama
- **Sumber**:
  - [Lua Version Comparison](http://lua-users.org/wiki/LuaVersionCompatibility)
  - [Complete Math Library Reference](https://www.lua.org/manual/5.4/manual.html#6.7)

### 2.5.2 Hyperbolic Functions

- **Topik**: math.sinh, math.cosh, math.tanh
- **Materi**:
  - math.sinh() untuk hyperbolic sine
  - math.cosh() untuk hyperbolic cosine
  - math.tanh() untuk hyperbolic tangent
  - Aplikasi dalam engineering dan physics
  - Relationship dengan exponential functions
- **Sumber**:
  - [Hyperbolic Functions Tutorial](https://www.lua.org/manual/5.4/manual.html#pdf-math.sinh)
  - [Mathematical Applications](https://rosettacode.org/wiki/Hyperbolic_functions#Lua)

### 2.5.3 Advanced Math Functions

- **Topik**: math.frexp, math.ldexp, math.fmod, math.ult
- **Materi**:
  - math.frexp() untuk fraction dan exponent extraction
  - math.ldexp() untuk loading exponent
  - math.fmod() untuk floating-point remainder
  - math.ult() untuk unsigned comparison (Lua 5.2+)
  - IEEE 754 floating point manipulation
- **Sumber**:
  - [IEEE 754 Operations in Lua](http://lua-users.org/wiki/FloatingPoint)
  - [Advanced Math Functions](https://www.lua.org/manual/5.4/manual.html#6.7)

### 2.5.4 Type Checking dan Conversion Functions

- **Topik**: math.type, math.tointeger (Lua 5.3+)
- **Materi**:
  - math.type() untuk checking integer vs float
  - math.tointeger() untuk safe integer conversion
  - Handling conversion failures
  - Compatibility dengan older Lua versions
- **Sumber**:
  - [Lua 5.3 Number System](https://www.lua.org/manual/5.3/manual.html#3.1)
  - [Type System Changes](http://lua-users.org/wiki/LuaFiveThree)

## 📐 **LEVEL 2: MATH LIBRARY BASICS**

### 2.1 Konstanta Matematika

- **Topik**: math.pi, math.huge, math.mininteger, math.maxinteger
- **Materi**:
  - math.pi (3.141592653589793)
  - math.huge (positive infinity)
  - math.mininteger dan math.maxinteger (Lua 5.3+)
  - Infinity dan -infinity handling
  - NaN (Not a Number) detection
  - Comparison dengan infinity values
- **Sumber**:
  - [Lua 5.4 Math Library](https://www.lua.org/manual/5.4/manual.html#6.7)
  - [Programming in Lua - Math Library](https://www.lua.org/pil/18.html)
  - [Lua Source Code - lmathlib.c](https://www.lua.org/source/5.4/lmathlib.c.html)

### 2.2 Basic Math Functions

- **Topik**: abs, floor, ceil, min, max
- **Materi**:
  - math.abs() untuk absolute value
  - math.floor() dan math.ceil() untuk rounding
  - math.min() dan math.max() untuk comparison
  - Handling multiple arguments
- **Sumber**:
  - [Lua Math Functions Tutorial](https://www.geeksforgeeks.org/lua-math-library/)
  - [Lua Quick Reference - Math](http://www.lua.org/manual/5.4/manual.html#6.7)

### 2.3 Rounding dan Truncation

- **Topik**: Berbagai teknik pembulatan
- **Materi**:
  - math.floor() vs math.ceil()
  - math.modf() untuk memisahkan integer dan fractional part
  "../../number"- Implementasi custom rounding functions
  - Banker's rounding dan teknik lainnya
- **Sumber**:
  - [Stack Overflow - Lua Rounding](https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate)
  - [Lua Users Wiki - Rounding](http://lua-users.org/wiki/SimpleRound)

## ⚠️ **LEVEL 3.5: ERROR HANDLING & EDGE CASES**

### 3.5.1 Mathematical Error Handling

- **Topik**: Domain errors, overflow, underflow
- **Materi**:
  - Division by zero behavior
  - Square root of negative numbers
  - Logarithm of non-positive numbers
  - Domain errors di trigonometric functions
  - NaN propagation rules
  - Infinity arithmetic rules
- **Sumber**:
  - [IEEE 754 Error Handling](https://en.wikipedia.org/wiki/IEEE_754)
  - [Lua Error Handling](http://lua-users.org/wiki/ErrorHandling)

### 3.5.2 Range dan Precision Limits

- **Topik**: Numerical limits dan precision
- **Materi**:
  - Machine epsilon dan floating point precision
  - Integer overflow behavior (Lua 5.3+)
  - Subnormal numbers
  - Loss of significance
  - Catastrophic cancellation examples
- **Sumber**:
  - [Floating Point Arithmetic](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html)
  - [Numerical Precision Issues](http://lua-users.org/wiki/FloatingPoint)

### 3.5.3 Cross-Platform Considerations

- **Topik**: Platform-specific behavior
- **Materi**:
  - Endianness effects
  - Different math library implementations
  - Precision differences across platforms
  - Performance variations
- **Sumber**:
  - [Platform Portability](http://lua-users.org/wiki/LuaPortability)
  - [Cross-Platform Testing](https://stackoverflow.com/questions/tagged/lua+portability)

## 🧮 **LEVEL 3: ADVANCED ARITHMETIC**

### 3.1 Trigonometric Functions

- **Topik**: sin, cos, tan, asin, acos, atan, atan2
- **Materi**:
  - Radian vs degree conversion
  - Inverse trigonometric functions
  - math.atan2() untuk two-argument arctangent
  - Practical applications
- **Sumber**:
  - [Lua Trigonometry Tutorial](https://www.lua.org/manual/5.4/manual.html#pdf-math.sin)
  - [Programming Examples - Trig in Lua](https://www.rosettacode.org/wiki/Trigonometric_functions#Lua)

### 3.2 Logarithmic dan Exponential Functions

- **Topik**: exp, log, log10, sqrt, pow, deg, rad
- **Materi**:
  - math.exp() untuk e^x
  - math.log() untuk natural logarithm
  - math.log10() untuk base-10 logarithm
  - math.sqrt() dan alternative methods
  - math.pow() vs operator ^ (deprecated di Lua 5.3+)
  - math.deg() untuk radian ke degree conversion
  - math.rad() untuk degree ke radian conversion
  - Custom logarithm bases dengan change of base formula
- **Sumber**:
  - [Math Library Documentation](https://www.lua.org/manual/5.4/manual.html#6.7)
  - [Lua Cookbook - Mathematical Functions](http://lua-users.org/wiki/MathLibraryTutorial)
  - [Angle Conversion Examples](https://rosettacode.org/wiki/Convert_radians_to_degrees#Lua)

### 3.3 Power Functions dan Roots

- **Topik**: Berbagai cara menghitung pangkat dan akar
- **Materi**:
  - Operator ^ vs math.pow()
  - math.sqrt() vs x^0.5
  - Menghitung nth root
  - Handling negative bases dan fractional exponents
- **Sumber**:
  - [Lua Math Power Functions](https://stackoverflow.com/questions/tagged/lua+math)
  - [Programming Pearls - Power Functions](http://lua-users.org/wiki/PowerFunction)

## 🎲 **LEVEL 4: RANDOM NUMBERS & PROBABILITY**

### 4.1 Random Number Generation

- **Topik**: math.random, math.randomseed
- **Materi**:
  - math.random() tanpa argument
  - math.random(n) untuk integer 1 sampai n
  - math.random(m, n) untuk range
  - Setting seed dengan math.randomseed()
- **Sumber**:
  - [Lua Random Numbers Guide](https://www.lua.org/manual/5.4/manual.html#pdf-math.random)
  - [Random Number Tutorial](http://lua-users.org/wiki/MathLibraryTutorial#Random_Numbers)

### 4.2 Advanced Random Techniques

- **Topik**: Distribusi probabilitas dan teknik sampling
- **Materi**:
  - Uniform distribution
  - Normal distribution (Box-Muller transform)
  - Weighted random selection
  - Shuffle algorithms
- **Sumber**:
  - [Lua Users Wiki - Random](http://lua-users.org/wiki/RandomSeed)
  - [Algorithm Implementation - Random](<https://rosettacode.org/wiki/Random_number_generator_(included)#Lua>)

### 4.3 Cryptographically Secure Random

- **Topik**: Alternative untuk kebutuhan keamanan
- **Materi**:
  - Keterbatasan math.random() untuk cryptography
  - Menggunakan external libraries
  - Platform-specific solutions
- **Sumber**:
  - [Security Considerations](https://security.stackexchange.com/questions/tagged/lua)
  - [Lua Crypto Libraries](https://luarocks.org/search?q=crypto)

## 🔢 **LEVEL 5: NUMBER MANIPULATION & FORMATTING**

### 5.1 String to Number Conversion

- **Topik**: tonumber(), string parsing
- **Materi**:
  - tonumber() dengan berbagai bases
  - Handling parsing errors
  - Custom parsing functions
  - Locale considerations
- **Sumber**:
  - [Lua Manual - tonumber](https://www.lua.org/manual/5.4/manual.html#pdf-tonumber)
  - [String to Number Tutorial](http://lua-users.org/wiki/StringToNumber)

### 5.2 Number to String Formatting

- **Topik**: tostring(), string.format()
- **Materi**:
  - Basic tostring() conversion
  - string.format() dengan format specifiers
  - Precision control untuk floating point
  - Scientific notation formatting
- **Sumber**:
  - [Lua String Formatting](https://www.lua.org/manual/5.4/manual.html#pdf-string.format)
  - [Format String Tutorial](http://lua-users.org/wiki/StringLibraryTutorial)

### 5.3 Custom Number Formatting

- **Topik**: Thousand separators, currency, custom formats
- **Materi**:
  - Adding commas untuk thousand separators
  - Currency formatting
  - Scientific notation custom
  - Locale-aware formatting
- **Sumber**:
  - [Number Formatting Examples](http://lua-users.org/wiki/FormattingNumbers)
  - [Locale-Aware Formatting](https://stackoverflow.com/questions/tagged/lua+formatting)

## 🎭 **LEVEL 6.5: MATHEMATICAL METAMETHODS**

### 6.5.1 Arithmetic Metamethods

- **Topik**: Overloading mathematical operators
- **Materi**:
  - **add, **sub, **mul, **div untuk basic arithmetic
  - **mod, **pow untuk modulo dan exponentiation
  - \_\_unm untuk unary minus
  - \_\_idiv untuk integer division (Lua 5.3+)
  - Creating custom number types
- **Sumber**:
  - [Metamethods Reference](https://www.lua.org/manual/5.4/manual.html#2.4)
  - [Custom Number Types](http://lua-users.org/wiki/LuaTypesTutorial)

### 6.5.2 Comparison Metamethods

- **Topik**: Mathematical comparisons
- **Materi**:
  - \_\_eq untuk equality
  - **lt, **le untuk ordering
  - Implementing total ordering
  - NaN comparison handling
- **Sumber**:
  - [Comparison Metamethods](https://www.lua.org/pil/13.2.html)
  - [Ordering Examples](http://lua-users.org/wiki/MetamethodsTutorial)

### 6.5.3 Advanced Mathematical Metamethods

- **Topik**: String conversion dan advanced features
- **Materi**:
  - \_\_tostring untuk custom formatting
  - \_\_concat untuk mathematical objects
  - \_\_call untuk function-like objects
  - Complex number implementation example
- **Sumber**:
  - [Advanced Metamethods](http://lua-users.org/wiki/GeneralizedPairsAndIpairs)
  - [Mathematical Object Implementation](http://lua-users.org/wiki/ComplexNumbers)

## 🧪 **LEVEL 6: BIT OPERATIONS**

### 6.1 Bitwise Operations Basics

- **Topik**: &, |, ~, <<, >>, ~ (Lua 5.3+)
- **Materi**:
  - Bitwise AND, OR, XOR
  - Left dan right shift
  - Bitwise NOT
  - Converting between bit operations dan arithmetic
- **Sumber**:
  - [Lua 5.3 Bitwise Operators](https://www.lua.org/manual/5.3/manual.html#3.4.2)
  - [Bit Operations Tutorial](http://lua-users.org/wiki/BitwiseOperators)

### 6.2 Bit Library (Lua 5.1/5.2)

- **Topik**: bit32 library untuk older versions
- **Materi**:
  - bit32.band, bit32.bor, bit32.bxor
  - bit32.lshift, bit32.rshift
  - bit32.bnot, bit32.extract, bit32.replace
- **Sumber**:
  - [Bit32 Library Documentation](https://www.lua.org/manual/5.2/manual.html#6.7)
  - [LuaBit Library](http://bitop.luajit.org/)

### 6.3 Advanced Bit Manipulation

- **Topik**: Bit flags, masks, dan advanced techniques
- **Materi**:
  - Using bits untuk flags
  - Bit masks dan filtering
  - Bit counting dan population count
  - Gray code dan other bit patterns
- **Sumber**:
  - [Bit Manipulation Tricks](http://lua-users.org/wiki/BitManipulation)
  - [Algorithms - Bit Operations](https://rosettacode.org/wiki/Category:Lua)

## 📊 **LEVEL 7: ADVANCED MATHEMATICAL CONCEPTS**

### 7.1 Complex Numbers

- **Topik**: Implementing complex number arithmetic
- **Materi**:
  - Creating complex number data structure
  - Basic operations (+, -, \*, /)
  - Magnitude, phase, conjugate
  - Polar form conversion
- **Sumber**:
  - [Complex Numbers in Lua](http://lua-users.org/wiki/ComplexNumbers)
  - [Mathematical Libraries](https://luarocks.org/search?q=math)

### 7.2 Matrix Operations

- **Topik**: Basic linear algebra
- **Materi**:
  - Matrix representation
  - Matrix multiplication
  - Determinant calculation
  - Matrix inversion basics
- **Sumber**:
  - [Matrix Libraries for Lua](https://luarocks.org/search?q=matrix)
  - [Linear Algebra Examples](http://lua-users.org/wiki/LinearAlgebra)

### 7.3 Statistical Functions

- **Topik**: Descriptive statistics
- **Materi**:
  - Mean, median, mode
  - Standard deviation dan variance
  - Correlation coefficients
  - Basic hypothesis testing
- **Sumber**:
  - [Statistics Libraries](https://luarocks.org/search?q=statistics)
  - [Statistical Computing in Lua](http://lua-users.org/wiki/Statistics)

## 🐛 **LEVEL 8.5: DEBUGGING & PROFILING MATHEMATICAL CODE**

### 8.5.1 Mathematical Debugging Techniques

- **Topik**: Debugging numerical computations
- **Materi**:
  - Assertion-based testing untuk mathematical properties
  - Logging intermediate calculations
  - Visualizing numerical data
  - Unit testing mathematical functions
- **Sumber**:
  - [Debugging Lua Code](http://lua-users.org/wiki/DebuggingLuaCode)
  - [Mathematical Testing](https://busted.org/)

### 8.5.2 Performance Profiling

- **Topik**: Measuring mathematical performance
- **Materi**:
  - Timing mathematical operations
  - Memory usage profiling
  - Bottleneck identification
  - Benchmarking different approaches
- **Sumber**:
  - [Lua Profiling Tools](http://lua-users.org/wiki/ProfilingLuaCode)
  - [Performance Analysis](https://luajit.org/running.html)

### 8.5.3 Numerical Validation

- **Topik**: Ensuring correctness of calculations
- **Materi**:
  - Reference implementation testing
  - Property-based testing untuk mathematical functions
  - Regression testing
  - Cross-validation dengan other languages
- **Sumber**:
  - [Property-Based Testing](https://github.com/luc-tielen/lua-quickcheck)
  - [Mathematical Validation Techniques](http://lua-users.org/wiki/UnitTesting)

## 🚀 **LEVEL 8: PERFORMANCE & OPTIMIZATION**

### 8.1 Numerical Performance

- **Topik**: Optimizing mathematical computations
- **Materi**:
  - Integer vs float performance
  - Loop optimization untuk calculations
  - Memory allocation considerations
  - LuaJIT-specific optimizations
- **Sumber**:
  - [LuaJIT Performance Guide](https://luajit.org/performance.html)
  - [Optimization Techniques](http://lua-users.org/wiki/OptimisationTips)

### 8.2 Numerical Precision dan Stability

- **Topik**: Floating point precision issues
- **Materi**:
  - IEEE 754 standard basics
  - Epsilon comparisons
  - Catastrophic cancellation
  - Numerical stability techniques
- **Sumber**:
  - [Floating Point Guide](https://floating-point-gui.de/)
  - [Numerical Precision in Lua](http://lua-users.org/wiki/FloatingPoint)

### 8.3 Big Number Libraries

- **Topik**: Arbitrary precision arithmetic
- **Materi**:
  - When to use big numbers
  - Available libraries (lua-gmp, etc.)
  - Performance trade-offs
  - Integration dengan existing code
- **Sumber**:
  - [Big Number Libraries](https://luarocks.org/search?q=bignum)
  - [Arbitrary Precision Arithmetic](http://lua-users.org/wiki/BigNumbers)

## 🛠️ **LEVEL 9: PRACTICAL APPLICATIONS**

### 9.1 Financial Calculations

- **Topik**: Money dan financial math
- **Materi**:
  - Interest calculations
  - Loan amortization
  - Present value, future value
  - Avoiding floating point errors dengan money
- **Sumber**:
  - [Financial Math Examples](https://rosettacode.org/wiki/Category:Finance)
  - [Decimal Libraries for Money](https://luarocks.org/search?q=decimal)

### 9.2 Game Mathematics

- **Topik**: Math untuk game development
- **Materi**:
  - 2D/3D vector operations
  - Collision detection
  - Interpolation (lerp, slerp)
  - Noise functions
- **Sumber**:
  - [Game Math Libraries](https://luarocks.org/search?q=vector)
  - [LÖVE Framework Math](https://love2d.org/wiki/Category:Modules)

### 9.3 Scientific Computing

- **Topik**: Numerical methods
- **Materi**:
  - Numerical integration
  - Root finding algorithms
  - Differential equation solving
  - Curve fitting
- **Sumber**:
  - [Scientific Computing Libraries](https://luarocks.org/search?q=science)
  - [Numerical Methods](http://lua-users.org/wiki/NumericalMethods)

## 📖 **LEVEL 10: EXTERNAL LIBRARIES & TOOLS**

### 10.1 Popular Math Libraries

- **Topik**: Extending Lua's math capabilities
- **Materi**:
  - LuaJIT FFI dengan math libraries
  - Torch/OpenResty integrations
  - Specialized domain libraries
- **Sumber**:
  - [LuaRocks Math Category](https://luarocks.org/search?q=mathematics)
  - [FFI Math Examples](http://luajit.org/ext_ffi_tutorial.html)

### 10.2 Interfacing dengan C Math Libraries

- **Topik**: Using C libraries dari Lua
- **Materi**:
  - Creating Lua C extensions
  - Using FFI untuk math functions
  - Performance considerations
- **Sumber**:
  - [Lua C API](https://www.lua.org/manual/5.4/manual.html#4)
  - [Creating C Extensions](http://lua-users.org/wiki/CApiTutorial)

### 10.3 Testing Mathematical Code

- **Topik**: Unit testing untuk numerical code
- **Materi**:
  - Assertion techniques untuk floating point
  - Property-based testing
  - Benchmarking mathematical functions
- **Sumber**:
  - [Lua Testing Frameworks](https://luarocks.org/search?q=test)
  - [Numerical Testing Strategies](http://lua-users.org/wiki/UnitTesting)

---

## 📚 **REFERENSI TAMBAHAN**

### Dokumentasi Resmi

- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/)
- [Programming in Lua (4th edition)](https://www.lua.org/pil/)

### Community Resources

- [Lua Users Wiki](http://lua-users.org/wiki/)
- [Lua Mailing List Archives](https://www.lua.org/lua-l.html)
- [Stack Overflow Lua Tag](https://stackoverflow.com/questions/tagged/lua)

### Libraries dan Tools

- [LuaRocks Package Manager](https://luarocks.org/)
- [LuaJIT Documentation](https://luajit.org/)
- [LÖVE 2D Game Framework](https://love2d.org/)

### Online Learning

- [Learn Lua in Y Minutes](https://learnxinyminutes.com/docs/lua/)
- [Rosetta Code Lua Examples](https://rosettacode.org/wiki/Category:Lua)
- [Codecademy Lua Course](https://www.codecademy.com/learn/learn-lua)

---

## ✅ **MILESTONE CHECKLIST**

**Pemula (Level 1-3)**:

- [ ] Memahami number types di Lua dan version differences
- [ ] Menguasai operator precedence dan associativity
- [ ] Familiar dengan semua math library functions
- [ ] Dapat handle basic arithmetic dan rounding
- [ ] Memahami trigonometric dan logarithmic functions
- [ ] Tahu cara handle mathematical errors

**Menengah (Level 4-6)**:

- [ ] Dapat menggunakan random numbers effectively
- [ ] Menguasai number formatting dan conversion
- [ ] Memahami bit operations (semua versi Lua)
- [ ] Dapat implement mathematical metamethods
- [ ] Familiar dengan hyperbolic functions
- [ ] Tahu IEEE 754 floating point details

**Lanjutan (Level 7-9)**:

- [ ] Implementasi complex mathematical concepts
- [ ] Optimasi performance numerical code
- [ ] Aplikasi praktis di domain tertentu
- [ ] Debugging dan profiling mathematical code
- [ ] Handle numerical precision issues
- [ ] Create mathematical libraries

**Expert (Level 10)**:

- [ ] Integrasi dengan external libraries
- [ ] Cross-platform mathematical compatibility
- [ ] Advanced numerical algorithms implementation
- [ ] Kontribusi ke mathematical Lua libraries
- [ ] Mengajar others tentang Lua mathematics
- [ ] Research-level mathematical computing

**Advanced Competencies**:

- [ ] Understand IEEE 754 completely
- [ ] Can implement arbitrary precision arithmetic
- [ ] Master all Lua version mathematical differences
- [ ] Proficient in mathematical metamethods
- [ ] Expert in numerical stability analysis
- [ ] Can create domain-specific mathematical DSLs

---

### **🎯 KEUNGGULAN KURIKULUM INI:**

1. **Lebih Lengkap dari Dokumentasi Resmi**: Mencakup edge cases, error handling, dan aplikasi praktis
2. **Version-Agnostic**: Support untuk semua versi Lua yang masih digunakan
3. **Hands-on Approach**: Tidak hanya teori tapi implementasi praktis
4. **Industry-Ready**: Mencakup debugging, profiling, dan optimization
5. **Research-Level**: Advanced topics seperti arbitrary precision arithmetic

_Kurikulum ini dirancang untuk memberikan pemahaman mendalam tentang Numbers & Math di Lua tanpa perlu merujuk ke dokumentasi resmi, namun setiap topik dilengkapi dengan sumber referensi untuk pembelajaran lebih lanjut._
