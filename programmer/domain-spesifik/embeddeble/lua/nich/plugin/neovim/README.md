# Panduan Lengkap Lua untuk Pengembangan Plugin Neovim

## **[1. Fondasi Dasar Lua][1]**

### 1.1 Pengenalan Lua

**Lua** adalah bahasa pemrograman scripting yang ringan, dinamis, dan mudah dipelajari. Nama "Lua" berarti "bulan" dalam bahasa Portugis. Lua dirancang untuk menjadi bahasa yang dapat di-embed (disematkan) ke dalam aplikasi lain, yang membuatnya sempurna untuk Neovim.

**Karakteristik utama Lua:**

- **Interpreted language**: Kode dijalankan langsung tanpa kompilasi
- **Dynamically typed**: Tipe data ditentukan saat runtime
- **Garbage collected**: Manajemen memori otomatis
- **Lightweight**: Ukuran kecil dan performa tinggi

### 1.2 Sintaks Dasar dan Struktur

#### Komentar

```lua
-- Komentar satu baris

--[[
    Komentar
    multi-baris
]]
```

#### Statement dan Expression

- **Statement**: Instruksi yang dieksekusi (seperti assignment, function call)
- **Expression**: Kombinasi nilai dan operator yang menghasilkan nilai

```lua
-- Statement
local x = 10
print("Hello")

-- Expression
local result = x + 5  -- x + 5 adalah expression
```

## **[2. Tipe Data dan Variabel][2]**

### 2.1 Tipe Data Primitif

#### Nil

**Nil** adalah tipe data yang merepresentasikan "tidak ada nilai" atau "kosong".

```lua
local empty_var = nil
print(empty_var)  -- Output: nil
```

#### Boolean

```lua
local is_true = true
local is_false = false

-- Falsy values: false dan nil
-- Truthy values: semua selain false dan nil (termasuk 0 dan "")
```

#### Number

Lua hanya memiliki satu tipe numerik yang merepresentasikan floating-point numbers.

```lua
local integer = 42
local float = 3.14159
local scientific = 1.23e-4  -- Scientific notation
local hex = 0xFF  -- Hexadecimal (255)
```

#### [String][string1]

```lua
local single_quote = 'Hello World'
local double_quote = "Hello World"
local multiline = [[
    Ini adalah string
    multi-baris
]]

-- String concatenation menggunakan operator ..
local greeting = "Hello" .. " " .. "World"

-- String interpolation tidak ada built-in, gunakan string.format
local name = "John"
local message = string.format("Hello, %s!", name)
```

### 2.2 Variabel dan Scope

#### Local vs Global Variables

```lua
-- Global variable (avoid in plugin development)
global_var = "I'm global"

-- Local variable (recommended)
local local_var = "I'm local"

-- Scope example
do
    local inner_var = "Only visible here"
    print(inner_var)  -- OK
end
-- print(inner_var)  -- Error: inner_var is nil
```

**Best Practice**: Selalu gunakan `local` untuk variabel dalam plugin development untuk menghindari namespace pollution.

## **[3. Operator dan Kontrol Flow][3]**

### 3.1 Operator Aritmatika

```lua
local a, b = 10, 3

print(a + b)   -- 13 (penjumlahan)
print(a - b)   -- 7  (pengurangan)
print(a * b)   -- 30 (perkalian)
print(a / b)   -- 3.333... (pembagian)
print(a % b)   -- 1  (modulo/sisa bagi)
print(a ^ b)   -- 1000 (eksponensial)
```

### 3.2 Operator Relasional

```lua
print(10 == 10)  -- true (sama dengan)
print(10 ~= 5)   -- true (tidak sama dengan, bukan !=)
print(10 > 5)    -- true (lebih besar)
print(10 < 5)    -- false (lebih kecil)
print(10 >= 10)  -- true (lebih besar atau sama)
print(10 <= 10)  -- true (lebih kecil atau sama)
```

### 3.3 Operator Logika

```lua
print(true and false)   -- false
print(true or false)    -- true
print(not true)         -- false

-- Short-circuit evaluation
local result = condition and value_if_true or value_if_false
```

### 3.4 Kontrol Flow Structures

#### If-Then-Else

```lua
local score = 85

if score >= 90 then
    print("Excellent")
elseif score >= 80 then
    print("Good")
elseif score >= 70 then
    print("Average")
else
    print("Poor")
end
```

#### While Loop

```lua
local i = 1
while i <= 5 do
    print("Iteration:", i)
    i = i + 1
end
```

#### Repeat-Until Loop

```lua
local i = 1
repeat
    print("Iteration:", i)
    i = i + 1
until i > 5
```

#### For Loop

```lua
-- Numeric for loop
for i = 1, 10, 2 do  -- start, end, step
    print(i)  -- 1, 3, 5, 7, 9
end

-- Generic for loop (untuk iterasi)
local fruits = {"apple", "banana", "orange"}
for index, fruit in ipairs(fruits) do
    print(index, fruit)
end
```

## **[4. Struktur Data Kompleks][4]**

### 4.1 Tables - Struktur Data Utama Lua

**Table** adalah satu-satunya struktur data kompleks di Lua. Table bersifat **associative array** yang dapat berperan sebagai array, hash table, object, dll.

#### Array-like Tables

```lua
-- Array dengan index numerik (1-based indexing)
local colors = {"red", "green", "blue"}
print(colors[1])  -- "red" (index dimulai dari 1, bukan 0)
print(#colors)    -- 3 (length operator)

-- Menambah elemen
colors[4] = "yellow"
table.insert(colors, "purple")  -- insert di akhir
table.insert(colors, 2, "orange")  -- insert di index 2
```

#### Hash Table / Dictionary

```lua
local person = {
    name = "John Doe",
    age = 30,
    city = "Jakarta"
}

-- Akses menggunakan dot notation
print(person.name)  -- "John Doe"

-- Akses menggunakan bracket notation
print(person["age"])  -- 30

-- Dynamic key
local key = "city"
print(person[key])  -- "Jakarta"
```

#### Mixed Tables

```lua
local mixed = {
    "first",      -- index 1
    "second",     -- index 2
    name = "John", -- string key
    [42] = "answer" -- numeric key (bukan sequential)
}

print(mixed[1])     -- "first"
print(mixed.name)   -- "John"
print(mixed[42])    -- "answer"
```

#### Nested Tables

```lua
local config = {
    editor = {
        theme = "dark",
        font_size = 14,
        plugins = {
            "lsp",
            "treesitter",
            "telescope"
        }
    },
    keybindings = {
        save = "<C-s>",
        quit = "<C-q>"
    }
}

print(config.editor.theme)  -- "dark"
print(config.editor.plugins[1])  -- "lsp"
```

### 4.2 Table Operations dan Methods

#### Table Library Functions

