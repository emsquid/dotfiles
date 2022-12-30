#!/bin/bash

cd "$HOME" || return
"${@}" &> /dev/null & disown
