# 🦞 Claw4Science Skills

> Three AI skills for scientific research tool discovery. Powered by the [Claw4Science](https://claw4science.org) directory of 131+ curated AI agent projects.

[![Claw4Science](https://img.shields.io/badge/🦞_Claw4Science-Directory-10b981?style=for-the-badge)](https://claw4science.org)

## Skills

### 1. 📄 paper-to-tools

**Paste a paper → Get matched tools.** Extract methodology keywords from an abstract or methods section, match them to AI agents that can reproduce the analysis.

```bash
npx skills add bioinfoark/claw4science-skills -s paper-to-tools -y
```

Then ask: *"I have a paper that uses scRNA-seq + molecular docking. What tools can help me replicate it?"*

### 2. ⚖️ science-agent-compare

**Compare agents side by side.** Resolves 9 groups of same-name projects in the OpenClaw ecosystem. Structured comparisons with recommendations.

```bash
npx skills add bioinfoark/claw4science-skills -s science-agent-compare -y
```

Then ask: *"What's the difference between BioClaw and BloClaw?"*

### 3. 🔬 science-agent-recommend

**Get personalized recommendations.** Describe your research domain → receive curated tool suggestions from 10 categories and 32 skill hubs.

```bash
npx skills add bioinfoark/claw4science-skills -s science-agent-recommend -y
```

Then ask: *"I'm a computational chemist working on drug-target interactions. What agents should I use?"*

## Install All

```bash
npx skills add bioinfoark/claw4science-skills -g -y
```

## What's Behind This

[Claw4Science](https://claw4science.org) is a curated directory of AI agent projects for scientific research — spanning bioinformatics, drug discovery, genomics, paper writing, and more. These skills make that directory accessible directly from your coding agent.

- **131+ projects** across 10 categories
- **32 skill hubs** with 2,200+ individual skills surveyed
- **9 same-name disambiguation** groups
- **Public API** at [claw4science.org/api/projects](https://claw4science.org/api/projects)

## Links

| Resource | URL |
|----------|-----|
| Directory | [claw4science.org](https://claw4science.org) |
| Skill Hubs | [claw4science.org/skill-hubs](https://claw4science.org/skill-hubs) |
| Blog | [claw4science.org/blog](https://claw4science.org/blog) |
| API | [claw4science.org/api/projects](https://claw4science.org/api/projects) |
| Contribute | [claw4science.org/contribute](https://claw4science.org/contribute) |

## License

MIT
