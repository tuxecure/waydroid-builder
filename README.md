# README

A GitHub Action for building packages

## Usage

Customize following example workflow and save as `.github/workflows/zip-it.yml` on your source repository.


```yaml
name: waydroid builder

on: [push]

jobs:
  wbuilder:
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v3
    - uses: tuxecure/waydroid-builder@ubuntu-18.04
```
