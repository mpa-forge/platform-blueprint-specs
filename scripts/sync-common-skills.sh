#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
specs_root="$(cd "${script_dir}/.." && pwd)"
manifest_path="${specs_root}/common/agent-skills-manifest.txt"
agent_manifest_path="${specs_root}/common/agent-manifest.txt"
source_skills_root="${specs_root}/.codex/skills"
source_agents_root="${specs_root}/.codex/agents"

mode="sync"
repo_root="${PWD}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)
      mode="check"
      shift
      ;;
    --repo-root)
      repo_root="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

repo_root="$(cd "${repo_root}" && pwd)"
target_skills_root="${repo_root}/.codex/skills"
target_agents_root="${repo_root}/.codex/agents"

if [[ "${repo_root}" == "${specs_root}" ]]; then
  echo "Run this script from a managed sibling repository, not platform-blueprint-specs itself." >&2
  exit 1
fi

if [[ ! -f "${manifest_path}" ]]; then
  echo "Shared skill manifest not found at ${manifest_path}" >&2
  exit 1
fi

if [[ ! -f "${agent_manifest_path}" ]]; then
  echo "Shared agent manifest not found at ${agent_manifest_path}" >&2
  exit 1
fi

if [[ ! -d "${source_skills_root}" ]]; then
  echo "Shared skills directory not found at ${source_skills_root}" >&2
  exit 1
fi

if [[ ! -d "${source_agents_root}" ]]; then
  echo "Shared agents directory not found at ${source_agents_root}" >&2
  exit 1
fi

mkdir -p "${target_skills_root}" "${target_agents_root}"

changed=0
checked=0

sync_entries() {
  local manifest="$1"
  local source_root="$2"
  local target_root="$3"
  local item_label="$4"

  while IFS= read -r item || [[ -n "${item}" ]]; do
    item="$(printf '%s' "${item}" | tr -d '\r')"
    if [[ -z "${item}" || "${item}" == \#* ]]; then
      continue
    fi

    local source_path="${source_root}/${item}"
    local target_path="${target_root}/${item}"

    if [[ ! -e "${source_path}" ]]; then
      echo "Shared ${item_label} missing: ${source_path}" >&2
      exit 1
    fi

    checked=$((checked + 1))

    if [[ "${mode}" == "check" ]]; then
      if [[ ! -e "${target_path}" ]] || ! diff -qr "${source_path}" "${target_path}" >/dev/null; then
        echo "Outdated or missing managed ${item_label}: ${item}" >&2
        changed=1
      fi
      continue
    fi

    case "${target_path}" in
      "${repo_root}"/*) ;;
      *)
        echo "Refusing to sync outside repo root: ${target_path}" >&2
        exit 1
        ;;
    esac

    rm -rf "${target_path}"
    mkdir -p "$(dirname "${target_path}")"
    cp -R "${source_path}" "${target_path}"
  done < "${manifest}"
}

sync_entries "${manifest_path}" "${source_skills_root}" "${target_skills_root}" "skill"
sync_entries "${agent_manifest_path}" "${source_agents_root}" "${target_agents_root}" "agent"

if [[ "${mode}" == "check" ]]; then
  if [[ "${changed}" -ne 0 ]]; then
    echo "Managed common skills and agents are out of date in ${repo_root}." >&2
    echo "Run 'make sync-agent-skills' from the repository root before pushing." >&2
    exit 1
  fi

  echo "Managed common skills and agents are up to date in ${repo_root} (${checked} entries checked)."
  exit 0
fi

echo "Synced managed common skills and agents into ${repo_root} (${checked} entries)."
