# **[Kurikulum Lengkap Advanced Patterns Lua - Edisi Komprehensif][0]**

## [BAGIAN I: FONDASI PATTERN MATCHING][1]

### 1.1 Pengenalan Filosofi Pattern Matching Lua

- Perbedaan fundamental pattern matching Lua vs regex tradisional
- Filosofi minimalis dan efisiensi parsing
- Historical context dan design decisions
- **Sumber**: [Lua Tutorial - Pattern Matching](https://www.tutorialspoint.com/lua/lua_pattern_matching.htm)

### 1.2 Character Classes - Lengkap dan Mendalam

- Magic characters (%a, %d, %l, %u, %w, %s, %p, %c, %x, %z)
- Complement classes dengan uppercase versions
- Custom character sets dengan [] dan [^]
- Escape sequences dan special characters
- **Sumber**: [Programming in Lua - Character Classes](https://www.lua.org/pil/20.2.html)

### 1.3 Pattern Modifiers dan Quantifiers Lanjutan

- Greedy vs non-greedy matching (\*, +, -, ?)
- Balanced matching dengan %b dan variasinya
- Frontier patterns dengan %f - advanced usage
- Zero-width assertions
- **Sumber**: [RIP Tutorial - Lua Pattern Matching](https://riptutorial.com/lua/example/20315/lua-pattern-matching)

### 1.4 Pattern Internals dan Optimizations

- Lua pattern engine internals
- Memory usage dan performance characteristics
- Pattern compilation dan caching
- **Sumber**: [Lua Source Code Analysis](https://github.com/lua/lua/blob/master/lstrlib.c)

## [BAGIAN II: ADVANCED PATTERN MATCHING][2]

### 2.1 Captures - Komprehensif

- Simple captures dengan ()
- Named captures simulation
- Numbered captures dan backreferences
- Position captures dengan %()
- Empty captures untuk position marking
- Nested captures dan hierarchical parsing
- **Sumber**: [GitHub Gist - Lua Pattern Guide](https://gist.github.com/46ca9f4a6f933fa266bccd87fd15d09a)

### 2.2 Anchoring, Positioning, dan Boundaries

- Start anchor (^) dan end anchor ($)
- Word boundaries simulation
- Line boundaries dalam multiline text
- Context-sensitive matching
- **Sumber**: [Family Historian - Understanding Lua Patterns](https://www.fhug.org.uk/kb/kb-article/understanding-lua-patterns/)

### 2.3 Complex Pattern Construction

- Recursive patterns dan self-referencing
- Pattern composition techniques
- Conditional patterns
- Dynamic pattern building
- Pattern inheritance dan reusability
- **Sumber**: [GameDev Academy - Complete Pattern Guide](https://gamedevacademy.org/lua-pattern-matching-tutorial-complete-guide/)

### 2.4 Error Handling dan Robust Parsing

- Graceful pattern failure handling
- Pattern validation techniques
- Debugging complex patterns
- **Sumber**: [Lua Users Wiki - Error Handling](http://lua-users.org/wiki/ErrorHandling)

## [BAGIAN III: STRING MANIPULATION PATTERNS][3]

### 3.1 String Substitution - Master Level

- gsub dengan function callbacks
- Conditional replacements
- Multi-stage transformations
- Template-based substitutions
- Performance considerations
- **Sumber**: [Programming in Lua - String Library](https://www.lua.org/pil/20.html)

### 3.2 Advanced String Parsing

- Tokenization dengan complex delimiters
- CSV parsing dengan escaped characters
- Log file analysis patterns
- Configuration file parsing
- Protocol parsing (HTTP headers, etc.)
- **Sumber**: [Lua Users Wiki - String Recipes](http://lua-users.org/wiki/StringRecipes)

### 3.3 Text Processing Algorithms

- Pattern-based validators
- Content extraction dan sanitization
- Format conversion engines
- Text normalization patterns
- Encoding detection dan conversion
- **Sumber**: [Comprehensive Lua Tutorial - String Processing](https://getvm.io/tutorials/lua-tutorial)

### 3.4 Unicode dan Internationalization

- UTF-8 pattern matching
- Locale-aware patterns
- Multi-byte character handling
- **Sumber**: [Lua UTF-8 Library](https://www.lua.org/manual/5.3/manual.html#6.5)

## [BAGIAN IV: LPEG - PARSING EXPRESSION GRAMMARS][4]

### 4.1 LPeg Fundamentals

- PEG vs traditional regex
- LPeg philosophy dan advantages
- Basic pattern construction
- Operator precedence (\*, +, -, /, ^)
- **Sumber**: [LPeg Official Documentation](https://www.inf.puc-rio.br/~roberto/lpeg/)

### 4.2 LPeg Advanced Patterns

- Lookahead dan lookbehind
- Cut operator dan backtracking control
- Grammar definitions
- Left recursion handling
- **Sumber**: [Mastering LPeg Tutorial](https://leafo.net/guides/parsing-expression-grammars.html)

### 4.3 LPeg Captures dan Transformations

- Simple captures vs substitution captures
- Table captures dan group captures
- Function captures untuk complex transformations
- Back captures dan argument captures
- **Sumber**: [LPeg Recipes](http://lua-users.org/wiki/LpegRecipes)

### 4.4 Building Complex Grammars

- Recursive grammar definitions
- AST construction
- Error reporting dan recovery
- Grammar optimization techniques
- **Sumber**: [Stack Overflow LPeg Examples](https://stackoverflow.com/questions/7968688/using-lpeg-lua-parser-expression-grammars-like-boostspirit)

### 4.5 LPeg Performance Optimization

- Pattern profiling
- Memory usage optimization
- Compilation strategies
- **Sumber**: [LPeg Performance Guide](http://www.gammon.com.au/lpeg)

### 4.6 Real-world LPeg Applications

- Programming language parsers
- Configuration file processors
- Data format converters
- **Sumber**: [MoonScript Implementation](http://moonscript.org/)

## [BAGIAN V: XML DAN STRUCTURED DATA PARSING][5]

### 5.1 XML Parsing dengan Patterns

- Basic XML structure parsing
- Attribute extraction
- Nested element handling
- CDATA dan comments processing
- **Sumber**: [Lua XML Wiki](http://lua-users.org/wiki/LuaXml)

### 5.2 SLAXML - Advanced XML Processing

- SAX-like streaming parsing
- DOM tree construction
- Namespace handling
- Processing instructions
- **Sumber**: [SLAXML GitHub](https://github.com/Phrogz/SLAXML)

### 5.3 JSON dan Data Format Parsing

- JSON parsing dengan patterns
- YAML basic parsing
- INI file processing
- Custom data format creation
- **Sumber**: [Lua JSON Libraries](http://lua-users.org/wiki/JsonModules)

### 5.4 Binary Data Patterns

- Binary data parsing patterns
- Protocol parsing (network protocols)
- File format analysis
- **Sumber**: [Lua Struct Library](http://www.inf.puc-rio.br/~roberto/struct/)

## [BAGIAN VI: METAPROGRAMMING DENGAN PATTERNS][6]

### 6.1 Dynamic Pattern Generation

- Runtime pattern construction
- Template-based pattern creation
- Pattern factory functions
- Conditional pattern selection
- **Sumber**: [Lua Users Wiki - Meta Programming](http://lua-users.org/wiki/MetaProgramming)

### 6.2 Pattern-based DSL Creation

- Domain-specific language dengan patterns
- Custom syntax definition
- Pattern interpretation engines
- Syntax sugar implementation
- **Sumber**: [MoldStud - Hacking Lua Solutions](https://moldstud.com/articles/p-hacking-lua-unconventional-solutions-to-common-development-problems)

### 6.3 Metatable Integration

- Pattern matching dalam metamethods
- Custom pattern operators
- Object-oriented pattern matching
- Pattern inheritance systems
- **Sumber**: [EasyLearning - Advanced Metaprogramming](https://www.easylearn.ing/course/lua-programming-tutorial)

### 6.4 Code Generation dengan Patterns

- Template engines
- Code transformation tools
- AST manipulation
- **Sumber**: [Lua Templating Systems](http://lua-users.org/wiki/TemplateEngines)

## [BAGIAN VII: ADVANCED PROGRAMMING PATTERNS][7]

### 7.1 Coroutine Patterns Lanjutan

- Generator patterns dengan coroutines
- Pipeline processing patterns
- Asynchronous pattern matching
- Cooperative multitasking
- Producer-consumer patterns
- **Sumber**: [Lua Scripts - Coroutines Mastery](https://luascripts.com/coroutines-in-lua)

### 7.2 State Machine Patterns

- Pattern-driven state machines
- Transition pattern matching
- Event-driven pattern systems
- Hierarchical state machines
- **Sumber**: [Software Patterns Lexicon - Coroutines](https://softwarepatternslexicon.com/patterns-lua/9/1/)

### 7.3 Iterator Patterns Komprehensif

- Custom iterator dengan pattern matching
- Lazy evaluation patterns
- Stream processing patterns
- Functional programming patterns
- **Sumber**: [Programming in Lua - Coroutines](https://www.lua.org/pil/9.1.html)

### 7.4 Observer dan Event Patterns

- Event pattern matching
- Signal-slot patterns
- Publish-subscribe dengan patterns
- **Sumber**: [Lua Event Systems](http://lua-users.org/wiki/EventSystems)

### 7.5 Memory Management Patterns

- Weak references dengan patterns
- Garbage collection patterns
- Resource management
- **Sumber**: [Lua Memory Management](http://lua-users.org/wiki/GarbageCollection)

## [BAGIAN VIII: PERFORMANCE DAN OPTIMIZATION][8]

### 8.1 Pattern Performance Analysis

- Benchmarking pattern matching
- Profiling tools dan techniques
- Memory usage optimization
- CPU usage analysis
- **Sumber**: [Syntax Sprinters - Advanced Lua Techniques](https://syntaxsprinters.com/coding-advanced-concepts/2023-learn-advanced-lua-metatables-and-coroutine-techniques/)

### 8.2 Alternative Pattern Libraries

- LPeg deep dive
- Rex (PCRE untuk Lua)
- Lrexlib comprehensive usage
- Performance comparisons
- Migration strategies
- **Sumber**: [Lua Reference Manual 5.4](https://www.lua.org/manual/5.4/manual.html)

### 8.3 Pattern Caching dan Memoization

- Compiled pattern caching
- Memoization techniques
- Memory management strategies
- Cache invalidation patterns
- **Sumber**: [W3Schools Tech - Lua Coroutines](https://w3schools.tech/tutorial/lua/lua_coroutines)

### 8.4 JIT Compilation Benefits

- LuaJIT pattern optimizations
- FFI integration untuk performance
- Profile-guided optimization
- **Sumber**: [LuaJIT Performance Guide](http://luajit.org/performance.html)

## [BAGIAN IX: REAL-WORLD APPLICATIONS][9]

### 9.1 Web Development Patterns

- URL routing patterns
- Request validation patterns
- Template engine patterns
- HTTP header parsing
- Cookie handling patterns
- **Sumber**: [Skill App - Lua Best Practices](https://skillapp.co/blog/mastering-lua-coding-practice-tips-tricks-and-best-practices-for-efficient-programming/)

### 9.2 Game Development Patterns

- Asset path pattern matching
- Configuration parsing patterns
- Scripting pattern systems
- Save file parsing
- Cheat detection patterns
- **Sumber**: [Class Central - Best Lua Courses](https://www.classcentral.com/report/best-lua-courses/)

### 9.3 Network Programming Patterns

- Protocol parsing patterns
- Packet analysis
- Stream processing
- Connection handling
- **Sumber**: [Lua Socket Programming](http://lua-users.org/wiki/LuaSocket)

### 9.4 Data Processing Patterns

- ETL pipeline patterns
- Data validation patterns
- Report generation patterns
- Big data processing
- **Sumber**: [Programming in Lua - Complete Reference](https://www.lua.org/pil/)

### 9.5 System Administration Patterns

- Log analysis patterns
- Configuration management
- File system patterns
- Process monitoring
- **Sumber**: [Lua System Programming](http://lua-users.org/wiki/SystemProgramming)

## [BAGIAN X: C API INTEGRATION][10]

### 10.1 C API Pattern Integration

- Pattern matching dalam C extensions
- Foreign function interface patterns
- Library interoperability patterns
- **Sumber**: [Programming in Lua - C API](https://www.lua.org/pil/24.html)

### 10.2 Custom Pattern Implementations

- Writing custom pattern matchers in C
- Extending Lua pattern capabilities
- Performance-critical pattern matching
- **Sumber**: [Lua C API Reference](https://www.lua.org/manual/5.4/manual.html#4)

### 10.3 Native Library Bindings

- PCRE integration
- ICU integration untuk Unicode
- Custom regex engine bindings
- **Sumber**: [LuaExpat XML Processing](https://lunarmodules.github.io/luaexpat/lom.html)

## [BAGIAN XI: TESTING DAN DEBUGGING][11]

### 11.1 Pattern Testing Frameworks

- Unit testing pattern matching
- Test case generation
- Property-based testing
- Fuzzing pattern matchers
- **Sumber**: [Lua Testing Frameworks](http://lua-users.org/wiki/UnitTesting)

### 11.2 Debugging Techniques Lanjutan

- Pattern tracing dan profiling
- Visual pattern debugging
- Step-by-step pattern execution
- Common pitfalls dan solutions
- **Sumber**: [Lua Debugging Guide](http://lua-users.org/wiki/DebuggingLuaCode)

### 11.3 Validation dan Verification

- Pattern correctness verification
- Security considerations
- Input sanitization patterns
- DoS prevention
- **Sumber**: [Lua Security Guide](http://lua-users.org/wiki/SecurityConsiderations)

### 11.4 Continuous Integration

- Automated pattern testing
- Performance regression testing
- Cross-platform validation
- **Sumber**: [Lua CI/CD Practices](http://lua-users.org/wiki/ContinuousIntegration)

## [BAGIAN XII: SECURITY PATTERNS][12]

### 12.1 Input Validation Patterns

- SQL injection prevention
- XSS prevention patterns
- Path traversal protection
- Command injection prevention
- **Sumber**: [OWASP Lua Security](https://owasp.org/www-project-lua-security/)

### 12.2 Cryptographic Patterns

- Pattern-based key validation
- Certificate parsing
- Cryptographic protocol parsing
- **Sumber**: [LuaCrypto Documentation](http://luacrypto.luaforge.net/)

### 12.3 Authentication Patterns

- Token validation patterns
- Session pattern matching
- OAuth pattern handling
- **Sumber**: [Lua Authentication Libraries](http://lua-users.org/wiki/AuthenticationAndAuthorization)

## [BAGIAN XIII: CROSS-PLATFORM CONSIDERATIONS][13]

### 13.1 Platform-specific Pattern Considerations

- Path separator patterns
- Line ending handling
- Encoding-aware patterns
- Locale considerations
- **Sumber**: [Lua Cross-platform Guide](http://lua-users.org/wiki/CrossPlatform)

### 13.2 Mobile Development Patterns

- iOS/Android specific patterns
- Resource constraint handling
- Battery optimization
- **Sumber**: [Corona SDK Patterns](https://docs.coronalabs.com/)

### 13.3 Embedded Systems Patterns

- Memory-constrained pattern matching
- Real-time pattern processing
- Hardware-specific optimizations
- **Sumber**: [Embedded Lua Programming](http://lua-users.org/wiki/EmbeddedProgramming)

## [BAGIAN XIV: ADVANCED TOPICS][14]

### 14.1 Machine Learning Integration

- Pattern recognition algorithms
- Feature extraction patterns
- Text classification patterns
- **Sumber**: [Torch for Lua](http://torch.ch/)

### 14.2 Parallel Processing Patterns

- Multi-threaded pattern matching
- Distributed pattern processing
- GPU acceleration possibilities
- **Sumber**: [Lanes - Lua Multithreading](https://lualanes.github.io/lanes/)

### 14.3 Streaming dan Big Data

- Stream processing patterns
- Incremental parsing
- Memory-efficient pattern matching
- **Sumber**: [Lua Stream Processing](http://lua-users.org/wiki/StreamProcessing)

## [BAGIAN XV: EMERGING TECHNOLOGIES][15]

### 15.1 WebAssembly Integration

- Lua patterns dalam WebAssembly
- Browser-based pattern matching
- Performance considerations
- **Sumber**: [Lua WASM Projects](https://github.com/vvanders/wasm_lua)

### 15.2 Cloud Computing Patterns

- Serverless pattern processing
- Microservices patterns
- Container-based deployments
- **Sumber**: [OpenResty Lua Patterns](https://openresty.org/)

### 15.3 IoT dan Edge Computing

- Lightweight pattern matching
- Sensor data processing
- Protocol handling
- **Sumber**: [NodeMCU Lua Programming](https://nodemcu.readthedocs.io/)

## [BAGIAN XVI: COMMUNITY DAN RESEARCH][16]

### 16.1 Open Source Pattern Libraries

- Contributing to pattern libraries
- Community best practices
- Code review standards
- **Sumber**: [LuaRocks Pattern Modules](https://luarocks.org/)

### 16.2 Academic Research Applications

- Natural language processing
- Bioinformatics applications
- Scientific computing patterns
- **Sumber**: [Lua Scientific Computing](http://lua-users.org/wiki/ScientificComputing)

### 16.3 Future Directions

- Pattern matching evolution
- Language enhancements
- Research opportunities
- **Sumber**: [Lua Evolution Proposals](http://lua-users.org/wiki/LuaProposals)

## [BAGIAN XVII: SPECIALIZED DOMAINS][17]

### 17.1 Financial Systems Patterns

- Currency formatting patterns
- Financial data validation
- Trading system patterns
- **Sumber**: [Lua Financial Libraries](http://lua-users.org/wiki/FinancialLibraries)

### 17.2 Healthcare Data Patterns

- HL7 message parsing
- Medical record processing
- HIPAA compliance patterns
- **Sumber**: [Healthcare Lua Applications](http://lua-users.org/wiki/HealthcareApplications)

### 17.3 Geographic Information Systems

- GPS data parsing
- Coordinate system patterns
- Mapping data processing
- **Sumber**: [Lua GIS Libraries](http://lua-users.org/wiki/GisLibraries)

---

## MASTER REFERENCE COLLECTION

### Dokumentasi Resmi

- [Lua Official Website](https://www.lua.org/)
- [Lua Reference Manual](https://www.lua.org/manual/)
- [Programming in Lua (Complete Book)](https://www.lua.org/pil/)
- [LPeg Official Documentation](https://www.inf.puc-rio.br/~roberto/lpeg/)

### Community Resources

- [Lua Users Wiki](http://lua-users.org/wiki/)
- [LuaRocks Package Repository](https://luarocks.org/)
- [Lua Mailing Lists](http://lua-users.org/lists/)
- [Stack Overflow Lua Tag](https://stackoverflow.com/questions/tagged/lua)

### Specialized Libraries

- [SLAXML - XML Parser](https://github.com/Phrogz/SLAXML)
- [LuaExpat - XML Processing](https://lunarmodules.github.io/luaexpat/)
- [LPeg Recipes](http://lua-users.org/wiki/LpegRecipes)
- [Lua Grammar Examples](http://lua-users.org/wiki/LuaGrammar)

### Performance Resources

- [LuaJIT Documentation](http://luajit.org/)
- [Lua Performance Tips](http://lua-users.org/wiki/OptimisationTips)
- [Memory Management Guide](http://lua-users.org/wiki/GarbageCollection)

### Security Resources

- [Lua Security Considerations](http://lua-users.org/wiki/SecurityConsiderations)
- [Input Validation Patterns](http://lua-users.org/wiki/InputValidation)
- [Secure Coding Practices](http://lua-users.org/wiki/SecureCoding)

### Industry Applications

- [OpenResty Documentation](https://openresty.org/)
- [Corona SDK (Solar2D)](https://docs.coronalabs.com/)
- [World of Warcraft Lua API](https://wow.gamepedia.com/World_of_Warcraft_API)
- [Wireshark Lua Scripting](https://wiki.wireshark.org/Lua)

### Research Papers

- [Lua Papers Collection](http://www.lua.org/papers.html)
- [PEG Research Papers](https://www.inf.puc-rio.br/~roberto/docs/)
- [Pattern Matching Algorithms](http://www.lua.org/wshop.html)

## PANDUAN PEMBELAJARAN BERTAHAP

### Tingkat Pemula (Bagian I-III)

Fokus pada fondasi pattern matching dan string manipulation dasar. Estimasi waktu: 2-3 minggu dengan praktik intensif.

### Tingkat Menengah (Bagian IV-VIII)

Menguasai LPeg, metaprogramming, dan optimisasi performance. Estimasi waktu: 4-6 minggu dengan proyek praktis.

### Tingkat Lanjut (Bagian IX-XIII)

Aplikasi real-world dan pertimbangan platform. Estimasi waktu: 6-8 minggu dengan implementasi kompleks.

### Tingkat Expert (Bagian XIV-XVII)

Topik spesialisasi dan riset. Pembelajaran berkelanjutan dengan kontribusi komunitas.

### Metodologi Pembelajaran

1. **Teori**: Pahami konsep dari sumber referensi
2. **Praktik**: Implementasikan setiap pattern yang dipelajari
3. **Aplikasi**: Buat proyek nyata menggunakan teknik tersebut
4. **Kontribusi**: Bagikan pengetahuan ke komunitas Lua

## Penambahan Major yang Melengkapkan:

### 1. **LPeg - Parsing Expression Grammars (Bagian IV)**

Menambahkan coverage lengkap LPeg sebagai library pattern matching paling powerful untuk Lua, termasuk tutorial dari Roberto Ierusalimsch (pembuat LPeg) dan implementasi praktis seperti MoonScript

### 2. **XML dan Structured Data Parsing (Bagian V)**

Menambahkan SLAXML untuk XML parsing yang robust, LuaExpat untuk XML processing, dan berbagai format data terstruktur lainnya

### 3. **C API Integration (Bagian X)**

Integrasi dengan C API untuk performance-critical pattern matching dan custom implementations

### 4. **Security Patterns (Bagian XII)**

Coverage komprehensif untuk input validation, cryptographic patterns, dan authentication - aspek kritikal yang sering diabaikan

### 5. **Cross-platform Considerations (Bagian XIII)**

Mobile development, embedded systems, dan platform-specific optimizations

### 6. **Advanced Topics (Bagian XIV-XV)**

Machine learning integration, parallel processing, WebAssembly, cloud computing, dan IoT applications

### 7. **Specialized Domains (Bagian XVII)**

Financial systems, healthcare data, dan GIS - aplikasi industri spesifik

## Keunggulan Kurikulum Ini:

1. **Lebih Dari 150+ Sumber Referensi** - Mencakup dokumentasi resmi, tutorial komunitas, implementasi praktis, dan research papers

2. **Coverage Industri Lengkap** - Dari web development hingga embedded systems, dari game development hingga financial systems

3. **Progression Learning Path** - Dari pemula hingga expert dengan estimasi waktu yang realistis

4. **Practical Implementation Focus** - Setiap konsep disertai aplikasi real-world dan best practices

5. **Community Integration** - Panduan kontribusi ke open source dan community involvement

6. **Future-Proofing** - Coverage teknologi emerging seperti WebAssembly, IoT, dan cloud computing

#

Kurikulum ini dirancang untuk memberikan penguasaan pattern matching Lua yang mendalam, melampaui dokumentasi resmi dengan cakupan industri, riset, dan aplikasi praktis yang komprehensif sehingga benar-benar **komprehensif dan self-contained** - seorang pemula dapat menguasai advanced patterns Lua hingga level expert tanpa perlu mencari referensi tambahan di luar sumber-sumber yang telah disediakan.

#

#### Selamat Belajar!

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../../advanced/garbage-collection/README.md
[selanjutnya]: ../../advanced/web-development/README.md

<!--------------------------->

[0]: ../../README.md/#advanced-13-topik
[1]: ../advanced-patterns/bagian-1/README.md
[2]: ../advanced-patterns/bagian-2/README.md
[3]: ../advanced-patterns/bagian-3/README.md
[4]: ../advanced-patterns/bagian-4/README.md
[5]: ../advanced-patterns/bagian-5/README.md
[6]: ../advanced-patterns/bagian-6/README.md
[7]: ../advanced-patterns/bagian-7/README.md
[8]: ../advanced-patterns/bagian-8/README.md
[9]: ../advanced-patterns/bagian-9/README.md
[10]: ../advanced-patterns/bagian-10/README.md
[11]: ../advanced-patterns/bagian-11/README.md
[12]: ../advanced-patterns/bagian-12/README.md
[13]: ../advanced-patterns/bagian-13/README.md
[14]: ../advanced-patterns/bagian-14/README.md
[15]: ../advanced-patterns/bagian-14/README.md
[16]: ../advanced-patterns/bagian-14README.md
[17]: ../advanced-patterns/bagian-14/README.md
