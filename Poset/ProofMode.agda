module Poset.ProofMode where

open import Prelude
open import Poset.Poset
open import Poset.Fun
open import Poset.Classes
open import Poset.Lib

abstract
  ⟬_⟭ : ∀ {ℓ} {A : Poset ℓ} (x : ⟪ A ⟫) → ⟪ A ⟫
  ⟬ x ⟭ = x

  unfold[⟬_⟭] : ∀ {ℓ} {A : Poset ℓ} (x : ⟪ A ⟫) → ⟬ x ⟭ ≡ x
  unfold[⟬ x ⟭] = ↯

inj[⟬⟭] : ∀ {ℓ} {A : Poset ℓ} {x y : ⟪ A ⟫} → ⟬ x ⟭ ≡ ⟬ y ⟭ → x ≡ y
inj[⟬⟭] {x = x} {y} rewrite unfold[⟬ x ⟭] | unfold[⟬ y ⟭] = id
  
_⦉_⦊_⇰_ : ∀ {ℓ₁} ℓ₂ {A : Poset ℓ₁} (_R_ : ∀ {ℓ} {A : Poset ℓ} → relation ℓ ⟪ A ⟫) → relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₂) ⟪ A ⟫
_⦉_⦊_⇰_ ℓ₂ {A} _R_ x₁ x₂ = ∀ {B : Poset ℓ₂} {y : ⟪ B ⟫} {k : ⟪ A ↗ B ⟫} → (k ⋅ x₂) R y → (k ⋅ x₁) R y 

