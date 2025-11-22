# Perbedaan Bahasa Pemrograman Embedded vs Embeddable

## Definisi dan Konsep Dasar

### Bahasa Pemrograman Embedded

**Definisi**: Bahasa yang **dirancang khusus** atau **dioptimalkan** untuk pengembangan embedded systems dengan karakteristik dan constraint khusus.

**Karakteristik:**

- Didesain untuk resource-constrained environments
- Low-level control terhadap hardware
- Minimal runtime overhead
- Real-time capabilities
- Deterministic behavior
- Small memory footprint

### Bahasa Pemrograman Embeddable

**Definisi**: Bahasa yang dapat **disematkan** atau **diintegrasikan** ke dalam sistem atau aplikasi lain sebagai scripting engine atau extension language.

**Karakteristik:**

- Dapat diintegrasikan ke dalam aplikasi host
- Menyediakan API untuk interaksi dengan host application
- Biasanya berfungsi sebagai scripting atau configuration language
- Host application mengontrol lifecycle bahasa tersebut

## Perbandingan Detail

### 1. Tujuan Utama

| Aspek                  | Embedded Languages                  | Embeddable Languages                            |
| ---------------------- | ----------------------------------- | ----------------------------------------------- |
| **Primary Purpose**    | Mengontrol hardware secara langsung | Memperluas fungsionalitas aplikasi host         |
| **Target Environment** | Microcontrollers, SoCs, bare metal  | Desktop applications, game engines, web servers |
| **Control Level**      | System-level control                | Application-level scripting                     |
| **Resource Focus**     | Memory dan power efficiency         | Ease of integration dan flexibility             |

### 2. Contoh Bahasa

#### Embedded Languages:

```c
// C - Classic embedded language
#include <avr/io.h>
#include <util/delay.h>

int main(void) {
    DDRB |= (1 << PB5);  // Direct hardware register access

    while(1) {
        PORTB |= (1 << PB5);   // Set pin high
        _delay_ms(1000);
        PORTB &= ~(1 << PB5);  // Set pin low
        _delay_ms(1000);
    }
}
```

```rust
// Rust - Modern embedded language
#![no_std]
#![no_main]

use cortex_m_rt::entry;
use stm32f4xx_hal::{pac, prelude::*};

#[entry]
fn main() -> ! {
    let dp = pac::Peripherals::take().unwrap();
    let gpioa = dp.GPIOA.split();
    let mut led = gpioa.pa5.into_push_pull_output();

    loop {
        led.set_high();
        cortex_m::asm::delay(1_000_000);
        led.set_low();
        cortex_m::asm::delay(1_000_000);
    }
}
```

#### Embeddable Languages:

```c
// Lua embedded dalam C application
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

void run_lua_script(const char* script) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // Execute Lua script dari C program
    luaL_dostring(L, script);

    lua_close(L);
}

// Lua script yang di-embed
const char* lua_script =
    "function calculate(x, y) "
    "    return x * y + 10 "
    "end "
    "result = calculate(5, 3)";
```

```python
# Python embedded dalam C++ application
#include <Python.h>

void execute_python_code() {
    Py_Initialize();

    PyRun_SimpleString(
        "import math\n"
        "result = math.sqrt(25)\n"
        "print(f'Result: {result}')\n"
    );

    Py_Finalize();
}
```

### 3. Arsitektur dan Runtime

#### Embedded Languages Architecture:

```
┌─────────────────────────────────────┐
│           Application Code          │
├─────────────────────────────────────┤
│        Runtime Library (minimal)    │
├─────────────────────────────────────┤
│         Hardware Abstraction        │
├─────────────────────────────────────┤
│              Hardware               │
│        (Microcontroller/SoC)        │
└─────────────────────────────────────┘
```

#### Embeddable Languages Architecture:

```
┌─────────────────────────────────────┐
│          Host Application           │
├─────────────────────────────────────┤
│     Language Runtime/Interpreter    │
│         (Lua, Python, etc.)         │
├─────────────────────────────────────┤
│          Script/Plugin Code         │
├─────────────────────────────────────┤
│        Operating System APIs        │
├─────────────────────────────────────┤
│           Hardware (PC/Server)      │
└─────────────────────────────────────┘
```

## Kategori dan Klasifikasi Lengkap

### Pure Embedded Languages

**Karakteristik**: Dirancang khusus untuk embedded systems

