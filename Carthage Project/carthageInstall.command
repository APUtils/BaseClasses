#!/bin/bash

base_dir=$(dirname "$0")
cd "$base_dir"

carthage bootstrap --platform iOS --cache-builds
