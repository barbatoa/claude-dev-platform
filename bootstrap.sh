#!/usr/bin/env bash
# Set up this workspace on a new machine: create the tier folders and register the
# platform's slash commands with Claude Code. Idempotent; never overwrites a real file.
set -euo pipefail

workspace_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
commands_dir="${HOME}/.claude/commands"

for tier in prototypes production archive; do
  mkdir -p "${workspace_root}/${tier}"
done

mkdir -p "${commands_dir}"
for command_file in "${workspace_root}"/_platform/commands/*.md; do
  link="${commands_dir}/$(basename "${command_file}")"
  if [[ -e "${link}" && ! -L "${link}" ]]; then
    echo "skip  ${link} — a real file is already there, not replacing it"
    continue
  fi
  ln -sfn "${command_file}" "${link}"
  echo "link  ${link}"
done

echo
echo "Workspace root: ${workspace_root}"
echo "Next: merge _platform/claude/settings.user.json into ~/.claude/settings.json"
echo "      to keep build output and lockfiles out of Claude's context."
