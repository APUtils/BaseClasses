#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""
echo ""
echo "Building Pods project..."
set -o pipefail && xcodebuild -workspace "Example/BaseClasses.xcworkspace" -scheme "BaseClasses-Example" -configuration "Release"  -sdk iphonesimulator | xcpretty

echo -e "\nBuilding Carthage project..."
set -o pipefail && xcodebuild -project "Carthage Project/BaseClasses.xcodeproj" -sdk iphonesimulator -target "Example" | xcpretty

echo -e "\nBuilding with Carthage..."
carthage build --no-skip-current

echo -e "\nPerforming tests..."
simulator_id="$(xcrun simctl list devices available | grep "iPhone SE" | tail -1 | sed -e "s/.*iPhone SE (//g" -e "s/).*//g")"
if [ -z "${simulator_id}" ]; then
    echo "error: Please install 'iPhone SE' simulator."
    echo " "
    exit 1
else
    echo "Using iPhone SE simulator with ID: '${simulator_id}'"
fi

set -o pipefail && xcodebuild -project "Carthage Project/BaseClasses.xcodeproj" -sdk iphonesimulator -scheme "Example" -destination "platform=iOS Simulator,id=${simulator_id}" test | xcpretty

echo ""
echo "SUCCESS!"
echo ""
echo ""
