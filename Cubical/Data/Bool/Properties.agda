{-# OPTIONS --safe #-}
module Cubical.Data.Bool.Properties where

open import Cubical.Core.Everything

open import Cubical.Functions.Involution

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Transport
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Pointed hiding (⌊_⌋)

open import Cubical.Data.Sum
open import Cubical.Data.Bool.Base
open import Cubical.Data.Empty
open import Cubical.Data.Empty as Empty
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit; Unit*; isPropUnit)

open import Cubical.Relation.Nullary

private
  variable
    ℓ : Level
    A : Type ℓ

notnot : ∀ x → not (not x) ≡ x
notnot true  = refl
notnot false = refl

notIso : Iso Bool Bool
Iso.fun notIso = not
Iso.inv notIso = not
Iso.rightInv notIso = notnot
Iso.leftInv notIso = notnot

notIsEquiv : isEquiv not
notIsEquiv = involIsEquiv {f = not} notnot

notEquiv : Bool ≃ Bool
notEquiv = involEquiv {f = not} notnot

@0 notEq : Bool ≡ Bool
notEq = involPath {f = not} notnot

private
  -- This computes to false as expected
  @0 nfalse : Bool
  nfalse = transp (λ i → notEq i) i0 true

  -- Sanity check
  nfalsepath : nfalse ≡ false
  nfalsepath = refl

discreteBool : Discrete Bool
discreteBool false false = yes refl
discreteBool false true  = no λ p → subst (λ b → if b then ⊥ else Bool) p true
discreteBool true  false = no λ p → subst (λ b → if b then Bool else ⊥) p true
discreteBool true  true  = yes refl

True : Dec A → Type₀
True Q = T ⌊ Q ⌋

False : Dec A → Type₀
False Q = T (not ⌊ Q ⌋)

toWitness : {Q : Dec A} → True Q → A
toWitness {Q = yes p} _ = p

toWitnessFalse : {Q : Dec A} → False Q → ¬ A
toWitnessFalse {Q = no ¬p} _ = ¬p

K-Bool
  : (P : {b : Bool} → b ≡ b → Type ℓ)
  → (∀{b} → P {b} refl)
  → ∀{b} → (q : b ≡ b) → P q
K-Bool P Pr {(false)} = J (λ{ false q → P q ; true _ → Lift ⊥ }) Pr
K-Bool P Pr {(true)}  = J (λ{ true q → P q ; false _ → Lift ⊥ }) Pr

isSetBool : isSet Bool
isSetBool a b = J (λ _ p → ∀ q → p ≡ q) (K-Bool (refl ≡_) refl)

true≢false : ¬ true ≡ false
true≢false p = subst (λ b → if b then Bool else ⊥) p true

false≢true : ¬ false ≡ true
false≢true p = subst (λ b → if b then ⊥ else Bool) p true

¬true→false : (x : Bool) → ¬ x ≡ true → x ≡ false
¬true→false false _ = refl
¬true→false true p = Empty.rec (p refl)

¬false→true : (x : Bool) → ¬ x ≡ false → x ≡ true
¬false→true false p = Empty.rec (p refl)
¬false→true true _ = refl

not≢const : ∀ x → ¬ not x ≡ x
not≢const false = true≢false
not≢const true  = false≢true

-- or properties
or-zeroˡ : ∀ x → true or x ≡ true
or-zeroˡ _ = refl

or-zeroʳ : ∀ x → x or true ≡ true
or-zeroʳ false = refl
or-zeroʳ true  = refl

or-identityˡ : ∀ x → false or x ≡ x
or-identityˡ _ = refl

or-identityʳ : ∀ x → x or false ≡ x
or-identityʳ false = refl
or-identityʳ true  = refl

or-comm      : ∀ x y → x or y ≡ y or x
or-comm false false = refl
or-comm false true  = refl
or-comm true  false = refl
or-comm true  true  = refl

or-assoc     : ∀ x y z → x or (y or z) ≡ (x or y) or z
or-assoc false y z = refl
or-assoc true  y z = refl

or-idem      : ∀ x → x or x ≡ x
or-idem false = refl
or-idem true  = refl

-- and properties
and-zeroˡ : ∀ x → false and x ≡ false
and-zeroˡ _ = refl