module ProofMode
  (_R_ : ∀ {ℓ} {A : Poset ℓ} → relation ℓ ⟪ A ⟫)
  {{R-Refl : ∀ {ℓ} {A : Poset ℓ} → Reflexive (_R_ {A = A})}}
  {{R-Transitive : ∀ {ℓ} {A : Poset ℓ} → Transitive (_R_ {A = A})}}
  {{R-Logical : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {B : Poset ℓ₂} → Logical[↗] (_R_ {A = A}) (_R_ {A = B}) (_R_ {A = A ↗ B})}}
  (_⦉R⦊_⇰_ : ∀ {ℓ₁} ℓ₂ {A : Poset ℓ₁} → relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₂) ⟪ A ⟫)
  (mk[⇰] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → ℓ₂ ⦉ _R_ ⦊ x₁ ⇰ x₂ → ℓ₂ ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭)
  (un[⇰] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → ℓ₂ ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭ → ℓ₂ ⦉ _R_ ⦊ x₁ ⇰ x₂)
  where
  [proof-mode]_∎ : ∀ {ℓ} {A : Poset ℓ} {x₁ x₂ : ⟪ A ⟫} → ℓ ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭ → x₁ R x₂
  [proof-mode] F ∎ = un[⇰] F {k = id♮} (xRx {{R-Refl}})

  infixr 0  _‣_
  _‣_ : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ x₃ : ⟪ A ⟫} → ℓ₂ ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭ → ℓ₂ ⦉R⦊ ⟬ x₂ ⟭ ⇰ ⟬ x₃ ⟭ → ℓ₂ ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₃ ⟭
  _‣_ G F = mk[⇰] $ λ {B} {y} {k} → un[⇰] G {k = k} ∘ un[⇰] F {k = k}

  [[_]] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} (x : ⟪ A ⟫) → ℓ₂ ⦉R⦊ ⟬ x ⟭ ⇰ ⟬ x ⟭
  [[ x ]] = mk[⇰] id

  ⟅_⟆ : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → x₁ R x₂ → ℓ₂ ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭
  ⟅ x₁Rx₂ ⟆ = mk[⇰] $ λ {B} {y} {k} P → _⊚_ {{R-Transitive}} P (res[•x][↗] {f = k} x₁Rx₂)

  ⟅_⟆⸢≡⸣ : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} → {x₁ x₂ : ⟪ A ⟫} (P : x₁ ≡ x₂) → ℓ₂ ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭
  ⟅ x₁≡x₂ ⟆⸢≡⸣ = ⟅ xRx[≡] x₁≡x₂ ⟆

  [focus-in_] :
    ∀ {ℓ₁ ℓ₂ ℓ₃} {A : Poset ℓ₁} {B : Poset ℓ₂} (op : ⟪ A ↗ B ⟫) {x : ⟪ A ⟫} {y : ⟪ A ⟫}
    → ℓ₃ ⦉R⦊ ⟬ x ⟭ ⇰ ⟬ y ⟭ → ℓ₃ ⦉R⦊ ⟬ op ⋅ x ⟭ ⇰ ⟬ op ⋅ y ⟭
  [focus-in op ] x⇰y = mk[⇰] $ λ {D} {z} {k} → un[⇰] x⇰y {k = k ∘♮ op}

  [focus-left_𝑜𝑓_] :
    ∀ {ℓ₁ ℓ₂ ℓ₃ ℓ₄} {A : Poset ℓ₁} {B : Poset ℓ₂} {C : Poset ℓ₃} (op : ⟪ A ↗ B ↗ C ⟫) (z : ⟪ B ⟫) {x y : ⟪ A ⟫} 
    → ℓ₄ ⦉R⦊ ⟬ x ⟭ ⇰ ⟬ y ⟭ → ℓ₄ ⦉R⦊ ⟬ op ⋅ x ⋅ z ⟭ ⇰ ⟬ op ⋅ y ⋅ z ⟭
  [focus-left op 𝑜𝑓 z ] x⇰y = mk[⇰] $ λ {_ _ k} → un[⇰] x⇰y {k = k ∘♮ flip♮ ⋅ op ⋅ z}

  [focus-right_𝑜𝑓_] :
    ∀ {ℓ₁ ℓ₂ ℓ₃ ℓ₄} {A : Poset ℓ₁} {B : Poset ℓ₂} {C : Poset ℓ₃} (op : ⟪ A ↗ B ↗ C ⟫) (z : ⟪ A ⟫) {x y : ⟪ B ⟫}
    → ℓ₄ ⦉R⦊ ⟬ x ⟭ ⇰ ⟬ y ⟭ → ℓ₄ ⦉R⦊ ⟬ op ⋅ z ⋅ x ⟭ ⇰ ⟬ op ⋅ z ⋅ y ⟭
  [focus-right op 𝑜𝑓 z ] x⇰y = mk[⇰] $ λ {_ _ k} → un[⇰] x⇰y {k = k ∘♮ op ⋅ z}

  module §-Reflexive[≈]
    {{R-Refl[≈] : ∀ {ℓ} {A : Poset ℓ} → Reflexive[ _≈♮_ ] (_R_ {A = A})}}
    where
    ⟅_⟆⸢≈⸣ : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} → {x₁ x₂ : ⟪ A ⟫} (P : x₁ ≈♮ x₂) → ℓ₂ ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭
    ⟅ x₁≈x₂ ⟆⸢≈⸣ = ⟅ xRx[] x₁≈x₂ ⟆

data _⦉⊑⦊_⇰_ {ℓ₁} ℓ₂ {A : Poset ℓ₁} : relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₂) ⟪ A ⟫ where
  mk[⦉⊑⦊]-≡ : ∀ {x₁ x₂ x₃ x₄ : ⟪ A ⟫} → x₃ ≡ ⟬ x₁ ⟭ → x₄ ≡ ⟬ x₂ ⟭ → ℓ₂ ⦉ _⊑♮_ ⦊ x₁ ⇰ x₂ → ℓ₂ ⦉⊑⦊ x₃ ⇰ x₄

mk[⦉⊑⦊] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → ℓ₂ ⦉ _⊑♮_ ⦊ x₁ ⇰ x₂ → ℓ₂ ⦉⊑⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭
mk[⦉⊑⦊] = mk[⦉⊑⦊]-≡ ↯ ↯