#### 1. System Programming Languages

```c
// C - The king of embedded
volatile uint32_t *GPIO_PORTA = (uint32_t*)0x40020000;

void configure_gpio(void) {
    *GPIO_PORTA |= (1 << 5);  // Direct memory mapped I/O
}
```

```assembly
; Assembly - Ultimate control
.section .text
.global _start

_start:
    ldr r0, =0x40020000    ; GPIO base address
    mov r1, #(1<<5)        ; Pin 5 mask
    str r1, [r0, #0x14]    ; Set output high
```

#### 2. Modern Embedded Languages

```rust
// Rust - Memory safety untuk embedded
use nb::block;
use stm32f4xx_hal::timer::Timer;

fn safe_delay(timer: &mut Timer<TIM2>) {
    block!(timer.wait()).unwrap();  // Zero-cost abstractions
}
```

#### 3. Specialized Embedded Languages

```ada
-- Ada - Safety-critical systems
with System;
package Sensor_Control is
   for Sensor_Address use at 16#4002_0000#;

   type Sensor_Data is mod 2**16;
   Sensor_Value : Sensor_Data;
   for Sensor_Value'Address use Sensor_Address;
end Sensor_Control;
```

### Pure Embeddable Languages

#### 1. Scripting Languages

```lua
-- Lua - Lightweight embeddable scripting
function init_game_object(name, x, y)
    local obj = {
        name = name,
        position = {x = x, y = y},
        update = function(self, dt)
            -- Game logic here
        end
    }
    return obj
end
```

```javascript
// JavaScript (V8 embedded)
// Dalam Node.js native modules
const { createRequire } = require("module");

function processData(input) {
  return input.map((x) => x * 2).filter((x) => x > 10);
}
```

#### 2. Configuration Languages

```tcl
# Tcl - Tool Command Language (embeddable)
proc configure_network {interface ip mask} {
    set config [list interface $interface ip $ip netmask $mask]
    return $config
}
```

```scheme
; Scheme - Embeddable Lisp dialect
(define (calculate-physics dt)
  (lambda (object)
    (update-position object
      (* (velocity object) dt))))
```

### Hybrid Languages (Both Embedded & Embeddable)

#### 1. Python/MicroPython

```python
# Standard Python (Embeddable)
import sys

def plugin_function(data):
    """Function called by host application"""
    return [x ** 2 for x in data if x > 0]

# Host application dapat call ini via Python C API
```

```python
# MicroPython (Embedded)
import machine
import time

led = machine.Pin(2, machine.Pin.OUT)

while True:
    led.on()
    time.sleep_ms(500)
    led.off()
    time.sleep_ms(500)
```

#### 2. C++ (dengan berbagai use cases)

```cpp
// C++ untuk embedded systems
class SensorManager {
private:
    volatile uint32_t* adc_base;

public:
    SensorManager(uint32_t addr) : adc_base(reinterpret_cast<volatile uint32_t*>(addr)) {}

    uint16_t read_sensor() {
        return static_cast<uint16_t>(*adc_base & 0xFFF);
    }
};
```

```cpp
// C++ sebagai embeddable (via DLL/SO)
extern "C" {
    __declspec(dllexport) int process_data(int* data, int length) {
        std::vector<int> vec(data, data + length);
        std::sort(vec.begin(), vec.end());
        return vec.back();  // Return max value
    }
}
```

## Use Cases dan Application Domains

### Embedded Languages Use Cases

#### 1. Automotive ECUs

```c
// Engine Control Unit programming
#include "engine_hal.h"

typedef struct {
    uint16_t rpm;
    uint8_t throttle_position;
    int16_t temperature;
} engine_params_t;

void control_fuel_injection(engine_params_t* params) {
    uint16_t injection_time = calculate_injection_time(
        params->rpm,
        params->throttle_position
    );

    set_injector_pulse_width(injection_time);
}
```

#### 2. IoT Sensors

```c
// LoRaWAN sensor node
#include "lora_radio.h"
#include "sensor_drivers.h"

void sensor_task(void) {
    sensor_data_t data;

    data.temperature = read_temperature_sensor();
    data.humidity = read_humidity_sensor();
    data.battery_level = read_battery_voltage();

    lora_transmit(&data, sizeof(data));

    enter_deep_sleep(SLEEP_DURATION_MS);
}
```

### Embeddable Languages Use Cases

#### 1. Game Scripting

