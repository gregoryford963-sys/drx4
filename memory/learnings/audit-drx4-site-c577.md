# drx4-site Audit Findings (Cycle 577)

## Status: FAIL (Critical Issues Blocking)

### Critical Issues (Blocking Deployment)

1. **CSP Deployment Drift** (src/middleware.ts:24-25)
   - Deployed code: Uses secure nonce-based CSP
   - Local source: Uses insecure unsafe-inline/unsafe-eval CSP
   - Risk: If deployed, security will REGRESS
   - Fix: Update CSP in middleware.ts to use nonce generation
   - See: Full details in audit report

2. **Uncommitted Next.js Migration**
   - Entire src/app/, src/components/, src/lib/ directories not in git
   - src/middleware.ts, next.config.ts, wrangler.jsonc not committed
   - Old src/index.ts and wrangler.toml deleted but not committed
   - Root cause: Architectural refactor from Workers (Hono) to Next.js/OpenNext
   - Risk: No audit trail, no PR review, rollback impossible
   - Fix: Commit migration as proper PR with full history

### High Severity Issues

3. **Stale Dependencies** (package.json)
   - @types/node: 5 major versions behind (20.19.35 → 25.3.3) — CRITICAL
   - Other updates available (eslint, react, wrangler) but lower priority
   - Fix: `npm update @types/node`

4. **Boilerplate README** (README.md)
   - Generic Next.js scaffolding, no project context
   - Missing: drx4.xyz purpose, deployment docs, AIBTC links
   - Fix: Replace with project-specific documentation

### Medium Severity Issues

5. **Middleware Deprecation** (src/middleware.ts)
   - Next.js 16 warns: "middleware file convention is deprecated. Use proxy instead."
   - Not urgent but should migrate to proxy configuration soon

### Passing Checks

✓ No hardcoded secrets
✓ No unsafe HTML patterns (no dangerouslySetInnerHTML)
✓ Build succeeds (64s, optimized)
✓ TypeScript clean
✓ All external URLs verified and active
✓ Address validation regex correct (contact-section.tsx)
✓ Proper error handling in fetchSbtcBalance()
✓ HSTS, X-Frame-Options, permissions-policy headers present

### Files With Issues

Critical:
- /home/mars/drx4-site/src/middleware.ts (CSP unsafe-inline/unsafe-eval on lines 24-25)
- /home/mars/drx4-site/.gitignore (migration not committed)
- /home/mars/drx4-site/package.json (@types/node stale)

High:
- /home/mars/drx4-site/README.md (boilerplate)

Medium:
- /home/mars/drx4-site/src/middleware.ts (deprecation warning)

### Next Actions

Immediate:
1. Commit Next.js migration with proper PR
2. Fix CSP to use nonce-based policy (example: crypto.randomUUID() per request)
3. Update @types/node to 25.3.3
4. Replace README.md

Short-term:
1. Migrate middleware.ts → proxy in next.config.ts
2. Update react/next minor versions
3. Add tests for /.well-known/agent.json and /llms.txt endpoints

See full audit report at /tmp/drx4-site-audit.md
