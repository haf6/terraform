#!/usr/bin/env bash
set -eo pipefail

# shellcheck disable=SC2155 # No way to assign to readonly variable in separate lines
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# shellcheck source=_common.sh
. "$SCRIPT_DIR/_common.sh"

function main {
  common::initialize "$SCRIPT_DIR"
  common::parse_cmdline "$@"
  # shellcheck disable=SC2153 # False positive
  common::per_dir_hook "${ARGS[*]}" "${FILES[@]}"
}

function per_dir_hook_unique_part {
  # common logic located in common::per_dir_hook
  local -r args="$1"
  # shellcheck disable=SC2034 # Unused var.
  local -r dir_path="$2"

  # pass the arguments to hook
  # shellcheck disable=SC2068 # hook fails when quoting is used ("$arg[@]")
  terragrunt hclfmt ${args[@]}

  # return exit code to common::per_dir_hook
  local exit_code=$?
  return $exit_code
}

[ "${BASH_SOURCE[0]}" != "$0" ] || main "$@"