un[⦉⊑⦊] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → ℓ₂ ⦉⊑⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭ → ℓ₂ ⦉ _⊑♮_ ⦊ x₁ ⇰ x₂
un[⦉⊑⦊] (mk[⦉⊑⦊]-≡ E₁ E₂ P) rewrite inj[⟬⟭] E₁ | inj[⟬⟭] E₂ = λ {B} {y} {k} → P {B} {y} {k}

module ProofMode[⊑] where
  open ProofMode _⊑♮_ _⦉⊑⦊_⇰_ mk[⦉⊑⦊] un[⦉⊑⦊] public
  open §-Reflexive[≈] public

open ProofMode[⊑] using () renaming
  ( [proof-mode]_∎     to [proof-mode]⸢⊑⸣_∎
  ; _‣_                to _‣⸢⊑⸣_
  ; [[_]]              to [[_]]⸢⊑⸣
  ; ⟅_⟆                to ⟅_⟆⸢⊑⸣
  ; ⟅_⟆⸢≡⸣             to ⟅_⟆⸢⊑-≡⸣
  ; [focus-in_]        to [focus-in_]⸢⊑⸣
  ; [focus-left_𝑜𝑓_]   to [focus-left_𝑜𝑓_]⸢⊑⸣
  ; [focus-right_𝑜𝑓_]  to [focus-right_𝑜𝑓_]⸢⊑⸣
  ; ⟅_⟆⸢≈⸣             to ⟅_⟆⸢⊑-≈⸣
  ) public

data _⦉≈⦊_⇰_ {ℓ₁} ℓ₂ {A : Poset ℓ₁} : relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₂) ⟪ A ⟫ where
  mk[⦉≈⦊]-≡ : ∀ {x₁ x₂ x₃ x₄ : ⟪ A ⟫} → x₃ ≡ ⟬ x₁ ⟭ → x₄ ≡ ⟬ x₂ ⟭ → ℓ₂ ⦉ _≈♮_ ⦊ x₁ ⇰ x₂ → ℓ₂ ⦉≈⦊ x₃ ⇰ x₄

mk[⦉≈⦊] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → ℓ₂ ⦉ _≈♮_ ⦊ x₁ ⇰ x₂ → ℓ₂ ⦉≈⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭
mk[⦉≈⦊] = mk[⦉≈⦊]-≡ ↯ ↯

un[⦉≈⦊] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → ℓ₂ ⦉≈⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭ → ℓ₂ ⦉ _≈♮_ ⦊ x₁ ⇰ x₂
un[⦉≈⦊] (mk[⦉≈⦊]-≡ E₁ E₂ P) rewrite inj[⟬⟭] E₁ | inj[⟬⟭] E₂ = λ {B} {y} {k} → P {B} {y} {k}

module ProofMode[≈] where
  open ProofMode _≈♮_ _⦉≈⦊_⇰_ mk[⦉≈⦊] un[⦉≈⦊] public
open ProofMode[≈] using () renaming
  ( [proof-mode]_∎    to [proof-mode]⸢≈⸣_∎
  ; _‣_                to _‣⸢≈⸣_
  ; [[_]]            to [[_]]⸢≈⸣
  ; ⟅_⟆              to ⟅_⟆⸢≈-≈⸣
  ; ⟅_⟆⸢≡⸣            to ⟅_⟆⸢≈-≡⸣
  ; [focus-in_]       to [focus-in_]⸢≈⸣
  ; [focus-left_𝑜𝑓_]  to [focus-left_𝑜𝑓_]⸢≈⸣
  ; [focus-right_𝑜𝑓_] to [focus-right_𝑜𝑓_]⸢≈⸣
  ) public

data _⦉≡⦊_⇰_ {ℓ₁} ℓ₂ {A : Poset ℓ₁} : relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₂) ⟪ A ⟫ where
  mk[⦉≡⦊]-≡ : ∀ {x₁ x₂ x₃ x₄ : ⟪ A ⟫} → x₃ ≡ ⟬ x₁ ⟭ → x₄ ≡ ⟬ x₂ ⟭ → ℓ₂ ⦉ _≡_ ⦊ x₁ ⇰ x₂ → ℓ₂ ⦉≡⦊ x₃ ⇰ x₄

