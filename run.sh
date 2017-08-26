#!/usr/bin/env bash

cd tests
elm-package install -y
cd ..
elm-test