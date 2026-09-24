#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
plugin_name=$(basename "$project_dir")
output_dir="$project_dir/outputs"
stage_dir=$(mktemp -d "${TMPDIR:-/tmp}/${plugin_name}.XXXXXX")

cleanup() {
  rm -rf "$stage_dir"
}
trap cleanup EXIT INT TERM

mkdir -p "$output_dir"

# Package only files used by the extension. This keeps repository metadata,
# development dependencies, and build files out of the store submission.
for path in manifest.json popup.html css js font image _locales LICENSE privacy-policy.md; do
  cp -R "$project_dir/$path" "$stage_dir/"
done

find "$stage_dir" -type f \
  \( -name .gitignore -o -name .gitkeep -o -name .DS_Store \) \
  -delete

for browser in chrome firefox; do
  archive="$output_dir/${plugin_name}-${browser}.zip"
  rm -f "$archive"
  (cd "$stage_dir" && zip -qr "$archive" .)
  printf 'Created %s\n' "$archive"
done
