{-# OPTIONS --safe #-}
module Data.Empty.Instances.Finite where

open import Foundations.Base
open import Foundations.Equiv

open import Meta.Search.Finite.ManifestBishop

open import Data.Empty.Base
open import Data.Fin.Computational.Closure
open import Data.List.Base

instance
  ⊥-manifest-bishop-finite : Manifest-bishop-finite ⊥
  ⊥-manifest-bishop-finite = fin $ fin-0-is-initial ₑ⁻¹

  decomp-fin-⊥ : goal-decomposition (quote Manifest-bishop-finite) ⊥
  decomp-fin-⊥ = decomp (quote ⊥-manifest-bishop-finite) []
