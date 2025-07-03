# 📚 Panduan Markdown Lengkap & Komprehensif

_Menguasai Semua Fitur Markdown dari Dasar hingga Advanced_

---

## 🎯 Daftar Isi Utama

### **[BAGIAN I: FUNDAMENTAL](#bagian-i-fundamental-1)**

1. [Sejarah & Varian Markdown](#1-sejarah--varian-markdown)
2. [Syntax Dasar](#2-syntax-dasar)
3. [Heading & Struktur](#3-heading--struktur)
4. [Text Formatting](#4-text-formatting)
5. [Lists & Organisasi](#5-lists--organisasi)

### **[BAGIAN II: CONTENT ELEMENTS](#bagian-ii-content-elements-1)**

6. [Links & Referensi](#6-links--referensi)
7. [Images & Media](#7-images--media)
8. [Code & Programming](#8-code--programming)
9. [Tables & Data](#9-tables--data)
10. [Blockquotes & Callouts](#10-blockquotes--callouts)

### **[BAGIAN III: ADVANCED FEATURES](#bagian-iii-advanced-features-1)**

11. [HTML Integration](#11-html-integration)
12. [Math & LaTeX](#12-math--latex)
13. [Diagrams & Visualizations](#13-diagrams--visualizations)
14. [Interactive Elements](#14-interactive-elements)
15. [Extensions & Plugins](#15-extensions--plugins)

### **[BAGIAN IV: PLATFORM SPECIFIC](#bagian-iv-platform-specific-1)**

16. [GitHub Flavored Markdown](#github-flavored-markdown-gfm)
17. [Discord & Chat Platforms](#17-discord--chat-platforms)
18. [Documentation Platforms](#18-documentation-platforms)
19. [Static Site Generators](#static-site-generators)
20. [Academic & Scientific](#academic--scientific)

### **BAGIAN V: EXPERT LEVEL**

21. [Custom Rendering](#custom-rendering)
22. [Performance & Optimization](#performance--optimization)
23. [Security Considerations](#security-considerations)
24. [Best Practices](#best-practices)
25. [Troubleshooting](#troubleshooting)

---

# BAGIAN I: FUNDAMENTAL

## 1. Sejarah & Varian Markdown

### 📜 Sejarah Singkat

- **2004**: John Gruber menciptakan Markdown
- **2012**: CommonMark specification dimulai
- **2014**: GitHub Flavored Markdown (GFM) diluncurkan
- **2017**: CommonMark 0.28 menjadi standar stabil

### 🌟 Varian Utama Markdown

#### **CommonMark** (Standar Utama)

```markdown
<!-- Syntax murni tanpa ekstensi -->

**Bold** dan _italic_ text
```

#### **[GitHub Flavored Markdown (GFM)](#bagian-iv-platform-specific)**

~~Strikethrough~~

```
- [x] Task lists
  | Tables | Support |
  |--------|---------|
  | Yes    | Full    |
```

#### **MultiMarkdown (MMD)**

```markdown
Title: Document Title  
Author: Your Name  
Date: 2025-05-31

Footnote reference[^fn1]
[^fn1]: Footnote content
```

#### **Pandoc Markdown**

```markdown
::: {.callout-note}
Pandoc-specific callout boxes
:::

Math: $E = mc^2$
```

#### **kramdown (Jekyll)**

```css
 {
  :.class-name ;
}
Paragraph dengan CSS class - List item {
  :toc ;
}
```

#### **Markdown Extra (PHP)**

```markdown
Term 1
: Definition 1

Term 2
: Definition 2
with multiple paragraphs
```

---

## 2. Syntax Dasar

### 🔤 Karakter Spesial & Escaping

```markdown
<!-- Karakter yang perlu di-escape -->

\* \_ \` \# \+ \- \. \! \[ \] \( \) \{ \} \< \> \| \~

<!-- Contoh penggunaan -->

\*Tidak menjadi italic\*
Harga: \$100 (tidak menjadi LaTeX)
```

### 📏 Whitespace & Line Breaks

```markdown
<!-- Hard break (2 spasi + enter) -->

Baris pertama  
Baris kedua

<!-- Soft break (hanya enter) -->

Baris pertama
Baris kedua (masih satu paragraf)

<!-- Paragraph break (2 enters) -->

Paragraf pertama

Paragraf kedua
```

### 🔄 HTML Entity Support

```markdown
&copy; &trade; &reg; &amp; &lt; &gt; &quot; &#39;
&mdash; &ndash; &hellip; &nbsp;

<!-- Hasil: © ™ ® & < > " ' — – …   -->
```

---

## 3. Heading & Struktur

### 📑 Heading Styles

```markdown
# H1 - Atx Style

## H2 - Atx Style

### H3 - Atx Style

#### H4 - Atx Style

##### H5 - Atx Style

###### H6 - Atx Style

<!-- Setext Style (hanya H1 & H2) -->

# Heading Level 1

## Heading Level 2
```

### 🆔 Custom IDs & Anchors

```markdown
<!-- Pandoc/kramdown syntax -->

## Heading

### Another Heading

<!-- GitLab syntax -->

## Heading {#custom-id}

<!-- Manual HTML -->
<h2 id="manual-id">Manual Heading</h2>
```

### 📊 Table of Contents (TOC)

```markdown
## <!-- Pandoc -->

toc: true
toc-depth: 3

---

<!-- GitLab -->

[[TOC]]

<!-- kramdown -->

- TOC
  {:toc}

<!-- Manual TOC -->

## Table of Contents

1. [Section 1](#section-1)
   - [Subsection 1.1](#subsection-11)
   - [Subsection 1.2](#subsection-12)
2. [Section 2](#section-2)
```

---

## 4. Text Formatting

### ✨ Basic Formatting

```markdown
_Italic_ atau _Italic_
**Bold** atau **Bold**
**_Bold Italic_** atau **_Bold Italic_**
~~Strikethrough~~
==Highlight== (tidak semua platform)
++Underline++ (tidak semua platform)
^Superscript^ (tidak semua platform)
~Subscript~ (tidak semua platform)
```

### 🎨 Advanced Text Styling

```markdown
<!-- Kombinasi formatting -->

**Bold dengan _italic_ di dalam**
_Italic dengan **bold** di dalam_
~~Strike dengan **bold** di dalam~~

<!-- Escape dalam formatting -->

**Bold dengan \*asterisk\* literal**
_Italic dengan \_underscore\_ literal_

<!-- Formatting dengan punctuation -->

**"Bold quote"**
_'Italic quote'_
**Bold.** Normal text.
```

### 🔤 Typography & Special Characters

```markdown
<!-- Em dash dan en dash -->

--- (em dash)
-- (en dash - beberapa parser)

<!-- Ellipsis -->

... (three dots)
… (ellipsis character)

<!-- Quotes -->

"Smart quotes" (beberapa parser)
'Single quotes'
``Double backticks for quotes''

<!-- Fractions -->

1/2 1/4 3/4 (beberapa parser auto-convert)
```

---

## 5. Lists & Organisasi

### 📝 Ordered Lists

```markdown
1. First item
2. Second item
3. Third item
   1. Nested item
   2. Another nested
4. Fourth item

<!-- Start numbering dari angka tertentu -->

5. Start from five
6. Six
7. Seven

<!-- Menggunakan tanda kurung -->

1. Alternative syntax
2. Also works
3. In some parsers
```

### 🔸 Unordered Lists

```markdown
- Item dengan dash

* Item dengan asterisk

- Item dengan plus

<!-- Nested lists -->

- Main item
  - Sub item (2 spaces)
    - Sub-sub item (4 spaces)
      - Deep nesting (6 spaces)
  - Back to sub level
- Another main item

<!-- Mixed markers -->

- Level 1
  - Level 2
    - Level 3
```

### ✅ Task Lists (GFM)

- [x] Completed task
- [ ] Uncompleted task
- [x] ~~Completed and crossed out~~
- [ ] Task with **bold text**
- [ ] Task with [link](https://example.com)
- [ ] Task with `code`
  - [x] Nested completed task
  - [ ] Nested uncompleted task

### 📋 Definition Lists (beberapa ekstensi)

<!-- Pandoc/PHP Markdown Extra -->

Term 1
: Definition 1

Term 2
: Definition 2a
: Definition 2b

<!-- kramdown -->

Definition List
: First definition
: Second definition

Another Term
: Another definition
with multiple paragraphs

Including code blocks:

      code example

### 📊 Complex Lists dengan Multiple Content

1. **First item** with multiple elements:

   This is a paragraph under the first item.

```python
# Code block in list
print("Hello from list!")
```

- Nested unordered list
- With multiple items

> Blockquote in list item

![Image in list](https://via.placeholder.com/100)

2. **Second item** continues the numbering

   | Tables | Also |
   | ------ | ---- |
   | Work   | Here |

---

# BAGIAN II: CONTENT ELEMENTS

## 6. Links & Referensi

### 🔗 Basic Links

```markdown
<!-- Inline links -->

[Link text](https://example.com)
[Link with title](https://example.com "Tooltip title")
[Link to email](mailto:user@example.com)
[Link to phone](tel:+1234567890)

<!-- Automatic links -->

<https://example.com>
<user@example.com>

<!-- Bare URLs (GFM) -->

https://github.com akan otomatis jadi link
```

### 📚 Reference Links

```markdown
<!-- Reference style -->

[Link text][reference-id]
[Another link][ref2]

<!-- References di bagian bawah -->

[reference-id]: https://example.com "Optional title"
[ref2]: https://another-site.com

<!-- Shortcut reference -->

[Google][]
[GitHub][]

[Google]: https://google.com
[GitHub]: https://github.com
```

### 🎯 Internal Links & Anchors

```markdown
<!-- Link ke heading -->

[Go to Section 1](#section-1)
[Link ke heading dengan spasi](#heading-dengan-spasi)

<!-- Relative links -->

[Other file](./other-file.md)
[Image link](../images/photo.jpg)
[Parent directory](../README.md)

<!-- Fragment identifiers -->

[Specific section](page.html#section)
[Heading in same doc](#heading-id)
```

### 🌐 Advanced Link Techniques

```markdown
<!-- Links dengan image -->

[![Alt text](image.jpg)](https://example.com)

<!-- Links dengan HTML attributes -->

<a href="https://example.com" target="_blank" rel="noopener">External link</a>

<!-- Links dengan CSS classes (kramdown) -->

[Link text](https://example.com){:.btn .btn-primary}

<!-- Links dalam teks kompleks -->

Visit [Google](https://google.com), [GitHub](https://github.com), or [Stack Overflow](https://stackoverflow.com) for more info.
```

---

## 7. Images & Media

### 🖼️ Basic Images

```markdown
<!-- Inline image -->

![Alt text](image.jpg)
![Alt text](image.jpg "Image title")

<!-- Reference style image -->

![Alt text][image-ref]
[image-ref]: path/to/image.jpg "Title"

<!-- Image dengan link -->

[![Alt text](image.jpg)](https://example.com)
```

### 📐 Image Sizing & Styling

```markdown
<!-- HTML untuk kontrol ukuran -->
<img src="image.jpg" alt="Alt text" width="300" height="200">
<img src="image.jpg" alt="Alt text" style="width: 50%;">

<!-- kramdown attributes -->

![Alt text](image.jpg){:width="300px" height="200px"}
![Alt text](image.jpg){:.center}

<!-- Pandoc -->

![Alt text](image.jpg){ width=50% }
```

### 🎬 Video & Audio (HTML)

```markdown
<!-- Video -->
<video width="320" height="240" controls>
  <source src="movie.mp4" type="video/mp4">
  <source src="movie.ogg" type="video/ogg">
  Your browser does not support the video tag.
</video>

<!-- Audio -->
<audio controls>
  <source src="audio.ogg" type="audio/ogg">
  <source src="audio.mpeg" type="audio/mpeg">
  Your browser does not support the audio element.
</audio>

<!-- YouTube embed -->
<iframe width="560" height="315" 
src="https://www.youtube.com/embed/VIDEO_ID" 
frameborder="0" allowfullscreen></iframe>
```

### 🖇️ Figure & Caption

<!-- HTML5 figure -->
<figure>
  <img src="image.jpg" alt="Description">
  <figcaption>

Image caption goes here

  </figcaption>
</figure>

<!-- Pandoc figure -->

![Caption text](image.jpg)

<!-- kramdown -->

![Alt text](image.jpg)
_Caption text_
{:.caption}

---

## 8. Code & Programming

### 💻 Inline Code

```markdown
Use `console.log()` untuk debugging.
Variabel `userName` harus string.
File `config.json` berisi pengaturan.

<!-- Escape backticks -->

`` Gunakan `backtick` dalam code ``
```

### 📝 Code Blocks

```markdown
<!-- Indented code blocks -->

    function hello() {
        console.log("Hello World!");
    }
```

<!-- Fenced code blocks -->

```

function hello() {
console.log("Hello World!");
}

```

<!-- Dengan syntax highlighting -->

```javascript
function hello() {
  console.log("Hello World!");
}
```

### 🌈 Syntax Highlighting

<!-- Berbagai bahasa pemrograman -->

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

```css
.container {
  display: flex;
  justify-content: center;
  align-items: center;
}
```

```json
{
  "name": "example",
  "version": "1.0.0",
  "dependencies": {
    "markdown": "^2.0.0"
  }
}
```

```bash
#!/bin/bash
echo "Hello World!"
for i in {1..5}; do
    echo "Count: $i"
done
```

```sql
SELECT users.name, orders.total
FROM users
INNER JOIN orders ON users.id = orders.user_id
WHERE orders.total > 100;
```

### 🔧 Advanced Code Features

```javascript {.line-numbers}
// Line numbers (beberapa renderer)
function example() {
  console.log("Line 2");
  console.log("Line 3");
}
```

<!-- Highlight specific lines -->

```python {hl_lines=[2,3]}
def example():
    print("This line is highlighted")  # Line 2
    print("This line too")             # Line 3
    print("This line is normal")       # Line 4
```

<!-- Code dengan filename -->

```javascript title="app.js"
console.log("Hello from app.js");
```

<!-- Collapsible code blocks (beberapa platform) -->
<details>
<summary>Click to expand code</summary>

```python
# Hidden code block
def secret_function():
    return "Secret!"
```

</details>

---

## 9. Tables & Data

### 📋 Basic Tables

| Header 1 | Header 2 | Header 3 |
| -------- | -------- | -------- |
| Row 1    | Data     | More     |
| Row 2    | Info     | Data     |

### 🎨 Table Alignment

| Left Align | Center Align | Right Align |
| :--------- | :----------: | ----------: |
| Left       |    Center    |       Right |
| Text       |     Text     |        Text |

### 📊 Complex Tables

| Feature | Basic | Pro  | Enterprise |
| ------- | :---: | :--: | :--------: |
| Users   |   1   |  10  | Unlimited  |
| Storage |  1GB  | 10GB |    1TB     |
| Support | Email | Chat |   Phone    |
| Price   | Free  |  $9  |    $99     |

<!-- Table dengan formatting dalam cells -->

| Name          | Description                             | Status |
| ------------- | --------------------------------------- | :----: |
| **Bold Name** | `code description`                      |   ✅   |
| _Italic Name_ | [Link description](https://example.com) |   ❌   |
| ~~Strike~~    | Multiple<br>Lines                       |   ⚠️   |

---

### 🔧 Table Extensions

<!-- Colspan (tidak standar, perlu HTML) -->
<table>
  <tr>
    <th>Header 1</th>
    <th colspan="2">Header 2 & 3</th>
  </tr>
  <tr>
    <td>Data 1</td>
    <td>Data 2</td>
    <td>Data 3</td>
  </tr>
</table>

<!-- Table dengan caption -->
<table>
  <caption>Table Caption</caption>
  <tr>
    <th>Header</th>
    <th>Another</th>
  </tr>
  <tr>
    <td>Data</td>
    <td>More Data</td>
  </tr>
</table>

### 📈 Data Visualization dalam Tables

<!-- Progress bars dengan Unicode -->

| Task   | Progress        | Status      |
| ------ | --------------- | ----------- |
| Design | ████████░░ 80%  | In Progress |
| Code   | ██████████ 100% | Complete    |
| Test   | ███░░░░░░░ 30%  | Started     |

<!-- Menggunakan emoji untuk status -->

| Feature | Status | Priority  |
| ------- | :----: | :-------: |
| Login   |   ✅   |  🔴 High  |
| Search  |   ⚠️   | 🟡 Medium |
| Export  |   ❌   |  🔵 Low   |

---

## 10. Blockquotes & Callouts

### 💬 Basic Blockquotes

> Single line quote

> Multi-line quote
> continues here
> and here

> **Bold dalam quote**
>
> _Italic dalam quote_
>
> `Code dalam quote`

### 🔗 Nested Blockquotes

> Level 1 quote
>
> > Level 2 quote
> >
> > > Level 3 quote
> > > Back to level 2
> > > Back to level 1

> Outer quote
>
> > Inner quote dengan formatting
> > **bold** dan _italic_
>
> Back to outer quote

### 📚 Citation & Attribution

> To be or not to be, that is the question.
>
> — William Shakespeare, _Hamlet_

> The best way to predict the future is to invent it.
>
> <cite>Alan Kay</cite>

<!-- HTML untuk citation -->
<blockquote>
  <p>Quote text here</p>
  <footer>
    <cite>Source Name</cite>
  </footer>
</blockquote>

### 🎨 Callout Boxes (platform-specific)

<!-- GitHub Alerts -->

> [!NOTE]
> Useful information that users should know.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

<!-- Obsidian callouts -->

> [!info]
> Information callout

> [!warning] Custom Title
> Warning with custom title

> [!question] Collapsible
> This can be collapsed

<!-- Pandoc/Quarto -->

::: {.callout-note}

## Note Title

Note content goes here
:::

::: {.callout-warning}
Warning content
:::

---

# [BAGIAN III: ADVANCED FEATURES](#bagian-iii-advanced-features)

## 11. HTML Integration

### 🌐 Raw HTML

<!-- HTML elements dalam Markdown -->
<div class="container">
  <p>HTML paragraph</p>
  <span style="color: red;">Colored text</span>
</div>

<!-- HTML attributes -->
<img src="image.jpg" alt="Alt text" class="responsive" id="main-image">

<!-- Custom containers -->
<section id="introduction">
# Markdown heading dalam HTML container
</section>

### 🎨 CSS Styling

<!-- Inline styles -->
<p style="color: blue; font-size: 18px;">Styled paragraph</p>

<!-- CSS classes (jika didukung) -->
<div class="alert alert-info">
  **Information:** This is an info box.
</div>

<!-- Style blocks (beberapa platform) -->
<style>
.custom-box {
  border: 2px solid #007acc;
  padding: 10px;
  border-radius: 5px;
  background-color: #f0f8ff;
}
</style>

<div class="custom-box">
Content dengan custom styling
</div>

### 📱 Responsive Elements

<!-- Responsive images -->

<img src="image.jpg" 
     alt="Responsive image"
     style="max-width: 100%; height: auto;">

<!-- Responsive tables -->
<div style="overflow-x: auto;">
  
| Very | Long | Table | With | Many | Columns | That | Might | Overflow |
|------|------|-------|------|------|---------|------|-------|----------|
| Data | Data | Data  | Data | Data | Data    | Data | Data  | Data     |

</div>

<!-- Responsive videos -->
<div style="position: relative; padding-bottom: 56.25%; height: 0;">
  <iframe src="https://www.youtube.com/embed/VIDEO_ID" 
          style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
          frameborder="0" allowfullscreen></iframe>
</div>

### 🔧 Interactive HTML

<!-- Forms -->
<form>
  <label for="name">Name:</label>
  <input type="text" id="name" name="name"><br><br>
  
  <label for="email">Email:</label>
  <input type="email" id="email" name="email"><br><br>
  
  <input type="submit" value="Submit">
</form>

<!-- Details/Summary (collapsible) -->
<details>
  <summary>Click to expand</summary>
  
  Hidden content here!
  
```python
  print("Code in collapsible section")
```

- List items
- Also work here
</details>

<!-- Progress bars -->

<progress value="70" max="100">70%</progress>

<!-- Buttons -->

<button onclick="alert('Hello!')">Click me</button>

---

## [12. Math & LaTeX](#bagian-iii-advanced-features)

### 🧮 Inline Math

```markdown
<!-- KaTeX/MathJax syntax -->

Persamaan linear: $ax + b = 0$
Pythagoras: $a^2 + b^2 = c^2$
Integral: $\int_{0}^{\infty} e^{-x} dx = 1$
```

### 📐 Display Math

```markdown
<!-- Block math -->

$$
E = mc^2
$$

$$
\frac{d}{dx}\left( \int_{0}^{x} f(u)\,du\right)=f(x)
$$

<!-- Matrix -->

$$
\begin{pmatrix}
a & b \\
c & d
\end{pmatrix}
$$

<!-- Aligned equations -->

$$
\begin{align}
x &= a + b \\
y &= c + d \\
z &= e + f
\end{align}
$$
```

### 🔬 Complex Mathematical Expressions

```markdown
<!-- Summation dan product -->

$$
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
$$

$$
\prod_{i=1}^{n} i = n!
$$

<!-- Limits -->

$$
\lim_{x \to \infty} \frac{1}{x} = 0
$$

<!-- Derivatives -->

$$
\frac{\partial f}{\partial x} = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}
$$

<!-- Complex fractions -->

$$
\frac{1}{\displaystyle 1+\frac{1}{\displaystyle 2+\frac{1}{\displaystyle 3+\cdots}}}
$$
```

### 📊 Chemical Formulas (mhchem)

```markdown
<!-- Chemical equations -->

$$\ce{H2O}$$
$$\ce{CaCO3 + 2HCl -> CaCl2 + H2O + CO2}$$
$$\ce{2H2 + O2 ->[catalyst] 2H2O}$$

<!-- Isotopes -->

$$\ce{^{235}U + ^{1}n -> ^{236}U -> ^{144}Ba + ^{89}Kr + 3^{1}n}$$
```

---

## 13. Diagrams & Visualizations

### 🌊 Mermaid Diagrams

```mermaid
<!-- Flowchart -->

flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Process 1]
    B -->|No| D[Process 2]
    C --> E[End]
    D --> E
```

```mermaid
<!-- Sequence diagram -->

sequenceDiagram
    participant A as Alice
    participant B as Bob
    A->>B: Hello Bob, how are you?
    B-->>A: Great, thanks!
    A->>B: See you later!
```

```mermaid
<!-- Gantt chart -->

gantt
    title Project Timeline
    dateFormat  YYYY-MM-DD
    section Design
    Wireframes    :a1, 2024-01-01, 30d
    Mockups       :after a1, 20d
    section Development
    Frontend      :2024-02-01, 45d
    Backend       :2024-02-01, 60d
```

```mermaid
<!-- Class diagram -->

classDiagram
    class Animal {
        +String name
        +int age
        +makeSound()
    }
    class Dog {
        +String breed
        +bark()
    }
    Animal <|-- Dog
```

### 📈 Chart.js Integration (beberapa platform)

```html
<canvas id="myChart" width="400" height="200"></canvas>
<script>
  const ctx = document.getElementById("myChart").getContext("2d");
  const myChart = new Chart(ctx, {
    type: "bar",
    data: {
      labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
      datasets: [
        {
          label: "# of Votes",
          data: [12, 19, 3, 5, 2, 3],
          backgroundColor: "rgba(54, 162, 235, 0.2)",
          borderColor: "rgba(54, 162, 235, 1)",
          borderWidth: 1,
        },
      ],
    },
  });
</script>
```

### 🎨 ASCII Art & Diagrams

```markdown
<!-- ASCII flowchart -->

    ┌─────────┐
    │  Start  │
    └────┬────┘
         │
    ┌────▼────┐
    │ Process │
    └────┬────┘
         │
    ┌────▼────┐
    │   End   │
    └─────────┘

<!-- ASCII table -->

╔══════════════╦══════════════╗
║       Header ║ Header       ║
╠══════════════╬══════════════╣
║         Data ║ Data         ║
║         Data ║ Data         ║
╚══════════════╩══════════════╝

<!-- Network diagram -->

Internet ── Router ── Switch ─┬─ Computer 1
├─ Computer 2
└─ Printer
```

---

## 14. Interactive Elements

### ☑️ Forms & Input Elements

```html
<!-- Survey form -->
<form>
  <fieldset>
    <legend>Feedback Form</legend>

    <label for="rating">Rating (1-5):</label>
    <input type="range" id="rating" name="rating" min="1" max="5" value="3" />
    <output for="rating">3</output><br /><br />

    <label for="category">Category:</label>
    <select id="category" name="category">
      <option value="bug">Bug Report</option>
      <option value="feature">Feature Request</option>
      <option value="question">Question</option></select
    ><br /><br />

    <label for="urgent">Urgent:</label>
    <input type="checkbox" id="urgent" name="urgent" /><br /><br />

    <label for="comments">Comments:</label><br />
    <textarea id="comments" name="comments" rows="4" cols="50"></textarea
    ><br /><br />

    <input type="submit" value="Submit" />
  </fieldset>
</form>
```

### 🎛️ Interactive Controls

````html
<!-- Audio player -->
<audio controls>
  <source src="podcast.mp3" type="audio/mpeg" />
  Your browser does not support the audio element.
</audio>

<!-- Video player -->
<video width="320" height="240" controls poster="thumbnail.jpg">
  <source src="video.mp4" type="video/mp4" />
  <source src="video.webm" type="video/webm" />
  Your browser does not support the video tag.
</video>

<!-- Interactive map -->
<iframe
  src="https://www.google.com/maps/embed?pb=..."
  width="600"
  height="450"
  style="border:0;"
  allowfullscreen=""
  loading="lazy"
>
</iframe>

<!-- Collapsible sections -->
<details open>
  <summary>Always Expanded Section</summary>
  <p>This section starts expanded.</p>
</details>

<details>
  <summary>🔍 Advanced Options</summary>

  - Option 1 - Option 2 - Option 3 ```javascript // Code in collapsible section
  console.log("Hidden by default");
</details>
````

</details>

### 🎮 JavaScript Interactions

```html
<!-- Interactive counter -->
<div id="counter-demo">
  <p>Count: <span id="count">0</span></p>
  <button onclick="increment()">+</button>
  <button onclick="decrement()">-</button>
  <button onclick="reset()">Reset</button>
</div>

<script>
  let count = 0;
  function increment() {
    count++;
    document.getElementById("count").textContent = count;
  }
  function decrement() {
    count--;
    document.getElementById("count").textContent = count;
  }
  function reset() {
    count = 0;
    document.getElementById("count").textContent = count;
  }
</script>

<!-- Toggle content -->
<button onclick="toggleContent()">Toggle Content</button>
<div id="toggleable" style="display: none;">
  <h3>Hidden Content</h3>
  <p>This content can be toggled on/off.</p>
</div>

<script>
  function toggleContent() {
    const element = document.getElementById("toggleable");
    element.style.display = element.style.display === "none" ? "block" : "none";
  }
</script>
```

---

## 15. Extensions & Plugins

### 🔌 Pandoc Extensions

## Pandoc title block

title: "Document Title"
author:

- John Doe
- Jane Smith
  date: "May 31, 2025"
  abstract: |
  This is the abstract of the document.
  It can span multiple lines.
  keywords: [markdown, pandoc, documentation]

---

<!-- Pandoc citations -->

Menurut penelitian [@smith2023; @jones2024], Markdown sangat efektif.

Seperti yang dijelaskan dalam @brown2023 [p. 42], format ini mudah dipelajari.

<!-- Bibliography -->

## References

```
<!-- Pandoc divs dan spans -->

::: {.warning}
This is a warning box.
:::

[Text dengan class]{.highlight}

<!-- Include files -->

{.include}
other-file.md
```

Pandoc tables

: Sample Table

| Right | Left | Center | Default |
| ----: | :--- | :----: | ------- |
|    12 | 12   |   12   | 12      |
|   123 | 123  |  123   | 123     |
|     1 | 1    |   1    | 1       |

### 🎯 kramdown Extensions

```markdown
<!-- Attribute lists -->

{:.class #id}
This paragraph has CSS class and ID.

![Image](image.jpg){:.center width="50%"}

<!-- Table of contents -->

- TOC
  {:toc}

<!-- Footnotes -->

Teks dengan footnote[^1].

[^1]: Ini adalah footnote.

<!-- Abbreviations -->

_[HTML]: HyperText Markup Language
_[CSS]: Cascading Style Sheets

HTML dan CSS adalah teknologi web fundamental.

<!-- Math blocks -->

$
\begin{aligned}
\nabla \times \vec{\mathbf{B}} -\, \frac1c\, \frac{\partial\vec{\mathbf{E}}}{\partial t} & = \frac{4\pi}{c}\vec{\mathbf{j}} \\
\nabla \cdot \vec{\mathbf{E}} & = 4 \pi \rho \\
\nabla \times \vec{\mathbf{E}}\, +\, \frac1c\, \frac{\partial\vec{\mathbf{B}}}{\partial t} & = \vec{\mathbf{0}} \\
\nabla \cdot \vec{\mathbf{B}} & = 0
\end{aligned}
$
```

### 📝 Python-Markdown Extensions

<!-- Admonitions -->

!!! note "Optional Title"
This is a note admonition.

!!! warning
This is a warning without custom title.

!!! tip "Pro Tip"
This is a collapsible tip.

    ```python
    print("Code in admonition")
    ```

<!-- Definition lists -->

Apple
: A red fruit
: Also a technology company

Orange
: An orange citrus fruit

<!-- Fenced code with custom attributes -->

```python title="example.py" linenums="1"
def hello_world():
    print("Hello, World!")
    return True

<!-- Smart symbols -->

(c) (tm) (r) -- --- ... << >>
<!-- Becomes: © ™ ® – — … « » -->
```

### 🚀 MDX (React Components)

```mdx
<!-- Import React components -->

import { Chart } from "./Chart";
import { Calculator } from "./Calculator";

# Interactive Document

Here's a regular paragraph with **markdown** formatting.

<Chart data={[1, 2, 3, 4, 5]} />

## Calculator Section

<Calculator initialValue={0} operations={["add", "subtract", "multiply"]} />

<!-- Combine JSX with Markdown -->

<div className="alert alert-info">
  This is JSX with **markdown** inside!

- List item 1
- List item 2
  </div>
```

---

# [BAGIAN IV: PLATFORM SPECIFIC](#bagian-iv-platform-specific)

## 16. GitHub Flavored Markdown

### 🐙 GitHub-Specific Features

```markdown
<!-- Mentions -->

@username akan memberikan notifikasi ke user
@organization/team untuk mention team

<!-- Issue/PR references -->

Fixes #123
Closes #456
Related to organization/repo#789

<!-- Commit references -->

See commit 1234567890abcdef
Short SHA1: a5c3785
```

### ✅ GitHub Task Lists dengan Advanced Features

- [x] #739
- [ ] https://github.com/octo-org/octo-repo/issues/740
- [ ] Add delight to the experience when all tasks are complete :tada:

<!-- Nested task lists -->

- [ ] Main task
  - [x] Subtask 1
  - [x] Subtask 2
  - [ ] Subtask 3
    - [x] Sub-subtask A
    - [ ] Sub-subtask B

### 🚨 GitHub Alerts

```markdown
> [!NOTE]
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.

<!-- Custom titles -->

> [!WARNING] Custom Warning Title
> This warning has a custom title.
```

### 📊 GitHub Syntax Highlighting

````markdown
<!-- Supported languages -->

```diff
- Removed line
+ Added line
  Unchanged line
```
````

```yaml
# GitHub Actions workflow
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: npm test
```

```dockerfile
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### 🎯 GitHub Advanced Table Features

<!-- Emoji dalam tables -->

| Feature         | Status | Priority |
| --------------- | :----: | :------: |
| Authentication  |   ✅   |    🔴    |
| API Integration |   ⚠️   |    🟡    |
| Testing         |   ❌   |    🔵    |

<!-- Links dalam tables -->

| Repository                                    | Language   |  Stars   |
| --------------------------------------------- | ---------- | :------: |
| [React](https://github.com/facebook/react)    | JavaScript | ⭐ 200k+ |
| [Vue](https://github.com/vuejs/vue)           | JavaScript | ⭐ 200k+ |
| [Angular](https://github.com/angular/angular) | TypeScript | ⭐ 90k+  |

---

## [17. Discord & Chat Platforms](#bagian-iv-platform-specific)

### 💬 Discord Markdown

<!-- Text formatting -->

_italic_ atau _italic_
**bold** atau **bold**
**_bold italic_** atau **_bold italic_**
~~strikethrough~~
||spoiler text||
`inline code`

<!-- Code blocks -->

```python
print("Hello Discord!")
```

<!-- Underline (Discord specific) -->

**underline text**

<!-- Kombinasi formatting -->

**_~~Bold italic strikethrough~~_**
**Bold dengan `code` di dalam**

### 📱 Slack Markdown

```
<!-- Slack formatting -->
*bold*
_italic_
~strikethrough~
`code`

<!-- Links -->
<https://example.com|Link text>
<@U1234567890> # User mention
<#C1234567890> # Channel mention

<!-- Code blocks -->
function hello() {
return "Hello Slack!";
}
```

```

<!-- Lists (limited support) -->
• Item 1
• Item 2
  ◦ Subitem
```

### 💬 WhatsApp Text Formatting

```markdown
<!-- WhatsApp formatting -->

_bold text_
_italic text_
~strikethrough text~
`monospace text`

<!-- Combinations tidak didukung penuh -->

_Bold_ dan _italic_ terpisah
```

### 📞 Telegram Markdown

````markdown
<!-- Telegram Bot API MarkdownV2 -->

_bold text_
_italic text_
**underline**
~strikethrough~
||spoiler||
`inline code`

```python
# code block
print("Hello Telegram!")
```
````

[inline URL](http://www.example.com/)
[inline mention of a user](tg://user?id=123456789)

---

## [18. Documentation Platforms](#bagian-iv-platform-specific)

### 📚 GitBook

```markdown
<!-- GitBook hints -->

{% hint style="info" %}
This is an info hint box.
{% endhint %}

{% hint style="warning" %}
This is a warning hint box.
{% endhint %}

{% hint style="danger" %}
This is a danger hint box.
{% endhint %}

<!-- Tabs -->

{% tabs %}
{% tab title="JavaScript" %}
```

```javascript
console.log("Hello from JavaScript!");
{% endtab %}
```

```python
{% tab title="Python" %}
print("Hello from Python!")
{% endtab %}
{% endtabs %}
```

<!-- File embeds -->

```json
{% code title="config.json" %}
{
  "name": "My App",
  "version": "1.0.0"
}
{% endcode %}
```

### 📖 Notion

```markdown
<!-- Notion callouts -->

> 💡 This is a light bulb callout
>
> Use it for tips and insights

> ⚠️ This is a warning callout
>
> Use it for important warnings

> 📝 This is a note callout
>
> Use it for additional information
```

Notion toggles

> **Click to expand**
>
> Hidden content goes here
>
> - List item 1
> - List item 2

Notion databases

| Task                |   Status    | Priority |  Due Date  |
| ------------------- | :---------: | :------: | :--------: |
| Design mockups      | In Progress |   High   | 2025-06-01 |
| Write documentation | Not Started |  Medium  | 2025-06-05 |
| Code review         |  Completed  |   High   | 2025-05-30 |

### 🌐 Confluence

```markdown
<!-- Confluence macros -->

<ac:structured-macro ac:name="info">
<ac:rich-text-body>

<p>This is an info macro.</p>
</ac:rich-text-body>
</ac:structured-macro>

<ac:structured-macro ac:name="code" ac:schema-version="1">
<ac:parameter ac:name="language">javascript</ac:parameter>
<ac:plain-text-body>

<![CDATA[
    function hello() {
        console.log("Hello Confluence!");
    }
    ]]>

</ac:plain-text-body>
</ac:structured-macro>

<!-- Table of contents -->

<ac:structured-macro ac:name="toc">
<ac:parameter ac:name="maxLevel">3</ac:parameter>
</ac:structured-macro>
```

### 📋 Obsidian

```markdown
<!-- Obsidian links -->

[[Internal Link]]
[[Internal Link|Display Text]]
[[Folder/Note Name]]

<!-- Obsidian tags -->

#tag #nested/tag #multi-word-tag

<!-- Obsidian callouts -->

> [!note]
> This is a note callout.

> [!abstract] Custom Title
> This is an abstract with custom title.

> [!info]- Foldable
> This callout can be folded.

<!-- Obsidian embeds -->

![[Another Note]]
![[Another Note#Specific Heading]]
![[image.png|300]]

<!-- Obsidian queries -->
```

```query
tag:#important
```

<!-- Obsidian canvas links -->

[[2025-05-31]] # Daily note link

---

## 19. Static Site Generators {#static-site-generators}

### ⚡ Next.js/MDX

---

title: "Blog Post Title"
date: "2025-05-31"
tags: ["web", "development"]

---

import { CustomComponent } from "../components/CustomComponent";
import Image from "next/image";

;

# Welcome to My Blog

This is regular **markdown** content.

```html
<CustomComponent data="Some data" isActive="{true}" />

<image
  src="/images/hero.jpg"
  alt="Hero image"
  width="{800}"
  height="{400}"
  priority
/>
```

## Interactive Section

```jsx
{
  /_ JSX comments work here _/;
}

<div className="bg-blue-100 p-4 rounded">
  This is JSX with **markdown** inside! - List item 1 - List item 2
</div>;
```

export default ({ children }) => (

  <div className="prose">{children}</div>
)
```

### 🎨 Gatsby

```
---
title: "Gatsby Blog Post"
date: "2025-05-31"
description: "This is a sample blog post"
tags: ["gatsby", "react", "graphql"]
---
```

# Gatsby Markdown Features

Gatsby supports standard markdown plus GraphQL queries.

```
<!-- Gatsby images -->

![Alt text](./images/local-image.jpg)

<!-- Gatsby links -->

[Internal link](/other-page/)
```

## Code Highlighting

```javascript{1,3-5}
function highlightedFunction() {
  console.log("Line 1 highlighted"); // highlighted
  console.log("Line 2 normal");
  console.log("Line 3 highlighted"); // highlighted
  console.log("Line 4 highlighted"); // highlighted
  console.log("Line 5 highlighted"); // highlighted
}
```

### 🔥 Nuxt Content

---

```title: "Nuxt Content Example"
description: "Example of Nuxt Content features"
tags: [nuxt, vue, markdown]
```

---

# Nuxt Content Features

Regular markdown content with Vue components.

```
::alert{type="info"}
This is an info alert component.
::

::code-group
```

```bash [npm]
npm install @nuxt/content
```

```bash [yarn]
yarn add @nuxt/content
```

```bash [pnpm]
pnpm add @nuxt/content
```

<!-- Vue components in markdown -->
<MyCustomComponent :data="frontmatter" />

<!-- Built-in components -->

```
::
::list{type="success"}

- Item 1
- Item 2
- Item 3
  ::
```

### 🦆 Docusaurus

---

id: docusaurus-example
title: Docusaurus Features
sidebar_label: Features

---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Docusaurus Markdown

## Admonitions

::: note
This is a note admonition.
:::

::: tip Pro tip
This is a tip with a custom title.
:::

:::warning
This is a warning admonition.
:::

:::danger Take care
This is a dangerous admonition.
:::

## Tabs

<Tabs>
  <TabItem value="js" label="JavaScript">

    console.log("Hello from JavaScript!");

  </TabItem>
  <TabItem value="py" label="Python">

    print("Hello from Python!")

  </TabItem>
  <TabItem value="java" label="Java">

    print("Oke");

  </TabItem>
</Tabs>

## Code blocks with title

```jsx title="/src/components/HelloWorld.js"
function HelloWorld() {
  return <h1>Hello, World!</h1>;
}
```

---

## 20. Academic & Scientific {#academic--scientific}

### 🎓 Academic Citations

<!-- Pandoc citations -->

Menurut penelitian [@smith2023], Markdown efektif untuk dokumentasi.

Beberapa studi [@jones2022; @brown2023; @wilson2024] mendukung hal ini.

@taylor2023 [p. 15] menyatakan bahwa format ini mudah dipelajari.

Seperti dijelaskan dalam [-@garcia2023], implementasi bervariasi.

<!-- Citation dengan prefix/suffix -->

[Lihat @johnson2023, pp. 10-15; juga @davis2023, ch. 3]

<!-- Suppress author -->

[@lee2023] vs [-@lee2023]

## References

<!-- Bibliography akan di-generate otomatis -->

### 📊 Data Visualization untuk Akademik

<!-- Penelitian data dalam tabel -->

| Variabel | Mean | SD   | Min | Max | n   |
| -------- | ---- | ---- | --- | --- | --- |
| Age      | 25.4 | 4.2  | 18  | 35  | 150 |
| Score    | 78.6 | 12.3 | 45  | 98  | 150 |
| Hours    | 6.8  | 2.1  | 2   | 12  | 150 |

**Table 1.** Descriptive statistics for study variables.

<!-- Hasil statistik -->

> **Results:** The correlation between study hours and test scores was
> statistically significant (_r_ = .65, _p_ < .001, 95% CI [.58, .71]).

<!-- Mathematical models -->

$
\text{Score} = \beta_0 + \beta_1 \times \text{Hours} + \beta_2 \times \text{Age} + \epsilon
$

Where:

- $\beta_0$ = intercept
- $\beta_1$ = coefficient for study hours
- $\beta_2$ = coefficient for age
- $\epsilon$ = error term

### 🔬 Scientific Notation & Formulas

<!-- Chemistry -->

$\ce{2H2 + O2 -> 2H2O}$
$\ce{CaCO3 + 2HCl -> CaCl2 + H2O + CO2}$

<!-- Physics -->

$F = ma$
$E = mc^2$
$\nabla \cdot \mathbf{E} = \frac{\rho}{\epsilon_0}$

<!-- Biology -->

Sequence: `ATCGATCGATCG`

**Figure 1.** DNA sequence analysis showing...

<!-- Statistics -->

$\chi^2 = \sum \frac{(O_i - E_i)^2}{E_i}$

_p_ < .05, _p_ < .01, _p_ < .001

<!-- Units -->

Temperature: 25°C ± 2°C
Mass: 1.25 × 10³ kg
Concentration: 5.0 mol·L⁻¹

### 📝 Research Paper Structure

---

title: "Impact of Markdown on Academic Writing Efficiency"
author:

- name: "Dr. Jane Smith"
  affiliation: "University of Technology"
  email: "jane.smith@university.edu"
- name: "Prof. John Doe"
  affiliation: "Research Institute"
  email: "john.doe@institute.org"
  date: "May 31, 2025"
  abstract: |
  This study investigates the impact of Markdown formatting on
  academic writing efficiency. Using a randomized controlled trial
  with 200 participants, we found that Markdown users completed
  writing tasks 23% faster than traditional word processor users
  (_p_ < .001).
  keywords: [markdown, academic writing, efficiency, productivity]
  bibliography: references.bib

---

# Introduction

Academic writing has traditionally relied on complex word processing
software [@microsoft2023]. However, recent developments in plain-text
formatting suggest alternative approaches may be more efficient
[@gruber2004; @macfarlane2023].

## Research Questions

1. Does Markdown improve writing speed?
2. Does it affect document quality?
3. What are user preferences?

# Methods

## Participants

We recruited 200 graduate students (_M_~age~ = 26.4, _SD_ = 3.2)
from three universities.

## Procedure

Participants were randomly assigned to either:

- Markdown condition (_n_ = 100)
- Word processor condition (_n_ = 100)

# Results

## Writing Speed

```r
# Statistical analysis
t.test(speed ~ condition, data = results)


```

Table 2 shows that Markdown users completed tasks significantly
faster (_t_(198) = 4.32, _p_ < .001, Cohen's _d_ = 0.61).

| Condition      | Mean Time (min) | SD  | 95% CI       |
| -------------- | --------------- | --- | ------------ |
| Markdown       | 18.4            | 4.2 | [17.6, 19.2] |
| Word Processor | 23.8            | 5.1 | [22.8, 24.8] |

**Table 2.** Task completion times by condition.

# Discussion

The results support our hypothesis that Markdown formatting
improves writing efficiency. This finding is consistent with
previous research on distraction-free writing environments
[@thompson2022].

## Limitations

- Limited to academic writing tasks
- Short-term study design
- Self-selected participant pool

# Conclusion

Markdown shows promise as an efficient academic writing tool,
particularly for researchers comfortable with plain-text editing.

# References

<!-- Auto-generated bibliography -->

---

# BAGIAN V: EXPERT LEVEL

## 21. Custom Rendering {#custom-rendering}

### 🎨 Custom CSS Classes

<!-- kramdown attribute syntax -->

```css
 {
  :.custom-class ;
}
This paragraph has a custom CSS class. {
  :.highlight.large-text #special-id ;
  .large-text;
}
#special-id
This has multiple classes and an ID.

<!-- Pandoc fenced divs -->

:::;
this is a warning box with custom styling.
:::

::: {
  #special-section .container;
}
```

# Section with Custom Container

Content inside custom div.

```div
:::

<!-- Span-level attributes -->

[Important text]{.highlight}
[Button text]{.btn .btn-primary}
```

### 🔧 Preprocessor Macros

<!-- Hugo shortcodes -->

```hugo
{{< figure src="image.jpg" title="Figure caption" >}}
{{< youtube id="dQw4w9WgXcQ" >}}
{{< tweet 1234567890 >}}

<!-- Jekyll liquid tags -->

{% highlight ruby %}
def hello
puts "Hello World!"
end
{% endhighlight %}

{% include image.html url="image.jpg" description="Image caption" %}

<!-- Custom shortcodes -->

{{< alert type="warning" >}}
This is a custom alert shortcode.
{{< /alert >}}

{{< tabs >}}
{{< tab name="JavaScript" >}}
```

```js
console.log("Hello!");
{{< /tab >}}
{{< tab name="Python" >}}
```

```python
print("Hello!")
{{< /tab >}}
{{< /tabs >}}
```

### 📱 Responsive Design Integration

<!-- Responsive images dengan HTML -->
<picture>
  <source media="(max-width: 768px)" srcset="image-mobile.jpg">
  <source media="(max-width: 1024px)" srcset="image-tablet.jpg">
  <img src="image-desktop.jpg" alt="Responsive image">
</picture>

<!-- CSS Grid layouts -->
<div class="grid-container">
  <div class="grid-item">

## Column 1 Content

Regular **markdown** content here.

  </div>
  <div class="grid-item">

## Column 2 Content

More markdown content.

  </div>
</div>

<style>
.grid-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
}

@media (max-width: 768px) {
  .grid-container {
    grid-template-columns: 1fr;
  }
}
</style>

### 🎯 Advanced Custom Elements

## Install This App Add this documentation to your home screen for offline

access.

<!-- Web Components -->
<!-- Progressive Web App features -->
<custom-card title="Card Title" type="info">
  **Markdown content** inside custom element. - List item 1 - List item 2
</custom-card>
<install-prompt>
</install-prompt>
<accessible-table>

| Header 1 | Header 2 | Header 3 | |----------|----------|----------| | Data 1
| Data 2 | Data 3 |

</accessible-table>

<!-- Accessibility enhancements -->

---

## 22. Performance & Optimization

### ⚡ Image Optimization

```markdown
<!-- WebP dengan fallback -->
<picture>
  <source srcset="image.webp" type="image/webp">
  <source srcset="image.jpg" type="image/jpeg">
  <img src="image.jpg" alt="Optimized image" loading="lazy">
</picture>

<!-- Responsive images -->

<img src="image-small.jpg"
     srcset="image-small.jpg 400w,
             image-medium.jpg 800w,
             image-large.jpg 1200w"
     sizes="(max-width: 400px) 400px,
            (max-width: 800px) 800px,
            1200px"
     alt="Responsive optimized image"
     loading="lazy">

<!-- Image dimensions untuk CLS -->

![Alt text](image.jpg){width="800" height="600"}
```

### 🔄 Code Splitting & Lazy Loading

<!-- Lazy loaded components -->

```html
<lazy-component>
  // Heavy code block yang di-lazy load function complexCalculation() { //
  Expensive operations here return result; }
</lazy-component>
```

<!-- Deferred content -->
<details>
  <summary>Load Heavy Content</summary>

  <!-- Heavy content hanya dimuat saat dibuka -->

```python
import pandas as pd
import numpy as np

# Large dataset processing
df = pd.read_csv('large_dataset.csv')
```

</details>

### 📊 Bundle Size Optimization

```markdown
<!-- Critical CSS inline -->
<style>
/* Hanya CSS yang diperlukan untuk above-the-fold */
.hero { font-size: 2rem; }
.nav { display: flex; }
</style>

<!-- Non-critical CSS deferred -->
<link rel="preload" href="non-critical.css" as="style" onload="this.onload=null;this.rel='stylesheet'">

<!-- Preload important resources -->
<link rel="preload" href="important-image.jpg" as="image">
<link rel="preload" href="main-font.woff2" as="font" type="font/woff2" crossorigin>
```

### 🎯 SEO Optimization

---

```
title: "Optimized Page Title | Site Name"
description: "Compelling meta description under 160 characters that includes target keywords."
keywords: ["keyword1", "keyword2", "keyword3"]
canonical: "https://example.com/canonical-url"
og:
title: "Social Media Title"
description: "Social media description"
image: "https://example.com/og-image.jpg"
type: "article"
twitter:
card: "summary_large_image"
creator: "@username"
schema:
type: "Article"
author: "Author Name"
datePublished: "2025-05-31"
```

---

# SEO-Optimized Content Structure

Use proper heading hierarchy for better SEO.

## Main Section Keyword

Content dengan **target keywords** yang natural.

### Subsection dengan Related Terms

- Gunakan semantic keywords
- Include related terms
- Maintain natural flow

![SEO optimized alt text](image.jpg "Descriptive title text")

[Internal link](./related-page.html) ke halaman terkait.

## Schema Markup Integration

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Article Headline",
  "author": {
    "@type": "Person",
    "name": "Author Name"
  },
  "datePublished": "2025-05-31"
}
</script>

---

## 23. Security Considerations

### 🔒 Content Security Policy

```markdown
<!-- CSP headers untuk Markdown dengan HTML -->
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self';
               script-src 'self' 'unsafe-inline';
               style-src 'self' 'unsafe-inline';
               img-src 'self' data: https:;">

<!-- Sanitize user input -->
<!-- JANGAN: Raw HTML dari user -->
<div>{{userInput}}</div>

<!-- GUNAKAN: Escaped content -->
<div>{{escapeHtml(userInput)}}</div>
```

### 🛡️ XSS Prevention

```markdown
<!-- Hindari JavaScript dalam Markdown -->
<!-- BERBAHAYA: -->
<img src="x" onerror="alert('XSS')">
<a href="javascript:alert('XSS')">Click me</a>

<!-- AMAN: -->
<img src="legitimate-image.jpg" alt="Safe image">
<a href="
```

```

<!-- <h3 id="dua"></h3> -->
```
