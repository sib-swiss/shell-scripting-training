#!/bin/bash

no_local() {
    answer=42
    echo "no_local: answer=$answer"
}

shadow() {
    local answer=21
    echo "shadow: answer=$answer"
}

answer=84

echo "Begin: answer=$answer"
no_local
echo "After no_local(): answer=$answer"
shadow
echo "After shadow(): answer=$answer"