mk[⦉≡⦊] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → ℓ₂ ⦉ _≡_ ⦊ x₁ ⇰ x₂ → ℓ₂ ⦉≡⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭
mk[⦉≡⦊] = mk[⦉≡⦊]-≡ ↯ ↯

un[⦉≡⦊] : ∀ {ℓ₁ ℓ₂} {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → ℓ₂ ⦉≡⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭ → ℓ₂ ⦉ _≡_ ⦊ x₁ ⇰ x₂
un[⦉≡⦊] (mk[⦉≡⦊]-≡ E₁ E₂ P) rewrite inj[⟬⟭] E₁ | inj[⟬⟭] E₂ = λ {B} {y} {k} → P {B} {y} {k}

module ProofMode[≡] where
  open ProofMode _≡_ _⦉≡⦊_⇰_ mk[⦉≡⦊] un[⦉≡⦊] public
open ProofMode[≡] using () renaming
  ( [proof-mode]_∎     to [proof-mode]⸢≡⸣_∎
  ; _‣_                to _‣⸢≡⸣_
  ; [[_]]              to [[_]]⸢≡⸣
  ; ⟅_⟆                to ⟅_⟆⸢≡-≡⸣
  ; [focus-in_]        to [focus-in_]⸢≡⸣
  ; [focus-left_𝑜𝑓_]   to [focus-left_𝑜𝑓_]⸢≡⸣
  ; [focus-right_𝑜𝑓_]  to [focus-right_𝑜𝑓_]⸢≡⸣
  ) public

-- record ProofMode {ℓ} (_R_ : ∀ {A : Poset ℓ} → relation ℓ ⟪ A ⟫) (⦉R⦊_⇰_ : ∀ {A : Poset ℓ} → relation (↑ᴸ ℓ) ⟪ A ⟫) : Set (↑ᴸ ℓ) where
--   field
--     [proof-mode]_∎ : ∀ {A : Poset ℓ} {x₁ x₂ : ⟪ A ⟫} → ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭ → x₁ R x₂
-- open ProofMode {{...}} public
-- 
-- record ProofState {ℓ₁ ℓ₂} (⦉R⦊_⇰_ : ∀ {A : Poset ℓ₁} → relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₂) ⟪ A ⟫) : Set (↑ᴸ (ℓ₁ ⊔ᴸ ℓ₂)) where
--   infixr 0 _‣_
--   field
--     _‣_ : ∀ {A : Poset ℓ₁} {x₁ x₂ x₃ : ⟪ A ⟫} → ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭ → ⦉R⦊ ⟬ x₂ ⟭ ⇰ ⟬ x₃ ⟭ → ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₃ ⟭
--     [[_]] : ∀ {A : Poset ℓ₁} (x : ⟪ A ⟫) → ⦉R⦊ ⟬ x ⟭ ⇰ ⟬ x ⟭
-- open ProofState {{...}} public
-- 
-- record ProofStep {ℓ₁ ℓ₂} (_R_ : ∀ {A : Poset ℓ₁} → relation ℓ₁ ⟪ A ⟫) (⦉R⦊_⇰_ : ∀ {A : Poset ℓ₁} → relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₂) ⟪ A ⟫) : Set (↑ᴸ (ℓ₁ ⊔ᴸ ℓ₂)) where
--   field
--     ⟅_⟆ : ∀ {A : Poset ℓ₁} {x₁ x₂ : ⟪ A ⟫} → x₁ R x₂ → ⦉R⦊ ⟬ x₁ ⟭ ⇰ ⟬ x₂ ⟭
-- open ProofStep {{...}} public
-- 
-- record ProofFocusIn {ℓ₁ ℓ₂ ℓ₃}
--   (⦉R⦊₁_⇰_ : ∀ {A : Poset ℓ₁} → relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₃) ⟪ A ⟫)
--   (⦉R⦊₂_⇰_ : ∀ {A : Poset ℓ₂} → relation (ℓ₂ ⊔ᴸ ↑ᴸ ℓ₃) ⟪ A ⟫)
--   : Set (↑ᴸ (ℓ₁ ⊔ᴸ ℓ₂ ⊔ᴸ ℓ₃)) where
--   field
--     [focus-in_] : ∀ {A : Poset ℓ₁} {B : Poset ℓ₂} (op : ⟪ A ↗ B ⟫) {x : ⟪ A ⟫} {y : ⟪ A ⟫} → ⦉R⦊₁ ⟬ x ⟭ ⇰ ⟬ y ⟭ → ⦉R⦊₂ ⟬ op ⋅ x ⟭ ⇰ ⟬ op ⋅ y ⟭
-- open ProofFocusIn {{...}} public
-- 
-- record ProofFocusLeft {ℓ₁ ℓ₂ ℓ₃ ℓ₄}
--   (⦉R⦊₁_⇰_ : ∀ {A : Poset ℓ₁} → relation (ℓ₁ ⊔ᴸ ↑ᴸ ℓ₄) ⟪ A ⟫)
--   (⦉R⦊₃_⇰_ : ∀ {A : Poset ℓ₃} → relation (ℓ₃ ⊔ᴸ ↑ᴸ ℓ₄) ⟪ A ⟫)
--   : Set (↑ᴸ (ℓ₁ ⊔ᴸ ℓ₂ ⊔ᴸ ℓ₃ ⊔ᴸ ℓ₄)) where
--   field
--     [focus-left_𝑜𝑓_] :
--       ∀ {A : Poset ℓ₁} {B : Poset ℓ₂} {C : Poset ℓ₃} (op : ⟪ A ↗ B ↗ C ⟫) (z : ⟪ B ⟫) {x y : ⟪ A ⟫} 
--       → ⦉R⦊₁ ⟬ x ⟭ ⇰ ⟬ y ⟭ → ⦉R⦊₃ ⟬ op ⋅ x ⋅ z ⟭ ⇰ ⟬ op ⋅ y ⋅ z ⟭
-- open ProofFocusLeft {{...}} public
-- 
-- record ProofFocusRight {ℓ₁ ℓ₂ ℓ₃ ℓ₄}
--   (⦉R⦊₂_⇰_ : ∀ {A : Poset ℓ₂} → relation (ℓ₂ ⊔ᴸ ↑ᴸ ℓ₄) ⟪ A ⟫)
--   (⦉R⦊₃_⇰_ : ∀ {A : Poset ℓ₃} → relation (ℓ₃ ⊔ᴸ ↑ᴸ ℓ₄) ⟪ A ⟫)
--   : Set (↑ᴸ (ℓ₁ ⊔ᴸ ℓ₂ ⊔ᴸ ℓ₃ ⊔ᴸ ℓ₄)) where
--   field
--     [focus-right_𝑜𝑓_] :
--       ∀ {A : Poset ℓ₁} {B : Poset ℓ₂} {C : Poset ℓ₃} (op : ⟪ A ↗ B ↗ C ⟫) (z : ⟪ A ⟫) {x y : ⟪ B ⟫}
--       → ⦉R⦊₂ ⟬ x ⟭ ⇰ ⟬ y ⟭ → ⦉R⦊₃ ⟬ op ⋅ z ⋅ x ⟭ ⇰ ⟬ op ⋅ z ⋅ y ⟭
-- open ProofFocusRight {{...}} public

