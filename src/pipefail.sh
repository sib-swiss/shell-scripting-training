#!/usr/bin/env bash

set -o pipefail

ls | grep ghk | wc -l

echo "status: $?"