```lua
local numbers = {3, 1, 4, 1, 5}

-- Sorting
table.sort(numbers)  -- {1, 1, 3, 4, 5}

-- Custom sort
table.sort(numbers, function(a, b) return a > b end)  -- descending

-- Concatenation (hanya untuk array part)
local text = table.concat({"Hello", "World", "!"}, " ")  -- "Hello World !"

-- Remove elements
table.remove(numbers, 2)  -- remove element at index 2
table.remove(numbers)     -- remove last element
```

#### Iterating Tables

```lua
local data = {name = "John", age = 30, city = "Jakarta"}

-- pairs() - iterasi semua key-value pairs
for key, value in pairs(data) do
    print(key, value)
end

-- ipairs() - iterasi hanya array part (sequential numeric keys)
local fruits = {"apple", "banana", "orange"}
for index, fruit in ipairs(fruits) do
    print(index, fruit)
end
```

## **[5. Functions - Konsep Mendalam][5]**

### 5.1 Function Definition dan Calling

#### Basic Function Syntax

```lua
-- Function declaration
function greet(name)
    return "Hello, " .. name
end

-- Function call
local message = greet("World")
print(message)  -- "Hello, World"
```

#### Anonymous Functions

```lua
-- Function sebagai value
local add = function(a, b)
    return a + b
end

-- Function sebagai argument
local function apply_operation(a, b, operation)
    return operation(a, b)
end

local result = apply_operation(5, 3, add)
print(result)  -- 8
```

### 5.2 Advanced Function Features

#### Multiple Return Values

```lua
function get_name_age()
    return "John", 25
end

local name, age = get_name_age()
print(name, age)  -- "John", 25

-- Mengabaikan return values
local name = get_name_age()  -- hanya ambil yang pertama
local _, age = get_name_age()  -- skip yang pertama
```

#### Variable Arguments (Varargs)

```lua
function sum(...)
    local args = {...}  -- pack arguments into table
    local total = 0
    for i = 1, #args do
        total = total + args[i]
    end
    return total
end

print(sum(1, 2, 3, 4, 5))  -- 15

-- select() function untuk varargs
function print_args(...)
    print("Total args:", select("#", ...))  -- count
    print("First arg:", select(1, ...))     -- get specific
end
```

#### Closures dan Lexical Scoping

```lua
function create_counter()
    local count = 0  -- upvalue

    return function()  -- closure
        count = count + 1
        return count
    end
end

local counter1 = create_counter()
local counter2 = create_counter()

print(counter1())  -- 1
print(counter1())  -- 2
print(counter2())  -- 1 (independent counter)
```

**Closure** adalah function yang "menangkap" variabel dari scope luar (upvalue). Ini sangat berguna untuk plugin development.

### 5.3 Function sebagai First-Class Citizens

```lua
-- Function dalam table
local math_ops = {
    add = function(a, b) return a + b end,
    subtract = function(a, b) return a - b end,
    multiply = function(a, b) return a * b end
}

print(math_ops.add(5, 3))  -- 8

-- Higher-order functions
function map(tbl, func)
    local result = {}
    for i, v in ipairs(tbl) do
        result[i] = func(v)
    end
    return result
end

local numbers = {1, 2, 3, 4, 5}
local squared = map(numbers, function(x) return x * x end)
-- squared = {1, 4, 9, 16, 25}
```

## **[6. Object-Oriented Programming (OOP) di Lua][6]**

### 6.1 Table sebagai Objects

```lua
-- Simple object
local person = {
    name = "John",
    age = 30
}

-- Method
function person:say_hello()
    print("Hello, I'm " .. self.name)
end

-- Atau menggunakan dot notation
function person.get_age(self)
    return self.age
end

person:say_hello()  -- "Hello, I'm John"
print(person:get_age())  -- 30
```

**Perbedaan `:` dan `.`:**

- `:` otomatis mengirim `self` sebagai parameter pertama
- `.` memerlukan explicit `self` parameter

### 6.2 Prototype-based OOP dengan Metatables

#### Metatable Basics

**Metatable** adalah table yang mendefinisikan behavior untuk operasi pada table lain.

```lua
local mt = {
    __add = function(a, b)
        return {x = a.x + b.x, y = a.y + b.y}
    end,
    __tostring = function(t)
        return "Point(" .. t.x .. ", " .. t.y .. ")"
    end
}

local point1 = {x = 1, y = 2}
local point2 = {x = 3, y = 4}

setmetatable(point1, mt)
setmetatable(point2, mt)

local result = point1 + point2  -- menggunakan __add
print(result)  -- menggunakan __tostring
```

#### Class Implementation

```lua
-- Class definition
local Person = {}
Person.__index = Person

function Person:new(name, age)
    local obj = {
        name = name or "Unknown",
        age = age or 0
    }
    setmetatable(obj, self)
    return obj
end

function Person:say_hello()
    print("Hello, I'm " .. self.name .. " and I'm " .. self.age .. " years old")
end

function Person:get_older()
    self.age = self.age + 1
end

-- Usage
local john = Person:new("John", 25)
john:say_hello()  -- "Hello, I'm John and I'm 25 years old"
john:get_older()
john:say_hello()  -- "Hello, I'm John and I'm 26 years old"
```

#### Inheritance

```lua
-- Base class
local Animal = {}
Animal.__index = Animal

function Animal:new(name)
    local obj = {name = name}
    setmetatable(obj, self)
    return obj
end

function Animal:speak()
    print(self.name .. " makes a sound")
end

-- Derived class
local Dog = {}
setmetatable(Dog, Animal)  -- Dog inherits from Animal
Dog.__index = Dog

function Dog:new(name, breed)
    local obj = Animal.new(self, name)
    obj.breed = breed or "Unknown"
    setmetatable(obj, self)
    return obj
end

function Dog:speak()  -- Override
    print(self.name .. " barks!")
end

function Dog:get_breed()
    return self.breed
end

-- Usage
local buddy = Dog:new("Buddy", "Golden Retriever")
buddy:speak()  -- "Buddy barks!"
print(buddy:get_breed())  -- "Golden Retriever"
```

## **[7. Modules dan Package Management][7]**

### 7.1 Module System

#### Creating Modules

```lua
-- file: math_utils.lua
local M = {}  -- Module table

local function private_helper()
    return "This is private"
end

function M.add(a, b)
    return a + b
end

function M.multiply(a, b)
    return a * b
end

M.PI = 3.14159

return M
```

#### Using Modules

```lua
-- Method 1: Full module
local math_utils = require('math_utils')
print(math_utils.add(5, 3))  -- 8
print(math_utils.PI)         -- 3.14159

-- Method 2: Selective import (manual)
local add = require('math_utils').add
print(add(2, 3))  -- 5
```

### 7.2 Package Path dan Loading

```lua
-- Melihat package path
print(package.path)

-- Menambah custom path
package.path = package.path .. ";/custom/path/?.lua"

-- Package loading information
print(package.loaded["math_utils"])  -- module info setelah di-load
```

