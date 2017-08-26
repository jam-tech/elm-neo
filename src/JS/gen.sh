#!/usr/bin/env bash

./node_modules/browserify/bin/cmd.js main.js -s all_crypto -o ../Native/Neo.js
cat native.js >> ../Native/Neo.js