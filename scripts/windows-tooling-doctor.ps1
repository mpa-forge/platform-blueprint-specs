$ErrorActionPreference = "Stop"

$checks = @(
  @{ Name = "bash"; Required = $true; Hint = "Install Git for Windows and ensure bash.exe is on PATH." },
  @{ Name = "make"; Required = $true; Hint = "Use ezwinports.make or MSYS2 make. Do not use GnuWin32 make." },
  @{ Name = "python"; Required = $true; Hint = "Install Python and ensure python resolves to the real interpreter, not a Store alias." },
  @{ Name = "gh"; Required = $true; Hint = "Install GitHub CLI." },
  @{ Name = "docker"; Required = $true; Hint = "Install Docker Desktop or equivalent." },
  @{ Name = "gcloud"; Required = $false; Hint = "Install Google Cloud CLI for cloud/deployment workflows." },
  @{ Name = "rg"; Required = $false; Hint = "Install ripgrep for fast repository search." }
)

$failed = $false

foreach ($check in $checks) {
  $command = Get-Command $check.Name -ErrorAction SilentlyContinue
  if ($null -eq $command) {
    if ($check.Required) {
      Write-Host "[FAIL] $($check.Name): not found. $($check.Hint)" -ForegroundColor Red
      $failed = $true
    } else {
      Write-Host "[WARN] $($check.Name): not found. $($check.Hint)" -ForegroundColor Yellow
    }
    continue
  }

  Write-Host "[OK] $($check.Name): $($command.Source)" -ForegroundColor Green
}

$make = Get-Command make -ErrorAction SilentlyContinue
if ($make) {
  $makeVersion = (& make --version | Select-Object -First 1)
  Write-Host "      $makeVersion"
  if ($make.Source -like "*GnuWin32*") {
    Write-Host "[FAIL] make: GnuWin32 make is unsupported for this workspace." -ForegroundColor Red
    $failed = $true
  }
}

$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
  $pythonVersion = (& python --version 2>&1 | Select-Object -First 1)
  Write-Host "      $pythonVersion"
}

if ($failed) {
  exit 1
}
