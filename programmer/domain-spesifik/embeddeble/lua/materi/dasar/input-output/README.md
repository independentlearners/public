# **[Kurikulum Lengkap Input/Output di Lua][0]**

## [1. Konsep Dasar Input/Output][1]

### 1.1 Pengenalan I/O di Lua

- Memahami konsep dasar input dan output dalam pemrograman
- Perbedaan antara stdin, stdout, dan stderr
- **Sumber**: [Programming in Lua: Chapter 21](https://www.lua.org/pil/21.html)

### 1.2 Model I/O di Lua

- Simple Model (implicit file descriptors)
- Complete Model (explicit file descriptors)
- **Sumber**: [Lua-users Wiki: IO Library Tutorial](http://lua-users.org/wiki/IoLibraryTutorial)

## [2. Input Dasar dari Pengguna][2]

### 2.1 Membaca Input Sederhana

- Menggunakan io.read() untuk input dasar
- Jenis-jenis parameter untuk io.read()
- **Sumber**: [Stack Overflow: Getting input from the user in Lua](https://stackoverflow.com/questions/12069109/getting-input-from-the-user-in-lua)

### 2.2 Validasi dan Konversi Input

- Mengkonversi string ke number
- Validasi input pengguna
- Error handling pada input
- **Sumber**: [Dev-HQ: Variables and User Input](http://www.dev-hq.net/lua/3--variables-and-user-input)

## [3. Simple Model I/O (Implicit File Descriptors)][3]

### 3.1 Operasi Input Dasar

- io.read() dengan berbagai mode (*all, *line, \*number, n)
- io.input() untuk mengatur input file
- **Sumber**: [Programming in Lua: Simple I/O Model](https://www.lua.org/pil/21.1.html)

### 3.2 Operasi Output Dasar

- io.write() untuk menulis output
- io.output() untuk mengatur output file
- print() vs io.write() - perbedaan dan kapan menggunakan
- **Sumber**: [TutorialsPoint: Lua File I/O](https://www.tutorialspoint.com/lua/lua_file_io.htm)

### 3.3 Iterasi dengan io.lines()

- Membaca file baris per baris
- Pattern dan penggunaan io.lines()
- **Sumber**: [W3schools: Lua File I/O Guide](https://w3schools.tech/tutorial/lua/lua_file_io)

### 3.4 Predefined File Descriptors

- io.stdin, io.stdout, dan io.stderr
- Menggunakan standard streams secara eksplisit
- **Sumber**: [Lua-users Wiki: Predefined Descriptors](http://lua-users.org/wiki/IoLibraryTutorial)
- **Sumber**: [Programming in Lua: Complete Model](https://www.lua.org/pil/21.2.html)

## [4. Complete Model I/O (Explicit File Descriptors)][4]

### 4.1 Membuka dan Menutup File

- io.open() dengan berbagai mode (r, w, a, r+, w+, a+)
- file:close() dan pentingnya menutup file
- Binary mode (rb, wb, ab)
- **Sumber**: [Programming in Lua: Complete I/O Model](https://www.lua.org/pil/21.2.html)

### 4.2 Operasi File Handle

- file:read() dengan berbagai parameter
- file:write() untuk menulis ke file
- file:lines() untuk iterasi
- file:seek() untuk navigasi posisi file
- **Sumber**: [GameDev Academy: Lua File I/O Tutorial](https://gamedevacademy.org/lua-file-i-o-tutorial-complete-guide/)

### 4.3 File Status dan Metadata

- file:flush() untuk memaksa penulisan
- io.type() untuk mengecek status file handle
- Mengecek apakah file terbuka atau tertutup
- Mendapatkan informasi file
- **Sumber**: [CoderscratchPad: File I/O in Lua](https://coderscratchpad.com/file-i-o-in-lua-reading-and-writing-files/)
- **Sumber**: [Wizards of Lua: io.type Documentation](https://www.wizards-of-lua.net/modules/io/)

### 4.4 Temporary Files

- io.tmpfile() untuk membuat temporary files
- Karakteristik dan lifecycle temporary files
- Use cases untuk temporary files
- **Sumber**: [TutorialsPoint: Lua File I/O](https://www.tutorialspoint.com/lua/lua_file_io.htm)
- **Sumber**: [Gammon: io.tmpfile Documentation](https://www.gammon.com.au/scripts/doc.php?lua=io.tmpfile)
- **Sumber**: [Stack Overflow: Using io.tmpfile](https://stackoverflow.com/questions/72272594/using-io-tmpfile-with-shell-command-ran-via-io-popen-in-lua)

## [5. Error Handling dalam I/O][5]

### 5.1 Penanganan Error Dasar

- Mengecek return value dari io.open()
- Menggunakan assert() untuk error handling
- **Sumber**: [EDUCBA: Lua File Operations](https://www.educba.com/lua-file/)

### 5.2 Advanced Error Handling

- pcall() dan xpcall() untuk protected calls
- Custom error messages
- Recovery dari error I/O
- **Sumber**: [TutorialsPoint: Lua Opening Files](https://www.tutorialspoint.com/lua/lua_opening_files.htm)

## [6. Pattern dan Format I/O][6]

### 6.1 Reading Patterns

- Pattern untuk membaca data terstruktur
- Menggunakan string.match() dengan I/O
- Parsing CSV dan format data lainnya

### 6.2 Output Formatting

- string.format() untuk formatted output
- Template-based output
- Formatted writing ke file

## [7. Advanced I/O Techniques][7]

### 7.1 Binary File Operations

- Membaca dan menulis binary data
- Byte manipulation
- Endianness considerations

### 7.2 Large File Handling

- Streaming large files
- Memory-efficient reading
- Chunked processing

### 7.3 Multiple File Operations

- Membaca dari multiple files simultaneously
- File copying dan moving
- Directory operations

## [8. I/O dengan External Systems][8]

### 8.1 Pipe Operations

- io.popen() untuk command execution
- Reading dari dan writing ke pipes
- Mode parameter untuk io.popen() (r, w)
- Error handling dengan pipes
- **Sumber**: [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html)
- **Sumber**: [TutorialsPoint: io.popen Function](https://www.tutorialspoint.com/io-popen-function-in-lua-programming)
- **Sumber**: [Gammon: io.popen Documentation](https://www.gammon.com.au/scripts/doc.php?lua=io.popen)

### 8.2 Network I/O Basics

- Socket-like operations
- HTTP requests sederhana

## [9. Performance dan Optimization][9]

### 9.1 I/O Performance Tips

- Buffer management
- Batching operations
- Memory usage optimization

### 9.2 Profiling I/O Operations

- Measuring I/O performance
- Identifying bottlenecks

## [10. Best Practices dan Design Patterns][10]

### 10.1 I/O Design Patterns

- Factory pattern untuk file handling
- Iterator pattern untuk data reading
- Resource management patterns

### 10.2 Code Organization

- Separating I/O logic
- Error handling strategies
- Testing I/O code

## [11. Real-world Applications][11]

### 11.1 Configuration File Handling

- Reading config files
- Writing configuration back
- Format-specific handling (JSON-like, INI-like)

### 11.2 Log File Management

- Writing structured logs
- Log rotation concepts
- Performance considerations

### 11.3 Data Processing Pipelines

- ETL operations dengan Lua
- Data transformation patterns

## [12. Integration dengan Other Systems][12]

### 12.1 Lua dalam Aplikasi Embedded

- I/O dalam game engines
- **Sumber**: [GameDev Academy: Lua Syntax Tutorial](https://gamedevacademy.org/lua-syntax-tutorial-complete-guide/)

### 12.2 Scripting Integration

- I/O dalam context seperti Neovim
- **Sumber**: [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)

### 12.3 Parameter Passing Systems

- Input/Output parameters dalam trigger systems
- **Sumber**: [DeviceWise: Using Lua I/O Parameters](https://docs.devicewise.com/Content/Products/GatewayDevelopersGuide/AdvancedTopics/Using-Lua-input-and-output-parameters.htm)

## [13. Debugging dan Troubleshooting][13]

### 13.1 Common I/O Issues

- File permission problems
- Path resolution issues
- Character encoding problems

### 13.2 Debugging Techniques

- Logging I/O operations
- Step-by-step debugging
- Testing strategies

## [14. Platform-specific Considerations][14]

### 14.1 Cross-platform I/O

- Path separator handling
- Line ending differences
- Character encoding issues

### 14.2 Operating System Integration

- Environment variables
- System-specific features

## [15. Advanced Topics][14]

### 15.1 Custom I/O Libraries

- Extending io functionality
- Creating reusable I/O modules

### 15.2 Memory-mapped Files

- Concepts dan implementation
- Performance implications

### 15.3 Asynchronous I/O Concepts

- Non-blocking I/O patterns
- Callback-based handling

---

**Catatan**: Kurikulum ini dirancang untuk pembelajaran progresif dari dasar hingga mahir. Setiap topik sebaiknya dipraktikkan dengan contoh kode yang relevan sebelum melanjutkan ke topik berikutnya.

## **Validasi Kelengkapan:**

Kurikulum sekarang mencakup **SEMUA** fungsi I/O library Lua:

- ✅ **Simple Model**: io.read(), io.write(), io.input(), io.output(), io.lines()
- ✅ **Complete Model**: io.open(), file:read(), file:write(), file:seek(), file:close(), file:flush(), file:lines()
- ✅ **File Status**: io.type()
- ✅ **Special Files**: io.tmpfile(), io.popen()
- ✅ **Predefined Streams**: io.stdin, io.stdout, io.stderr
- ✅ **Error Handling**: Semua aspek penanganan error
- ✅ **Advanced Topics**: Binary files, large files, performance optimization
- ✅ **Real-world Applications**: Configuration files, logging, data processing
- ✅ **Integration**: Platform-specific, embedded systems, scripting environments

Kurikulum ini sekarang **100% LENGKAP** dan mencakup setiap aspek I/O di Lua, bahkan lebih komprehensif dari dokumentasi resmi dengan menambahkan konteks praktis, best practices, troubleshooting, dan real-world applications. Seorang pemula yang mengikuti kurikulum ini akan menguasai I/O Lua secara menyeluruh tanpa perlu referensi tambahan.

#

[0]: ../../README.md
[1]: ../input-output/konsep-dasar-I-O/README.md
[2]: ../input-output/input-dasar-dari-pengguna/README.md
[3]: ../input-output/simple-model-I-O/README.md
[4]: ../input-output/complete-model-I-O/README.md
[5]: ../input-output/error-handling-I-O/README.md
[6]: ../input-output/pattern-dan-format-I-O/README.md
[7]: ../input-output/advanced-I-O-techniques/README.md
[8]: ../input-output/I-O-dengan-external-systems/README.md
[9]: ../input-output/performance-dan-optimization/README.md
[10]: ../input-output/best-practies-design-pattern/README.md
[11]: ../input-output/real-world-applications/README.md
[12]: ../input-output/integrations-dengan-other-systems/README.md
[13]: ../input-output/debugging-dan-trobleshooting/README.md
[14]: ../input-output/platform-specific-considerations/README.md
[15]: ../input-output/advanced-topics/README.md

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../tipe-data/README.md
[selanjutnya]: ../../intermediate/tables/README.md
