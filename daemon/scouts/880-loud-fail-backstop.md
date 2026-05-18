# lp#880 action 4 scout: LOUD-fail backstop for TENERO_REFRESH_ENABLED-unset-in-prod

**Scout date:** 2026-05-18T22:04Z (cycle 2034v417)
**Status:** scout-ready, NOT-yet-actioned — waiting for @whoabuddy greenlight on lp#880 v414 PR offer
**References:**
- [lp#880](https://github.com/aibtcdev/landing-page/issues/880) action 4: "Backstop: file a follow-up so the gate fails LOUD (ERROR, not WARN) if a prod env has this unset for >1h"
- [my v414 engagement](https://github.com/aibtcdev/landing-page/issues/880#issuecomment-4482076327) with proposed spec

## Code path (current state)

**File:** `worker.ts:204-228` (SchedulerDO.runTenero method)

```ts
private async runTenero(parentLogger: Logger): Promise<TeneroRunResult> {
  const logger = parentLogger.child
    ? parentLogger.child({ task: "tenero" })
    : parentLogger;
  const startedAt = Date.now();

  if (this.env.TENERO_REFRESH_ENABLED !== "true") {
    logger.warn("tenero.refresh_skipped_disabled", {
      deployEnv: this.env.DEPLOY_ENV ?? "unset",
      teneroRefreshEnabled: this.env.TENERO_REFRESH_ENABLED ?? "unset",
    });
    return {
      startedAt,
      durationMs: Date.now() - startedAt,
      tokensAttempted: 0, succeeded: 0, failed: 0,
      minuteRemaining: null, monthRemaining: null,
    };
  }
  // ... (proceeds to runTeneroTask if enabled)
}
```

The disabled-branch returns a zero-result and logs WARN. Loops every 5min indefinitely while flag is unset.

## Proposed diff (PR-ready sketch)

```ts
// Constant — single source of truth
const TENERO_GATE_UNSET_ESCALATION_MS = 60 * 60 * 1000; // 1h

private async runTenero(parentLogger: Logger): Promise<TeneroRunResult> {
  const logger = parentLogger.child
    ? parentLogger.child({ task: "tenero" })
    : parentLogger;
  const startedAt = Date.now();

  if (this.env.TENERO_REFRESH_ENABLED !== "true") {
    // LOUD-fail backstop: if production has been gate-unset for >1h, log
    // ERROR instead of WARN so alerting on production ERROR logs catches it.
    // Tracking key persists across alarms via DO storage.
    const lastEnabledAt = await this.ctx.storage.get<number>(
      "tenero.lastEnabledAt"
    );
    const sinceLastEnabledMs =
      lastEnabledAt !== undefined ? startedAt - lastEnabledAt : null;

    const isProd = this.env.DEPLOY_ENV === "production";
    const escalate =
      isProd &&
      sinceLastEnabledMs !== null &&
      sinceLastEnabledMs > TENERO_GATE_UNSET_ESCALATION_MS;

    const event = escalate
      ? "tenero.gate_unset_extended"
      : "tenero.refresh_skipped_disabled";
    const logFn = escalate ? logger.error : logger.warn;

    logFn(event, {
      deployEnv: this.env.DEPLOY_ENV ?? "unset",
      teneroRefreshEnabled: this.env.TENERO_REFRESH_ENABLED ?? "unset",
      sinceLastEnabledMs,
      thresholdMs: TENERO_GATE_UNSET_ESCALATION_MS,
    });

    return {
      startedAt,
      durationMs: Date.now() - startedAt,
      tokensAttempted: 0, succeeded: 0, failed: 0,
      minuteRemaining: null, monthRemaining: null,
    };
  }

  // Enabled path — record the last-enabled timestamp so the backstop's
  // sinceLastEnabledMs measurement is meaningful.
  await this.ctx.storage.put("tenero.lastEnabledAt", startedAt);

  // ... existing token-set resolve + runTeneroTask + persistTeneroResult ...
}
```

**Scope:** ~20 LOC including constant, KV-state read, escalation logic, and write-back on enabled tick. Smaller than my v414 estimate of "~30 LOC."

## Test plan

`lib/scheduler/__tests__/tenero-task.test.ts` doesn't cover the gate (that lives in worker.ts). Need either:

1. A new `worker.ts`-level test (Wrangler test-runner / `unstable_dev`), OR
2. Extract the gate logic into a pure function `evaluateTeneroGate(env, lastEnabledAt, now)` that returns `{shouldRun, logEvent, logLevel, logFields}` and test that

Option 2 is cleaner and follows the existing tenero-task pattern (orchestration in DO method, pure logic extractable). Estimated test additions: ~30-50 LOC across 4-5 test cases:

- gate=true → returns `{shouldRun: true, ...}` and would write lastEnabledAt
- gate=unset, DEPLOY_ENV=production, lastEnabledAt=null → WARN, no escalation
- gate=unset, DEPLOY_ENV=production, lastEnabledAt=now-30m → WARN, no escalation
- gate=unset, DEPLOY_ENV=production, lastEnabledAt=now-61m → ERROR with sinceLastEnabledMs
- gate=unset, DEPLOY_ENV=preview/dev → WARN regardless of duration (escalation is prod-only per spec)

## Risk surface

1. **DO storage write on every enabled tick adds 1 write/tick.** Acceptable cost (alarm fires every ~ALARM_TICK_MS). If concerning, could write only when transitioning unset→enabled.
2. **First-run after deploy has no lastEnabledAt.** Handled by `sinceLastEnabledMs !== null` guard — escalation only fires when we have a reference point. Could also seed lastEnabledAt=startedAt on first-ever invocation.
3. **DEPLOY_ENV=undefined cases.** Current code does `this.env.DEPLOY_ENV ?? "unset"`. Escalation only fires when `isProd === true` (strict equality), so undefined/preview/dev environments never escalate. Matches the "production-only" intent in lp#880 action 4 spec.

## PR-readiness checklist

- [x] Code path located (worker.ts:204-228)
- [x] Proposed diff sketched
- [x] Constant + KV storage key named
- [x] Test plan with 5 cases identified
- [x] Risk surface analyzed
- [ ] Greenlight from @whoabuddy on lp#880 (not received as of v417 22:04Z)
- [ ] Confirmation that action 1 (wrangler secret put) has landed (so the production gate actually transitions through enabled→unset cycles for the test to be meaningful in prod)

## Decision rule for firing

Open the PR when:
1. @whoabuddy responds on [my v414 lp#880 engagement](https://github.com/aibtcdev/landing-page/issues/880#issuecomment-4482076327) with explicit "yes please" OR
2. Action 1 lands AND @whoabuddy hasn't claimed action 4 himself within ~24h after that
3. Someone else opens a related PR — in that case, leave them alone unless they ping me

Do NOT open speculatively. The build-burst pattern (v416 codified) means whoabuddy is currently issue-shaping, not implementation-merging. He may queue action 4 for himself.

## Cross-references

- v412 lp#794 regression evidence
- v414 lp#880 substantive engagement
- v416 build-burst-then-respond pattern codification
- daemon/scouts/876-p3-0b-wire-up.md (parallel scout doc, similar posture)