```lua
-- Lua dalam game engine
local player = {
    health = 100,
    position = {x = 0, y = 0},

    move = function(self, dx, dy)
        self.position.x = self.position.x + dx
        self.position.y = self.position.y + dy

        -- Call C++ engine function
        engine.update_player_position(self.position.x, self.position.y)
    end,

    take_damage = function(self, damage)
        self.health = self.health - damage
        if self.health <= 0 then
            engine.trigger_game_over()
        end
    end
}
```

#### 2. Web Server Extensions

```javascript
// Node.js dengan native modules
const addon = require("./build/Release/native_addon");

function processRequest(req, res) {
  // Call native C++ function untuk performance-critical operations
  const result = addon.fast_compute(req.body.data);

  res.json({
    result: result,
    timestamp: Date.now(),
  });
}
```

#### 3. CAD Software Plugins

```python
# Python embedded dalam CAD application
import cad_api

def create_spiral(radius, height, turns):
    """Create spiral geometry"""
    points = []
    steps = turns * 20

    for i in range(steps):
        angle = (i / steps) * turns * 2 * math.pi
        x = radius * math.cos(angle)
        y = radius * math.sin(angle)
        z = (i / steps) * height
        points.append(cad_api.Point3D(x, y, z))

    return cad_api.create_curve(points)
```

## Integration Patterns

### Embedding Pattern untuk Embeddable Languages

#### 1. Library Integration

```c
// Host application embedding Lua
#include <lua.h>
#include <lauxlib.h>

typedef struct {
    lua_State* L;
    bool initialized;
} script_engine_t;

int script_engine_init(script_engine_t* engine) {
    engine->L = luaL_newstate();
    if (!engine->L) return -1;

    luaL_openlibs(engine->L);

    // Register C functions untuk Lua
    lua_register(engine->L, "c_print", lua_c_print);
    lua_register(engine->L, "c_get_time", lua_c_get_time);

    engine->initialized = true;
    return 0;
}

int script_engine_execute(script_engine_t* engine, const char* script) {
    if (!engine->initialized) return -1;

    return luaL_dostring(engine->L, script);
}
```

#### 2. Plugin Architecture

```cpp
// C++ application dengan Python plugins
class PluginManager {
private:
    PyObject* plugin_module;

public:
    bool load_plugin(const std::string& plugin_path) {
        Py_Initialize();

        PyObject* sys_path = PySys_GetObject("path");
        PyObject* path = PyUnicode_FromString(plugin_path.c_str());
        PyList_Append(sys_path, path);

        plugin_module = PyImport_ImportModule("plugin");
        return plugin_module != nullptr;
    }

    template<typename... Args>
    PyObject* call_plugin_function(const std::string& func_name, Args... args) {
        PyObject* func = PyObject_GetAttrString(plugin_module, func_name.c_str());
        if (!func || !PyCallable_Check(func)) {
            return nullptr;
        }

        PyObject* py_args = build_python_args(args...);
        PyObject* result = PyObject_CallObject(func, py_args);

        Py_DECREF(py_args);
        Py_DECREF(func);

        return result;
    }
};
```

## Performance dan Resource Implications

### Memory Footprint Comparison

```
Embedded Languages (Typical):
┌──────────────┬────────────┬─────────────┐
│   Language   │ Runtime    │ Hello World │
├──────────────┼────────────┼─────────────┤
│ C            │ 0 KB       │ ~1 KB       │
│ Assembly     │ 0 KB       │ ~100 bytes  │
│ Rust         │ ~10 KB     │ ~5 KB       │
│ C++          │ ~20 KB     │ ~10 KB      │
│ MicroPython  │ ~100 KB    │ ~150 KB     │
└──────────────┴────────────┴─────────────┘

Embeddable Languages (Typical):
┌──────────────┬────────────┬─────────────┐
│   Language   │ Runtime    │ Hello World │
├──────────────┼────────────┼─────────────┤
│ Lua          │ ~200 KB    │ ~250 KB     │
│ Python       │ ~10 MB     │ ~15 MB      │
│ JavaScript   │ ~15 MB     │ ~20 MB      │
│ Ruby         │ ~20 MB     │ ~25 MB      │
└──────────────┴────────────┴─────────────┘
```

### Performance Characteristics

#### Embedded Languages:

