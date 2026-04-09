#!/bin/bash
# Recommend Claw4Science projects by research domain
# Usage: bash scripts/recommend.sh <domain>
# Domains: biomedicine, drug-discovery, genomics, paper-writing, education, benchmark, security

DOMAIN="${1:-}"

if [ -z "$DOMAIN" ]; then
  echo "Usage: bash scripts/recommend.sh <domain>"
  echo ""
  echo "Available domains:"
  echo "  biomedicine    — Bio-omics, medical, clinical"
  echo "  drug-discovery — Molecular, cheminformatics, docking"
  echo "  genomics       — Sequence analysis, CRISPR, spatial"
  echo "  paper-writing  — Writing, citation, review"
  echo "  research       — General research automation"
  echo "  education      — Teaching, learning assistants"
  echo "  benchmark      — Agent evaluation, safety testing"
  echo "  security       — Agent skill auditing"
  echo "  all            — Show everything"
  exit 0
fi

curl -s "https://claw4science.org/api/projects" | python3 -c "
import json, sys

domain = '$DOMAIN'.lower()
data = json.load(sys.stdin)

# Domain to group mapping
domain_groups = {
    'biomedicine': ['science', 'bio-omics'],
    'drug-discovery': ['drug-molecular'],
    'drug': ['drug-molecular'],
    'genomics': ['bio-omics', 'science'],
    'paper-writing': ['paper-tools'],
    'paper': ['paper-tools'],
    'research': ['general-research', 'specialized'],
    'education': ['education'],
    'benchmark': ['benchmark'],
    'security': ['security'],
    'all': [],
}

# Domain to keyword fallback
domain_keywords = {
    'biomedicine': ['bio', 'medical', 'clinical', 'omics', 'health'],
    'drug-discovery': ['drug', 'molecular', 'docking', 'chem', 'pharma'],
    'genomics': ['genom', 'sequence', 'crispr', 'spatial', 'rna'],
    'paper-writing': ['paper', 'writing', 'citation', 'manuscript'],
    'research': ['research', 'scientist', 'autonomous'],
    'education': ['education', 'learn', 'teach', 'math'],
    'benchmark': ['benchmark', 'eval', 'safety'],
    'security': ['security', 'scan', 'audit'],
}

groups = domain_groups.get(domain, [])
keywords = domain_keywords.get(domain, [domain])

matches = []
for p in data.get('projects', []):
    if domain == 'all' or p.get('group', '') in groups:
        matches.append(p)
    elif any(kw in f\"{p.get('title','')} {p.get('description','')} {' '.join(p.get('tags',[]))}\".lower() for kw in keywords):
        matches.append(p)

# Also check skills
for p in data.get('skills', []):
    if any(kw in f\"{p.get('title','')} {p.get('description','')}\".lower() for kw in keywords):
        matches.append(p)

if not matches:
    print(f'No recommendations for domain \"{domain}\"')
    print(f'Try: biomedicine, drug-discovery, genomics, paper-writing, research, education, benchmark, security')
    sys.exit(0)

def parse_stars(s):
    s = str(s).replace(',','')
    if s.endswith('K'): return float(s[:-1]) * 1000
    try: return float(s)
    except: return 0

matches.sort(key=lambda x: -parse_stars(x.get('static_stars', '0')))

print(f'Recommendations for \"{domain}\" ({len(matches)} projects):\n')
for m in matches[:15]:
    title = m.get('title', '')
    repo = m.get('repo', '')
    stars = m.get('static_stars', '?')
    desc = m.get('description', '')[:100]
    group = m.get('group', '')
    anchor = repo.lower().replace('/', '-').replace('_', '-') if repo else ''
    print(f'  ⭐ {stars:>6}  {title} [{group}]')
    print(f'           {desc}...')
    print(f'           https://claw4science.org/#project-{anchor}')
    print()

print(f'Browse all at https://claw4science.org')
"