## **[8. Error Handling dan Debugging][8]**

### 8.1 Error Types dan Handling

#### Basic Error Handling

```lua
-- Throwing errors
error("Something went wrong!")

-- Conditional errors
if not condition then
    error("Condition failed", 2)  -- level 2 (caller's caller)
end

-- Assertions
assert(x > 0, "x must be positive")
```

#### Protected Calls (pcall)

```lua
local function risky_function()
    error("Oops!")
end

-- pcall returns success status + results
local success, result = pcall(risky_function)
if success then
    print("Result:", result)
else
    print("Error:", result)  -- result contains error message
end

-- With arguments
local success, result = pcall(function(a, b)
    return a / b
end, 10, 0)
```

#### xpcall for Advanced Error Handling

```lua
local function error_handler(err)
    print("Error occurred:", err)
    print("Stack trace:", debug.traceback())
    return err
end

local function risky_operation()
    error("Something bad happened")
end

local success, result = xpcall(risky_operation, error_handler)
```

### 8.2 Debugging Tools

```lua
-- Debug library
print(debug.traceback())  -- Stack trace

-- Variable inspection
local function inspect_locals()
    local i = 1
    while true do
        local name, value = debug.getlocal(2, i)  -- level 2, variable i
        if not name then break end
        print(name, value)
        i = i + 1
    end
end
```

## **[9. Advanced Lua Concepts][9]**

### 9.1 Coroutines - Cooperative Multithreading

**Coroutine** adalah function yang dapat di-suspend dan di-resume.

```lua
-- Creating coroutine
local function count_down(n)
    for i = n, 1, -1 do
        print("Count:", i)
        coroutine.yield(i)  -- Suspend dan return value
    end
    return "Done!"
end

local co = coroutine.create(count_down)

-- Running coroutine
print(coroutine.resume(co, 3))  -- true, 3
print(coroutine.resume(co))     -- true, 2
print(coroutine.resume(co))     -- true, 1
print(coroutine.resume(co))     -- true, "Done!"
print(coroutine.resume(co))     -- false, "cannot resume dead coroutine"
```

#### Coroutine States

```lua
print(coroutine.status(co))  -- "suspended", "running", "dead", "normal"
```

### 9.2 Metatables - Advanced Usage

#### Metamethods

```lua
local Vector = {}

local mt = {
    __add = function(a, b) return Vector.new(a.x + b.x, a.y + b.y) end,
    __sub = function(a, b) return Vector.new(a.x - b.x, a.y - b.y) end,
    __mul = function(a, b)
        if type(b) == "number" then
            return Vector.new(a.x * b, a.y * b)
        end
        return a.x * b.x + a.y * b.y  -- dot product
    end,
    __eq = function(a, b) return a.x == b.x and a.y == b.y end,
    __lt = function(a, b) return a:length() < b:length() end,
    __tostring = function(v) return "Vector(" .. v.x .. ", " .. v.y .. ")" end,
    __index = Vector,
    __newindex = function(t, k, v)
        if k == "x" or k == "y" then
            rawset(t, k, v)
        else
            error("Cannot set property " .. k)
        end
    end
}

function Vector.new(x, y)
    local v = {x = x or 0, y = y or 0}
    setmetatable(v, mt)
    return v
end

function Vector:length()
    return math.sqrt(self.x^2 + self.y^2)
end
```

### 9.3 Environment dan Global Variables

```lua
-- _G adalah global environment table
print(_G.print)  -- reference to print function

-- Setting global variables
_G.my_global = "Hello World"
print(my_global)  -- accessible globally

-- Custom environment
local env = {
    print = function(x) io.write("CUSTOM: " .. tostring(x) .. "\n") end,
    x = 42
}

local function custom_func()
    print(x)  -- akan menggunakan custom print dan x dari env
end

-- Set environment (Lua 5.1 style)
setfenv(custom_func, env)
custom_func()  -- "CUSTOM: 42"
```

## **[10. Neovim Integration Fundamentals][10]**

### 10.1 Neovim Lua API Structure

#### Vim Global Namespace

```lua
-- vim adalah global table yang berisi semua Neovim API
print(vim.version())  -- Neovim version info

-- vim.api - Core API functions
-- vim.fn - Vimscript functions
-- vim.cmd - Execute Ex commands
-- vim.opt - Option management
-- vim.keymap - Keymap management
-- vim.autocmd - Autocommand management
```

#### Basic API Usage

```lua
-- Execute vimscript commands
vim.cmd('echo "Hello from Lua"')
vim.cmd([[
    set number
    set relativenumber
]])

-- Call vimscript functions
local line_count = vim.fn.line('$')
local current_file = vim.fn.expand('%:p')

-- Buffer operations
local current_buffer = vim.api.nvim_get_current_buf()
local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)
```

### 10.2 Neovim Options System

```lua
-- vim.opt - modern option interface
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- List options
vim.opt.runtimepath:append('/custom/path')

-- vim.o, vim.go, vim.bo, vim.wo - direct option access
vim.o.background = 'dark'      -- global
vim.bo.filetype = 'lua'        -- buffer-local
vim.wo.wrap = false            -- window-local
```

### 10.3 Keymaps dan Autocommands

```lua
-- Keymap creation
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {
    desc = 'Find files',
    silent = true,
    noremap = true
})

-- Multiple modes
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', {desc = 'Copy to clipboard'})

-- Autocommands
local augroup = vim.api.nvim_create_augroup('MyPlugin', {clear = true})

vim.api.nvim_create_autocmd('BufEnter', {
    group = augroup,
    pattern = '*.lua',
    callback = function()
        print('Entering Lua file')
    end
})
```

## **[11. Plugin Architecture dan Design Patterns][11]**

### 11.1 Plugin Structure Standards

#### Standard Plugin Layout

```
my-plugin/
├── lua/
│   └── my-plugin/
│       ├── init.lua          -- Main plugin entry
│       ├── config.lua        -- Configuration management
│       ├── utils.lua         -- Utility functions
│       └── modules/
│           ├── feature1.lua
│           └── feature2.lua
├── plugin/
│   └── my-plugin.vim         -- Plugin loading
└── doc/
    └── my-plugin.txt         -- Documentation
```

#### Plugin Init Pattern

```lua
-- lua/my-plugin/init.lua
local M = {}

-- Default configuration
local default_config = {
    enable_feature1 = true,
    enable_feature2 = false,
    custom_setting = "default_value"
}

-- Plugin state
local state = {
    initialized = false,
    config = {}
}

-- Setup function (required for modern plugins)
function M.setup(user_config)
    -- Merge user config with defaults
    state.config = vim.tbl_deep_extend('force', default_config, user_config or {})

    -- Initialize plugin
    if not state.initialized then
        M._initialize()
        state.initialized = true
    end
end

function M._initialize()
    -- Setup autocommands, keymaps, commands, etc.
    require('my-plugin.config').setup(state.config)
end

-- Public API functions
function M.some_function()
    if not state.initialized then
        error("Plugin not initialized. Call setup() first.")
    end
    -- Function implementation
end

return M
```

