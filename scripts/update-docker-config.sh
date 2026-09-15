#!/usr/bin/env bash
set -euo pipefail

docker_dir="${1:?usage: update-docker-config <docker-config-directory>}"
mkdir -p "$docker_dir"
config_file="$docker_dir/config.json"
temp_file="$(mktemp "$docker_dir/.config.json.XXXXXX")"
trap 'rm -f "$temp_file"' EXIT

# Preserve unrelated settings, but keep registry authentication managed by Nix.
# Slurp lets us reject empty files and multiple JSON documents as well as arrays.
merge_config() {
  jq -es '
    if length == 1 and (.[0] | type == "object") then
      .[0] | .auths = {} | .credsStore = "1password" | del(.credHelpers)
    else error("Docker config must contain exactly one JSON object") end
  ' "$@"
}

if [[ -e "$config_file" || -L "$config_file" ]]; then
  merge_config "$config_file" > "$temp_file"
else
  printf '{}\n' | merge_config > "$temp_file"
fi

# Rename within the same directory, so a failed merge leaves the original intact.
chmod 0600 "$temp_file"
mv -f "$temp_file" "$config_file"
