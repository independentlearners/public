# Kurikulum Lengkap Function di Lua

## **Bagian 1: Dasar-Dasar Function**

### 1.1 Pengenalan Function

- **Apa itu function dan mengapa penting**
- **Sintaks dasar function di Lua**
- **Perbedaan function dengan statement lainnya**
- **Function sebagai first-class citizen**

**Sumber:**

- [Lua 5.4 Reference Manual - Functions](https://www.lua.org/manual/5.4/manual.html#3.4.11)
- [Programming in Lua - Function Basics](https://www.lua.org/pil/5.html)

### 1.2 Membuat Function Sederhana

- **Deklarasi function dengan `function` keyword**
- **Parameter dan argument**
- **Return values**
- **Local vs global functions**

**Sumber:**

- [Lua Tutorial - Functions](https://www.tutorialspoint.com/lua/lua_functions.htm)
- [Learn Lua in Y Minutes - Functions](https://learnxinyminutes.com/docs/lua/)

### 1.3 Function Scope dan Visibility

- **Local functions**
- **Global functions**
- **Upvalues dan closures dasar**
- **Function hoisting di Lua**

**Sumber:**

- [Programming in Lua - Local Variables and Blocks](https://www.lua.org/pil/4.2.html)
- [Lua Users Wiki - Scope Tutorial](http://lua-users.org/wiki/ScopeTutorial)

## **Bagian 2: Parameter dan Return Values**

### 2.1 Parameter Handling

- **Fixed parameters**
- **Variable arguments (...)**
- **Default parameter simulation**
- **Named parameters menggunakan tables**

**Sumber:**

- [Programming in Lua - Variable Number of Arguments](https://www.lua.org/pil/5.2.html)
- [Lua Users Wiki - Variable Arguments](http://lua-users.org/wiki/VarargTheSecondLook)

### 2.2 Multiple Return Values

- **Returning multiple values**
- **Unpacking return values**
- **Using select() dengan multiple returns**
- **Best practices untuk multiple returns**

**Sumber:**

- [Programming in Lua - Multiple Results](https://www.lua.org/pil/5.1.html)
- [Lua Performance Tips - Multiple Returns](http://lua-users.org/wiki/OptimisationTips)

### 2.3 Advanced Parameter Patterns

- **Function overloading simulation**
- **Parameter validation**
- **Type checking dalam parameters**
- **Error handling untuk invalid parameters**

**Sumber:**

- [Lua Users Wiki - Function Overloading](http://lua-users.org/wiki/FunctionOverloading)
- [Programming in Lua - Error Handling](https://www.lua.org/pil/8.html)

## **Bagian 3: Function Types dan Styles**

### 3.1 Anonymous Functions

- **Function expressions**
- **Lambda-style functions**
- **Inline functions**
- **Function sebagai arguments**

**Sumber:**

- [Programming in Lua - Anonymous Functions](https://www.lua.org/pil/6.1.html)
- [Lua Users Wiki - Anonymous Functions](http://lua-users.org/wiki/AnonymousFunction)

### 3.2 Higher-Order Functions

- **Functions yang menerima functions**
- **Functions yang mengembalikan functions**
- **Function composition**
- **Callback patterns**

**Sumber:**

- [Programming in Lua - Higher-Order Functions](https://www.lua.org/pil/6.html)
- [Lua Functional Programming Guide](http://lua-users.org/wiki/FunctionalProgramming)

### 3.3 Recursive Functions

- **Direct recursion**
- **Tail recursion**
- **Mutual recursion**
- **Memoization untuk optimasi**

**Sumber:**

- [Programming in Lua - Tail Calls](https://www.lua.org/pil/6.3.html)
- [Lua Users Wiki - Recursion](http://lua-users.org/wiki/RecursiveFunctions)

## **Bagian 4: Closures dan Upvalues**

### 4.1 Understanding Closures

- **Apa itu closure**
- **Lexical scoping**
- **Upvalues dalam detail**
- **Closure vs global variables**

**Sumber:**

- [Programming in Lua - Closures](https://www.lua.org/pil/6.1.html)
- [Lua Manual - Lexical Scoping](https://www.lua.org/manual/5.4/manual.html#3.5)

### 4.2 Practical Closures

- **Factory functions**
- **Private variables simulation**
- **Stateful functions**
- **Event handlers dengan closures**

**Sumber:**

- [Lua Users Wiki - Closures Tutorial](http://lua-users.org/wiki/ClosuresTutorial)
- [Programming in Lua - A Taste of Functional Programming](https://www.lua.org/pil/6.html)

### 4.3 Advanced Closure Patterns

- **Closure-based modules**
- **Decorator pattern dengan closures**
- **Currying dan partial application**
- **Memory management dengan closures**

**Sumber:**

- [Lua Users Wiki - Currying](http://lua-users.org/wiki/CurriedLua)
- [Advanced Lua Programming Techniques](http://lua-users.org/wiki/LuaTutorial)

## **Bagian 5: Metatables dan Functions**

### 5.1 \_\_call Metamethod

- **Membuat tables callable**
- **Function-like objects**
- **Implementing functors**
- **Advanced \_\_call patterns**

**Sumber:**

- [Programming in Lua - Metatables](https://www.lua.org/pil/13.html)
- [Lua Manual - Metamethods](https://www.lua.org/manual/5.4/manual.html#2.4)

### 5.2 Function Metatables

- **Setting metatables untuk functions**
- **Function introspection**
- **Function modification**
- **Debugging dengan function metatables**

**Sumber:**

- [Lua Users Wiki - Function Metatable](http://lua-users.org/wiki/FunctionMetatable)
- [Programming in Lua - Debug Library](https://www.lua.org/pil/23.html)

## **Bagian 6: Coroutines dan Functions**

### 6.1 Coroutines Basics

- **Creating coroutines dengan functions**
- **yield dan resume**
- **Coroutine states**
- **Error handling dalam coroutines**

**Sumber:**

- [Programming in Lua - Coroutines](https://www.lua.org/pil/9.html)
- [Lua Manual - Coroutines](https://www.lua.org/manual/5.4/manual.html#2.6)

### 6.2 Advanced Coroutine Patterns dengan Functions

- **Producer-consumer dengan coroutines**
- **Cooperative multitasking**
- **Generators menggunakan coroutines**
- **Lazy iterators dan on-demand computation**
- **Async patterns dengan coroutines**
- **Coroutine-based state machines**
- **Stream processing dengan coroutines**
- **Coroutines vs Python generators comparison**

**Sumber:**

- [Lua Users Wiki - Coroutine Patterns](http://lua-users.org/wiki/CoroutinesTutorial)
- [Programming in Lua - Iterators and Closures](https://www.lua.org/pil/7.html)
- [Programming in Lua - Coroutines as Iterators](https://www.lua.org/pil/9.3.html)
- [Lua Coroutines vs Python Generators](http://lua-users.org/wiki/LuaCoroutinesVersusPythonGenerators)
- [Understanding Coroutines in Lua](https://softwarepatternslexicon.com/patterns-lua/9/1/)

## **Bagian 7: Performance dan Optimization**

### 7.1 Function Performance

- **Function call overhead**
- **Local vs global function performance**
- **Upvalue access performance**
- **Tail call optimization**

**Sumber:**

- [Lua Performance Tips](http://lua-users.org/wiki/OptimisationTips)
- [Programming in Lua - Performance Tips](https://www.lua.org/pil/25.html)

### 7.2 Memory Management

- **Function memory usage**
- **Closure memory implications**
- **Garbage collection dan functions**
- **Weak references dengan functions**

**Sumber:**

- [Programming in Lua - Garbage Collection](https://www.lua.org/pil/17.html)
- [Lua Manual - Garbage Collection](https://www.lua.org/manual/5.4/manual.html#2.5)

## **Bagian 8: Advanced Function Techniques**

### 8.1 Function Composition dan Chaining

- **Composing functions**
- **Method chaining**
- **Pipeline patterns**
- **Functional programming style**

**Sumber:**

- [Lua Functional Programming](http://lua-users.org/wiki/FunctionalProgramming)
- [Function Composition in Lua](http://lua-users.org/wiki/FunctionComposition)

### 8.2 Dynamic Function Generation dan Metaprogramming

- **Creating functions at runtime**
- **loadstring dan load untuk function generation**
- **Code generation dengan functions**
- **Template functions**
- **Meta-programming dengan functions**
- **AST manipulation dan macro systems**
- **Token filtering dan preprocessing**

**Sumber:**

- [Lua Users Wiki - Dynamic Code Generation](http://lua-users.org/wiki/DynamicCodeGeneration)
- [Programming in Lua - Compilation, Execution, and Errors](https://www.lua.org/pil/8.html)
- [Lua Users Wiki - Meta Programming](http://lua-users.org/wiki/MetaProgramming)
- [Experimental Meta-Programming for Lua](https://mr.gy/blog/lua-meta-programming.html)

### 8.3 Function Introspection

- **Debug library untuk functions**
- **Function information**
- **Stack traces**
- **Profiling functions**

**Sumber:**

- [Programming in Lua - Debug Library](https://www.lua.org/pil/23.html)
- [Lua Manual - Debug Interface](https://www.lua.org/manual/5.4/manual.html#4.7)

## **Bagian 9: Patterns dan Best Practices**

### 9.1 Common Function Patterns

- **Factory pattern**
- **Builder pattern**
- **Observer pattern dengan functions**
- **Strategy pattern**

**Sumber:**

- [Lua Design Patterns](http://lua-users.org/wiki/LuaDesignPatterns)
- [Programming Patterns in Lua](http://lua-users.org/wiki/ProgrammingPatterns)

### 9.2 Error Handling

- **pcall dan xpcall**
- **Error propagation**
- **Custom error handling**
- **Exception-like patterns**

**Sumber:**

- [Programming in Lua - Error Handling and Exceptions](https://www.lua.org/pil/8.4.html)
- [Lua Error Handling Tutorial](http://lua-users.org/wiki/ErrorHandling)

### 9.3 Testing Functions

- **Unit testing untuk functions**
- **Mock functions**
- **Testing closures**
- **Performance testing**

**Sumber:**

- [Lua Unit Testing](http://lua-users.org/wiki/UnitTesting)
- [Testing Frameworks untuk Lua](http://lua-users.org/wiki/TestingFrameworks)

## **Bagian 11: Function Serialization dan Persistence**

### 11.1 Function Serialization

- **Dumping functions dengan string.dump**
- **Loading serialized functions**
- **Bytecode analysis dan manipulation**
- **Cross-platform bytecode considerations**
- **Security implications of function serialization**

**Sumber:**

- [Lua Manual - string.dump](https://www.lua.org/manual/5.4/manual.html#pdf-string.dump)
- [Programming in Lua - Compilation, Execution, and Errors](https://www.lua.org/pil/8.html)
- [Lua Users Wiki - Bytecode](http://lua-users.org/wiki/LuaBytecode)

### 11.2 Persistent Function State

- **Saving function state**
- **Checkpoint dan resume patterns**
- **Serializing closures dan upvalues**
- **Function migration across processes**

**Sumber:**

- [Lua Users Wiki - Serialization](http://lua-users.org/wiki/TableSerialization)
- [Function State Persistence Techniques](http://lua-users.org/wiki/PersistenceLibrary)

## **Bagian 12: Generic for Loop dan Custom Iterators**

### 12.1 Generic for Loop Internals

- **Bagaimana generic for bekerja**
- **Iterator protocol (next, state, control)**
- **Stateless vs stateful iterators**
- **Multiple values dari iterators**

**Sumber:**

- [Programming in Lua - Iterators and Closures](https://www.lua.org/pil/7.html)
- [Lua Generic for Loop Tutorial](https://www.tutorialspoint.com/lua/lua_generic_for.htm)
- [Lua Manual - Generic for Statement](https://www.lua.org/manual/5.4/manual.html#3.3.5)

### 12.2 Custom Iterator Functions

- **Stateless iterator functions**
- **Closure-based iterators**
- **Coroutine-based iterators**
- **Complex iteration patterns**
- **Performance considerations untuk iterators**

**Sumber:**

- [Programming in Lua - Iterators and Closures](https://www.lua.org/pil/7.html)
- [Lua Users Wiki - Iterator Patterns](http://lua-users.org/wiki/IteratorsTutorial)
- [Coroutines as Iterators Examples](https://gist.github.com/2413313)

## **Bagian 13: Function Environments dan Sandboxing**

### 13.1 Function Environments (Lua 5.1)

- **setfenv dan getfenv**
- **Per-function environments**
- **Environment inheritance**
- **Sandboxing dengan environments**

**Sumber:**

- [Programming in Lua - The Environment](https://www.lua.org/pil/14.html)
- [Lua 5.1 Manual - Environments](https://www.lua.org/manual/5.1/manual.html#2.9)

### 13.2 \_ENV dan Upvalues (Lua 5.2+)

- **\_ENV sebagai upvalue**
- **Modifying function environments**
- **load dengan custom environments**
- **Security dan sandboxing modern**

**Sumber:**

- [Lua 5.2 Manual - Environments](https://www.lua.org/manual/5.2/manual.html#2.2)
- [Programming in Lua - Environments in Lua 5.2](https://www.lua.org/pil/15.html)
- [Lua Users Wiki - Sandboxing](http://lua-users.org/wiki/SandBoxes)

### 10.1 Web Development

- **Handler functions**
- **Middleware patterns**
- **Route handlers**
- **Template functions**

**Sumber:**

- [OpenResty Best Practices](https://github.com/openresty/lua-resty-core)
- [Lua Web Development](http://lua-users.org/wiki/WebDevelopment)

### 10.2 Game Development

- **Event handlers**
- **State machines dengan functions**
- **AI behavior functions**
- **Scripting patterns**

**Sumber:**

- [Lua Game Development](http://lua-users.org/wiki/GameDevelopment)
- [Love2D Function Patterns](https://love2d.org/wiki/Main_Page)

### 10.3 System Programming

- **File processing functions**
- **Network handling**
- **Process management**
- **Configuration functions**

**Sumber:**

- [Lua System Programming](http://lua-users.org/wiki/SystemProgramming)
- [LuaRocks Function Libraries](https://luarocks.org/)

## **Proyek Praktik**

## **Bagian 10: Real-World Applications**

Buat library dengan berbagai utility functions yang menggunakan semua konsep yang dipelajari.

### Proyek 2: Event System

Implementasi event system menggunakan closures dan higher-order functions.

### Proyek 3: Template Engine

Buat template engine sederhana yang menggunakan function generation.

### Proyek 4: Functional Programming Library

Implementasi map, filter, reduce, dan function composition utilities.

### Proyek 6: Iterator Library

Buat library iterator yang menggunakan berbagai teknik (stateless, closure, coroutine).

### Proyek 7: Function Serialization System

Implementasi system untuk menyimpan dan memuat function state.

### Proyek 8: Sandboxed Execution Environment

Buat environment untuk menjalankan functions secara aman.

## **Sumber Tambahan**

### Dokumentasi Resmi

- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/)
- [Programming in Lua (4th edition)](https://www.lua.org/pil/)

### Komunitas dan Tutorial

- [Lua Users Wiki](http://lua-users.org/wiki/)
- [Learn Lua in Y Minutes](https://learnxinyminutes.com/docs/lua/)
- [Lua Tutorial by TutorialsPoint](https://www.tutorialspoint.com/lua/)

### Advanced Resources

- [LuaJIT Documentation](https://luajit.org/luajit.html)
- [OpenResty Lua Guide](https://github.com/openresty/lua-nginx-module)
- [Lua Performance Guide](http://lua-users.org/wiki/OptimisationTips)

### Books dan E-books

- "Programming in Lua" by Roberto Ierusalimschy
- "Lua Quick Start Guide" by Gabor Szauer
- "Learning Game AI Programming with Lua" by David Young

## **Timeline Pembelajaran**

**Minggu 1-2:** Bagian 1-2 (Dasar-dasar dan Parameter)
**Minggu 3-4:** Bagian 3-4 (Function Types dan Closures)
**Minggu 5-6:** Bagian 5-6 (Metatables dan Coroutines)
**Minggu 7-8:** Bagian 7-8 (Performance dan Advanced Techniques)
**Minggu 9-10:** Bagian 9-10 (Patterns dan Applications)
**Minggu 11-12:** Bagian 11-12 (Serialization dan Iterators)
**Minggu 13-14:** Bagian 13 (Environments dan Sandboxing)
**Minggu 15-16:** Proyek praktik dan review mendalam

Kurikulum ini dirancang untuk memberikan pemahaman mendalam tentang functions di Lua, mulai dari konsep dasar hingga teknik advanced yang tidak selalu tercakup dalam dokumentasi resmi.