### 11.2 Configuration Management

```lua
-- lua/my-plugin/config.lua
local M = {}

function M.setup(config)
    -- Setup keymaps if enabled
    if config.enable_keymaps then
        M.setup_keymaps(config.keymaps)
    end

    -- Setup autocommands
    if config.enable_autocommands then
        M.setup_autocommands()
    end
end

function M.setup_keymaps(keymaps)
    for mode, mappings in pairs(keymaps) do
        for lhs, rhs in pairs(mappings) do
            vim.keymap.set(mode, lhs, rhs)
        end
    end
end

function M.setup_autocommands()
    local augroup = vim.api.nvim_create_augroup('MyPlugin', {clear = true})

    vim.api.nvim_create_autocmd('BufWritePost', {
        group = augroup,
        pattern = '*.lua',
        callback = function()
            -- Handle buffer save
        end
    })
end

return M
```

### 11.3 Event System dan Callbacks

```lua
-- Event emitter pattern
local EventEmitter = {}
EventEmitter.__index = EventEmitter

function EventEmitter:new()
    local obj = {
        listeners = {}
    }
    setmetatable(obj, self)
    return obj
end

function EventEmitter:on(event, callback)
    if not self.listeners[event] then
        self.listeners[event] = {}
    end
    table.insert(self.listeners[event], callback)
end

function EventEmitter:emit(event, ...)
    if self.listeners[event] then
        for _, callback in ipairs(self.listeners[event]) do
            callback(...)
        end
    end
end

-- Usage in plugin
local events = EventEmitter:new()

events:on('file_opened', function(filename)
    print('File opened:', filename)
end)

events:emit('file_opened', 'init.lua')
```

## **[12. Performance dan Optimization][12]**

### 12.1 Lua Performance Best Practices

#### Local Variables

```lua
-- Bad: accessing global repeatedly
for i = 1, 1000000 do
    math.sin(i)  -- global lookup setiap iterasi
end

-- Good: localize globals
local sin = math.sin
for i = 1, 1000000 do
    sin(i)  -- local access
end
```

#### Table Pre-allocation

```lua
-- Bad: table growth
local t = {}
for i = 1, 1000 do
    t[i] = i
end

-- Good: pre-allocate
local t = {}
for i = 1, 1000 do
    t[i] = i
end
-- Atau gunakan table.new jika tersedia
```

#### String Concatenation

```lua
-- Bad: multiple concatenations
local result = ""
for i = 1, 1000 do
    result = result .. tostring(i)
end

-- Good: table concat
local parts = {}
for i = 1, 1000 do
    parts[i] = tostring(i)
end
local result = table.concat(parts)
```

### 12.2 Memory Management

```lua
-- Weak references untuk caching
local cache = {}
setmetatable(cache, {__mode = "v"})  -- weak values

-- Explicit cleanup
local function cleanup()
    -- Clear large data structures
    for k in pairs(large_table) do
        large_table[k] = nil
    end

    -- Force garbage collection if needed
    collectgarbage("collect")
end
```

## **[13. Testing dan Quality Assurance][13]**

### 13.1 Unit Testing dengan Busted

```lua
-- spec/my_plugin_spec.lua
describe("My Plugin", function()
    local plugin

    before_each(function()
        plugin = require('my-plugin')
    end)

    it("should initialize correctly", function()
        plugin.setup({})
        assert.is_true(plugin.is_initialized())
    end)

    it("should handle configuration", function()
        local config = {enable_feature = true}
        plugin.setup(config)
        assert.equals(true, plugin.get_config().enable_feature)
    end)

    describe("utility functions", function()
        it("should validate input", function()
            assert.has_error(function()
                plugin.some_function(nil)
            end)
        end)
    end)
end)
```

### 13.2 Integration Testing

```lua
-- Test dengan Neovim API
describe("Neovim Integration", function()
    it("should create buffer correctly", function()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Hello", "World"})

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        assert.same({"Hello", "World"}, lines)
    end)
end)
```

## **[14. Advanced Plugin Development Patterns][14]**

### 14.1 Async Programming

```lua
-- Menggunakan vim.loop (libuv binding)
local uv = vim.loop

local function read_file_async(path, callback)
    uv.fs_open(path, "r", 438, function(err, fd)
        if err then
            callback(err)
            return
        end

        uv.fs_fstat(fd, function(err, stat)
            if err then
                callback(err)
                return
            end

            uv.fs_read(fd, stat.size, 0, function(err, data)
                uv.fs_close(fd, function() end)
                callback(err, data)
            end)
        end)
    end)
end

-- Usage
read_file_async('init.lua', function(err, data)
    if err then
        print('Error:', err)
    else
        print('File content:', data)
    end
end)
```

### 14.2 Job Control

```lua
-- Running external commands
local function run_command(cmd, args, callback)
    local stdout = uv.new_pipe(false)
    local stderr = uv.new_pipe(false)

    local handle = uv.spawn(cmd, {
        args = args,
        stdio = {nil, stdout, stderr}
    }, function(code, signal)
        callback(code, signal)
    end)

    uv.read_start

    uv.read_start(stdout, function(err, data)
        if data then
            print('stdout:', data)
        end
    end)

    uv.read_start(stderr, function(err, data)
        if data then
            print('stderr:', data)
        end
    end)

    return handle
end

-- Usage
run_command('git', {'status', '--porcelain'}, function(code, signal)
    print('Command finished with code:', code)
end)
```

### 14.3 Plugin Communication dan Integration

```lua
-- Plugin registry pattern
local PluginRegistry = {}
PluginRegistry.plugins = {}

function PluginRegistry.register(name, plugin)
    PluginRegistry.plugins[name] = plugin
end

function PluginRegistry.get(name)
    return PluginRegistry.plugins[name]
end

function PluginRegistry.has(name)
    return PluginRegistry.plugins[name] ~= nil
end

-- Cross-plugin communication
local function integrate_with_telescope()
    if PluginRegistry.has('telescope') then
        local telescope = PluginRegistry.get('telescope')
        -- Add custom picker
        telescope.register_picker('my_picker', function()
            -- Custom telescope picker implementation
        end)
    end
end
```

## **[15. Buffer dan Window Management][15]**

### 15.1 Buffer Operations

