# Panduan Lengkap Number dalam Lua - Dari Dasar hingga Mahir

## 1. Konsep Dasar Number di Lua

### 1.1 Tipe Data Number dalam Lua

Lua hanya memiliki SATU tipe data numerik yang disebut `number`. Secara internal, Lua menggunakan:

- **Double-precision floating-point** (IEEE 754) sebagai representasi default
- Sejak Lua 5.3: dukungan untuk **integer** dan **float** sebagai subtipe

```lua
-- Semua ini adalah tipe number
local a = 42        -- integer
local b = 3.14      -- float
local c = 1e10      -- scientific notation
local d = 0xFF      -- hexadecimal
local e = 0b1010    -- binary (Lua 5.3+)
local f = 0o777     -- octal (Lua 5.3+)

print(type(a))      -- "number"
print(type(b))      -- "number"
```

### 1.2 Representasi Internal Number

```lua
-- Cek apakah number adalah integer atau float
print(math.type(42))     -- "integer"
print(math.type(42.0))   -- "float"
print(math.type(42.5))   -- "float"

-- Konversi eksplisit
print(math.tointeger(42.7))  -- 42
print(math.tointeger(42.0))  -- 42
print(math.tointeger("42"))  -- 42
```

## 2. Berbagai Format Penulisan Number

### 2.1 Integer Literals

```lua
local decimal = 123
local negative = -456
local zero = 0

-- Hexadecimal (base 16)
local hex1 = 0xFF        -- 255
local hex2 = 0xDEADBEEF  -- 3735928559
local hex3 = 0xff        -- case insensitive

-- Binary (base 2) - Lua 5.3+
local bin1 = 0b1010      -- 10
local bin2 = 0B11110000  -- 240

-- Octal (base 8) - Lua 5.3+
local oct1 = 0o777       -- 511
local oct2 = 0O644       -- 420
```

### 2.2 Float Literals

```lua
-- Decimal notation
local float1 = 3.14
local float2 = 0.5
local float3 = .5        -- leading zero optional
local float4 = 5.        -- trailing zero optional

-- Scientific notation
local sci1 = 1e10        -- 10000000000
local sci2 = 1.5e-4      -- 0.00015
local sci3 = 2E+3        -- 2000.0
local sci4 = 1.23e+2     -- 123.0

-- Hexadecimal float (Lua 5.2+)
local hexfloat1 = 0x1.8p3    -- 1.5 * 2^3 = 12.0
local hexfloat2 = 0xA.Bp2    -- (10 + 11/16) * 2^2 = 42.75
```

### 2.3 Special Values

```lua
-- Infinity
local inf_pos = math.huge         -- positive infinity
local inf_neg = -math.huge        -- negative infinity
local inf_calc = 1/0              -- positive infinity

-- NaN (Not a Number)
local nan = 0/0
local nan2 = math.sqrt(-1)

-- Checking special values
print(inf_pos == math.huge)       -- true
print(nan == nan)                 -- false (NaN ≠ NaN)
print(nan ~= nan)                 -- true
```

## 3. Operasi Aritmatika

### 3.1 Operasi Dasar

```lua
local a, b = 10, 3

-- Operasi dasar
print(a + b)    -- 13 (addition)
print(a - b)    -- 7  (subtraction)
print(a * b)    -- 30 (multiplication)
print(a / b)    -- 3.333... (division)
print(a % b)    -- 1  (modulo)
print(a ^ b)    -- 1000 (exponentiation)

-- Floor division (Lua 5.3+)
print(a // b)   -- 3 (floor division)
print(-7 // 3)  -- -3
print(7 // -3)  -- -3
```

### 3.2 Operasi Unary

```lua
local x = 5
print(-x)       -- -5 (negation)
print(+x)       -- 5  (unary plus, no effect)

-- Increment/decrement (manual)
x = x + 1       -- increment
x = x - 1       -- decrement
```

### 3.3 Precedence dan Associativity

```lua
-- Precedence (highest to lowest):
-- ^
-- unary operators (- +)
-- * / // %
-- + -

print(2 + 3 * 4)        -- 14 (not 20)
print((2 + 3) * 4)      -- 20
print(2 ^ 3 ^ 2)        -- 512 (2^(3^2), right associative)
print((2 ^ 3) ^ 2)      -- 64
```

