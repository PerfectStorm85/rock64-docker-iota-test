#!/bin/bash
read -p 'Changelist name: ' answer
git init
git add .
git commit -m "$answer"
git remote add originTest https://github.com/PerfectStorm85/rock64-docker-iota-test.git
git remote -v
git push -u originTest master
