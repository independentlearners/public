<a href="../../../../../../../../kamus/README.md" onmouseover="showTooltip(event, 'File kamus utf-8')" onmouseout="hideTooltip()">Lihat kamus</a>
<div id="tooltip" style="display:none; position:absolute; background:#333; color:#fff; padding:5px 8px; border-radius:5px; font-size:13px;"></div>

<script>
function showTooltip(event, text) {
  const tooltip = document.getElementById('tooltip');
  tooltip.innerText = text;
  tooltip.style.left = (event.pageX + 10) + 'px';
  tooltip.style.top = (event.pageY + 10) + 'px';
  tooltip.style.display = 'block';
}

function hideTooltip() {
  document.getElementById('tooltip').style.display = 'none';
}
</script>


<!-- <pre>
  <code id="to-copy">


  teksnya disini



  </code>
  <button onclick="navigator.clipboard.writeText(document.getElementById('to-copy').innerText)">Salin</button>
</pre>

<!-- ---------------------------------------- -->
<!--
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

<!-- <pre><code>teksnya disini</code></pre> -->

<!-- <h3 id="satu"></h3> -->