## 4. Konversi dan Casting

### 4.1 String ke Number

```lua
-- Automatic conversion
local str_num = "123"
print(str_num + 0)      -- 123
print(str_num * 1)      -- 123

-- Explicit conversion
print(tonumber("123"))      -- 123
print(tonumber("123.45"))   -- 123.45
print(tonumber("FF", 16))   -- 255 (hex)
print(tonumber("1010", 2))  -- 10 (binary)
print(tonumber("777", 8))   -- 511 (octal)

-- Error handling
print(tonumber("abc"))      -- nil
print(tonumber("12.34.56")) -- nil
```

### 4.2 Number ke String

```lua
local num = 123.456

-- Automatic conversion
print("Number: " .. num)    -- "Number: 123.456"

-- Explicit conversion
print(tostring(num))        -- "123.456"

-- Formatted conversion
print(string.format("%.2f", num))      -- "123.46"
print(string.format("%d", num))        -- "123"
print(string.format("%x", 255))        -- "ff"
print(string.format("%X", 255))        -- "FF"
print(string.format("%o", 255))        -- "377"
print(string.format("%e", num))        -- "1.234560e+02"
print(string.format("%g", num))        -- "123.456"
```

## 5. Math Library - Fungsi Matematika

### 5.1 Fungsi Dasar

```lua
-- Basic math functions
print(math.abs(-5))         -- 5
print(math.max(1,2,3,4,5))  -- 5
print(math.min(1,2,3,4,5))  -- 1
print(math.floor(3.7))      -- 3
print(math.ceil(3.2))       -- 4

-- Rounding
local function round(x)
    return math.floor(x + 0.5)
end
print(round(3.7))           -- 4
print(round(3.2))           -- 3
```

### 5.2 Fungsi Trigonometri

```lua
local angle = math.pi / 4   -- 45 degrees in radians

-- Trigonometric functions
print(math.sin(angle))      -- 0.707...
print(math.cos(angle))      -- 0.707...
print(math.tan(angle))      -- 1.0

-- Inverse trigonometric
print(math.asin(0.5))       -- 0.523... (30 degrees)
print(math.acos(0.5))       -- 1.047... (60 degrees)
print(math.atan(1))         -- 0.785... (45 degrees)
print(math.atan2(1, 1))     -- 0.785... (45 degrees)

-- Degree/Radian conversion
print(math.deg(math.pi))    -- 180
print(math.rad(180))        -- 3.141...
```

### 5.3 Fungsi Logaritma dan Eksponensial

```lua
-- Exponential and logarithm
print(math.exp(1))          -- 2.718... (e^1)
print(math.log(math.e))     -- 1 (natural log)
print(math.log10(100))      -- 2 (base 10 log)
print(math.log(8, 2))       -- 3 (log base 2 of 8)

-- Power functions
print(math.pow(2, 3))       -- 8 (same as 2^3)
print(math.sqrt(16))        -- 4
```

### 5.4 Konstanta Matematika

```lua
print(math.pi)              -- 3.141592653589793
print(math.huge)            -- inf
print(math.e or (math.exp(1))) -- 2.718281828459045 (if available)

-- Creating your own constants
local PHI = (1 + math.sqrt(5)) / 2  -- Golden ratio
print(PHI)                  -- 1.618...
```

## 6. Random Numbers

### 6.1 Basic Random Generation

```lua
-- Initialize random seed
math.randomseed(os.time())

-- Generate random numbers
print(math.random())        -- 0 to 1 (exclusive)
print(math.random(10))      -- 1 to 10 (inclusive)
print(math.random(5, 15))   -- 5 to 15 (inclusive)

-- Multiple calls
for i = 1, 5 do
    print(math.random(1, 100))
end
```

### 6.2 Advanced Random Techniques

