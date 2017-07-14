#!/bin/bash
git log --graph --pretty=format:'%Cred%h%Creset %Cblue%an %C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
