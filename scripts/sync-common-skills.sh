#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
specs_root="$(cd "${script_dir}/.." && pwd)"
manifest_path="${specs_root}/common/agent-skills-manifest.txt"
source_skills_root="${specs_root}/.codex/skills"

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

if [[ ! -f "${manifest_path}" ]]; then
  echo "Shared skill manifest not found at ${manifest_path}" >&2
  exit 1
fi

if [[ ! -d "${source_skills_root}" ]]; then
  echo "Shared skills directory not found at ${source_skills_root}" >&2
  exit 1
fi

if [[ "${repo_root}" == "${specs_root}" ]]; then
  echo "Run this script from a managed sibling repository, not platform-blueprint-specs itself." >&2
  exit 1
fi

mkdir -p "${target_skills_root}"

changed=0
checked=0

while IFS= read -r skill || [[ -n "${skill}" ]]; do
  skill="$(printf '%s' "${skill}" | tr -d '\r')"
  if [[ -z "${skill}" || "${skill}" == \#* ]]; then
    continue
  fi

  source_dir="${source_skills_root}/${skill}"
  target_dir="${target_skills_root}/${skill}"

  if [[ ! -d "${source_dir}" ]]; then
    echo "Shared skill directory missing: ${source_dir}" >&2
    exit 1
  fi

  checked=$((checked + 1))

  if [[ "${mode}" == "check" ]]; then
    if [[ ! -d "${target_dir}" ]] || ! diff -qr "${source_dir}" "${target_dir}" >/dev/null; then
      echo "Outdated or missing managed skill: ${skill}" >&2
      changed=1
    fi
    continue
  fi

  case "${target_dir}" in
    "${repo_root}"/*) ;;
    *)
      echo "Refusing to sync outside repo root: ${target_dir}" >&2
      exit 1
      ;;
  esac

  rm -rf "${target_dir}"
  mkdir -p "$(dirname "${target_dir}")"
  cp -R "${source_dir}" "${target_dir}"
done < "${manifest_path}"

if [[ "${mode}" == "check" ]]; then
  if [[ "${changed}" -ne 0 ]]; then
    echo "Managed common skills are out of date in ${repo_root}." >&2
    echo "Run 'make sync-agent-skills' from the repository root before pushing." >&2
    exit 1
  fi

  echo "Managed common skills are up to date in ${repo_root} (${checked} skill directories checked)."
  exit 0
fi

echo "Synced managed common skills into ${repo_root} (${checked} skill directories)."