and-zeroʳ : ∀ x → x and false ≡ false
and-zeroʳ false = refl
and-zeroʳ true  = refl

and-identityˡ : ∀ x → true and x ≡ x
and-identityˡ _ = refl

and-identityʳ : ∀ x → x and true ≡ x
and-identityʳ false = refl
and-identityʳ true  = refl

and-comm      : ∀ x y → x and y ≡ y and x
and-comm false false = refl
and-comm false true  = refl
and-comm true  false = refl
and-comm true  true  = refl

and-assoc     : ∀ x y z → x and (y and z) ≡ (x and y) and z
and-assoc false y z = refl
and-assoc true  y z = refl

and-idem      : ∀ x → x and x ≡ x
and-idem false = refl
and-idem true  = refl

-- xor properties
⊕-identityʳ : ∀ x → x ⊕ false ≡ x
⊕-identityʳ false = refl
⊕-identityʳ true = refl

⊕-comm : ∀ x y → x ⊕ y ≡ y ⊕ x
⊕-comm false false = refl
⊕-comm false true  = refl
⊕-comm true  false = refl
⊕-comm true  true  = refl

⊕-assoc : ∀ x y z → x ⊕ (y ⊕ z) ≡ (x ⊕ y) ⊕ z
⊕-assoc false y z = refl
⊕-assoc true false z = refl
⊕-assoc true true z = notnot z

not-⊕ˡ : ∀ x y → not (x ⊕ y) ≡ not x ⊕ y
not-⊕ˡ false y = refl
not-⊕ˡ true  y = notnot y

⊕-invol : ∀ x y → x ⊕ (x ⊕ y) ≡ y
⊕-invol false x = refl
⊕-invol true  x = notnot x

isEquiv-⊕ : ∀ x → isEquiv (x ⊕_)
isEquiv-⊕ x = involIsEquiv (⊕-invol x)

@0 ⊕-Path : ∀ x → Bool ≡ Bool
⊕-Path x = involPath {f = x ⊕_} (⊕-invol x)

@0 ⊕-Path-refl : ⊕-Path false ≡ refl
⊕-Path-refl = isInjectiveTransport refl

¬transportNot : ∀(P : Bool ≡ Bool) b → ¬ (transport P (not b) ≡ transport P b)
¬transportNot P b eq = not≢const b sub
  where
  sub : not b ≡ b
  sub = subst {A = Bool → Bool} (λ f → f (not b) ≡ f b)
          (λ i c → transport⁻Transport P c i) (cong (transport⁻ P) eq)

module BoolReflection where
  data Table (A : Type₀) (P : Bool ≡ A) : Type₀ where
    inspect : (b c : A)
            → transport P false ≡ b
            → transport P true ≡ c
            → Table A P

  table : ∀ P → Table Bool P
  table = J Table (inspect false true refl refl)

  reflLemma : (P : Bool ≡ Bool)
         → transport P false ≡ false
         → transport P true ≡ true
         → transport P ≡ transport (⊕-Path false)
  reflLemma P ff tt i false = ff i
  reflLemma P ff tt i true = tt i

  notLemma : (P : Bool ≡ Bool)
         → transport P false ≡ true
         → transport P true ≡ false
         → transport P ≡ transport (⊕-Path true)
  notLemma P ft tf i false = ft i
  notLemma P ft tf i true  = tf i

  @0 categorize : ∀ P → transport P ≡ transport (⊕-Path (transport P false))
  categorize P with table P
  categorize P | inspect false true p q
    = subst (λ b → transport P ≡ transport (⊕-Path b)) (sym p) (reflLemma P p q)
  categorize P | inspect true false p q
    = subst (λ b → transport P ≡ transport (⊕-Path b)) (sym p) (notLemma P p q)
  categorize P | inspect false false p q
    = Empty.rec (¬transportNot P false (q ∙ sym p))
  categorize P | inspect true true p q
    = Empty.rec (¬transportNot P false (q ∙ sym p))

  @0 ⊕-complete : ∀ P → P ≡ ⊕-Path (transport P false)
  ⊕-complete P = isInjectiveTransport (categorize P)

  @0 ⊕-comp : ∀ p q → ⊕-Path p ∙ ⊕-Path q ≡ ⊕-Path (q ⊕ p)
  ⊕-comp p q = isInjectiveTransport (λ i x → ⊕-assoc q p x i)

  open Iso

  @0 reflectIso : Iso Bool (Bool ≡ Bool)
  reflectIso .fun = ⊕-Path
  reflectIso .inv P = transport P false
  reflectIso .leftInv = ⊕-identityʳ
  reflectIso .rightInv P = sym (⊕-complete P)

  @0 reflectEquiv : Bool ≃ (Bool ≡ Bool)
  reflectEquiv = isoToEquiv reflectIso

