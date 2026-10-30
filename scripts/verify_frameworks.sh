#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
FAILURES=0

fail() {
  echo "❌ $*"
  FAILURES=$((FAILURES + 1))
}

manifest_paths() {
  grep -oE 'path: *"Frameworks/[^"]+\.xcframework\.zip"' "$ROOT/Package.swift" | sed -E 's/path: *"([^"]+)"/\1/' | sort
}

verify_manifest_matches_zips() {
  local on_disk
  on_disk="$(cd "$ROOT" && find Frameworks -name '*.xcframework.zip' | sort)"
  if [ "$(manifest_paths)" != "$on_disk" ]; then
    fail "Package.swift binary targets and zips under Frameworks/ differ"
    diff <(manifest_paths) <(echo "$on_disk") || true
  fi
}

verify_zip() {
  local zip="$1" versions="$2" checksums="$3"
  local expected_version
  local name top expected_checksum actual_checksum
  name="$(basename "$zip" .xcframework.zip)"
  expected_version="$(awk -v n="$name" '$1 == n { print $2 }' "$versions")"
  [ -n "$expected_version" ] || { fail "$name: no entry in $(basename "$versions")"; return; }

  top="$(unzip -Z1 "$zip" | cut -d/ -f1 | grep -v '^__MACOSX$' | sort -u)"
  if [ "$top" != "$name.xcframework" ]; then
    fail "$name: archive must contain exactly $name.xcframework at its root, found: $(echo $top)"
    return
  fi

  expected_checksum="$(awk -v z="$(basename "$zip")" '$1 == z { print $2 }' "$checksums")"
  actual_checksum="$(swift package compute-checksum "$zip")"
  if [ "$expected_checksum" != "$actual_checksum" ]; then
    fail "$name: checksum $actual_checksum does not match CHECKSUMS.txt (${expected_checksum:-missing})"
  fi

  local dest="$WORK/ours/$name"
  mkdir -p "$dest"
  ditto -x -k "$zip" "$dest"
  local plists
  plists="$(find "$dest/$name.xcframework" -path "*/$name.framework/*" -name Info.plist -not -path '*.lproj/*' -not -path '*.bundle/*')"
  if [ -z "$plists" ]; then
    fail "$name: no framework Info.plist found"
    return
  fi
  while IFS= read -r plist; do
    local version
    version="$(plutil -extract CFBundleShortVersionString raw "$plist" 2>/dev/null || echo missing)"
    if [ "$version" != "$expected_version" ]; then
      fail "$name: ${plist#$dest/} is version $version, expected $expected_version"
    fi
  done <<< "$plists"
}

verify_against_upstream() {
  local vendor_dir="$1" checksums="$2"
  local url sha actual
  url="$(awk -F': ' '/^Upstream:/ { print $2 }' "$checksums")"
  sha="$(awk -F': ' '/^Upstream SHA-256:/ { print $2 }' "$checksums")"
  [ -n "$url" ] && [ -n "$sha" ] || { fail "$vendor_dir: CHECKSUMS.txt is missing Upstream or Upstream SHA-256"; return; }

  local upstream_zip="$WORK/upstream-$(basename "$vendor_dir").zip"
  curl -fsSL --retry 3 -o "$upstream_zip" "$url"
  actual="$(shasum -a 256 "$upstream_zip" | cut -d' ' -f1)"
  if [ "$actual" != "$sha" ]; then
    fail "$vendor_dir: upstream archive SHA-256 is $actual, expected $sha"
    return
  fi

  local upstream_dir="$WORK/upstream/$(basename "$vendor_dir")"
  mkdir -p "$upstream_dir"
  ditto -x -k "$upstream_zip" "$upstream_dir"
  for zip in "$vendor_dir"/*.xcframework.zip; do
    local name src
    name="$(basename "$zip" .xcframework.zip)"
    src="$(find "$upstream_dir" -maxdepth 2 -type d -name "$name.xcframework" | head -1)"
    if [ -z "$src" ]; then
      fail "$name: not present in upstream archive $url"
    elif ! diff -rq "$src" "$WORK/ours/$name/$name.xcframework" > /dev/null; then
      fail "$name: contents differ from upstream archive $url"
    fi
  done
}

verify_manifest_matches_zips
for vendor_dir in "$ROOT"/Frameworks/*/; do
  vendor_dir="${vendor_dir%/}"
  vendor="$(basename "$vendor_dir")"
  checksums="$vendor_dir/CHECKSUMS.txt"
  versions="$vendor_dir/VERSIONS"
  [ -f "$versions" ] || { fail "$vendor: missing VERSIONS file"; continue; }
  [ -f "$checksums" ] || { fail "$vendor: missing CHECKSUMS.txt"; continue; }
  echo "Verifying $vendor"
  for zip in "$vendor_dir"/*.xcframework.zip; do
    verify_zip "$zip" "$versions" "$checksums"
  done
  if [ "${SKIP_UPSTREAM:-false}" != "true" ]; then
    verify_against_upstream "$vendor_dir" "$checksums"
  fi
done

if [ "$FAILURES" -gt 0 ]; then
  echo "$FAILURES framework check(s) failed"
  exit 1
fi
echo "✅ All frameworks match their declared versions and checksums"