```lua
-- Random float in range
local function randomFloat(min, max)
    return min + (max - min) * math.random()
end

print(randomFloat(1.5, 3.7))    -- random float between 1.5 and 3.7

-- Weighted random selection
local function weightedRandom(weights)
    local total = 0
    for _, weight in ipairs(weights) do
        total = total + weight
    end

    local r = math.random() * total
    local sum = 0
    for i, weight in ipairs(weights) do
        sum = sum + weight
        if r <= sum then
            return i
        end
    end
end

-- Example: 50% chance for 1, 30% for 2, 20% for 3
local weights = {50, 30, 20}
print(weightedRandom(weights))
```

## 7. Bitwise Operations (Lua 5.3+)

### 7.1 Basic Bitwise Operations

```lua
local a, b = 0b1100, 0b1010  -- 12 and 10 in binary

-- Bitwise operations
print(a & b)        -- 8  (AND: 1000)
print(a | b)        -- 14 (OR:  1110)
print(a ~ b)        -- 6  (XOR: 0110)
print(~a)           -- bitwise NOT
print(a << 2)       -- 48 (left shift)
print(a >> 2)       -- 3  (right shift)
```

### 7.2 Practical Bitwise Applications

```lua
-- Check if number is power of 2
local function isPowerOfTwo(n)
    return n > 0 and (n & (n - 1)) == 0
end

print(isPowerOfTwo(8))      -- true
print(isPowerOfTwo(10))     -- false

-- Extract specific bits
local function getBit(num, pos)
    return (num >> pos) & 1
end

local function setBit(num, pos)
    return num | (1 << pos)
end

local function clearBit(num, pos)
    return num & ~(1 << pos)
end

local number = 0b1010  -- 10
print(getBit(number, 1))        -- 1
print(setBit(number, 0))        -- 11 (1011)
print(clearBit(number, 1))      -- 8  (1000)
```

## 8. Precision dan Floating Point Issues

### 8.1 Floating Point Precision

```lua
-- Common precision issues
print(0.1 + 0.2)            -- 0.30000000000000004 (not exactly 0.3)
print(0.1 + 0.2 == 0.3)     -- false

-- Safe comparison for floats
local function floatEqual(a, b, epsilon)
    epsilon = epsilon or 1e-10
    return math.abs(a - b) < epsilon
end

print(floatEqual(0.1 + 0.2, 0.3))  -- true

-- Machine epsilon
local function machineEpsilon()
    local eps = 1.0
    while 1.0 + eps > 1.0 do
        eps = eps / 2.0
    end
    return eps * 2.0
end

print(machineEpsilon())     -- approximately 2.22e-16
```

### 8.2 Integer vs Float Behavior

```lua
-- Integer arithmetic (exact)
print(math.type(3 + 4))     -- "integer"
print(3 + 4 == 7)           -- true (exact)

-- Float arithmetic (approximate)
print(math.type(3.0 + 4.0)) -- "float"
print(3.0 + 4.0 == 7.0)     -- true (but may have precision issues)

-- Mixed arithmetic
print(math.type(3 + 4.0))   -- "float" (result is float)
print(math.type(3.0 + 4))   -- "float" (result is float)
```

## 9. Advanced Number Manipulation

### 9.1 Number Parsing dan Validation

```lua
-- Advanced number parsing
local function parseNumber(str)
    -- Remove whitespace
    str = str:match("^%s*(.-)%s*$")

    -- Check for empty string
    if str == "" then return nil end

    -- Try to convert
    local num = tonumber(str)
    if num then
        return num, math.type(num)
    end

    -- Try different bases
    if str:match("^0x") then
        return tonumber(str, 16), "integer"
    elseif str:match("^0b") then
        return tonumber(str:sub(3), 2), "integer"
    elseif str:match("^0o") then
        return tonumber(str:sub(3), 8), "integer"
    end

    return nil
end

print(parseNumber("  123  "))       -- 123, integer
print(parseNumber("0xFF"))          -- 255, integer
print(parseNumber("invalid"))       -- nil
```

### 9.2 Number Formatting

