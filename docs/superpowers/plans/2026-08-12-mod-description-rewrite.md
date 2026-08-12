# Nuclear Option Mod Description Rewrite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the NOMM descriptions for NO VOR CDI, SITREP, and NO Mod Bar with accurate, player-focused copy grounded in their repositories.

**Architecture:** Keep the manifest schema and all release metadata unchanged. Edit only each manifest's `description` field, using the registry's strongest pattern: outcome first, signature features second, and scope or integration details last.

**Tech Stack:** NOMNOM JSON manifests, PowerShell JSON validation, Git diff review.

---

### Task 1: Rewrite the three descriptions

**Files:**
- Modify: `modManifests/NOVor.json`
- Modify: `modManifests/Sitrep.json`
- Modify: `modManifests/NoModBar.json`

- [x] **Step 1: Replace each description**

Write player-facing copy based on the corresponding repository's implemented features. Do not change IDs, tags, URLs, authors, or artifact metadata.

- [x] **Step 2: Validate all three manifests**

Run:

```powershell
Get-Content -Raw modManifests\NOVor.json | ConvertFrom-Json | Out-Null
Get-Content -Raw modManifests\Sitrep.json | ConvertFrom-Json | Out-Null
Get-Content -Raw modManifests\NoModBar.json | ConvertFrom-Json | Out-Null
```

Expected: all commands exit successfully with no parser errors.

- [x] **Step 3: Review the diff**

Run:

```powershell
git diff -- modManifests/NOVor.json modManifests/Sitrep.json modManifests/NoModBar.json
```

Expected: only the three `description` values change.
