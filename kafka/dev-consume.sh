#!/bin/zsh

if [ -z "$1" ]; then
    echo "Provide topic"
    exit 1
else
    kafkactl consume $1 --from-beginning --print-keys -o yaml
fi
