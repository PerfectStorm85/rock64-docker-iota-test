#!/bin/bash
read -p 'Changelist name: ' answer
git init
git add .
git commit -m "$answer"
git remote add origin https://gitlab.com/PerfectStorm/rock64-docker-iota-fullnode.git
git remote -v
git push -u origin master
