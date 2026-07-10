#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCHEME="${SCHEME:-Needlyo}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 17}"
RESULT_BUNDLE="${RESULT_BUNDLE:-$PROJECT_DIR/Build/TestResults/$SCHEME.xcresult}"

rm -rf "$RESULT_BUNDLE"
mkdir -p "$(dirname "$RESULT_BUNDLE")"

xcodebuild \
  test \
  -scheme "$SCHEME" \
  -project "$PROJECT_DIR/Needlyo.xcodeproj" \
  -destination "$DESTINATION" \
  -enableCodeCoverage YES \
  -resultBundlePath "$RESULT_BUNDLE"

printf '\n=== Target Coverage Summary ===\n'
xcrun xccov view --report --only-targets "$RESULT_BUNDLE"

printf '\n=== Test Coverage Report ===\n'
xcrun xccov view --report "$RESULT_BUNDLE"