_≤_ : Bool → Bool → Type
true ≤ false = ⊥
_ ≤ _ = Unit

_≥_ : Bool → Bool → Type
false ≥ true = ⊥
_ ≥ _ = Unit

isProp≤ : ∀ b c → isProp (b ≤ c)
isProp≤  true false = isProp⊥
isProp≤  true  true = isPropUnit
isProp≤ false false = isPropUnit
isProp≤ false  true = isPropUnit

isProp≥ : ∀ b c → isProp (b ≥ c)
isProp≥ false  true = isProp⊥
isProp≥  true  true = isPropUnit
isProp≥ false false = isPropUnit
isProp≥  true false = isPropUnit

isProp-T : ∀ b → isProp (T b)
isProp-T false = isProp⊥
isProp-T true = isPropUnit

isPropDep-T : isPropDep T
isPropDep-T = isOfHLevel→isOfHLevelDep 1 isProp-T

IsoBool→∙ : ∀ {ℓ} {A : Pointed ℓ} → Iso ((Bool , true) →∙ A) (typ A)
Iso.fun IsoBool→∙ f = fst f false
fst (Iso.inv IsoBool→∙ a) false = a
fst (Iso.inv (IsoBool→∙ {A = A}) a) true = pt A
snd (Iso.inv IsoBool→∙ a) = refl
Iso.rightInv IsoBool→∙ a = refl
Iso.leftInv IsoBool→∙ (f , p) =
  ΣPathP ((funExt (λ { false → refl ; true → sym p}))
        , λ i j → p (~ i ∨ j))

-- import here to avoid conflicts
open import Cubical.Data.Unit

-- relation to hProp

BoolProp≃BoolProp* : {a : Bool} → T a ≃ T* {ℓ} a
BoolProp≃BoolProp* {a = true} = Unit≃Unit*
BoolProp≃BoolProp* {a = false} = uninhabEquiv (λ x → Empty.rec x) (λ x → Empty.rec* x)

TInj : (a b : Bool) → T a ≃ T b → a ≡ b
TInj true true _ = refl
TInj true false p = Empty.rec (p .fst tt)
TInj false true p = Empty.rec (invEq p tt)
TInj false false _ = refl

TInj* : (a b : Bool) → T* {ℓ} a ≃ T* {ℓ} b → a ≡ b
TInj* true true _ = refl
TInj* true false p = Empty.rec* (p .fst tt*)
TInj* false true p = Empty.rec* (invEq p tt*)
TInj* false false _ = refl

isPropT : {a : Bool} → isProp (T a)
isPropT {a = true} = isPropUnit
isPropT {a = false} = isProp⊥

isPropT* : {a : Bool} → isProp (T* {ℓ} a)
isPropT* {a = true} = isPropUnit*
isPropT* {a = false} = isProp⊥*

DecT : {a : Bool} → Dec (T a)
DecT {a = true} = yes tt
DecT {a = false} = no (λ x → x)

DecT* : {a : Bool} → Dec (T* {ℓ} a)
DecT* {a = true} = yes tt*
DecT* {a = false} = no (λ (lift x) → x)

Dec→DecBool : {P : Type ℓ} → (dec : Dec P) → P → T ⌊ dec ⌋
Dec→DecBool (yes p) _ = tt
Dec→DecBool (no ¬p) q = Empty.rec (¬p q)

DecBool→Dec : {P : Type ℓ} → (dec : Dec P) → T ⌊ dec ⌋ → P
DecBool→Dec (yes p) _ = p