-- instance
--   ProofMode[⊑] : ∀ {ℓ} → ProofMode {ℓ} _⊑_ (_⦉⊑⦊_⇰_ ℓ)
--   ProofMode[⊑] = record { [proof-mode]_∎ = ProofMode[⊑].[R-proof-mode]_∎ }
--   ProofState[⊑] : ∀ {ℓ₁ ℓ₂} → ProofState {ℓ₁} {ℓ₂} (_⦉⊑⦊_⇰_ ℓ₂)
--   ProofState[⊑] = record { _‣_ = ProofMode[⊑]._R‣_ ; [[_]] = ProofMode[⊑].[R][[_]]}
--   ProofStep[⊑] : ∀ {ℓ₁ ℓ₂} → ProofStep {ℓ₁} {ℓ₂} _⊑_ (_⦉⊑⦊_⇰_ ℓ₂)
--   ProofStep[⊑] = record { ⟅_⟆ = ProofMode[⊑].[R]⟅_⟆ }
--   ProofStep[⊑-≡] : ∀ {ℓ₁ ℓ₂} → ProofStep {ℓ₁} {ℓ₂} _≡_ (_⦉⊑⦊_⇰_ ℓ₂)
--   ProofStep[⊑-≡] = record { ⟅_⟆ = ProofMode[⊑].[R-≡]⟅_⟆ }
--   ProofStep[⊑-≈] : ∀ {ℓ₁ ℓ₂} → ProofStep {ℓ₁} {ℓ₂} _≈_ (_⦉⊑⦊_⇰_ ℓ₂)
--   ProofStep[⊑-≈] = record { ⟅_⟆ = ProofMode[⊑].§-Reflexive[≈].[R-≈]⟅_⟆ }
--   ProofFocusIn[⊑] : ∀ {ℓ₁ ℓ₂ ℓ₃} → ProofFocusIn {ℓ₁} {ℓ₂} {ℓ₃} (_⦉⊑⦊_⇰_ ℓ₃) (_⦉⊑⦊_⇰_ ℓ₃)
--   ProofFocusIn[⊑] = record { [focus-in_] = ProofMode[⊑].[R-focus-in_] }
--   ProofFocusLeft[⊑] : ∀ {ℓ₁ ℓ₂ ℓ₃ ℓ₄} → ProofFocusLeft {ℓ₁} {ℓ₂} {ℓ₃} {ℓ₄} (_⦉⊑⦊_⇰_ ℓ₄) (_⦉⊑⦊_⇰_ ℓ₄)
--   ProofFocusLeft[⊑] = record { [focus-left_𝑜𝑓_] = ProofMode[⊑].[R-focus-left_𝑜𝑓_] }
--   ProofFocusRight[⊑] : ∀ {ℓ₁ ℓ₂ ℓ₃ ℓ₄} → ProofFocusRight {ℓ₁} {ℓ₂} {ℓ₃} {ℓ₄} (_⦉⊑⦊_⇰_ ℓ₄) (_⦉⊑⦊_⇰_ ℓ₄)
--   ProofFocusRight[⊑] = record { [focus-right_𝑜𝑓_] = ProofMode[⊑].[R-focus-right_𝑜𝑓_] }
-- 
-- instance
--   ProofMode[≈] : ∀ {ℓ} → ProofMode {ℓ} _≈_ (_⦉≈⦊_⇰_ ℓ)
--   ProofMode[≈] = record { [proof-mode]_∎ = ProofMode[≈].[R-proof-mode]_∎ }
--   ProofState[≈] : ∀ {ℓ₁ ℓ₂} → ProofState {ℓ₁} {ℓ₂} (_⦉≈⦊_⇰_ ℓ₂)
--   ProofState[≈] = record { _‣_ = ProofMode[≈]._R‣_ ; [[_]] = ProofMode[≈].[R][[_]]}
--   ProofStep[≈] : ∀ {ℓ₁ ℓ₂} → ProofStep {ℓ₁} {ℓ₂} _≈_ (_⦉≈⦊_⇰_ ℓ₂)
--   ProofStep[≈] = record { ⟅_⟆ = ProofMode[≈].[R]⟅_⟆ }
--   ProofStep[≈-≡] : ∀ {ℓ₁ ℓ₂} → ProofStep {ℓ₁} {ℓ₂} _≡_ (_⦉≈⦊_⇰_ ℓ₂)
--   ProofStep[≈-≡] = record { ⟅_⟆ = ProofMode[≈].[R-≡]⟅_⟆ }
--   ProofFocusIn[≈] : ∀ {ℓ₁ ℓ₂ ℓ₃} → ProofFocusIn {ℓ₁} {ℓ₂} {ℓ₃} (_⦉≈⦊_⇰_ ℓ₃) (_⦉≈⦊_⇰_ ℓ₃)
--   ProofFocusIn[≈] = record { [focus-in_] = ProofMode[≈].[R-focus-in_] }
--   ProofFocusLeft[≈] : ∀ {ℓ₁ ℓ₂ ℓ₃ ℓ₄} → ProofFocusLeft {ℓ₁} {ℓ₂} {ℓ₃} {ℓ₄} (_⦉≈⦊_⇰_ ℓ₄) (_⦉≈⦊_⇰_ ℓ₄)
--   ProofFocusLeft[≈] = record { [focus-left_𝑜𝑓_] = ProofMode[≈].[R-focus-left_𝑜𝑓_] }
--   ProofFocusRight[≈] : ∀ {ℓ₁ ℓ₂ ℓ₃ ℓ₄} → ProofFocusRight {ℓ₁} {ℓ₂} {ℓ₃} {ℓ₄} (_⦉≈⦊_⇰_ ℓ₄) (_⦉≈⦊_⇰_ ℓ₄)
--   ProofFocusRight[≈] = record { [focus-right_𝑜𝑓_] = ProofMode[≈].[R-focus-right_𝑜𝑓_] }
-- 
-- instance
--   ProofMode[≡] : ∀ {ℓ} → ProofMode {ℓ} _≡_ (_⦉≡⦊_⇰_ ℓ)
--   ProofMode[≡] = record { [proof-mode]_∎ = ProofMode[≡].[R-proof-mode]_∎ }
--   ProofState[≡] : ∀ {ℓ₁ ℓ₂} → ProofState {ℓ₁} {ℓ₂} (_⦉≡⦊_⇰_ ℓ₂)
--   ProofState[≡] = record { _‣_ = ProofMode[≡]._R‣_ ; [[_]] = ProofMode[≡].[R][[_]]}
--   ProofStep[≡] : ∀ {ℓ₁ ℓ₂} → ProofStep {ℓ₁} {ℓ₂} _≡_ (_⦉≡⦊_⇰_ ℓ₂)
--   ProofStep[≡] = record { ⟅_⟆ = ProofMode[≡].[R]⟅_⟆ }
--   ProofFocusIn[≡] : ∀ {ℓ₁ ℓ₂ ℓ₃} → ProofFocusIn {ℓ₁} {ℓ₂} {ℓ₃} (_⦉≡⦊_⇰_ ℓ₃) (_⦉≡⦊_⇰_ ℓ₃)
--   ProofFocusIn[≡] = record { [focus-in_] = ProofMode[≡].[R-focus-in_] }
--   ProofFocusLeft[≡] : ∀ {ℓ₁ ℓ₂ ℓ₃ ℓ₄} → ProofFocusLeft {ℓ₁} {ℓ₂} {ℓ₃} {ℓ₄} (_⦉≡⦊_⇰_ ℓ₄) (_⦉≡⦊_⇰_ ℓ₄)
--   ProofFocusLeft[≡] = record { [focus-left_𝑜𝑓_] = ProofMode[≡].[R-focus-left_𝑜𝑓_] }
--   ProofFocusRight[≡] : ∀ {ℓ₁ ℓ₂ ℓ₃ ℓ₄} → ProofFocusRight {ℓ₁} {ℓ₂} {ℓ₃} {ℓ₄} (_⦉≡⦊_⇰_ ℓ₄) (_⦉≡⦊_⇰_ ℓ₄)
--   ProofFocusRight[≡] = record { [focus-right_𝑜𝑓_] = ProofMode[≡].[R-focus-right_𝑜𝑓_] }
