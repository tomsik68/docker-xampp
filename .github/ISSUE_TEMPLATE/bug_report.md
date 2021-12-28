---
name: Bug report
about: X doesn't work as expected
title: ''
labels: bug
assignees: tomsik68

---

# Bug Report

I'm running Docker on: **Linux**

## XAMPP start command

I used the following command to start the xampp container:

```bash
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www tomsik68/xampp:8
```

## Additional steps to trigger the bug

After starting the container, I did the following:

1. Restart MySQL
2. Browse to http://localhost:41062/xampp

## Expected behavior

Web browser shows XAMPP control panel.

## Actual behavior

Web browser gives the following error:

```
404 Not Found
```
