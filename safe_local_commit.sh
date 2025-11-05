#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/webapp-fire"

echo "=== starting safe_local_commit ==="
date

# required artifacts
required=( "sqli_response.txt" "screenshot_sqli_burp.png" "screenshot_xss_alert.png" )
for f in "${required[@]}"; do
  if [ ! -f "$f" ]; then
    echo "ERROR: required artifact missing: $f"
    exit 2
  fi
done
echo "All required artifacts present."

# create small README/report/gitignore if missing
if [ ! -f README.md ]; then
  cat > README.md <<'R'
# webapp-fire (Vulnerable Flask app)
Mini vulnerable Flask app for training and PoC capture.
R
  echo "Created README.md"
fi

if [ ! -f report.md ]; then
  cat > report.md <<'RPT'
# Report placeholder
Replace with full report when ready.
RPT
  echo "Created report.md"
fi

if [ ! -f .gitignore ]; then
  cat > .gitignore <<'G'
venv/
db.sqlite
cookies.txt
__pycache__/
*.pyc
G
  echo "Created .gitignore"
fi

# init git repo if needed (safe)
if [ ! -d .git ]; then
  git init -b main
  echo "Initialized git repo on branch main"
else
  echo "Git repo already exists"
fi

# prepare safe add list (only files that exist)
safe_add=( "README.md" "report.md" ".gitignore" "app.py" "templates" \
           "sqli_response.txt" "sqli_response_page_snapshot.html" "sqli_repeater_response.xml" \
           "screenshot_sqli_burp.png" "screenshot_admin_before.png" \
           "xss_response.txt" "xss_response_post.txt" "xss_headers.txt" "screenshot_xss_alert.png" )

to_add=()
for f in "${safe_add[@]}"; do
  if [ -e "$f" ]; then to_add+=("$f"); fi
done

if [ "${#to_add[@]}" -eq 0 ]; then
  echo "No safe files found to add; aborting."
  exit 3
fi

echo "Adding files to index:"
for f in "${to_add[@]}"; do echo "  $f"; done

git add "${to_add[@]}"

# commit locally (exact message)
git commit -m "Add PoC artifacts: SQLi authentication bypass and stored XSS evidence" || echo "Nothing to commit (or commit failed)."

echo "Local commit complete. NOT pushing to any remote (to avoid interactive prompts)."
date
echo "=== finished safe_local_commit ==="
