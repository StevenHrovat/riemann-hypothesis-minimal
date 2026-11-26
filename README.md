# Riemann Hypothesis in Lean 4

Single-file edition.

| Edition | Lines of Lean shipped |
| --- | ---: |
| [Original](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/) | ~17,000,000 |
| [Compact](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact) | ~76,000 |
| [Minimal](OneLineRH.lean) | 1 |

```lean
import New.Main theorem RH : RiemannHypothesis := New.zeta_zeros_on_line New.grh
```

The complete source file fits in 80 columns. Checked with Lean 4.35.0 using `propext`, `Classical.choice`, and `Quot.sound`.

<details>
<summary>Reproduce the check</summary>

Run these commands from an empty directory with `git` and `elan` installed.

```sh
git clone https://github.com/1337isnot1337/riemann-hypothesis-minimal.git
git clone https://github.com/leanprover-community/riemann-hypothesis.git
cd riemann-hypothesis
git checkout e063a923620ee7787b4a1270421478645bf66bdb
lake exe cache get
lake env lean ../riemann-hypothesis-minimal/OneLineRH.lean
```

`New.Main` supplies the generalized result. The last two terms specialize it to Mathlib’s `RiemannHypothesis`. The upstream proof is by Levent Alpöge with Claude. [Original announcement](https://alpo.ge/remark.pdf) · [Pinned Lean source](https://github.com/leanprover-community/riemann-hypothesis/blob/e063a923620ee7787b4a1270421478645bf66bdb/src/Main.lean#L1-L5)

</details>

<details>
<summary>Citation</summary>

If you use this edition, please cite Cinna Davis’s site and this repository. If you use the proof, cite the original release and credit Levent Alpöge and Claude. [Cinna Davis](https://itsdavis.com/) · [This repository](https://github.com/1337isnot1337/riemann-hypothesis-minimal) · [Original release](https://alpo.ge/remark.pdf)

</details>