```lua
-- Buffer creation dan manipulation
local function create_scratch_buffer()
    local buf = vim.api.nvim_create_buf(false, true)  -- not listed, scratch

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'my-plugin')

    -- Set buffer content
    local lines = {
        "Welcome to My Plugin",
        "Press 'q' to quit",
        "",
        "Content goes here..."
    }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Make buffer read-only
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)

    return buf
end

-- Buffer-local keymaps
local function setup_buffer_keymaps(buf)
    local opts = {buffer = buf, silent = true}

    vim.keymap.set('n', 'q', function()
        vim.api.nvim_buf_delete(buf, {force = true})
    end, opts)

    vim.keymap.set('n', '<CR>', function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = cursor[1]
        -- Handle selection
        handle_selection(line)
    end, opts)
end
```

### 15.2 Window Management

```lua
-- Floating window creation
local function create_floating_window(buf, title)
    -- Get editor dimensions
    local width = vim.api.nvim_get_option('columns')
    local height = vim.api.nvim_get_option('lines')

    -- Calculate floating window size
    local win_height = math.ceil(height * 0.8 - 4)
    local win_width = math.ceil(width * 0.8)

    -- Calculate starting position
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    -- Window configuration
    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded",
        title = title,
        title_pos = "center"
    }

    -- Create window
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Set window options
    vim.api.nvim_win_set_option(win, 'cursorline', true)
    vim.api.nvim_win_set_option(win, 'wrap', false)

    return win
end

-- Split window management
local function create_side_panel(buf)
    -- Create vertical split
    vim.cmd('vsplit')
    local win = vim.api.nvim_get_current_win()

    -- Set buffer in window
    vim.api.nvim_win_set_buf(win, buf)

    -- Resize window
    vim.api.nvim_win_set_width(win, 40)

    return win
end
```

## **[16. Text Manipulation dan Parsing][16]**

### 16.1 Advanced String Operations

```lua
-- Pattern matching utilities
local function extract_function_names(content)
    local functions = {}

    -- Lua function pattern
    for func_name in content:gmatch("function%s+([%w_%.]+)%s*%(") do
        table.insert(functions, func_name)
    end

    -- Local function pattern
    for func_name in content:gmatch("local%s+function%s+([%w_]+)%s*%(") do
        table.insert(functions, func_name)
    end

    return functions
end

-- Text processing dengan coroutines
local function process_large_text(text, processor)
    local co = coroutine.create(function()
        local lines = vim.split(text, '\n')
        for i, line in ipairs(lines) do
            local processed = processor(line)
            coroutine.yield(processed)

            -- Yield control setiap 100 lines untuk responsiveness
            if i % 100 == 0 then
                vim.schedule(function() end)
            end
        end
    end)

    return co
end
```

### 16.2 LSP Integration Patterns

```lua
-- LSP client integration
local function setup_lsp_integration()
    -- Register custom LSP handler
    vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        -- Custom diagnostic processing
        if result and result.diagnostics then
            for _, diagnostic in ipairs(result.diagnostics) do
                -- Process diagnostic
                process_diagnostic(diagnostic)
            end
        end

        -- Call default handler
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
    end
end

-- Custom LSP commands
local function register_lsp_commands()
    vim.lsp.commands['my-plugin/custom-action'] = function(command, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
            -- Perform custom action
            perform_custom_action(command.arguments, client)
        end
    end
end
```

## **[17. File System Operations][17]**

### 17.1 File I/O dengan Error Handling

```lua
-- Safe file operations
local function read_file_safe(path)
    local file, err = io.open(path, 'r')
    if not file then
        return nil, "Cannot open file: " .. err
    end

    local content, read_err = file:read('*all')
    file:close()

    if not content then
        return nil, "Cannot read file: " .. read_err
    end

    return content
end

local function write_file_safe(path, content)
    local file, err = io.open(path, 'w')
    if not file then
        return false, "Cannot create file: " .. err
    end

    local success, write_err = file:write(content)
    file:close()

    if not success then
        return false, "Cannot write file: " .. write_err
    end

    return true
end

-- Directory operations
local function ensure_directory(path)
    local stat = vim.loop.fs_stat(path)
    if not stat then
        local success = vim.fn.mkdir(path, 'p')
        if success == 0 then
            return false, "Cannot create directory: " .. path
        end
    elseif stat.type ~= 'directory' then
        return false, "Path exists but is not a directory: " .. path
    end
    return true
end
```

### 17.2 Path Manipulation

```lua
-- Cross-platform path utilities
local path_sep = package.config:sub(1,1)  -- '/' on Unix, '\' on Windows

local function join_path(...)
    local parts = {...}
    return table.concat(parts, path_sep)
end

local function normalize_path(path)
    -- Convert to forward slashes and resolve .. and .
    path = path:gsub('\\', '/')

    local parts = vim.split(path, '/')
    local normalized = {}

    for _, part "../../../../../../embedded/lua/nich/plugin/pembelajaran-praktis"in ipairs(parts) do
        if part "../../../../../../embedded/lua/nich/plugin/pembelajaran-praktis"== '..' and #normalized > 0 and normalized[#normalized] ~= '..' then
            table.remove(normalized)
        elseif part "../../../../../../embedded/lua/nich/plugin/pembelajaran-praktis"~= '.' and part "../../../../../../embedded/lua/nich/plugin/pembelajaran-praktis"~= '' then
            table.insert(normalized, part)
        end
    end

    return table.concat(normalized, '/')
end

local function get_relative_path(from, to)
    from = normalize_path(from)
    to = normalize_path(to)

    local from_parts = vim.split(from, '/')
    local to_parts = vim.split(to, '/')

    -- Find common prefix
    local common = 0
    for i = 1, math.min(#from_parts, #to_parts) do
        if from_parts[i] == to_parts[i] then
            common = i
        else
            break
        end
    end

    -- Build relative path
    local rel_parts = {}

    -- Add .. for each remaining from part
    "../../../../../../embedded/lua/nich/plugin/pembelajaran-praktis"for i = common + 1, #from_parts do
        table.insert(rel_parts, '..')
    end

    -- Add remaining to parts
    for i = common + 1, #to_parts do
        table.insert(rel_parts, to_parts[i])
    end

    return #rel_parts > 0 and table.concat(rel_parts, '/') or '.'
end
```

## **[18. Configuration dan Persistence][18]**

### 18.1 Configuration Schema Validation

```lua
-- Configuration schema definition
local ConfigSchema = {}

function ConfigSchema.validate(config, schema)
    local function validate_value(value, schema_def, path)
        path = path or "config"

        if schema_def.type then
            local actual_type = type(value)
            if actual_type ~= schema_def.type then
                error(string.format("%s: expected %s, got %s", path, schema_def.type, actual_type))
            end
        end

        if schema_def.validator and not schema_def.validator(value) then
            error(string.format("%s: validation failed", path))
        end

        if schema_def.properties and type(value) == "table" then
            for key, prop_schema in pairs(schema_def.properties) do
                if value[key] ~= nil then
                    validate_value(value[key], prop_schema, path .. "." .. key)
                elseif prop_schema.required then
                    error(string.format("%s.%s: required property missing", path, key))
                end
            end
        end
    end

    validate_value(config, schema)
    return true
end

-- Usage example
local plugin_schema = {
    type = "table",
    properties = {
        enable_auto_save = {
            type = "boolean",
            default = true
        },
        max_file_size = {
            type = "number",
            validator = function(v) return v > 0 and v <= 1000000 end
        },
        excluded_filetypes = {
            type = "table",
            default = {"help", "alpha"}
        },
        keymaps = {
            type = "table",
            properties = {
                save = {type = "string", default = "<C-s>"},
                load = {type = "string", default = "<C-l>"}
            }
        }
    }
}
```

