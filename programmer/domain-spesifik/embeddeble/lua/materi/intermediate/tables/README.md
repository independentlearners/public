# **[KURIKULUM TABLES LUA - LENGKAP DAN KOMPREHENSIF][0]**

### **1. DASAR-DASAR TABLES**

- **Pengenalan dan Konsep Tables**

  - Sumber: Programming in Lua: Tables - https://www.lua.org/pil/2.5.html
  - Sumber: TutorialsPoint: Lua Tables - https://www.tutorialspoint.com/lua/lua_tables.htm

- **Konstruksi dan Inisialisasi Tables**
  - Sumber: Lua-users Wiki: Tables Tutorial - http://lua-users.org/wiki/TablesTutorial
  - Sumber: W3Schools: Lua Tables - https://w3schools.tech/tutorial/lua/lua_tables

### **2. OPERASI DASAR TABLES**

- **Akses dan Modifikasi Elemen**

  - Sumber: GameDev Academy: Lua Table Tutorial - https://gamedevacademy.org/lua-table-tutorial-complete-guide/
  - Sumber: PiEmbSysTech: Understanding Tables - https://piembsystech.com/understanding-tables-in-lua-programming-language/

- **Iterasi dan Traversal Tables**
  - **pairs() vs ipairs() - Perbedaan dan Penggunaan**
    - Sumber: Stack Overflow: pairs vs ipairs - https://stackoverflow.com/questions/55108794/what-is-the-difference-between-pairs-and-ipairs-in-lua
    - Sumber: LuaScripts: Pairs vs Ipairs - https://luascripts.com/lua-pairs-vs-ipairs
    - Sumber: Opensource.com: How to iterate over tables - https://opensource.com/article/22/11/iterate-over-tables-lua

### **3. RAW TABLE OPERATIONS (TAMBAHAN PENTING)**

- **rawget, rawset, rawlen, rawequal**

  - Sumber: O'Reilly: rawget and rawset - https://www.oreilly.com/library/view/lua-quick-start/9781789343229/abf0a818-b5b1-47ae-aea3-eb315edca6c8.xhtml
  - Sumber: Wikibooks: Lua Programming Tables - https://en.wikibooks.org/wiki/Lua_Programming/Tables
  - Sumber: Stack Overflow: Rawset function - https://stackoverflow.com/questions/23012040/rawset-function-in-lua

- **next() Function dan Generic for Loop**
  - Sumber: Programming in Lua: Stateless Iterators - https://www.lua.org/pil/7.3.html

### **4. TABLE LIBRARY DAN FUNGSI BUILT-IN**

- **Fungsi table.insert, table.remove, table.sort**

  - Sumber: GameDev Academy: Table Library Tutorial - https://gamedevacademy.org/lua-table-library-tutorial-complete-guide/
  - Sumber: TutorialsPoint: Lua Tutorial - https://www.tutorialspoint.com/lua/index.htm

- **table.concat, table.unpack, table.pack (Lua 5.2+)**

  - Sumber: GameDev Academy: Table Library - https://gamedevacademy.org/lua-table-library-tutorial-complete-guide/

- **table.move (Lua 5.3+)**
  - Sumber: Lua 5.4 Reference Manual - https://www.lua.org/manual/5.4/manual.html

### **5. METATABLES DAN METAMETHODS**

- **Konsep Dasar Metatables**

  - Sumber: Programming in Lua: Metatables - https://www.lua.org/pil/13.html
  - Sumber: TutorialsPoint: Lua Metatables - https://www.tutorialspoint.com/lua/lua_metatables.htm

- **setmetatable dan getmetatable**
  - Sumber: LuaScripts: Mastering setmetatable - https://luascripts.com/lua-setmetatable
  - Sumber: LuaScripts: Mastering Metatables - https://luascripts.com/metatables-lua

### **6. METAMETHODS LENGKAP (TAMBAHAN KOMPREHENSIF)**

- **Arithmetic Metamethods (**add, **sub, **mul, **div, **mod, **pow, \_\_unm)**

  - Sumber: GitHub: Metatable Methods Cheatsheet - https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f

- **Relational Metamethods (**eq, **lt, \_\_le)**

  - Sumber: Programming in Lua: Metatables - https://www.lua.org/pil/13.html

- **Indexing Metamethods (**index, **newindex)**

  - Sumber: TutorialsPoint: Table Metatables - https://www.tutorialspoint.com/lua/lua_table_metatables.htm

- **Other Metamethods (**call, **tostring, **len, **concat)**
  - Sumber: Roblox Creator: Metatables - https://create.roblox.com/docs/luau/metatables

### **7. GARBAGE COLLECTION DAN FINALIZERS (TOPIK PENTING YANG TERLEWAT)**

- **\_\_gc Metamethod untuk Tables (Lua 5.2+)**

  - Sumber: Stack Overflow: \_\_gc metamethod for tables - https://stackoverflow.com/questions/14096204/does-lua-gc-metamethod-now-work-for-table-lua-5-2-1
  - Sumber: Stack Overflow: Lua 5.1 workaround for \_\_gc - https://stackoverflow.com/questions/27426704/lua-5-1-workaround-for-gc-metamethod-for-tables

