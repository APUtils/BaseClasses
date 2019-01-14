#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""

set -o pipefail && xcodebuild -workspace "Example/BaseClasses.xcworkspace" -scheme "StretchScrollView-Example" -configuration "Release"  -sdk iphonesimulator12.1 | xcpretty

echo ""
echo "SUCCESS!"
echo ""
