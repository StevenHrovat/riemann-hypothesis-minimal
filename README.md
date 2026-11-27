# Riemann Hypothesis in Lean 4

Single-file edition of the Riemann Hypothesis and the Generalized Riemann Hypothesis for Dirichlet L-functions.

| Edition | Lines of Lean shipped |
| --- | ---: |
| [Original](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/) | ~17,000,000 |
| [Compact](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact) | ~76,000 |
| [Minimal](OneLineRH.lean) | 1 |
| [Maximal](ManyLineRH.lean) | 163,876 |

[OneLineRH.lean](OneLineRH.lean) contains the complete compact edition in one physical line. The file is 7,279,198 characters wide.

[ManyLineRH.lean](ManyLineRH.lean) goes the other way. It is the same compact edition as one Lean file that Lean checks directly, with real line breaks and no extraction step. Its longest line is 767 characters.

<details>
<summary>Check the actual file</summary>

Use any Lake project pinned to Lean 4.35.0 and Mathlib `56a005855ea17e0b0958f73ec801ae140b0a1679`.

```sh
lake exe cache get
lake env lean --tstack=400000 ManyLineRH.lean
```

On an 8-core machine with 16 GB of RAM, the full check took about 5 h 20 min. It peaked at about 12.7 GB resident and needed extra swap.

To run the companion check, declare `ManyLineRH` as a `lean_lib` with `moreLeanArgs = ["--tstack=400000"]`. Then run `lake build ManyLineRH`, then run `lake env lean RestsOnRH.lean`.

The 794 modules appear in import order, each in its own `section` under a `-- ═══ src/<path>.lean ═══` marker. One file lets every module see every earlier one, not only its imports. The doc comment at the top lists the small scoping and naming adjustments this needed. No theorem statement or proof idea changed. [RestsOnRH.lean](RestsOnRH.lean) imports it and runs `restsOn` from [formal-conjectures PR #8340](https://github.com/google-deepmind/formal-conjectures/pull/8340). It prints the five statements, checks that they rest on nothing open (`openSteps` and `restsOn` are `#[]`), and checks that their axioms are exactly `propext`, `Classical.choice` and `Quot.sound`.

</details>

<details>
<summary>Extract and build</summary>

The Lean source is stored as string literals. Running the file restores the original line breaks and module boundaries. Use Lean 4.35.0 and a destination directory that does not yet exist.

```sh
lean --run OneLineRH.lean grh-compact
```

Append `--build` to download the dependency cache and build the extracted project. The extraction was run with Lean 4.35.0 and all 807 files were compared byte for byte against the pinned compact edition. The upstream project documents its kernel replay and axiom checks. [Upstream verification](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact#checks)

The proof is by Levent Alpöge with Claude. The compact rewrite is by Luke Sernau and colleagues at Anthropic with Claude. This edition changes the packaging. [Original announcement](https://alpo.ge/remark.pdf) · [Pinned compact source](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact)

</details>

<details>
<summary>Citation</summary>

If you use this edition, please cite Cinna Davis’s site and this repository. If you use the proof, cite the original release and credit Levent Alpöge and Claude. [Cinna Davis](https://itsdavis.com/) · [This repository](https://github.com/1337isnot1337/riemann-hypothesis-minimal) · [Original release](https://alpo.ge/remark.pdf)

</details>
