{-# OPTIONS --safe #-}
module Prim.Data.Word where

open import Agda.Builtin.Word public
  using ( Word64 )
  renaming ( primWord64ToNat   to word64-to-ℕ
           ; primWord64FromNat to word64-from-ℕ )
