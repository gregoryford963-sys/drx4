# Pillar: BFF Skills (PRIMARY — daily submission)

Submit 1 quality DeFi skill per day to `BitflowFinance/bff-skills`. Win daily $100 + HODLMM bonus.

**Repo:** `/home/mars/bff-skills/` (fork)
**Format:** `/skills/{skill-name}/` containing `SKILL.md`, `AGENT.md`, `{skill-name}.ts`
**PR title:** `[AIBTC Skills Comp Day X] Skill Name`
**Deadline:** 11:59 PM PDT daily

## Per-Cycle BFF Actions (in order)

### Step 1: Check open PRs for reviews (EVERY cycle)
```bash
gh pr list --repo BitflowFinance/bff-skills --author secret-mars --state open --json number,title,reviews,comments
```
- Read ALL review comments and requested changes
- Address feedback immediately — fix code, push updates, respond to reviewers
- Merged PRs = money. Unreviewed PRs = nothing. Prioritize getting existing PRs merged.

### Step 2: Research before building (MANDATORY)
- Read protocol docs thoroughly. WebFetch the actual API/contract source.
- Check existing submissions: `gh search prs --repo BitflowFinance/bff-skills --state all` — no dupes
- Understand the DeFi primitive deeply. Don't build what you don't understand.
- Study winning submissions from other agents — what got merged fast? What got rejected?

### Step 3: Build with quality
Write `.ts` implementation with:
- `doctor` command (env/wallet checks)
- `run` command (core execution)
- `install-packs` command (if applicable)
- JSON output: `{status, action, data, error}`
- Real safety controls IN CODE (spend limits, confirmation gates, refusal logic)

### Step 4: Test thoroughly
- Run all commands locally. Every command produces clean JSON.
- Get on-chain proof (real mainnet tx hash).
- Run `bun run typecheck` — must pass.

### Step 5: Document and submit
- Fill SKILL.md (frontmatter + description + safety) and AGENT.md (decision order + guardrails)
- PR with smoke test output, frontmatter validated, on-chain proof linked

## SKILL.md Format (CRITICAL — CI rejects bad format)

- Frontmatter MUST use nested `metadata:` block (not flat top-level)
- Tags: comma-separated string `"l2, read-only"` (NOT YAML array)
- `user-invocable`: string `"true"` (NOT boolean)
- Required under metadata: author, author-agent, entry, user-invocable, arguments, tags
- Reference: SKILL_TEMPLATE.md in bff-skills repo

## Quality Rules

- **Reviews first.** Always check and address open PR feedback before starting new work.
- **Research first.** Never build a skill without reading the protocol docs and contract source.
- **Build from real usage.** Every skill from something we actually do on-chain.
- **On-chain proof mandatory.** Real tx hash.
- **Safety controls in code.** Not just docs.
- **Test before submit.** All commands produce clean JSON.
- **Study what wins.** Look at merged PRs — learn the pattern.

## Day Tracking

Compute day from start date (2026-03-25). Check `project_bff_skills_comp.md` before submitting.
Update health.json: `bff_skills.submitted_today`, `total_submitted`.

## HODLMM-Eligible Ideas (bonus $100)

- Bitflow HODLMM position manager
- HODLMM yield optimizer
- HODLMM risk monitor
