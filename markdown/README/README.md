<pre>
  <code id="to-copy">
  
  
  teksnya disini
  
  
  
  </code>
  <button onclick="navigator.clipboard.writeText(document.getElementById('to-copy').innerText)">Salin</button>
</pre>

<!-- ---------------------------------------- -->

<pre>
  <code id="copy-me">teksnya disini</code>
  <button onclick="copyText()">Salin</button>
</pre>

<script>
  function copyText() {
    const text = document.getElementById("copy-me").innerText;
  navigator.clipboard.writeText(text);
  alert("Disalin!");
}
</script>

<!-- ---------------------------------------- -->

<pre><code>teksnya disini</code></pre>
