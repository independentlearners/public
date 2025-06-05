# **[Kurikulum Lengkap Metatables & Metamethods di Lua][0]**

## **FASE 1: DASAR-DASAR KONSEPTUAL**

### 1.1 Pemahaman Fundamental Metatables

- **Apa itu Metatables dan mengapa penting**

  - Sumber: [Lua Official PIL - Chapter 13](https://www.lua.org/pil/13.html)
  - Sumber: [TutorialsPoint Lua Metatables](https://www.tutorialspoint.com/lua/lua_metatables.htm)

- **Perbedaan antara Tables biasa vs Tables dengan Metatables**

  - Sumber: [GameDev Academy - Complete Guide](https://gamedevacademy.org/lua-metatable-tutorial-complete-guide/)

- **Konsep "Hidden Tables" dan bagaimana mereka mempengaruhi behavior**
  - Sumber: [lua-users wiki: Metamethods Tutorial](http://lua-users.org/wiki/MetamethodsTutorial)

### 1.2 Memahami Metamethods

- **Definisi dan fungsi Metamethods**

  - Sumber: [TutorialsPoint - Metatables vs Metamethods](https://www.tutorialspoint.com/lua/lua_metatables_vs_metamethods.htm)

- **Event-driven nature dari Metamethods**

  - Sumber: [Mikolaj Gucki Tutorial](https://github.com/mikolajgucki/lua-tutorial/blob/master/05-lua-metatables/lua-metatables.md)

- **Kapan dan mengapa Metamethods dipanggil**
  - Sumber: [CoderScratchpad Guide](https://coderscratchpad.com/metatables-and-metamethods-in-lua/)

## **FASE 2A: VERSION COMPATIBILITY DAN HISTORICAL CONTEXT**

### 2A.1 Lua Version Differences dalam Metamethods

- **Lua 5.1 vs 5.2 vs 5.3 vs 5.4: Evolution of Metatables**

  - Sumber: [Lua 5.1 Reference Manual](https://www.lua.org/manual/5.1/manual.html)
  - Sumber: [Lua 5.3 Reference Manual](https://www.lua.org/manual/5.3/manual.html)

- **Deprecated metamethods dan migration patterns**

  - Sumber: [Stack Overflow - **pairs and **ipairs Issues](https://stackoverflow.com/questions/70466069/pairs-and-ipairs-metamethods-does-not-work-at-all)

- **Bitwise operations introduction (Lua 5.3+)**

  - Sumber: [TutorialsPoint Lua Metatables](https://www.tutorialspoint.com/lua/lua_metatables.htm)

- **Backward compatibility strategies**
  - Sumber: [GitHub lua-stdlib Issue](https://github.com/lua-stdlib/lua-stdlib/issues/75)

### 2A.2 Cross-Version Code Patterns

- **Feature detection techniques**

  - Sumber: [PhysicsClass Blog - ipairs vs pairs](https://physicsclass.blog/lua-iteration-functions-ipairs-vs-pairs/)

- **Polyfill implementations untuk older versions**

  - Sumber: [LuaScripts - Pairs vs IPairs](https://luascripts.com/lua-pairs-vs-ipairs)

- **Version-agnostic metatable design**
  - Sumber: [Factorio Forums - \_\_ipairs Discussion](https://forums.factorio.com/viewtopic.php?t=30055)

## **FASE 2B: METAMETHOD SELECTION ALGORITHMS**

### 2B.1 Metamethod Resolution Process

- **Left-to-right evaluation rules**

  - Sumber: [Lua Official PIL - Metamethod Selection](https://www.lua.org/pil/13.1.html)

- **Priority system untuk mixed operand types**

  - Sumber: [GameDev Academy - Complete Guide](https://gamedevacademy.org/lua-metatable-tutorial-complete-guide/)

- **Fallback mechanisms dan error handling**
  - Sumber: [CoderScratchpad Guide](https://coderscratchpad.com/metatables-and-metamethods-in-lua/)

### 2B.2 Complex Resolution Scenarios

- **Nested metatable lookups**

  - Sumber: [lua-users wiki: Metamethods Tutorial](http://lua-users.org/wiki/MetamethodsTutorial)

- **Multiple inheritance resolution conflicts**

  - Sumber: [Lua Official PIL - Multiple Inheritance](https://www.lua.org/pil/16.3.html)

- **Performance implications of resolution chains**
  - Sumber: [MoldStud - Flexible API Design](https://moldstud.com/articles/p-exploring-lua-metatables-unlocking-the-power-of-flexible-apis)

## **FASE 2: FUNGSI DASAR DAN OPERASI**

- **Cara kerja setmetatable() secara mendalam**

  - Sumber: [LuaScripts - Mastering setmetatable](https://luascripts.com/lua-setmetatable)

- **Penggunaan getmetatable() untuk introspection**

  - Sumber: [LuaScripts - Metatables Guide](https://luascripts.com/metatables-lua)

- **Proteksi Metatables dan security considerations**
  - Sumber: [Phrogz - Values and Metatables](https://phrogz.net/lua/LearningLua_ValuesAndMetatables.html)

### 2.2 Metamethods Dasar untuk Akses Data

- **\_\_index: Menghandle missing keys**

  - Sumber: [PiEmbSysTech Guide](https://piembsystech.com/metatables-and-metamethods-in-lua-programming-language/)

- **\_\_newindex: Controlling assignment ke missing keys**

  - Sumber: [GitHub Gist Cheatsheet](https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f)

- **Perbedaan behavior: function vs table di \_\_index**
  - Sumber: [LearnXYZ - Metatables and Myths](https://learnxyz.in/lua-metatables-and-myths/)

## **FASE 3: OPERATOR OVERLOADING**

### 3.1 Arithmetic Metamethods

- \***\*add, **sub, **mul, **div: Basic arithmetic operations\*\*

  - Sumber: [CodeRancher - Operator Overloading](https://www.coderancher.us/2024/04/26/lua-meta-tables-operator-overloading/)

- \***\*mod, **pow, \_\_unm: Advanced arithmetic operations\*\*

  - Sumber: [Lua Official PIL - Chapter 13](https://www.lua.org/pil/13.html)

- \***\*idiv, **band, **bor, **bxor: Bitwise operations (Lua 5.3+)\*\*
  - Sumber: [TutorialsPoint Lua Metatables](https://www.tutorialspoint.com/lua/lua_metatables.htm)

### 3.2 Comparison Metamethods

- **\_\_eq: Equality comparison**

  - Sumber: [GameDev Academy - Complete Guide](https://gamedevacademy.org/lua-metatable-tutorial-complete-guide/)

- \***\*lt, **le: Less than dan less equal comparisons\*\*

  - Sumber: [CoderScratchpad Guide](https://coderscratchpad.com/metatables-and-metamethods-in-lua/)

- **Asymmetric comparison handling dan edge cases**
  - Sumber: [lua-users wiki: Metamethods Tutorial](http://lua-users.org/wiki/MetamethodsTutorial)

### 3.3 Special Operation Metamethods

- **\_\_concat: String concatenation behavior**

  - Sumber: [LuaScripts - Metatables Guide](https://luascripts.com/metatables-lua)

- **\_\_len: Length operator customization**

  - Sumber: [Mikolaj Gucki Tutorial](https://github.com/mikolajgucki/lua-tutorial/blob/master/05-lua-metatables/lua-metatables.md)

- **\_\_tostring: Custom string representation**
  - Sumber: [PiEmbSysTech Guide](https://piembsystech.com/metatables-and-metamethods-in-lua-programming-language/)

## **FASE 4: TEKNIK LANJUTAN**

### 4.1 Function Call Metamethods

- **\_\_call: Making tables callable seperti functions**

  - Sumber: [LuaScripts - Mastering setmetatable](https://luascripts.com/lua-setmetatable)

- **Creating functors dan callable objects**

  - Sumber: [CodeRancher - Operator Overloading](https://www.coderancher.us/2024/04/26/lua-meta-tables-operator-overloading/)

- **Advanced function call patterns**
  - Sumber: [Stack Overflow - Lua Proxy Discussion](https://stackoverflow.com/questions/40391902/trying-to-make-a-lua-proxy-with-metatables)

### 4.2 Garbage Collection Metamethods

- **\_\_gc: Finalizers dan cleanup behavior**

  - Sumber: [Lua Official PIL - Chapter 13](https://www.lua.org/pil/13.html)

- **Resource management dengan Metatables**

  - Sumber: [CoderScratchpad Guide](https://coderscratchpad.com/metatables-and-metamethods-in-lua/)

- **\_\_mode: Weak references dan weak tables**

  - Sumber: [lua-users wiki: Weak Tables Tutorial](http://lua-users.org/wiki/WeakTablesTutorial)
  - Sumber: [TutorialsPoint - Weak Tables](https://www.tutorialspoint.com/lua/lua_weak_tables.htm)
  - Sumber: [ACM Digital Library - Understanding Lua's GC](https://dl.acm.org/doi/fullHtml/10.1145/3414080.3414093)

- **Weak keys vs weak values vs weak both ("k", "v", "kv")**

  - Sumber: [Lua Official PIL Chapter 17](https://www.lua.org/pil/17.html)
  - Sumber: [GitHub Gist Cheatsheet](https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f)

- **Ephemeron tables (weak keys, strong values)**

  - Sumber: [Stack Overflow - Weak References Discussion](https://stackoverflow.com/questions/63110063/what-are-weak-references)

- **Memory management patterns dengan weak references**
  - Sumber: [Stack Overflow - Lua Weak References](https://stackoverflow.com/questions/7451734/lua-weak-references)

### 4.3 Iterator Metamethods dan Version Differences

- **\_\_close: Automatic resource cleanup (Lua 5.4+)**

  - Sumber: [PiEmbSysTech Guide](https://piembsystech.com/metatables-and-metamethods-in-lua-programming-language/)

- **to-be-closed variables integration**

  - Sumber: [TutorialsPoint - Metatables vs Metamethods](https://www.tutorialspoint.com/lua/lua_metatables_vs_metamethods.htm)

- **\_\_pairs: Custom iteration behavior (Lua 5.2+)**

  - Sumber: [Factorio Forums - \_\_ipairs Discussion](https://forums.factorio.com/viewtopic.php?t=30055)
  - Sumber: [Lua 5.4 Docs - pairs()](https://www.luadocs.com/docs/functions/table/pairs)

- **\_\_ipairs: Sequential iteration customization (Lua 5.2, deprecated in 5.3)**

  - Sumber: [Stack Overflow - **pairs and **ipairs Issues](https://stackoverflow.com/questions/70466069/pairs-and-ipairs-metamethods-does-not-work-at-all)
  - Sumber: [GitHub lua-stdlib Issue](https://github.com/lua-stdlib/lua-stdlib/issues/75)

- **Version compatibility dan migration strategies**

  - Sumber: [PhysicsClass Blog - ipairs vs pairs](https://physicsclass.blog/lua-iteration-functions-ipairs-vs-pairs/)
  - Sumber: [LuaScripts - Pairs vs IPairs](https://luascripts.com/lua-pairs-vs-ipairs)

- **Custom iterator patterns tanpa **pairs/**ipairs**
  - Sumber: [Lua Official PIL - Stateless Iterators](https://www.lua.org/pil/7.3.html)

## **FASE 5: DESIGN PATTERNS DAN APLIKASI**

### 5.1 Inheritance Patterns

- **Single inheritance dengan \_\_index chaining**

  - Sumber: [Phrogz - Values and Metatables](https://phrogz.net/lua/LearningLua_ValuesAndMetatables.html)

- **Multiple inheritance techniques**

  - Sumber: [Lua Official PIL - Multiple Inheritance](https://www.lua.org/pil/16.3.html)

- **Prototype-based inheritance patterns**
  - Sumber: [MoldStud - Flexible API Design](https://moldstud.com/articles/p-exploring-lua-metatables-unlocking-the-power-of-flexible-apis)

### 5.2 Object-Oriented Programming

- **Creating class-like structures**

  - Sumber: [CodeRancher - Operator Overloading](https://www.coderancher.us/2024/04/26/lua-meta-tables-operator-overloading/)

- **Method definition dan self reference**

  - Sumber: [O'Reilly - Creating Solid APIs](https://www.oreilly.com/library/view/creating-solid-apis/9781491986301/ch04.html)

- **Polymorphism dengan Metatables**
  - Sumber: [GameDev Academy - Complete Guide](https://gamedevacademy.org/lua-metatable-tutorial-complete-guide/)

### 5.3 Proxy dan Wrapper Patterns

- **Creating transparent proxy objects**

  - Sumber: [Stack Overflow - Lua Proxy Discussion](https://stackoverflow.com/questions/40391902/trying-to-make-a-lua-proxy-with-metatables)

- **Access control dan permission systems**

  - Sumber: [MoldStud - Flexible API Design](https://moldstud.com/articles/p-exploring-lua-metatables-unlocking-the-power-of-flexible-apis)

- **Logging dan debugging wrappers**
  - Sumber: [LuaScripts - Metatables Guide](https://luascripts.com/metatables-lua)

## **FASE 6: PERFORMANCE DAN OPTIMIZATION**

### 6.1 Performance Considerations

- **Metatable lookup overhead**

  - Sumber: [Lua Official PIL - Multiple Inheritance](https://www.lua.org/pil/16.3.html)

- **Caching strategies untuk improved performance**

  - Sumber: [O'Reilly - Creating Solid APIs](https://www.oreilly.com/library/view/creating-solid-apis/9781491986301/ch04.html)

- **Benchmarking metatable operations**
  - Sumber: [CoderScratchpad Guide](https://coderscratchpad.com/metatables-and-metamethods-in-lua/)

### 6.2 Memory Management

- **Metatable sharing strategies**

  - Sumber: [Phrogz - Values and Metatables](https://phrogz.net/lua/LearningLua_ValuesAndMetatables.html)

- **Avoiding memory leaks dengan proper cleanup**

  - Sumber: [PiEmbSysTech Guide](https://piembsystech.com/metatables-and-metamethods-in-lua-programming-language/)

- **Weak reference patterns untuk cached data**
  - Sumber: [lua-users wiki: Metamethods Tutorial](http://lua-users.org/wiki/MetamethodsTutorial)

## **FASE 7: ADVANCED TECHNIQUES DAN EDGE CASES**

### 7.1 Metatable Chaining

- **Complex inheritance hierarchies**

  - Sumber: [O'Reilly - Creating Solid APIs](https://www.oreilly.com/library/view/creating-solid-apis/9781491986301/ch04.html)

- **Dynamic metatable modification**

  - Sumber: [MoldStud - Flexible API Design](https://moldstud.com/articles/p-exploring-lua-metatables-unlocking-the-power-of-flexible-apis)

- **Circular reference prevention**
  - Sumber: [LearnXYZ - Metatables and Myths](https://learnxyz.in/lua-metatables-and-myths/)

### 7.2 Integration dengan C API

- **Userdata metatables**

  - Sumber: [Lua Official PIL - Chapter 13](https://www.lua.org/pil/13.html)

- **C function integration patterns**

  - Sumber: [lua-users wiki: Metamethods Tutorial](http://lua-users.org/wiki/MetamethodsTutorial)

- **Cross-language object binding**
  - Sumber: [PiEmbSysTech Guide](https://piembsystech.com/metatables-and-metamethods-in-lua-programming-language/)

### 7.3 Debugging dan Troubleshooting

- **Common metatable pitfalls dan solutions**

  - Sumber: [LearnXYZ - Metatables and Myths](https://learnxyz.in/lua-metatables-and-myths/)

- **Debugging metatable behavior**

  - Sumber: [GitHub Gist Cheatsheet](https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f)

- **Testing strategies untuk metatable-heavy code**
  - Sumber: [CoderScratchpad Guide](https://coderscratchpad.com/metatables-and-metamethods-in-lua/)

## **FASE 8: REAL-WORLD APPLICATIONS**

### 8.1 Domain-Specific Languages (DSL)

- **Creating expressive APIs dengan metatables**

  - Sumber: [MoldStud - Flexible API Design](https://moldstud.com/articles/p-exploring-lua-metatables-unlocking-the-power-of-flexible-apis)

- **Configuration system design**

  - Sumber: [O'Reilly - Creating Solid APIs](https://www.oreilly.com/library/view/creating-solid-apis/9781491986301/ch04.html)

- **Template system implementation**
  - Sumber: [LuaScripts - Metatables Guide](https://luascripts.com/metatables-lua)

### 8.2 Game Development Applications

- **Entity component systems**

  - Sumber: [GameDev Academy - Complete Guide](https://gamedevacademy.org/lua-metatable-tutorial-complete-guide/)

- **Resource management systems**

  - Sumber: [CodeRancher - Operator Overloading](https://www.coderancher.us/2024/04/26/lua-meta-tables-operator-overloading/)

- **Event handling frameworks**
  - Sumber: [Mikolaj Gucki Tutorial](https://github.com/mikolajgucki/lua-tutorial/blob/master/05-lua-metatables/lua-metatables.md)

### 8.3 Library dan Framework Design

- **API design best practices**

  - Sumber: [O'Reilly - Creating Solid APIs](https://www.oreilly.com/library/view/creating-solid-apis/9781491986301/ch04.html)

- **Backwards compatibility strategies**

  - Sumber: [MoldStud - Flexible API Design](https://moldstud.com/articles/p-exploring-lua-metatables-unlocking-the-power-of-flexible-apis)

- **Documentation dan usage patterns**
  - Sumber: [GitHub Gist Cheatsheet](https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f)

## **REFERENSI TAMBAHAN**

### Quick Reference Materials

- **Metamethods Cheatsheet**: [GitHub Gist](https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f)
- **Official Documentation**: [Lua PIL](https://www.lua.org/pil/13.html)
- **Community Wiki**: [lua-users wiki](http://lua-users.org/wiki/MetamethodsTutorial)

### Advanced Reading

- **Performance Optimization**: [Lua PIL Multiple Inheritance](https://www.lua.org/pil/16.3.html)
- **API Design**: [O'Reilly Creating Solid APIs](https://www.oreilly.com/library/view/creating-solid-apis/9781491986301/ch04.html)
- **Myths dan Misconceptions**: [LearnXYZ Guide](https://learnxyz.in/lua-metatables-and-myths/)

---

## **Beberapa yang telah ditambahkan dan lebih komprehensif dari Dokumentasi Resmi:**

- **Historical Context**: Dokumentasi resmi tidak menjelaskan evolution dan deprecated features
- **Performance Deep Dive**: Analisis mendalam tentang overhead dan optimization strategies
- **Real-world Patterns**: Lebih banyak design patterns dan use cases praktis
- **Error Scenarios**: Edge cases dan troubleshooting yang tidak dicover dokumentasi resmi
- **Cross-platform Considerations**: Compatibility patterns untuk berbagai environments

#

- **Estimasi Waktu Pembelajaran Total**: 4-6 bulan dengan praktik konsisten
- **Level Prasyarat**: Pemahaman dasar Lua tables dan functions
- **Metode Pembelajaran**: Kombinasi teori, praktik, dan project-based learning

Kurikulum ini mencakup **8 fase pembelajaran** dengan **25+ sub-topik** dan **50+ sumber referensi** yang beragam, membuatnya jauh lebih komprehensif daripada dokumentasi resmi Lua. Setiap aspek dari metatables dan metamethods telah dicover dari level conceptual hingga implementation advanced dan real-world applications.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../../intermediate/testing-and-debugging/README.md
[selanjutnya]: ../../advanced/coroutines/README.md

<!--------------------------------------------------- -->

[0]: ../../README.md#advanced-13-topik
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