```lua
-- Advanced formatting functions
local function formatNumber(num, decimals, thousands_sep, decimal_sep)
    decimals = decimals or 0
    thousands_sep = thousands_sep or ","
    decimal_sep = decimal_sep or "."

    local formatted = string.format("%." .. decimals .. "f", num)
    local integer_part, decimal_part = formatted:match("([^.]*)(.*)")

    -- Add thousands separator
    integer_part = integer_part:reverse():gsub("(%d%d%d)", "%1" .. thousands_sep):reverse()
    if integer_part:sub(1, 1) == thousands_sep then
        integer_part = integer_part:sub(2)
    end

    return integer_part .. decimal_part:gsub("%.", decimal_sep)
end

print(formatNumber(1234567.89, 2))          -- "1,234,567.89"
print(formatNumber(1234567.89, 2, " ", ",")) -- "1 234 567,89"
```

### 9.3 Mathematical Sequences dan Series

```lua
-- Fibonacci sequence
local function fibonacci(n)
    if n <= 1 then return n end
    local a, b = 0, 1
    for i = 2, n do
        a, b = b, a + b
    end
    return b
end

-- Factorial
local function factorial(n)
    if n <= 1 then return 1 end
    local result = 1
    for i = 2, n do
        result = result * i
    end
    return result
end

-- Prime checking
local function isPrime(n)
    if n < 2 then return false end
    if n == 2 then return true end
    if n % 2 == 0 then return false end

    for i = 3, math.sqrt(n), 2 do
        if n % i == 0 then return false end
    end
    return true
end

print(fibonacci(10))    -- 55
print(factorial(5))     -- 120
print(isPrime(17))      -- true
```

## 10. Performance Optimization

### 10.1 Integer vs Float Performance

```lua
-- Performance comparison
local function timeFunction(func, iterations)
    local start = os.clock()
    for i = 1, iterations do
        func()
    end
    return os.clock() - start
end

-- Integer operations (usually faster)
local function integerOps()
    local a = 1000000
    local b = 999999
    local c = a + b - a * b // a
end

-- Float operations
local function floatOps()
    local a = 1000000.0
    local b = 999999.0
    local c = a + b - a * b / a
end

-- Compare performance
local int_time = timeFunction(integerOps, 1000000)
local float_time = timeFunction(floatOps, 1000000)

print("Integer ops time:", int_time)
print("Float ops time:", float_time)
```

### 10.2 Optimized Mathematical Functions

```lua
-- Fast integer square root
local function isqrt(n)
    if n < 0 then return nil end
    if n < 2 then return n end

    local x = n
    local y = (x + 1) // 2
    while y < x do
        x = y
        y = (x + n // x) // 2
    end
    return x
end

-- Fast power function for integer exponents
local function fastPow(base, exp)
    if exp == 0 then return 1 end
    if exp == 1 then return base end
    if exp < 0 then return 1 / fastPow(base, -exp) end

    local result = 1
    while exp > 0 do
        if exp % 2 == 1 then
            result = result * base
        end
        base = base * base
        exp = exp // 2
    end
    return result
end

print(isqrt(16))        -- 4
print(fastPow(2, 10))   -- 1024
```

## 11. Practical Applications

### 11.1 Financial Calculations

```lua
-- Calculate compound interest
local function compoundInterest(principal, rate, time, compound_frequency)
    compound_frequency = compound_frequency or 1
    return principal * (1 + rate / compound_frequency) ^ (compound_frequency * time)
end

-- Calculate loan payment
local function loanPayment(principal, annual_rate, years)
    local monthly_rate = annual_rate / 12
    local num_payments = years * 12
    return principal * (monthly_rate * (1 + monthly_rate)^num_payments) /
           ((1 + monthly_rate)^num_payments - 1)
end

print(compoundInterest(1000, 0.05, 10))     -- $1628.89
print(loanPayment(200000, 0.04, 30))        -- $954.83
```

### 11.2 Statistical Functions

```lua
-- Calculate mean
local function mean(numbers)
    local sum = 0
    for _, num in ipairs(numbers) do
        sum = sum + num
    end
    return sum / #numbers
end

-- Calculate standard deviation
local function stddev(numbers)
    local avg = mean(numbers)
    local sum_sq_diff = 0
    for _, num in ipairs(numbers) do
        sum_sq_diff = sum_sq_diff + (num - avg)^2
    end
    return math.sqrt(sum_sq_diff / #numbers)
end

local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
print("Mean:", mean(data))          -- 5.5
print("Std Dev:", stddev(data))     -- 2.87
```