- **Finalizers dan Table Cleanup**
  - Sumber: ACM: Understanding Lua's Garbage Collection - https://dl.acm.org/doi/fullHtml/10.1145/3414080.3414093
  - Sumber: GitHub: LuaJIT \_\_gc on tables - https://github.com/LuaJIT/LuaJIT/issues/47

### **8. WEAK TABLES (TOPIK KRUSIAL YANG DIPERLUAS)**

- **Konsep Weak References**
  - Sumber: Programming in Lua: Weak Tables - https://www.lua.org/pil/17.html
- **\_\_mode Metamethod (k, v, kv)**

  - Sumber: GitHub Cheatsheet + Evan Hahn Notes - https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f
  - Sumber: Evan Hahn: Lua 5.4 Notes - https://evanhahn.com/my-notes-from-the-lua-5.4-reference

- **Ephemeron Tables**

  - Sumber: Lua 5.4 Reference Manual - https://www.lua.org/manual/5.4/manual.html

- **Weak Tables dengan C API**
  - Sumber: Stack Overflow: Weak table and GC finalizer - https://stackoverflow.com/questions/24087890/weak-table-and-gc-finalizer-using-c-api

### **9. ADVANCED METATABLES**

- **Operator Overloading dengan Tables**

  - Sumber: Programming in Lua: Metatables - https://www.lua.org/pil/13.html

- **Custom Indexing dan Property Access**
  - Sumber: SRB2 Wiki: Lua Metatables - https://wiki.srb2.org/wiki/Lua/Metatables
  - Sumber: IBM Netezza: Metatables - https://www.ibm.com/docs/en/netezza?topic=lpl-metatables-1

### **10. OBJECT-ORIENTED PROGRAMMING DENGAN TABLES**

- **Class Implementation menggunakan Tables**

  - Sumber: Programming in Lua (Bab 16) - https://www.lua.org/pil/16.html

- **Inheritance dan Polymorphism**
  - Sumber: Lua-users Wiki: Object Oriented Programming - http://lua-users.org/wiki/ObjectOrientedProgramming

### **11. TABLES SEBAGAI STRUKTUR DATA**

- **Array dan List Implementation**

  - Sumber: LuaScripts: Table of Tables - https://luascripts.com/lua-table-of-tables
  - Sumber: API7.ai: Table and Metatable - https://api7.ai/learning-center/openresty/lua-table-and-metatable

- **Dictionary dan Hash Tables**
- **Nested Tables dan Struktur Kompleks**
- **Set Implementation dengan Tables**
- **Stack dan Queue Implementation**

### **12. PERFORMANCE DAN OPTIMASI TABLES**

- **Memory Management Tables**

  - Sumber: Lua-users Wiki: Optimization Tips - http://lua-users.org/wiki/OptimisationTips

- **Best Practices untuk Large Tables**

  - Sumber: Programming in Lua: Performance Tips - https://www.lua.org/gems/

- **Table Pre-allocation dan Sizing**
- **Cache-Friendly Table Access Patterns**

### **13. ADVANCED PATTERNS DAN TEKNIK**

- **Serialization dan Persistence**

  - Sumber: Lua-users Wiki: Table Serialization - http://lua-users.org/wiki/TableSerialization

- **Factory Patterns dan Builder Patterns**

  - Sumber: Lua-users Wiki: Design Patterns - http://lua-users.org/wiki/DesignPatterns

- **Memoization dengan Tables**
- **Lookup Tables dan Dispatch Tables**

### **14. VERSION-SPECIFIC FEATURES (TAMBAHAN PENTING)**

- **Lua 5.1 vs 5.2+ Differences**
- **LuaJIT-specific Table Behaviors**
- **Compatibility Issues dan Workarounds**

### **15. DEBUGGING DAN TROUBLESHOOTING**

- **Common Table Pitfalls**

  - Sumber: Lua-users Wiki: Common Mistakes - http://lua-users.org/wiki/CommonMistakes

- **Table Inspection dan Debugging Tools**

  - Sumber: Lua-users Wiki: Debugging - http://lua-users.org/wiki/DebuggingLuaCode

- **Memory Leaks dengan Tables**
- **Circular Reference Detection**

### **16. REAL-WORLD APPLICATIONS**

- **Configuration Tables**
- **Data Processing dengan Tables**
- **Game Development dengan Tables**
- **Web Development (OpenResty/Nginx)**
- **Database Abstraction dengan Tables**

### **17. ADVANCED TOPICS**

- **Coroutines dengan Tables**
- **FFI Integration dengan Tables**
- **C API untuk Tables**
- **Custom Iterators dengan Tables**

### **18. SECURITY CONSIDERATIONS (TAMBAHAN KEAMANAN)**

- **Sandboxing dengan Tables**
- **Preventing Prototype Pollution**
- **Safe Table Access Patterns**

Kurikulum ini mencakup semua aspek Tables di Lua, termasuk topik-topik krusial seperti raw operations, garbage collection, finalizers, dan version-specific features. Ini adalah kurikulum yang benar-benar komprehensif untuk menguasai Tables di Lua secara mendalam.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../../dasar/input-output/README.md
[selanjutnya]: ../../intermediate/modules-and-packages/README.md

<!-- ------------------------------------------------- -->

[0]: ../../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