Dec≃DecBool : {P : Type ℓ} → (h : isProp P)(dec : Dec P) → P ≃ T ⌊ dec ⌋
Dec≃DecBool h dec = propBiimpl→Equiv h isPropT (Dec→DecBool dec) (DecBool→Dec dec)

Bool≡BoolDec : {a : Bool} → a ≡ ⌊ DecT {a = a} ⌋
Bool≡BoolDec {a = true} = refl
Bool≡BoolDec {a = false} = refl

Dec→DecBool* : {P : Type ℓ} → (dec : Dec P) → P → T* {ℓ} ⌊ dec ⌋
Dec→DecBool* (yes p) _ = tt*
Dec→DecBool* (no ¬p) q = Empty.rec (¬p q)

DecBool→Dec* : {P : Type ℓ} → (dec : Dec P) → T* {ℓ} ⌊ dec ⌋ → P
DecBool→Dec* (yes p) _ = p

Dec≃DecBool* : {P : Type ℓ} → (h : isProp P)(dec : Dec P) → P ≃ T* {ℓ} ⌊ dec ⌋
Dec≃DecBool* h dec = propBiimpl→Equiv h isPropT* (Dec→DecBool* dec) (DecBool→Dec* dec)

Bool≡BoolDec* : {a : Bool} → a ≡ ⌊ DecT* {ℓ} {a = a} ⌋
Bool≡BoolDec* {a = true} = refl
Bool≡BoolDec* {a = false} = refl

T× : (a b : Bool) → T (a and b) → T a × T b
T× true true _ = tt , tt
T× true false p = Empty.rec p
T× false true p = Empty.rec p
T× false false p = Empty.rec p

T×' : (a b : Bool) → T a × T b → T (a and b)
T×' true true _ = tt
T×' true false (_ , p) = Empty.rec p
T×' false true (p , _) = Empty.rec p
T×' false false (p , _) = Empty.rec p

T×≃ : (a b : Bool) → T a × T b ≃ T (a and b)
T×≃ a b =
  propBiimpl→Equiv (isProp× isPropT isPropT) isPropT
    (T×' a b) (T× a b)

T⊎ : (a b : Bool) → T (a or b) → T a ⊎ T b
T⊎ true true _ = inl tt
T⊎ true false _ = inl tt
T⊎ false true _ = inr tt
T⊎ false false p = Empty.rec p

T⊎' : (a b : Bool) → T a ⊎ T b → T (a or b)
T⊎' true true _ = tt
T⊎' true false _ = tt
T⊎' false true _ = tt
T⊎' false false (inl p) = Empty.rec p
T⊎' false false (inr p) = Empty.rec p

PropBoolP→P : (dec : Dec A) → T ⌊ dec ⌋ → A
PropBoolP→P (yes p) _ = p

P→PropBoolP : (dec : Dec A) → A → T ⌊ dec ⌋
P→PropBoolP (yes p) _ = tt
P→PropBoolP (no ¬p) = ¬p

Bool≡ : Bool → Bool → Bool
Bool≡ true true = true
Bool≡ true false = false
Bool≡ false true = false
Bool≡ false false = true

Bool≡≃ : (a b : Bool) → (a ≡ b) ≃ T (Bool≡ a b)
Bool≡≃ true true = isContr→≃Unit (inhProp→isContr refl (isSetBool _ _))
Bool≡≃ true false = uninhabEquiv true≢false (λ x → Empty.rec x)
Bool≡≃ false true = uninhabEquiv false≢true (λ x → Empty.rec x)
Bool≡≃ false false = isContr→≃Unit (inhProp→isContr refl (isSetBool _ _))
open Iso

-- Bool is equivalent to bi-point type

Iso-⊤⊎⊤-Bool : Iso (Unit ⊎ Unit) Bool
Iso-⊤⊎⊤-Bool .fun (inl tt) = true
Iso-⊤⊎⊤-Bool .fun (inr tt) = false
Iso-⊤⊎⊤-Bool .inv true = inl tt
Iso-⊤⊎⊤-Bool .inv false = inr tt
Iso-⊤⊎⊤-Bool .leftInv (inl tt) = refl
Iso-⊤⊎⊤-Bool .leftInv (inr tt) = refl
Iso-⊤⊎⊤-Bool .rightInv true = refl
Iso-⊤⊎⊤-Bool .rightInv false = refl