## 12. Error Handling dan Edge Cases

### 12.1 Common Pitfalls

```lua
-- Division by zero
local function safeDivide(a, b)
    if b == 0 then
        return nil, "Division by zero"
    end
    return a / b
end

-- Overflow detection
local function safeMultiply(a, b)
    if a == 0 or b == 0 then return 0 end
    if a > 0 and b > 0 and a > math.huge / b then
        return nil, "Overflow"
    end
    if a < 0 and b < 0 and a < math.huge / b then
        return nil, "Overflow"
    end
    return a * b
end

-- NaN and infinity handling
local function isValidNumber(n)
    return type(n) == "number" and n == n and n ~= math.huge and n ~= -math.huge
end

print(safeDivide(10, 0))        -- nil, "Division by zero"
print(isValidNumber(0/0))       -- false (NaN)
print(isValidNumber(1/0))       -- false (infinity)
print(isValidNumber(42))        -- true
```

## 13. Best Practices

### 13.1 Code Style dan Conventions

```lua
-- Use meaningful variable names
local accountBalance = 1000.50  -- good
local x = 1000.50               -- bad

-- Use constants for magic numbers
local PI = math.pi
local GOLDEN_RATIO = (1 + math.sqrt(5)) / 2
local MAX_ITERATIONS = 100

-- Group related calculations
local function calculateCircle(radius)
    local area = PI * radius^2
    local circumference = 2 * PI * radius
    local diameter = 2 * radius

    return {
        area = area,
        circumference = circumference,
        diameter = diameter
    }
end
```

### 13.2 Performance Best Practices

```lua
-- Cache frequently used values
local sqrt, abs, floor = math.sqrt, math.abs, math.floor

-- Prefer integer operations when possible
local function fastDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return sqrt(dx*dx + dy*dy)  -- using cached sqrt
end

-- Use appropriate data types
local function processLargeNumbers(numbers)
    -- Use integer when possible for better performance
    local sum = 0  -- integer
    for _, num in ipairs(numbers) do
        if math.type(num) == "integer" then
            sum = sum + num  -- integer arithmetic
        else
            sum = sum + num  -- converts to float
        end
    end
    return sum
end
```

## **Kesimpulan**

Penguasaan number dalam Lua memerlukan pemahaman mendalam tentang:

1. **Representasi internal** - bagaimana Lua menyimpan dan memproses angka
2. **Format penulisan** - berbagai cara menulis literal numerik
3. **Operasi matematika** - dari dasar hingga kompleks
4. **Konversi dan casting** - mengubah antara tipe data
5. **Precision handling** - mengatasi masalah floating-point
6. **Performance optimization** - memilih approach yang tepat
7. **Error handling** - menangani edge cases dengan baik

## **Poin-poin kunci yang perlu Anda fokuskan:**

1. **Pahami bahwa Lua hanya memiliki satu tipe `number`** - ini berbeda dengan bahasa lain yang memiliki int, float, double terpisah.

2. **Kuasai berbagai format penulisan** - decimal, hexadecimal, binary, octal, scientific notation, dan hexadecimal float.

3. **Pelajari presisi floating-point** - ini sangat penting untuk menghindari bug yang sulit ditemukan.

4. **Manfaatkan math library** - Lua memiliki fungsi matematika yang sangat lengkap.

5. **Pahami bitwise operations** (Lua 5.3+) - berguna untuk manipulasi data tingkat rendah.

6. **Praktikkan error handling** - selalu antisipasi edge cases seperti division by zero, overflow, NaN, dan infinity.

Dengan memahami semua aspek ini, Anda akan mampu menangani berbagai skenario pemrograman yang melibatkan angka dengan confidence dan efficiency.

> - **[Ke Atas](#)**
> - **[Kurikulum][1]**
> - **[Domain Spesifik][domain-spesifik]**

[domain-spesifik]: ../../../../README.md
[1]: ../../README.md