### 18.2 Persistent Storage

```lua
-- Data persistence utilities
local Storage = {}

function Storage.get_data_dir()
    return vim.fn.stdpath('data') .. '/my-plugin'
end

function Storage.ensure_data_dir()
    local data_dir = Storage.get_data_dir()
    return ensure_directory(data_dir)
end

function Storage.save_json(filename, data)
    local success, err = Storage.ensure_data_dir()
    if not success then
        return false, err
    end

    local filepath = join_path(Storage.get_data_dir(), filename .. '.json')
    local json_str = vim.fn.json_encode(data)

    return write_file_safe(filepath, json_str)
end

function Storage.load_json(filename)
    local filepath = join_path(Storage.get_data_dir(), filename .. '.json')
    local content, err = read_file_safe(filepath)

    if not content then
        return nil, err
    end

    local success, data = pcall(vim.fn.json_decode, content)
    if not success then
        return nil, "Invalid JSON data"
    end

    return data
end

-- Session management
local Session = {}

function Session.save_state(state)
    return Storage.save_json('session', {
        timestamp = os.time(),
        state = state
    })
end

function Session.load_state()
    local data, err = Storage.load_json('session')
    if not data then
        return nil, err
    end

    return data.state
end
```

## 19. User Interface Components

### 19.1 Menu System

```lua
-- Menu component
local Menu = {}
Menu.__index = Menu

function Menu:new(items, opts)
    opts = opts or {}
    local obj = {
        items = items,
        selected = 1,
        title = opts.title or "Menu",
        on_select = opts.on_select,
        on_cancel = opts.on_cancel,
        buf = nil,
        win = nil
    }
    setmetatable(obj, self)
    return obj
end

function Menu:render()
    local lines = {self.title, string.rep('-', #self.title)}

    for i, item in ipairs(self.items) do
        local prefix = i == self.selected and '> ' or '  '
        local text = type(item) == 'string' and item or item.text
        table.insert(lines, prefix .. text)
    end

    return lines
end

function Menu:show()
    -- Create buffer
    self.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(self.buf, 'modifiable', false)

    -- Update content
    self:update()

    -- Create floating window
    self.win = create_floating_window(self.buf, self.title)

    -- Setup keymaps
    self:setup_keymaps()
end

function Menu:update()
    local lines = self:render()
    vim.api.nvim_buf_set_option(self.buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(self.buf, 'modifiable', false)

    -- Update cursor position
    if self.win and vim.api.nvim_win_is_valid(self.win) then
        vim.api.nvim_win_set_cursor(self.win, {self.selected + 2, 0})
    end
end

function Menu:setup_keymaps()
    local opts = {buffer = self.buf, silent = true}

    -- Navigation
    vim.keymap.set('n', 'j', function() self:move_down() end, opts)
    vim.keymap.set('n', 'k', function() self:move_up() end, opts)
    vim.keymap.set('n', '<Down>', function() self:move_down() end, opts)
    vim.keymap.set('n', '<Up>', function() self:move_up() end, opts)

    -- Selection
    vim.keymap.set('n', '<CR>', function() self:select() end, opts)
    vim.keymap.set('n', '<Space>', function() self:select() end, opts)

    -- Cancel
    vim.keymap.set('n', 'q', function() self:cancel() end, opts)
    vim.keymap.set('n', '<Esc>', function() self:cancel() end, opts)
end

function Menu:move_down()
    self.selected = math.min(self.selected + 1, #self.items)
    self:update()
end

function Menu:move_up()
    self.selected = math.max(self.selected - 1, 1)
    self:update()
end

function Menu:select()
    local item = self.items[self.selected]
    self:close()

    if self.on_select then
        self.on_select(item, self.selected)
    end
end

function Menu:cancel()
    self:close()
    if self.on_cancel then
        self.on_cancel()
    end
end

function Menu:close()
    if self.win and vim.api.nvim_win_is_valid(self.win) then
        vim.api.nvim_win_close(self.win, true)
    end
end
```

### 19.2 Progress Indicator

```lua
-- Progress bar component
local Progress = {}
Progress.__index = Progress

function Progress:new(opts)
    opts = opts or {}
    local obj = {
        title = opts.title or "Progress",
        total = opts.total or 100,
        current = 0,
        width = opts.width or 50,
        buf = nil,
        win = nil,
        timer = nil
    }
    setmetatable(obj, self)
    return obj
end

function Progress:show()
    self.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(self.buf, 'modifiable', false)

    self.win = create_floating_window(self.buf, self.title)
    self:update()
end

function Progress:update()
    local percent = math.floor((self.current / self.total) * 100)
    local filled = math.floor((self.current / self.total) * self.width)
    local empty = self.width - filled

    local bar = string.rep('█', filled) .. string.rep('░', empty)
    local lines = {
        self.title,
        string.format("[%s] %d%%", bar, percent),
        string.format("%d / %d", self.current, self.total)
    }

    vim.api.nvim_buf_set_option(self.buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(self.buf, 'modifiable', false)
end

function Progress:increment(amount)
    amount = amount or 1
    self.current = math.min(self.current + amount, self.total)
    self:update()

    if self.current >= self.total then
        vim.defer_fn(function()
            self:close()
        end, 1000)  -- Auto-close after 1 second when complete
    end
end

function Progress:set_progress(value)
    self.current = math.max(0, math.min(value, self.total))
    self:update()
end

function Progress:close()
    if self.timer then
        self.timer:stop()
        self.timer:close()
    end

    if self.win and vim.api.nvim_win_is_valid(self.win) then
        vim.api.nvim_win_close(self.win, true)
    end
end
```

## 20. Plugin Integration Examples

### 20.1 Telescope Integration

```lua
-- Custom Telescope picker
local function create_telescope_picker()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local function my_picker(opts)
        opts = opts or {}

        pickers.new(opts, {
            prompt_title = "My Plugin Items",
            finder = finders.new_table {
                results = get_plugin_items(),  -- Your data source
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.name,
                        ordinal = entry.name,
                    }
                end,
            },
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    -- Handle selection
                    handle_telescope_selection(selection.value)
                end)
                return true
            end,
        }):find()
    end

    return my_picker
end

-- Register with Telescope
local function setup_telescope_integration()
    local has_telescope, telescope = pcall(require, 'telescope')
    if not has_telescope then
        return
    end

    telescope.register_extension {
        setup = function(ext_config, config)
            -- Extension setup
        end,
        exports = {
            my_picker = create_telescope_picker()
        }
    }
end
```

