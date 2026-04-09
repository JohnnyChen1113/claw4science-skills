#!/bin/bash
# Search Claw4Science projects by keyword
# Usage: bash scripts/search.sh <keyword>
# Returns matching projects from the live API

QUERY="${1:-}"
if [ -z "$QUERY" ]; then
  echo "Usage: bash scripts/search.sh <keyword>"
  echo "Example: bash scripts/search.sh 'single cell'"
  exit 1
fi

bash "$(dirname "$0")/get-data.sh" | python3 -c "
import json, sys

query = '$QUERY'.lower()
data = json.load(sys.stdin)

matches = []
for p in data.get('projects', []):
    text = f\"{p.get('title','')} {p.get('description','')} {' '.join(p.get('tags',[]))}\".lower()
    if query in text:
        matches.append(p)

for p in data.get('skills', []):
    text = f\"{p.get('title','')} {p.get('description','')}\".lower()
    if query in text:
        matches.append(p)

if not matches:
    print(f'No matches for \"{query}\"')
    sys.exit(0)

print(f'Found {len(matches)} matches for \"{query}\":\n')
for m in sorted(matches, key=lambda x: -int(str(x.get('static_stars','0')).replace('K','000').replace('.','').replace('k','000') or '0')):
    title = m.get('name', '')
    repo = m.get('repo', '')
    stars = m.get('static_stars', '?')
    desc = m.get('description', '')[:100]
    group = m.get('category', '')
    anchor = repo.lower().replace('/', '-').replace('_', '-') if repo else ''
    print(f'  {title} ({stars} stars) [{group}]')
    print(f'    {desc}...')
    print(f'    https://claw4science.org/#project-{anchor}')
    print(f'    https://github.com/{repo}')
    print()
"
