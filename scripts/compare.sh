#!/bin/bash
# Compare two Claw4Science projects side by side
# Usage: bash scripts/compare.sh <repo1> <repo2>
# Example: bash scripts/compare.sh Runchuan-BU/BioClaw qinheming/BIoClaw

REPO1="${1:-}"
REPO2="${2:-}"

if [ -z "$REPO1" ] || [ -z "$REPO2" ]; then
  echo "Usage: bash scripts/compare.sh <owner/repo1> <owner/repo2>"
  echo "Example: bash scripts/compare.sh Runchuan-BU/BioClaw qinheming/BIoClaw"
  exit 1
fi

curl -s "https://claw4science.org/api/projects" | python3 -c "
import json, sys

repo1 = '$REPO1'.lower()
repo2 = '$REPO2'.lower()
data = json.load(sys.stdin)

all_items = data.get('projects', []) + data.get('skills', []) + data.get('skill_hubs', [])

p1 = p2 = None
for p in all_items:
    r = p.get('repo', '').lower()
    if r == repo1: p1 = p
    if r == repo2: p2 = p

if not p1:
    print(f'Project not found: {repo1}')
    sys.exit(1)
if not p2:
    print(f'Project not found: {repo2}')
    sys.exit(1)

def anchor(repo):
    return repo.lower().replace('/', '-').replace('_', '-')

print(f'| | {p1[\"title\"]} | {p2[\"title\"]} |')
print(f'|---|---|---|')
print(f'| **Repo** | {p1.get(\"repo\",\"\")} | {p2.get(\"repo\",\"\")} |')
print(f'| **Stars** | {p1.get(\"static_stars\",\"?\")} | {p2.get(\"static_stars\",\"?\")} |')
print(f'| **Language** | {p1.get(\"language\",\"?\")} | {p2.get(\"language\",\"?\")} |')
print(f'| **Group** | {p1.get(\"group\",\"?\")} | {p2.get(\"group\",\"?\")} |')
print(f'| **Description** | {p1.get(\"description\",\"\")[:80]}... | {p2.get(\"description\",\"\")[:80]}... |')
print(f'| **Tags** | {\", \".join(p1.get(\"tags\",[])[:4])} | {\", \".join(p2.get(\"tags\",[])[:4])} |')
print(f'| **Listing** | https://claw4science.org/#project-{anchor(p1[\"repo\"])} | https://claw4science.org/#project-{anchor(p2[\"repo\"])} |')
print()

# Check for compare page
tags1 = set(t.lower() for t in p1.get('tags',[]))
tags2 = set(t.lower() for t in p2.get('tags',[]))
if p1.get('compare_url'):
    print(f'Compare page: https://claw4science.org{p1[\"compare_url\"]}')
elif p2.get('compare_url'):
    print(f'Compare page: https://claw4science.org{p2[\"compare_url\"]}')
"
