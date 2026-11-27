import ManyLineRH

/-! # What ManyLineRH.lean claims, and how to check each claim

ManyLineRH.lean is the compact GRH/RH proof (Levent Alpöge with Claude; compact edition by Luke
Sernau and colleagues at Anthropic with Claude; Apache-2.0, see LICENSE, NOTICE, ATTRIBUTION.md) as
one multi-line Lean file. Build it first, for example as a Lake `lean_lib` with
`moreLeanArgs = ["--tstack=400000"]`, then run `lake env lean RestsOnRH.lean`. Every claim below is
printed or checked by a command in this file. The file fails to compile if a check fails.

1. **The statements.** `#print` shows the five statements. `RiemannHypothesis` is Mathlib's own
   definition. The other four are plain `Prop` definitions at the top of ManyLineRH.lean.
2. **Nothing open.** `openSteps d` lists every declaration reached from `d` whose statement or proof
   is `sorry`. `restsOn d` also adds `native` for `native_decide` / `decide +native` and any axiom
   outside the standard three. Both print `#[]` for all five theorems, and `d`'s own proof has no
   `sorry` either.
3. **Axioms.** For each theorem, the axioms are exactly `[propext, Classical.choice, Quot.sound]`.
   The check is done in code and then shown by `#print axioms`.
4. **The single-file helper.** `RHSingleFile.freshCaches` is the only `def` the merge added. It is a
   `CoreM` program that `run_cmd` runs at each module start. No theorem uses it, as checked below,
   so it adds no axioms to them.
5. **`O1`.** `O1` below is a definition only: a new name for `Prop`. It states nothing, proves
   nothing and adds no axioms (`#print axioms O1`). No theorem refers to it.

No proof term was changed for this file. It only reads the environment built by ManyLineRH.lean. -/

/-- A definition only: `O1` is another name for `Prop`. It is not an axiom and asserts nothing. -/
def O1 : Type := Prop

#print axioms O1

-- 1. The statements
#print RiemannHypothesis
#print RiemannZetaZerosOnLine
#print DirichletLNonvanishingRightOfHalf
#print DirichletLZerosOnLine
#print PrimitiveDirichletLZerosOnLine
#check @riemannHypothesis
#check @riemannZeta_eq_zero_re
#check @LFunction_ne_zero_of_half_lt_re
#check @LFunction_eq_zero_re
#check @LFunction_eq_zero_re_of_isPrimitive

/-! # `restsOn`

From google-deepmind/formal-conjectures PR #8340
(https://github.com/google-deepmind/formal-conjectures/pull/8340), adapted to stand alone here.
`openSteps d` names every declaration reached from `d` whose own statement or proof is `sorry`;
`restsOn d` adds `native` for `native_decide` / `decide +native` and any axiom beyond
`propext`, `Classical.choice` and `Quot.sound`. An empty array means: rests on nothing open.
The check below makes this file fail to compile unless all five theorems rest on nothing. -/

namespace RestsOn
open Lean

/-- Drop compiler auxiliaries (`_proof_1`, `match_1`, private prefixes). -/
def userFacingName (n : Name) : Name := Id.run do
  let mut n := privateToUserName n
  while n.isInternal && !n.isAnonymous do
    n := n.getPrefix
  return n

/-- The open statements `declName` rests on, through any number of steps. -/
partial def openSteps (declName : Name) : CoreM (Array Name) := do
  let env := (← getEnv).setExporting false
  let rec visit (c : Name) (s : NameSet × NameSet) : CoreM (NameSet × NameSet) := do
    let (seen, found) := s
    if seen.contains c || c == ``sorryAx then return s
    let seen := seen.insert c
    unless (← collectAxioms c).contains ``sorryAx do return (seen, found)
    let some info := env.find? c | return (seen, found)
    let value? := info.value? (allowOpaque := true)
    let found :=
      if c != declName && (info.type.hasSorry || value?.any (·.hasSorry)) then
        found.insert (userFacingName c)
      else found
    let mut s := (seen, found)
    for d in info.type.getUsedConstants ++ (value?.map (·.getUsedConstants)).getD #[] do
      s ← visit d s
    if let .inductInfo v := info then
      for d in v.ctors do s ← visit d s
    return s
  let (_, found) ← visit declName ({}, {})
  return (found.erase (userFacingName declName)).toArray.qsort Name.lt

/-- The axioms every Mathlib proof may rest on. -/
def standardAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

/-- Everything `declName` rests on beyond `standardAxioms`. Empty: the statement is settled. -/
def restsOn (declName : Name) : CoreM (Array String) := do
  let axioms := (← collectAxioms declName).filter
    fun a => a != ``sorryAx && !standardAxioms.contains a
  let isNative (a : Name) := a.components.contains `_native
  let native := if axioms.any isNative then #["native"] else #[]
  let others := (axioms.filter (!isNative ·)).map Name.toString
  return (← openSteps declName).map Name.toString ++ native ++ others

end RestsOn

-- 2.–4. Nothing open, exact axioms, helper unused
open Lean in
/-- Whether `target` is reached from `declName` through the constants of types and values. -/
partial def RestsOn.reaches (declName target : Name) : CoreM Bool := do
  let env ← getEnv
  let rec go (todo : List Name) (seen : NameSet) : Bool :=
    match todo with
    | [] => false
    | c :: rest =>
      if c == target then true
      else if seen.contains c then go rest seen
      else
        let seen := seen.insert c
        match env.find? c with
        | none => go rest seen
        | some info =>
          let ds := info.type.getUsedConstants ++
            ((info.value? (allowOpaque := true)).map (·.getUsedConstants)).getD #[]
          go (ds.toList ++ rest) seen
  return go [declName] {}

open Lean in
#eval show CoreM Unit from do
  for d in [``riemannHypothesis, ``riemannZeta_eq_zero_re, ``LFunction_ne_zero_of_half_lt_re,
      ``LFunction_eq_zero_re, ``LFunction_eq_zero_re_of_isPrimitive] do
    let steps ← RestsOn.openSteps d
    let r ← RestsOn.restsOn d
    -- `restsOn` leaves out a `sorry` in `d`'s own proof (PR #8340 design), so check that too.
    let ownSorry := (← collectAxioms d).contains ``sorryAx
    let axs := ((← collectAxioms d).map Name.toString).qsort (· < ·)
    let usesHelper ← RestsOn.reaches d ``RHSingleFile.freshCaches
    let usesO1 ← RestsOn.reaches d ``O1
    IO.println s!"openSteps {d} = {steps}"
    IO.println s!"restsOn {d} = {r}"
    unless steps.isEmpty && r.isEmpty && !ownSorry do
      throwError "{d} rests on {r} (open steps {steps}, own sorry: {ownSorry})"
    unless axs == #["Classical.choice", "Quot.sound", "propext"] do
      throwError "{d} uses axioms {axs}"
    if usesHelper || usesO1 then
      throwError "{d} refers to freshCaches ({usesHelper}) or O1 ({usesO1})"
  IO.println "all five: axioms exactly [propext, Classical.choice, Quot.sound]; freshCaches and O1 unused"

#print axioms riemannHypothesis
#print axioms riemannZeta_eq_zero_re
#print axioms LFunction_ne_zero_of_half_lt_re
#print axioms LFunction_eq_zero_re
#print axioms LFunction_eq_zero_re_of_isPrimitive
#print axioms RHSingleFile.freshCaches
