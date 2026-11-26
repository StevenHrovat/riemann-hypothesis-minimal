# Riemann Hypothesis in Lean 4

Single-file edition.

| Edition | Lines of Lean shipped |
| --- | ---: |
| [Original](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/) | ~17,000,000 |
| [Compact](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact) | ~76,000 |
| [Minimal](OneLineRH.lean) | 1 |

[OneLineRH.lean](OneLineRH.lean) contains the complete compact edition in one physical line. The file is 7,279,198 characters wide.

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