- **Execution Speed**: Direct compilation ke machine code
- **Memory Access**: Direct hardware register access
- **Real-time**: Deterministic timing behavior
- **Startup Time**: Instant (no interpreter initialization)

#### Embeddable Languages:

- **Execution Speed**: Interpreted atau JIT compiled
- **Memory Access**: Through host application APIs
- **Real-time**: Non-deterministic due to garbage collection
- **Startup Time**: Runtime initialization overhead

## Decision Matrix

### Choosing Between Embedded vs Embeddable

#### Gunakan Embedded Languages Jika:

- ✅ Direct hardware control diperlukan
- ✅ Real-time performance critical
- ✅ Memory/power constraints ketat
- ✅ Standalone system operation
- ✅ Safety-critical applications
- ✅ Long-term reliability requirements

#### Gunakan Embeddable Languages Jika:

- ✅ Rapid development/prototyping
- ✅ User customization/scripting needed
- ✅ Plugin architecture required
- ✅ Configuration flexibility important
- ✅ Domain-specific scripting
- ✅ Integration dengan existing applications

#### Hybrid Approach (Gunakan Keduanya):

```
┌─────────────────────────────────────┐
│     Host Application (C/C++)        │
│  ┌─────────────────────────────────┐│
│  │    Embedded Script Engine       ││
│  │         (Lua/Python)            ││
│  └─────────────────────────────────┘│
├─────────────────────────────────────┤
│      Hardware Abstraction Layer     │
├─────────────────────────────────────┤
│            Hardware                 │
└─────────────────────────────────────┘
```

**Contoh Hybrid Implementation:**

```c
// Main embedded application dalam C
int main(void) {
    hardware_init();

    // Initialize embedded scripting engine
    script_engine_t engine;
    script_engine_init(&engine);

    // Load user configuration scripts
    script_engine_load_file(&engine, "config.lua");

    while (1) {
        // Critical real-time tasks dalam C
        handle_interrupts();
        process_sensor_data();

        // Non-critical tasks via scripting
        script_engine_call(&engine, "update_display");
        script_engine_call(&engine, "log_data");

        system_sleep();
    }
}
```

## Kesimpulan

**Key Differences Summary:**

| Aspek              | Embedded Languages        | Embeddable Languages            |
| ------------------ | ------------------------- | ------------------------------- |
| **Purpose**        | Control hardware directly | Extend host applications        |
| **Runtime**        | Minimal/none              | Full interpreter/VM             |
| **Performance**    | Maximum                   | Moderate (flexibility priority) |
| **Resource Usage** | Minimal                   | Higher (acceptable trade-off)   |
| **Development**    | Lower level, more complex | Higher level, more productive   |
| **Use Case**       | System programming        | Application scripting           |

**Practical Implications:**

- **Embedded languages** = "I AM the system"
- **Embeddable languages** = "I work WITHIN the system"

Memahami perbedaan ini penting untuk memilih approach yang tepat untuk setiap project. Banyak sistem modern menggunakan kombinasi keduanya untuk mendapatkan benefit dari real-time performance DAN flexibility.

**Ringkasan Singkat:**

**Embedded Languages** → "Saya ADALAH sistem"

- Contoh: C untuk mikrokontroler, Assembly untuk boot loader
- Mengontrol hardware secara langsung
- Minimal runtime overhead

**Embeddable Languages** → "Saya BEKERJA DALAM sistem"

- Contoh: Lua dalam game engine, Python dalam CAD software
- Di-integrate ke dalam aplikasi host
- Fokus pada extensibility dan scripting

**Analogi Sederhana:**

- **Embedded** = Seperti "otak" yang mengontrol robot secara langsung
- **Embeddable** = Seperti "plugin" yang menambah fitur ke aplikasi yang sudah ada

**Real-world Examples:**

1. **Arduino programming (Embedded)**: C++ code yang di-compile langsung ke microcontroller, mengontrol GPIO pins secara langsung

2. **Blender Python scripting (Embeddable)**: Python code yang berjalan di dalam Blender software untuk otomasi modeling tasks

**Hybrid Cases:**
Beberapa bahasa bisa keduanya:

- **MicroPython**: Embedded (untuk ESP32) DAN Embeddable (bisa di-embed ke C applications)
- **C++**: Embedded (untuk sistem real-time) DAN Embeddable (sebagai DLL/library)

#

> #### [Home][domain-spesifik]

[domain-spesifik]: ../../domain-spesifik/README.md
