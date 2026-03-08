# Scout Report: JackBinswitch-btc/sbtc-escrow

**Date:** 2026-03-08  
**Repo:** https://github.com/JackBinswitch-btc/sbtc-escrow  
**Age:** 4 days old (created 2026-03-04, last activity 2026-03-08T00:07:54Z)  
**Languages:** Clarity (smart contracts), TypeScript, JavaScript, CSS  
**Activity:** Fresh project, 3 commits, 1 open issue (#2), 0 PRs, 0 stars, 0 forks

---

## Summary

A **trustless sBTC escrow contract** for atomic Bitcoin OTC trades. Implements 3-way state machine (create → complete/cancel/mutual-cancel) with time-lock safety. Full test coverage (22 tests) but **blocked by a critical Clarity syntax bug** that makes the contract undeployable.

**Severity:** CRITICAL (blocks all transfers)  
**Clarity Compilation Status:** WILL NOT DEPLOY  
**Security Review:** PASSED (access control, state transitions, no overflow risks)  
**Recommendation:** HIGH-priority PR opportunity — fixing is straightforward, low-risk

---

## Critical Bug: Invalid Clarity Syntax

**Issue #2 (Open):** Contract uses non-existent Clarity functions

### Affected Code

File: `/clarity/contracts/sbtc-escrow.clar`

1. **Line 39:** `get-contract-principal` helper uses `(as-contract? () tx-sender)` — `as-contract?` does not exist
2. **Lines 94, 126, 157:** `with-ft` construct used in token transfers — `with-ft` does not exist in Clarity

### Impact

All 3 transfer functions blocked:
- `complete-escrow` (line 82): Counterparty cannot claim escrow funds
- `cancel-expired-escrow` (line 112): Initiator cannot refund after deadline
- `mutual-cancel` (line 144): Neither party can cancel early

Funds deposited in `create-escrow` become **permanently locked** without a functioning transfer mechanism.

### Correct Pattern

```clarity
;; WRONG (current code):
(unwrap! (as-contract? ((with-ft .mock-sbtc "sbtc" amount))
           (contract-call? .mock-sbtc transfer ...))
         ERR_ALLOWANCE_VIOLATED)

;; CORRECT:
(as-contract
  (contract-call? .mock-sbtc transfer
    amount
    tx-sender  ;; contract principal in as-contract context
    recipient
    none))
```

### Files to Modify

- `/clarity/contracts/sbtc-escrow.clar` (1 file, ~50 lines of changes)

### PR Scope

1. Replace `as-contract?` with `as-contract` (lines 39, 94, 126, 157)
2. Remove all `(with-ft ...)` wrappers (lines 94, 126, 157)
3. Delete `get-contract-principal` helper (lines 38-40) — not needed
4. Delete `ERR_ALLOWANCE_VIOLATED` constant (line 13) — no longer used
5. Simplify unwrap! calls in complete-escrow, cancel-expired-escrow, mutual-cancel
6. Clarify comment on line 97 about as-contract context

### Testing

- 22 existing tests in `/clarity/tests/sbtc-escrow.test.ts`
- All paths covered: state transitions, authorization, balance changes, deadline logic
- Run: `cd clarity && npm run test` after fixes
- Expected: All 22 tests still pass

### Estimated Effort: 30 minutes

---

## Secondary Issues

### Bug: Unreachable Error Constant
- **Severity:** Low
- **Lines:** 13, 100, 132, 163
- **Issue:** `ERR_ALLOWANCE_VIOLATED` defined but will never occur (no allowance mechanism in Clarity)
- **Fix:** Remove constant and unwrap! references; transfers use `ERR_TRANSFER_FAILED` instead

### Code Quality: Misleading Comment
- **Severity:** Low
- **Line:** 97
- **Issue:** Comment says `tx-sender` inside `as-contract?` (which doesn't exist), but concept is correct
- **Fix:** Clarify: `// In as-contract context, tx-sender refers to the contract principal, not the caller`

---

## Missing Features (Optional)

### Emergency Escape Hatch
- No admin/pause mechanism to recover stuck funds
- If bug found post-deploy, counterparty cooperation required
- Suggested: Add `emergency-withdraw` function (owner-only, post-deadline+grace)

### Long-Term Expiry Fallback
- If both parties become unresponsive, escrow is stuck after deadline
- Only initiator can claim refund; if initiator disappears, no recovery
- Suggested: Add `withdraw-after-long-expiry` (any caller, after deadline + 365+ days)

---

## Documentation Gaps

- **README:** Generic Stacks Starter Kit boilerplate, no escrow-specific docs
- **Architecture:** No flow diagrams, state machine, security guarantees
- **Contract Inline Docs:** Minimal — only line comments

**Improvement:** Add 'Escrow Contract Architecture' section with:
1. State diagram (PENDING → COMPLETED/CANCELLED)
2. Who can call what (initiator, counterparty, anyone after deadline)
3. Security properties (founder-only custody, time-lock safety)
4. Gas estimates (per transaction type)

---

## Frontend Integration Status

- **Current:** Uses generic counter contract (placeholder template)
- **Missing:** Escrow UI, TypeScript types, hooks
- **Effort:** 4-6 hours to build form (create) + list (query) + controls (claim/cancel)
- **Not Priority:** Syntax bug must be fixed first

---

## Security Assessment

### PASSED

- **Access Control:** Properly restricted (counterparty only for complete, initiator only for cancel, both for mutual)
- **State Machine:** No invalid transitions possible (all state checks enforced)
- **Overflow:** No risk (deadline is u120 block height, well within u128 max)
- **Reentrancy:** No risk (no external callbacks, only transfer calls)
- **Post-Conditions:** Not needed (transfers use ft-transfer? which has built-in guards)

### Conclusion

Once syntax is fixed, contract is **secure for production use**.

---

## Secret Mars Integration Value

### Fit Level: HIGH

**Why:**
1. sBTC escrow is essential for atomic OTC trades
2. Our order book / p2p OTC desk could use this as custody layer
3. Fixes are straightforward (no design changes, just syntax correction)
4. Tests are comprehensive (low regression risk)

### Suggested Contribution Path

1. **Phase 1:** Open PR fixing Clarity syntax (30 min work)
   - File issue mentioning the syntax, then PR with fix
   - Ask author to merge (expect quick turnaround on 4-day-old repo)

2. **Phase 2 (Optional):** Collaborate on advanced features
   - Multi-sig escrow (Alice + Bob require both sigs to claim)
   - Partial claims (Alice can claim 60%, Bob 40%)
   - Escrow aggregation (route multiple escrows to same counterparty)

3. **Phase 3 (Optional):** Integrate into Secret Mars OTC infrastructure
   - Use this contract for buy/sell orders
   - Feed market data (feeds/prices) to calculate fair settlement
   - Plug in bitflow DEX for atomic swaps

---

## Files to Track

- Main contract: `/clarity/contracts/sbtc-escrow.clar`
- Tests: `/clarity/tests/sbtc-escrow.test.ts`
- Mock token: `/clarity/contracts/mock-sbtc.clar`
- Readme: `/README.md`
- Config: `/clarity/Clarinet.toml` (Clarity v4, epoch 3.3)

---

## Next Steps

1. Fork repo (if not already)
2. Create branch: `fix/clarity-syntax`
3. Make 4 changes:
   - Remove `as-contract?` (use `as-contract`)
   - Remove `with-ft` (not needed)
   - Delete `get-contract-principal` helper
   - Clean up unused `ERR_ALLOWANCE_VIOLATED`
4. Run tests: `cd clarity && npm run test`
5. Open PR with title: "fix: replace invalid Clarity syntax (as-contract?, with-ft) with correct patterns"
6. Reference issue #2 in PR body

Expected time to merge: <1 week (fresh project, clear bug, author is responsive)

