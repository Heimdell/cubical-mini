{-# OPTIONS --safe #-}
module Correspondences.Discrete where

open import Foundations.Base
open import Foundations.HLevel.Base

open import Meta.Variadic

open import Correspondences.Base public
open import Correspondences.Decidable
open import Correspondences.Separated

open import Data.Dec.Base as Dec
open import Data.Dec.Path

open import Functions.Embedding

private variable
  ℓ ℓ′ : Level
  A : Type ℓ
  B : Type ℓ′

record is-discrete (A : Type ℓ) : Type ℓ where
  no-eta-equality
  constructor is-discrete-η
  field is-discrete-β : Dec on-paths-of A

open is-discrete public

is-discrete→is-¬¬-separated : is-discrete A → is-¬¬-separated A
is-discrete→is-¬¬-separated di _ _ = dec→essentially-classical (di .is-discrete-β _ _)

-- Hedberg
is-discrete→is-set : is-discrete A → is-set A
is-discrete→is-set = is-¬¬-separated→is-set ∘ is-discrete→is-¬¬-separated

opaque
  unfolding is-of-hlevel
  is-discrete-is-prop : is-prop (is-discrete A)
  is-discrete-is-prop d₁ d₂ i .is-discrete-β _ _ =
    dec-is-of-hlevel 1 (is-discrete→is-set d₁ _ _) (d₁ .is-discrete-β _ _) (d₂ .is-discrete-β _ _) i

instance
  H-Level-is-discrete : ∀ {n} → H-Level (suc n) (is-discrete A)
  H-Level-is-discrete = hlevel-prop-instance is-discrete-is-prop

is-discrete-injection : (A ↣ B) → is-discrete B → is-discrete A
is-discrete-injection (f , f-inj) B-dis .is-discrete-β x y =
  Dec.dmap f-inj
           (_∘ ap f)
           (B-dis .is-discrete-β (f x) (f y))

is-discrete-embedding : (A ↪ B) → is-discrete B → is-discrete A
is-discrete-embedding (f , f-emb) =
  is-discrete-injection (f , is-embedding→injective f-emb)


discrete : ⦃ d : is-discrete A ⦄ → is-discrete A
discrete ⦃ d ⦄ = d

Σ-is-discrete
  : ∀ {ℓ ℓ′} {A : Type ℓ} {B : A → Type ℓ′}
  → is-discrete A → Π[ is-discrete ∘ B ]
  → is-discrete Σ[ B ]
Σ-is-discrete {B} A-d B-d .is-discrete-β (a₁ , b₁) (a₂ , b₂) with A-d .is-discrete-β a₁ a₂
... | no  a₁≠a₂ = no $ a₁≠a₂ ∘ ap fst
... | yes a₁=a₂ with B-d _ .is-discrete-β (subst _ a₁=a₂ b₁) b₂
... | no  b₁≠b₂ = no λ r → b₁≠b₂ $ from-pathP $
  subst (λ X → ＜ b₁ ／ (λ i → B (X i)) ＼ b₂ ＞)
        (is-set-β (is-discrete→is-set A-d) a₁ a₂ (ap fst r) a₁=a₂)
        (ap snd r)
... | yes b₁=b₂ = yes $ Σ-path a₁=a₂ b₁=b₂

×-is-discrete : is-discrete A → is-discrete B
              → is-discrete (A × B)
×-is-discrete A-d B-d .is-discrete-β (a₁ , b₁) (a₂ , b₂) with A-d .is-discrete-β a₁ a₂
... | no  a₁≠a₂ = no $ a₁≠a₂ ∘ ap fst
... | yes a₁=a₂ with B-d .is-discrete-β b₁ b₂
... | no  b₁≠b₂ = no $ b₁≠b₂ ∘ ap snd
... | yes b₁=b₂ = yes $ Σ-pathP a₁=a₂ b₁=b₂

lift-is-discrete : is-discrete A → is-discrete (Lift ℓ A)
lift-is-discrete di .is-discrete-β (lift x) (lift y) =
  Dec.dmap (ap lift) (_∘ ap lower) (is-discrete-β di x y)
