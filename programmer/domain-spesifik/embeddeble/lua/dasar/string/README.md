# Panduan Lengkap String dalam Lua - Dari Dasar hingga Mahir

### Pada bagian ini kita akan mempelajari secara mendalam mengenai String yang meliputi beriku

<h3 id="satu"></h3>

**[Level Dasar:](#1-dasar-dasar-string-lua)**

- Cara membuat string (quotes, long strings, escape sequences)
- Operasi dasar (concatenation, length)
- Function library dasar

<h3 id="dua"></h3>

**[Level Menengah:](#4-pattern-matching-regex-alternatif-lua)**

- Pattern matching (alternatif regex Lua)
- String formatting dan manipulation
- UTF-8 support
- Search dan replace functions

<h3 id="tiga"></h3>

**[Level Mahir:](#7-performance-optimization)**

- Performance optimization techniques
- Advanced algorithms (Levenshtein distance, Boyer-Moore search)
- String compression dan encoding (Base64, run-length)
- Template engine dan string interpolation
- Security practices (SQL injection prevention, HTML escaping)

**Fitur Khusus:**

- StringBuilder pattern untuk concatenation efisien
- Custom validation functions
- Text processing utilities
- Unit testing framework untuk string functions

Setiap bagian dilengkapi dengan contoh kode praktis yang bisa langsung Anda gunakan. Panduan ini dirancang untuk membuat Anda benar-benar menguasai segala aspek string dalam Lua, mulai dari konsep dasar hingga teknik advanced yang digunakan dalam aplikasi production.

## [1. DASAR-DASAR STRING LUA](#satu)

### Definisi dan Karakteristik

String dalam Lua adalah _sequence of bytes_ atau urutan byte yang immutable (tidak dapat diubah). Setiap operasi string menghasilkan string baru.

### Cara Membuat String

#### 1.1 Single Quotes dan Double Quotes

```lua
local str1 = 'Hello World'
local str2 = "Hello World"
local str3 = 'Dia berkata "Halo"'
local str4 = "Dia berkata 'Halo'"
```

#### 1.2 Long Strings (Multi-line)

```lua
local longStr = [[
Ini adalah string panjang
yang bisa mencakup beberapa baris
tanpa perlu escape characters
]]

-- Dengan level brackets untuk nested content
local nestedStr = [=[
String ini bisa mengandung [[content]] di dalamnya
karena menggunakan level bracket berbeda
]=]

-- Multiple levels
local complexStr = [===[
Bisa mengandung [=[ dan ]=] di dalamnya
]===]
```

#### 1.3 Escape Sequences

```lua
local escaped = "Line 1\nLine 2\tTabbed\\"
local specialChars = "\a\b\f\n\r\t\v\\\"\'"
local unicodeStr = "\u{1F600}"  -- Unicode emoji (Lua 5.3+)
local hexStr = "\x41\x42\x43"   -- ABC dalam hex
local decimalStr = "\65\66\67"  -- ABC dalam decimal
```

## 2. OPERASI DASAR STRING

### 2.1 Concatenation (Penggabungan)

```lua
local a = "Hello"
local b = "World"
local result = a .. " " .. b  -- "Hello World"

-- Multiple concatenation
local full = "Lua" .. " " .. "is" .. " " .. "awesome"

-- Dengan non-string (otomatis converted)
local mixed = "Number: " .. 42  -- "Number: 42"
```

### 2.2 Length Operator

```lua
local str = "Hello"
local len = #str  -- 5

-- Untuk UTF-8 (Lua 5.3+)
local utf8Str = "Héllo"
local byteLen = #utf8Str      -- byte length
local charLen = utf8.len(utf8Str)  -- character length
```

## 3. STRING LIBRARY FUNCTIONS

### 3.1 Basic Functions

#### string.len()

```lua
local str = "Hello World"
print(string.len(str))  -- 11
print(#str)             -- sama dengan di atas
```

#### string.sub()

```lua
local str = "Hello World"
print(string.sub(str, 1, 5))   -- "Hello"
print(string.sub(str, 7))      -- "World"
print(string.sub(str, -5))     -- "World" (dari belakang)
print(string.sub(str, -5, -1)) -- "World"
```

#### string.upper() dan string.lower()

```lua
local text = "Hello World"
print(string.upper(text))  -- "HELLO WORLD"
print(string.lower(text))  -- "hello world"
```

#### string.reverse()

```lua
local str = "Hello"
print(string.reverse(str))  -- "olleH"
```

#### string.rep()

```lua
local pattern = "Lua"
print(string.rep(pattern, 3))      -- "LuaLuaLua"
print(string.rep(pattern, 3, "-")) -- "Lua-Lua-Lua"
```

### 3.2 Advanced Search Functions

#### string.find()

```lua
local text = "Hello World Hello"
local start, finish = string.find(text, "World")
print(start, finish)  -- 7 11

-- Dengan plain search (no pattern)
local pos = string.find(text, "World", 1, true)

-- Case insensitive search
local function findIgnoreCase(str, pattern)
    return string.find(string.lower(str), string.lower(pattern))
end
```

#### string.match()

```lua
local email = "user@example.com"
local domain = string.match(email, "@(.+)")
print(domain)  -- "example.com"

-- Multiple captures
local date = "2024-12-25"
local year, month, day = string.match(date, "(%d+)-(%d+)-(%d+)")
```

#### string.gmatch()

```lua
local text = "apple,banana,cherry"
for fruit in string.gmatch(text, "([^,]+)") do
    print(fruit)
end
-- Output: apple, banana, cherry

-- Extract all numbers
local str = "I have 10 apples and 5 oranges"
for num in string.gmatch(str, "%d+") do
    print(tonumber(num))
end
```

### 3.3 String Replacement

#### string.gsub()

```lua
local text = "Hello World Hello"
local result = string.gsub(text, "Hello", "Hi")
print(result)  -- "Hi World Hi"

-- Dengan limit
local limited = string.gsub(text, "Hello", "Hi", 1)
print(limited)  -- "Hi World Hello"

-- Dengan function replacement
local numbers = "1 2 3 4 5"
local doubled = string.gsub(numbers, "%d+", function(n)
    return tostring(tonumber(n) * 2)
end)
print(doubled)  -- "2 4 6 8 10"

-- Dengan table replacement
local replacements = {Hello = "Hi", World = "Universe"}
local replaced = string.gsub(text, "%w+", replacements)
```

## 4. PATTERN MATCHING (REGEX ALTERNATIF LUA)

### [4.1 Basic Pattern Characters](#dua)

```lua
-- Character classes
local patterns = {
    "%a",  -- letters
    "%d",  -- digits
    "%l",  -- lowercase letters
    "%u",  -- uppercase letters
    "%w",  -- alphanumeric
    "%s",  -- space characters
    "%p",  -- punctuation
    "%c",  -- control characters
    "%x"   -- hexadecimal digits
}

-- Negation dengan uppercase
"%A"  -- non-letters
"%D"  -- non-digits
-- dst...
```

### 4.2 Pattern Modifiers

```lua
-- Quantifiers
local text = "Hello123World"
print(string.match(text, "%a+"))     -- "Hello" (one or more letters)
print(string.match(text, "%d*"))     -- "" (zero or more digits)
print(string.match(text, "%d-"))     -- "" (zero or more digits, non-greedy)
print(string.match(text, "%a?"))     -- "H" (zero or one letter)

-- Anchors
print(string.match("Hello", "^H"))   -- "H" (start of string)
print(string.match("Hello", "o$"))   -- "o" (end of string)
```

### 4.3 Advanced Patterns

```lua
-- Character sets
local pattern1 = "[aeiou]"     -- vowels
local pattern2 = "[^aeiou]"    -- non-vowels
local pattern3 = "[a-z]"       -- lowercase range
local pattern4 = "[0-9A-F]"    -- hex digits

-- Captures
local function parseEmail(email)
    local user, domain = string.match(email, "([%w%.%-_]+)@([%w%.%-]+)")
    return user, domain
end

-- Complex pattern example
local function parseURL(url)
    local protocol, host, port, path = string.match(url,
        "^(%w+)://([%w%.%-]+):?(%d*)(.*)$")
    return protocol, host, (port ~= "" and tonumber(port) or nil), path
end
```

## 5. STRING FORMATTING

### 5.1 string.format()

```lua
-- Basic formatting
local name = "John"
local age = 25
local formatted = string.format("Name: %s, Age: %d", name, age)

-- Number formatting
local pi = 3.14159
print(string.format("%.2f", pi))      -- "3.14"
print(string.format("%08.2f", pi))    -- "00003.14"
print(string.format("%-10.2f", pi))   -- "3.14      "

-- Integer formatting
local num = 42
print(string.format("%d", num))       -- "42"
print(string.format("%05d", num))     -- "00042"
print(string.format("%x", num))       -- "2a" (hex)
print(string.format("%X", num))       -- "2A" (hex uppercase)
print(string.format("%o", num))       -- "52" (octal)

-- Scientific notation
local big = 123456789
print(string.format("%e", big))       -- "1.234568e+08"
print(string.format("%E", big))       -- "1.234568E+08"
```

### 5.2 Custom Formatting Functions

```lua
-- Ribuan separator
local function formatNumber(num)
    local formatted = tostring(num)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Padding functions
local function padLeft(str, len, char)
    char = char or " "
    return string.rep(char, len - #str) .. str
end

local function padRight(str, len, char)
    char = char or " "
    return str .. string.rep(char, len - #str)
end

local function padCenter(str, len, char)
    char = char or " "
    local totalPad = len - #str
    local leftPad = math.floor(totalPad / 2)
    local rightPad = totalPad - leftPad
    return string.rep(char, leftPad) .. str .. string.rep(char, rightPad)
end
```

## 6. UTF-8 SUPPORT (LUA 5.3+)

### 6.1 UTF-8 Library Functions

```lua
-- UTF-8 string operations
local utf8Str = "Héllo Wörld 🌍"

-- Length in characters (not bytes)
print(utf8.len(utf8Str))  -- character count

-- Character iteration
for pos, code in utf8.codes(utf8Str) do
    print(pos, utf8.char(code))
end

-- Offset operations
local pos = utf8.offset(utf8Str, 3)  -- position of 3rd character
print(string.sub(utf8Str, pos, utf8.offset(utf8Str, 4) - 1))

-- Codepoint conversion
print(utf8.codepoint("A"))        -- 65
print(utf8.char(65))              -- "A"
print(utf8.char(0x1F600))         -- "😀"
```

### 6.2 UTF-8 Helper Functions

```lua
-- UTF-8 aware substring
local function utf8Sub(str, start, finish)
    local startByte = utf8.offset(str, start)
    local endByte = finish and utf8.offset(str, finish + 1) - 1 or #str
    return string.sub(str, startByte, endByte)
end

-- UTF-8 reverse
local function utf8Reverse(str)
    local reversed = {}
    for pos, code in utf8.codes(str) do
        table.insert(reversed, 1, utf8.char(code))
    end
    return table.concat(reversed)
end
```

## [7. PERFORMANCE OPTIMIZATION](#tiga)

### 7.1 String Concatenation Optimization

```lua
-- BURUK: Concatenation berulang
local function badConcat(strings)
    local result = ""
    for i, str in ipairs(strings) do
        result = result .. str  -- Inefficient!
    end
    return result
end

-- BAIK: Table concat
local function goodConcat(strings)
    return table.concat(strings)
end

-- TERBAIK: dengan separator
local function bestConcat(strings, separator)
    return table.concat(strings, separator or "")
end

-- StringBuilder pattern
local StringBuilder = {}
StringBuilder.__index = StringBuilder

function StringBuilder:new()
    return setmetatable({buffer = {}}, self)
end

function StringBuilder:append(str)
    table.insert(self.buffer, str)
    return self
end

function StringBuilder:toString()
    return table.concat(self.buffer)
end

-- Usage
local sb = StringBuilder:new()
sb:append("Hello"):append(" "):append("World")
print(sb:toString())
```

### 7.2 Pattern Caching

```lua
-- Cache compiled patterns
local patternCache = {}

local function getCachedPattern(pattern)
    if not patternCache[pattern] then
        -- Pre-validate pattern
        local ok, err = pcall(string.find, "", pattern)
        if not ok then
            error("Invalid pattern: " .. pattern)
        end
        patternCache[pattern] = pattern
    end
    return patternCache[pattern]
end
```

## 8. STRING UTILITIES LANJUTAN

### 8.1 String Validation

```lua
-- Email validation
local function isValidEmail(email)
    local pattern = "^[%w%.%-_]+@[%w%.%-]+%.%w+$"
    return string.match(email, pattern) ~= nil
end

-- Phone number validation
local function isValidPhone(phone)
    local cleaned = string.gsub(phone, "[%s%-().]", "")
    return string.match(cleaned, "^%+?%d+$") ~= nil and #cleaned >= 10
end

-- URL validation
local function isValidURL(url)
    local pattern = "^https?://[%w%.%-]+[%w%.%-_~:/?#%[%]@!$&'()*+,;=]*$"
    return string.match(url, pattern) ~= nil
end
```

### 8.2 Text Processing

```lua
-- Word count
local function wordCount(text)
    local count = 0
    for word in string.gmatch(text, "%S+") do
        count = count + 1
    end
    return count
end

-- Sentence splitting
local function splitSentences(text)
    local sentences = {}
    for sentence in string.gmatch(text, "[^%.!%?]+[%.!%?]") do
        local trimmed = string.match(sentence, "^%s*(.-)%s*$")
        if trimmed ~= "" then
            table.insert(sentences, trimmed)
        end
    end
    return sentences
end

-- Title case
local function titleCase(str)
    return string.gsub(str, "(%a)([%w_']*)", function(first, rest)
        return string.upper(first) .. string.lower(rest)
    end)
end

-- Slug generation
local function createSlug(text)
    local slug = string.lower(text)
    slug = string.gsub(slug, "[%s_]+", "-")  -- spaces to hyphens
    slug = string.gsub(slug, "[^%w%-]", "")  -- remove special chars
    slug = string.gsub(slug, "%-+", "-")     -- multiple hyphens to one
    slug = string.gsub(slug, "^%-+", "")     -- leading hyphens
    slug = string.gsub(slug, "%-+$", "")     -- trailing hyphens
    return slug
end
```

### 8.3 Advanced String Algorithms

```lua
-- Levenshtein distance
local function levenshteinDistance(str1, str2)
    local len1, len2 = #str1, #str2
    local matrix = {}

    for i = 0, len1 do
        matrix[i] = {[0] = i}
    end

    for j = 0, len2 do
        matrix[0][j] = j
    end

    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (string.sub(str1, i, i) == string.sub(str2, j, j)) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i-1][j] + 1,      -- deletion
                matrix[i][j-1] + 1,      -- insertion
                matrix[i-1][j-1] + cost  -- substitution
            )
        end
    end

    return matrix[len1][len2]
end

-- Fuzzy string matching
local function fuzzyMatch(str, pattern, threshold)
    threshold = threshold or 0.8
    local distance = levenshteinDistance(str, pattern)
    local maxLen = math.max(#str, #pattern)
    local similarity = 1 - (distance / maxLen)
    return similarity >= threshold, similarity
end

-- Boyer-Moore string search (simplified)
local function createBadCharTable(pattern)
    local table = {}
    for i = 1, #pattern do
        table[string.sub(pattern, i, i)] = #pattern - i
    end
    return table
end

local function boyerMooreSearch(text, pattern)
    local badCharTable = createBadCharTable(pattern)
    local textLen, patternLen = #text, #pattern
    local skip = 0

    while skip <= textLen - patternLen do
        local j = patternLen
        while j >= 1 and string.sub(pattern, j, j) == string.sub(text, skip + j, skip + j) do
            j = j - 1
        end

        if j == 0 then
            return skip + 1  -- Found at position skip + 1
        else
            local badChar = string.sub(text, skip + j, skip + j)
            skip = skip + math.max(1, j - (badCharTable[badChar] or patternLen))
        end
    end

    return nil  -- Not found
end
```

## 9. STRING COMPRESSION DAN ENCODING

### 9.1 Simple Compression

```lua
-- Run-length encoding
local function runLengthEncode(str)
    local result = {}
    local i = 1

    while i <= #str do
        local char = string.sub(str, i, i)
        local count = 1

        while i + count <= #str and string.sub(str, i + count, i + count) == char do
            count = count + 1
        end

        if count > 1 then
            table.insert(result, count .. char)
        else
            table.insert(result, char)
        end

        i = i + count
    end

    return table.concat(result)
end

-- Run-length decoding
local function runLengthDecode(str)
    local result = {}
    local i = 1

    while i <= #str do
        local count = ""
        while i <= #str and string.match(string.sub(str, i, i), "%d") do
            count = count .. string.sub(str, i, i)
            i = i + 1
        end

        if count ~= "" and i <= #str then
            local char = string.sub(str, i, i)
            table.insert(result, string.rep(char, tonumber(count)))
            i = i + 1
        elseif i <= #str then
            table.insert(result, string.sub(str, i, i))
            i = i + 1
        end
    end

    return table.concat(result)
end
```

### 9.2 Base64 Encoding/Decoding

```lua
local base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function base64Encode(str)
    local result = {}
    local padding = ""

    for i = 1, #str, 3 do
        local a, b, c = string.byte(str, i, i + 2)
        b = b or 0
        c = c or 0

        local bitmap = (a << 16) + (b << 8) + c

        for j = 18, 0, -6 do
            local index = ((bitmap >> j) & 63) + 1
            table.insert(result, string.sub(base64Chars, index, index))
        end
    end

    local paddingLength = (3 - (#str % 3)) % 3
    for i = 1, paddingLength do
        result[#result - i + 1] = "="
    end

    return table.concat(result)
end

local function base64Decode(str)
    local charMap = {}
    for i = 1, #base64Chars do
        charMap[string.sub(base64Chars, i, i)] = i - 1
    end

    str = string.gsub(str, "=", "")
    local result = {}

    for i = 1, #str, 4 do
        local a = charMap[string.sub(str, i, i)] or 0
        local b = charMap[string.sub(str, i + 1, i + 1)] or 0
        local c = charMap[string.sub(str, i + 2, i + 2)] or 0
        local d = charMap[string.sub(str, i + 3, i + 3)] or 0

        local bitmap = (a << 18) + (b << 12) + (c << 6) + d

        if i + 1 <= #str then table.insert(result, string.char((bitmap >> 16) & 255)) end
        if i + 2 <= #str then table.insert(result, string.char((bitmap >> 8) & 255)) end
        if i + 3 <= #str then table.insert(result, string.char(bitmap & 255)) end
    end

    return table.concat(result)
end
```

## 10. STRING INTERPOLATION DAN TEMPLATING

### 10.1 Simple Template Engine

```lua
local function simpleTemplate(template, data)
    return string.gsub(template, "${(%w+)}", function(key)
        return tostring(data[key] or "")
    end)
end

-- Usage
local template = "Hello ${name}, you are ${age} years old!"
local data = {name = "John", age = 30}
print(simpleTemplate(template, data))

-- Advanced template with nested data
local function advancedTemplate(template, data)
    return string.gsub(template, "${([%w%.]+)}", function(path)
        local value = data
        for key in string.gmatch(path, "[^%.]+") do
            if type(value) == "table" and value[key] then
                value = value[key]
            else
                return ""
            end
        end
        return tostring(value)
    end)
end

-- Usage
local complexData = {
    user = {
        name = "John",
        profile = {age = 30}
    }
}
local complexTemplate = "Hello ${user.name}, age: ${user.profile.age}"
print(advancedTemplate(complexTemplate, complexData))
```

### 10.2 Conditional Templates

```lua
local function conditionalTemplate(template, data)
    -- Handle if statements
    template = string.gsub(template, "{%%if%s+([%w%.]+)%%}(.-){%%endif%%}", function(condition, content)
        local value = data
        for key in string.gmatch(condition, "[^%.]+") do
            if type(value) == "table" and value[key] then
                value = value[key]
            else
                value = nil
                break
            end
        end
        return (value and value ~= false and value ~= "") and content or ""
    end)

    -- Handle loops
    template = string.gsub(template, "{%%for%s+(%w+)%s+in%s+([%w%.]+)%%}(.-){%%endfor%%}", function(item, collection, content)
        local items = data
        for key in string.gmatch(collection, "[^%.]+") do
            if type(items) == "table" and items[key] then
                items = items[key]
            else
                items = nil
                break
            end
        end

        if type(items) == "table" then
            local results = {}
            for _, value in ipairs(items) do
                local itemData = {}
                for k, v in pairs(data) do
                    itemData[k] = v
                end
                itemData[item] = value
                table.insert(results, simpleTemplate(content, itemData))
            end
            return table.concat(results)
        end
        return ""
    end)

    -- Handle variables
    return simpleTemplate(template, data)
end
```

## 11. BEST PRACTICES & TIPS

### 11.1 Performance Tips

1. **Hindari concatenation berulang** - gunakan table.concat
2. **Cache pattern yang sering digunakan**
3. **Gunakan string.find dengan plain=true untuk literal search**
4. **Pertimbangkan UTF-8 handling untuk text internasional**

### 11.2 Memory Management

```lua
-- Good: reuse string objects
local commonStrings = {
    empty = "",
    space = " ",
    newline = "\n",
    comma = ",",
}

-- Bad: creating many temporary strings
local function badExample(items)
    local result = ""
    for i, item in ipairs(items) do
        result = result .. item .. ", "  -- Creates many intermediate strings
    end
    return result
end

-- Good: minimize string creation
local function goodExample(items)
    local parts = {}
    for i, item in ipairs(items) do
        table.insert(parts, item)
    end
    return table.concat(parts, ", ")
end
```

### 11.3 Security Considerations

```lua
-- SQL injection prevention
local function escapeSQLString(str)
    return "'" .. string.gsub(str, "'", "''") .. "'"
end

-- HTML escaping
local function escapeHTML(str)
    local escapes = {
        ["&"] = "&amp;",
        ["<"] = "&lt;",
        [">"] = "&gt;",
        ['"'] = "&quot;",
        ["'"] = "&#39;"
    }
    return string.gsub(str, "[&<>\"']", escapes)
end

-- Input sanitization
local function sanitizeInput(str, maxLength)
    maxLength = maxLength or 1000
    str = string.sub(str, 1, maxLength)
    str = string.gsub(str, "[%c]", "")  -- Remove control characters
    return str
end
```

## 12. TESTING STRING FUNCTIONS

### 12.1 Unit Testing Framework

```lua
local function assertEqual(actual, expected, message)
    if actual == expected then
        print("✓ " .. (message or "Test passed"))
    else
        print("✗ " .. (message or "Test failed"))
        print("  Expected: " .. tostring(expected))
        print("  Actual:   " .. tostring(actual))
    end
end

-- Test examples
local function runStringTests()
    -- Test basic operations
    assertEqual("Hello" .. " " .. "World", "Hello World", "String concatenation")
    assertEqual(#"Hello", 5, "String length")
    assertEqual(string.upper("hello"), "HELLO", "String uppercase")

    -- Test pattern matching
    local email = "test@example.com"
    local domain = string.match(email, "@(.+)")
    assertEqual(domain, "example.com", "Email domain extraction")

    -- Test custom functions
    assertEqual(levenshteinDistance("kitten", "sitting"), 3, "Levenshtein distance")

    print("All string tests completed!")
end
```

## KESIMPULAN

String dalam Lua adalah tipe data yang sangat powerful dengan library function yang lengkap. Kunci untuk menguasai string Lua adalah:

1. **Memahami immutability** - setiap operasi menghasilkan string baru
2. **Menguasai pattern matching** - alternatif regex yang powerful
3. **Optimasi performance** - gunakan table.concat untuk concatenation besar
4. **UTF-8 awareness** - penting untuk aplikasi international
5. **Security practices** - selalu escape dan sanitize input

Dengan memahami semua konsep di atas, Anda akan menjadi expert dalam manipulasi string Lua untuk segala kebutuhan pemrograman Anda!

[Daftar Kurikulum][1]

[Domain Spesifik][domain-spesifik]

[domain-spesifik]: ../../../../README.md
[1]: ../../README.md