### 20.2 Treesitter Integration

```lua
-- Treesitter utilities
local function get_treesitter_integration()
    local has_treesitter, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
    if not has_treesitter then
        return nil
    end

    local function get_node_at_cursor()
        local node = ts_utils.get_node_at_cursor()
        return node
    end

    local function get_function_nodes()
        local parser = vim.treesitter.get_parser()
        local tree = parser:parse()[1]
        local root = tree:root()

        local functions = {}
        local query = vim.treesitter.query.parse('lua', [[
            (function_declaration name: (identifier) @func_name)
            (assignment_statement
                (variable_list name: (identifier) @var_name)
                (expression_list value: (function_definition)))
        ]])

        for id, node in query:iter_captures(root, 0) do
            local name = query.captures[id]
            if name == "func_name" or name == "var_name" then
                local text = vim.treesitter.get_node_text(node, 0)
                table.insert(functions, {
                    name = text,
                    node = node,
                    start_row = node:start(),
                    end_row = node:end_()
                })
            end
        end

        return functions
    end

    return {
        get_node_at_cursor = get_node_at_cursor,
        get_function_nodes = get_function_nodes
    }
end
```

## 21. Deployment dan Distribution

### 21.1 Plugin Packaging

```lua
-- lua/my-plugin/health.lua - Health check
local M = {}

function M.check()
    vim.health.report_start("My Plugin")

    -- Check Neovim version
    if vim.fn.has('nvim-0.8') == 1 then
        vim.health.report_ok("Neovim version >= 0.8")
    else
        vim.health.report_error("Neovim version < 0.8", {
            "Update Neovim to version 0.8 or higher"
        })
    end

    -- Check dependencies
    local deps = {'telescope', 'nvim-treesitter'}
    for _, dep in ipairs(deps) do
        local has_dep = pcall(require, dep)
        if has_dep then
            vim.health.report_ok(dep .. " is installed")
        else
            vim.health.report_warn(dep .. " is not installed", {
                "Install " .. dep .. " for full functionality"
            })
        end
    end

    -- Check configuration
    local config = require('my-plugin').get_config()
    if config then
        vim.health.report_ok("Plugin is configured")
    else
        vim.health.report_error("Plugin not configured", {
            "Run require('my-plugin').setup{} in your config"
        })
    end
end

return M
```

### 21.2 Documentation Generation

```lua
-- Generate documentation from code
local function generate_docs()
    local docs = {
        "# My Plugin Documentation",
        "",
        "## API Reference",
        ""
    }

    -- Parse module files for documentation
    local function parse_module(filepath)
        local content, err = read_file_safe(filepath)
        if not content then
            return
        end

        -- Extract function documentation
        for func_doc in content:gmatch("%-%-%-([^%c]*)\nfunction ([%w_%.]+)") do
            local doc_text, func_name = func_doc:match("^(.*)\nfunction ([%w_%.]+)")
            if doc_text and func_name then
                table.insert(docs, "### " .. func_name)
                table.insert(docs, "")
                table.insert(docs, doc_text)
                table.insert(docs, "")
            end
        end
    end

    -- Process all Lua files
    local plugin_dir = vim.fn.stdpath('config') .. '/lua/my-plugin'
    local files = vim.fn.glob(plugin_dir .. '/**/*.lua', false, true)

    for _, file in ipairs(files) do
        parse_module(file)
    end

    return table.concat(docs, '\n')
end
```

## 22. Best Practices Summary

### 22.1 Code Organization

- **Modular design**: Pecah plugin menjadi modul-modul kecil yang focused
- **Clear separation**: Pisahkan configuration, API, UI, dan utility functions
- **Consistent naming**: Gunakan konvensi penamaan yang konsisten
- **Error boundaries**: Implement proper error handling di setiap layer

### 22.2 Performance Considerations

- **Lazy loading**: Load komponen hanya ketika diperlukan
- **Local variables**: Localize global references yang sering digunakan
- **Memory management**: Cleanup resources yang tidak diperlukan
- **Async operations**: Gunakan coroutines atau vim.schedule untuk operasi berat

### 22.3 User Experience

- **Progressive disclosure**: Tampilkan opsi advanced hanya ketika diperlukan
- **Sensible defaults**: Provide configuration defaults yang masuk akal
- **Feedback**: Berikan feedback visual untuk operasi yang memakan waktu
- **Documentation**: Provide comprehensive help dan examples

### 22.4 Compatibility

- **Version checking**: Check Neovim version dan dependencies
- **Graceful degradation**: Provide fallbacks untuk missing dependencies
- **Cross-platform**: Handle path separators dan OS-specific behaviors
- **Backward compatibility**: Maintain API stability across versions

## 1. Fondasi Bahasa Lua

1. **Sintaks Dasar & Struktur Kontrol**

   - Tipe data (nil, boolean, number, string, table, function)
   - `if`, `for`, `while`, `repeat…until`

2. **Fungsi dan First-Class Functions**

   - Anonymous functions, closures, varargs (`...`)
   - Penggunaan dan penerapan _higher-order functions_

3. **Table sebagai Struktur Data Serbaguna**

   - Array vs. hash-map
   - Iterasi dengan `pairs` dan `ipairs`

4. **Modularisasi & Package**

   - `require` dan `package.path`
   - Memahami _module loader_ bawaan Lua

---

## 2. Konsep Lanjutan Lua

1. **Metatable & Metamethods**

   - Overloading operator (`__index`, `__newindex`, `__call`, dll.)
   - Membuat object-like dan proxy tables

2. **Environment & Sandboxing**

   - `_ENV` (Lua 5.2+) untuk mengontrol global namespace
   - Amankan eksekusi kode plugin

3. **Coroutine & Asynchrony**

   - Membuat coroutine, `coroutine.resume`/`yield`
   - Pola _producer-consumer_ atau _task scheduling_ sederhana

4. **Error Handling**

   - `pcall` vs. `xpcall` dan debugging stack traceback

5. **Memory Management & Garbage Collection**

   - Bagaimana Lua mengelola memori, kapan meng­-trigger GC

---

## 3. Neovim-Spesifik

1. **API Lua Neovim**

   - `vim.api.nvim_*` untuk command, buffer, window, extmarks, autocommand
   - `vim.fn.*` untuk memanggil VimL functions

2. **Job Control & Async I/O**

   - `vim.loop` (libuv binding) untuk spawn proses, timers, filesystem watcher
   - `vim.fn.jobstart`/`jobwait` untuk task eksternal

3. **Keymap & Command Creation**

   - `vim.keymap.set()`, `vim.api.nvim_create_user_command()`

