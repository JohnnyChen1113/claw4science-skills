#!/bin/bash
# Match paper methods to AI agents
# Usage: bash scripts/paper-match.sh "<abstract or methods text>"
# Example: bash scripts/paper-match.sh "We performed scRNA-seq analysis followed by molecular docking"

TEXT="${1:-}"

if [ -z "$TEXT" ]; then
  echo "Usage: bash scripts/paper-match.sh \"<abstract or methods text>\""
  echo "Example: bash scripts/paper-match.sh \"single-cell RNA-seq with trajectory analysis and drug target validation\""
  exit 1
fi

curl -s "https://claw4science.org/api/projects" | python3 -c "
import json, sys, re

text = '''$TEXT'''.lower()
data = json.load(sys.stdin)

# Keyword → weight mapping (higher = more specific match)
keyword_map = {
    # Genomics & Omics
    'scrna': ['single-cell', 'scRNA', 'omics'],
    'single.cell': ['single-cell', 'scRNA', 'omics'],
    'rna.seq': ['RNA-seq', 'omics', 'differential expression'],
    'differential expression': ['DEG', 'RNA-seq'],
    'trajectory': ['trajectory', 'pseudotime', 'single-cell'],
    'spatial transcriptom': ['spatial', 'visium', 'MERFISH'],
    'blast': ['BLAST', 'sequence', 'alignment'],
    'sequence alignment': ['BLAST', 'alignment'],
    'crispr': ['CRISPR', 'gene editing'],
    'genome': ['genome', 'variant', 'WGS'],
    'chip.seq': ['ChIP-seq', 'epigenomics'],
    'atac.seq': ['ATAC-seq', 'chromatin'],
    # Drug & Chemistry
    'docking': ['docking', 'molecular', 'drug'],
    'molecular dynamics': ['MD', 'simulation', 'OpenMM'],
    'drug.target': ['DTI', 'drug', 'pharmacology'],
    'admet': ['ADMET', 'drug', 'toxicity'],
    'virtual screening': ['screening', 'drug', 'docking'],
    'rdkit': ['RDKit', 'cheminformatics'],
    'smiles': ['SMILES', 'molecular'],
    'pymol': ['PyMOL', 'visualization', 'structure'],
    'protein fold': ['folding', 'AlphaFold', 'ESMFold'],
    'alphafold': ['AlphaFold', 'structure prediction'],
    'esmfold': ['ESMFold', 'folding'],
    # Research
    'pubmed': ['PubMed', 'literature'],
    'literature review': ['literature', 'review', 'search'],
    'systematic review': ['systematic', 'literature'],
    'meta.analysis': ['meta-analysis', 'statistics'],
    'machine learning': ['ML', 'prediction'],
    'deep learning': ['DL', 'neural network'],
    # Clinical
    'clinical trial': ['clinical', 'trial'],
    'patient': ['clinical', 'medical', 'health'],
    'biomarker': ['biomarker', 'clinical', 'omics'],
}

# Find matching keywords in text
matched_keywords = set()
for pattern, tags in keyword_map.items():
    if re.search(pattern, text):
        matched_keywords.update(tags)

if not matched_keywords:
    # Fallback: extract individual words
    words = set(re.findall(r'[a-z]{4,}', text))
    matched_keywords = words

# Score each project
scores = []
all_items = data.get('projects', []) + data.get('skills', [])
for p in all_items:
    p_text = f\"{p.get('title','')} {p.get('description','')} {' '.join(p.get('tags',[]))}\".lower()
    score = sum(1 for kw in matched_keywords if kw.lower() in p_text)
    if score > 0:
        scores.append((p, score))

scores.sort(key=lambda x: -x[1])

print(f'Keywords detected: {\", \".join(sorted(matched_keywords))}')
print(f'Matched {len(scores)} projects:\n')

for p, score in scores[:8]:
    title = p.get('title', '')
    repo = p.get('repo', '')
    stars = p.get('static_stars', '?')
    desc = p.get('description', '')[:100]
    anchor = repo.lower().replace('/', '-').replace('_', '-') if repo else ''
    print(f'  [{score} hits] {title} ({stars} stars)')
    print(f'    {desc}...')
    print(f'    https://claw4science.org/#project-{anchor}')
    print()

if not scores:
    print('No specific matches found. Browse all projects at https://claw4science.org')
else:
    print(f'Full directory: https://claw4science.org')
"
