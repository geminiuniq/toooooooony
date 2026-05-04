#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

latest_html="$(ls -t *.html 2>/dev/null | head -n 1 || true)"
if [[ -z "$latest_html" ]]; then
  echo "No html file found in $ROOT_DIR" >&2
  exit 1
fi

echo "Latest html: $latest_html"

# Keep index.html aligned to latest html.
if [[ "$latest_html" != "index.html" ]]; then
  cp "$latest_html" index.html
  echo "Copied $latest_html -> index.html"
fi

# Add auth gate if missing.
if ! rg -q "tony" index.html || ! rg -q "tototony" index.html; then
  inject_file="$(mktemp)"
  cat > "$inject_file" <<'EOF'
<!-- obita-auth-snippet:start -->
<style>
  #obita-auth-overlay {
    position: fixed;
    inset: 0;
    z-index: 99999;
    background: rgba(15, 23, 42, 0.92);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
  }
  #obita-auth-card {
    width: 100%;
    max-width: 360px;
    background: #ffffff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.25);
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  }
  #obita-auth-card h2 { margin: 0 0 12px 0; font-size: 18px; }
  #obita-auth-card label { display: block; margin: 10px 0 6px; font-size: 13px; color: #334155; }
  #obita-auth-card input {
    width: 100%;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    padding: 10px 12px;
    font-size: 14px;
  }
  #obita-auth-card button {
    margin-top: 14px;
    width: 100%;
    border: 0;
    border-radius: 8px;
    padding: 10px 12px;
    font-size: 14px;
    color: #fff;
    background: #0f766e;
    cursor: pointer;
  }
  #obita-auth-error { color: #b91c1c; min-height: 20px; margin-top: 8px; font-size: 13px; }
</style>
<div id="obita-auth-overlay">
  <form id="obita-auth-card" autocomplete="off">
    <h2>访问验证</h2>
    <label for="obita-auth-user">用户名</label>
    <input id="obita-auth-user" name="username" required>
    <label for="obita-auth-pass">密码</label>
    <input id="obita-auth-pass" name="password" type="password" required>
    <button type="submit">登录</button>
    <div id="obita-auth-error"></div>
  </form>
</div>
<script>
  (function () {
    var form = document.getElementById('obita-auth-card');
    var user = document.getElementById('obita-auth-user');
    var pass = document.getElementById('obita-auth-pass');
    var error = document.getElementById('obita-auth-error');
    var overlay = document.getElementById('obita-auth-overlay');
    if (!form || !user || !pass || !error || !overlay) return;
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      if (user.value.trim() === 'tony' && pass.value === 'tototony') {
        overlay.parentNode.removeChild(overlay);
        return;
      }
      error.textContent = '用户名或密码错误';
      pass.value = '';
      pass.focus();
    });
    user.focus();
  })();
</script>
<!-- obita-auth-snippet:end -->
EOF

  awk -v inject_file="$inject_file" '
    /<\/body>/ && !done {
      while ((getline line < inject_file) > 0) print line
      close(inject_file)
      done=1
    }
    { print }
  ' index.html > index.html.tmp

  mv index.html.tmp index.html
  rm -f "$inject_file"
  echo "Auth gate injected into index.html"
fi

echo "Auth gate verified in index.html"
echo "Done"