4. **Autoloading & Lazy-Loading Patterns**

   - Strategi loading berdasarkan event (BufRead, CmdUndefined, keystroke)
   - Dinamis memanipulasi `runtimepath` dan `package.loaded`

5. **Plugin Discovery & Registry**

   - Menelusuri direktori plugin, membaca `init.lua` atau `plugin/*.lua`
   - Membuat manifest (mis. JSON atau Lua table) untuk daftar plugin dan metadata

---

## 4. Software Engineering & Desain

1. **Arsitektur Modular**

   - Pisahkan core manager, resolver (dependency), downloader, loader, dan UI
   - Gunakan folder `lua/manager/{core,resolver,downloader,loader,ui}`

2. **Dependency Resolution & Versioning**

   - Algoritma topological sort untuk urutan install/load
   - SemVer parsing, fallback ke Git tags/branches

3. **IO & Caching**

   - Download via Git/HTTP (`git clone`, `curl`) asinkron
   - Cache plugin terdownload, checksum verify, invalidasi cache

4. **Concurrency Control**

   - Batasi jumlah job parallel, antrean, timeouts

5. **Testing & CI**

   - Unit test dengan [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
   - Mocking filesystem & jobstart, jalankan di GH Actions

---

## 5. UX & Integrasi

1. **User Configuration API**

   - `setup({ … })` pattern dengan merge default + user opts
   - Validasi tipe opsi dan beri error message yang informatif

2. **Tampilan & Feedback**

   - Progress bar (virt_lines), `vim.notify`, floating window dengan status install/update

3. **Keybindings Kustom**

   - Shortcut default, tapi bisa di-override

4. **Kompatibilitas Terminal & GUI**

   - Fallback untuk terminal yang tak support floating window

5. **Dokumentasi Otomatis**

   - Generate `:help manager.txt` dari komentar Lua atau template

---

## 6. Sumber Belajar & Latihan

- **Lua**:

  - _Programming in Lua_ (Roberto Ierusalimschy)
  - learnlua.org (interaktif)

- **Neovim Lua API**:

  - `:help lua-guide`, `:help api`
  - [nvim-lua guide](https://github.com/nanotee/nvim-lua-guide)

- **Contoh Plugin Manager**:

  - [packer.nvim](https://github.com/wbthomason/packer.nvim)
  - [lazy.nvim](https://github.com/folke/lazy.nvim) (studi kode mereka)

- **Async & LibUV**:

  - Dokumentasi libuv, artikel “Asynchronous Lua Patterns”

- **Desain Sistem**:

  - Buku “Designing Data-Intensive Applications” (Bab dependency graphs)
  - Artikel tentang package managers (npm, pip)

## Kesimpulan

Materi Lua yang telah dijelaskan mencakup semua aspek yang diperlukan untuk pengembangan plugin Neovim yang sophisticated. Dengan pemahaman mendalam tentang:

1. **Foundasi Lua**: Syntax, data types, control structures
2. **Advanced concepts**: OOP, metatable, coroutines, closures
3. **Neovim integration**: API, buffer/window management, events
4. **Plugin architecture**: Modular design, configuration, testing
5. **UI components**: Floating windows, menus, progress indicators
6. **Integration patterns**: Telescope, LSP, Treesitter
7. **Performance optimization**: Memory management, async patterns

Anda akan memiliki kemampuan untuk membuat plugin Neovim yang tidak hanya memenuhi kebutuhan IDE terminal-based, tetapi juga dapat diperluas dengan fitur-fitur additional sesuai kebutuhan spesifik Anda. Setiap konsep telah dijelaskan dengan detail syntax, terminology, dan implementasi praktis yang dapat langsung diaplikasikan dalam pengembangan plugin. Dengan menguasai tumpukan pengetahuan ini—dari dasar-dasar Lua hingga arsitektur plugin manager anda akan merancang dan membangun sendiri plugin manager matching atau melampaui lazy.nvim. Mulai pelan-pelan, pahami setiap lapisannya, lalu integrasikan—sambil tetap enjoy ngoding! 🚀

# Daftar Rekomendasi Modul

- **FOUNDATION LEVEL**

  1.  Modul 1: Lingkungan & Persiapan
  2.  Modul 2: Sintaks Dasar & Tipe Data
  3.  Modul 3: Operator & Ekspresi&#x20;

- **INTERMEDIATE LEVEL**

  4. Modul 4: Alur Kontrol & Perulangan
  5. Modul 5: Fungsi & Cakupan Variabel&#x20;

- **ADVANCED LEVEL**

  6. Modul 6: Tabel – Kekuatan Super Lua
  7. Modul 7: Pemrosesan String & Pola
  8. Modul 8: Pemrograman Berorientasi Objek&#x20;

- **EXPERT LEVEL**

  9. Modul 9: Metatables & Metamethods
  10. Modul 10: Coroutines & Concurrency
  11. Modul 11: Modul & Paket&#x20;

- **SPECIALIZED DOMAINS**

  12. Modul 12: File I/O & Pemrograman Sistem
  13. Modul 13: Penanganan Error & Debugging
  14. Modul 14: C API & Ekstensi
  15. Modul 15: Matematika & Utilitas&#x20;

- **PROFESSIONAL APPLICATIONS**

  16. Modul 16: Pengembangan Web
  17. Modul 17: Pengembangan Game
  18. Modul 18: Sistem Embedded
  19. Modul 19: Data Science & Analisis
  20. Modul 20: Scripting & Otomasi&#x20;

- **ADVANCED INTEGRATION**

  21. Modul 21: Integrasi Database&#x20;

> Untuk dapat melihat daftarnya secara lengkap kunjungi [berikut](../../../README.md)

[1]: ../neovim/module/1-dasar/README.md
[2]: ../neovim/module/2-variable/README.md
[3]: ../neovim/module/3-operator-kontrolFlow/README.md
[4]: ../neovim/module/4-struktur-data-kompleks/README.md
[5]: ../neovim/module/5-function/README.md
[6]: ../neovim/module/6-oop/README.md
[7]: ../neovim/module/7-modules-dan-manajemenPaket/README.md
[8]: ../neovim/module/8-error-handling-dan-debugging/README.md
[9]: ../neovim/module/9-coroutines-konkurensi/README.md
[10]: ../neovim/module/10-metatables/README.md
[11]: ../neovim/module/11-plugin-structure-standards/README.md/#11-interaksi-dengan-sistem-file-dan-os
[12]: ../neovim/module/12-lua-performance-best-practices/README.md/
[13]: ../neovim/module/13-unit-testing-dengan-busted/README.md/
[14]: ../neovim/module/14-async-programming/README.md/
[15]: ../neovim/module/15-ui/README.md
[16]: ../neovim/module/16-floating-windows/README.md
[17]: ../neovim/module/17-lsp/README.md
[18]: ../neovim/module/18-testing/README.md

<!-- ------------- -->

[string1]: ../../../dasar/string/README.md
