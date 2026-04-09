#!/bin/bash
# Fetch project data — tries API first, falls back to local JSON
# Returns JSON to stdout

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
LOCAL_INDEX="$HOME/claw_like/src/config/locale/messages/en/pages/index.json"
LOCAL_SKILLS="$HOME/claw_like/src/config/locale/messages/en/pages/skills.json"
LOCAL_HUBS="$HOME/claw_like/src/config/locale/messages/en/pages/skill-hubs.json"

# Try API first (5 second timeout)
API_DATA=$(curl -s --max-time 5 "https://claw4science.org/api/projects" 2>/dev/null)

if echo "$API_DATA" | python3 -c "import json,sys; json.load(sys.stdin)" 2>/dev/null; then
  echo "$API_DATA"
  exit 0
fi

# Fallback: build from local JSON files
if [ -f "$LOCAL_INDEX" ]; then
  python3 -c "
import json

with open('$LOCAL_INDEX') as f:
    idx = json.load(f)

projects = []
for item in idx['page']['sections']['projects']['items']:
    projects.append({
        'name': item.get('title', ''),
        'description': item.get('description', ''),
        'repo': item.get('repo', ''),
        'language': item.get('language', ''),
        'static_stars': item.get('static_stars', '0'),
        'tags': item.get('tags', []),
        'category': item.get('group', ''),
        'homepage': item.get('homepage', ''),
        'paper': item.get('paper', ''),
    })

skills = []
if '$LOCAL_SKILLS' and __import__('os').path.exists('$LOCAL_SKILLS'):
    with open('$LOCAL_SKILLS') as f:
        sk = json.load(f)
    for item in sk['page']['sections']['skills']['items']:
        skills.append({
            'name': item.get('title', ''),
            'description': item.get('description', ''),
            'repo': item.get('repo', ''),
            'tags': item.get('tags', []),
            'category': item.get('group', ''),
        })

hubs = []
if '$LOCAL_HUBS' and __import__('os').path.exists('$LOCAL_HUBS'):
    with open('$LOCAL_HUBS') as f:
        sh = json.load(f)
    for item in sh['page']['sections']['skills']['items']:
        hubs.append({
            'name': item.get('title', ''),
            'description': item.get('description', ''),
            'repo': item.get('repo', ''),
            'tags': item.get('tags', []),
            'category': item.get('group', ''),
        })

print(json.dumps({'projects': projects, 'skills': skills, 'skill_hubs': hubs}))
" 2>/dev/null
  exit 0
fi

echo '{"error": "No data source available"}' >&2
exit 1
