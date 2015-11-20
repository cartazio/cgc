module AGT.SimplyTyped.Concrete where

open import Prelude
open import POSet

infixr  4 _⟨→⟩_
infix   8 _⊢_
infix   8 _∈_
infix   8 _⊴ᵗ_
infixr  9 _⌾⸢⊴ᵗ⸣_
infixr 10 _∷_

------------
-- [type] --
------------

data type : Set where
  ⊥ : type
  ⟨𝔹⟩ : type
  _⟨→⟩_ : type → type → type

---------------------
-- order on [type] --
---------------------

data _⊴ᵗ_ : type → type → Set where
  ⊥ : ∀ {τ} → ⊥ ⊴ᵗ τ
  ⟨𝔹⟩ : ⟨𝔹⟩ ⊴ᵗ ⟨𝔹⟩
  _⟨→⟩_ : ∀ {τ₁₁ τ₂₁ τ₁₂ τ₂₂} → τ₁₁ ⊴ᵗ τ₁₂ → τ₂₁ ⊴ᵗ τ₂₂ → (τ₁₁ ⟨→⟩ τ₂₁) ⊴ᵗ (τ₁₂ ⟨→⟩ τ₂₂)

xRx⸢⊴ᵗ⸣ : reflexive _⊴ᵗ_
xRx⸢⊴ᵗ⸣ {⊥} = ⊥
xRx⸢⊴ᵗ⸣ {⟨𝔹⟩} = ⟨𝔹⟩
xRx⸢⊴ᵗ⸣ {τ₁ ⟨→⟩ τ₂} = xRx⸢⊴ᵗ⸣ ⟨→⟩ xRx⸢⊴ᵗ⸣

_⌾⸢⊴ᵗ⸣_ : transitive _⊴ᵗ_
_ ⌾⸢⊴ᵗ⸣ ⊥ = ⊥
⟨𝔹⟩ ⌾⸢⊴ᵗ⸣ ⟨𝔹⟩ = ⟨𝔹⟩
(τ₁₁ ⟨→⟩ τ₂₁) ⌾⸢⊴ᵗ⸣ (τ₁₂ ⟨→⟩ τ₂₂) = τ₁₁ ⌾⸢⊴ᵗ⸣ τ₁₂ ⟨→⟩ τ₂₁ ⌾⸢⊴ᵗ⸣ τ₂₂

instance
  Reflexive[⊴ᵗ] : Reflexive _⊴ᵗ_
  Reflexive[⊴ᵗ] = record { xRx = xRx⸢⊴ᵗ⸣ }
  Transitive[⊴ᵗ] : Transitive _⊴ᵗ_
  Transitive[⊴ᵗ] = record { _⌾_ = _⌾⸢⊴ᵗ⸣_ }
  PreOrder[type] : PreOrder zeroˡ type
  PreOrder[type] = record { _⊴_ = _⊴ᵗ_ }

-------------------------------
-- [dom], [cod] and [equate] --
-------------------------------

domᵗ : type → type
domᵗ (τ₁ ⟨→⟩ τ₂) = τ₁
domᵗ _ = ⊥

dom⁺ : ⟪ ⇧ type ⇒ ⇧ type ⟫
dom⁺ = witness-x (curry⸢λ↑⸣ id⸢λ↑⸣) $ mk[witness] domᵗ ppr
  where
    ppr : proper (_⊴_ ⇉ _⊴_) domᵗ
    ppr ⊥ = ⊥
    ppr ⟨𝔹⟩ = ⊥
    ppr (⊴₁ ⟨→⟩ ⊴₂) = ⊴₁
  
codᵗ : type → type
codᵗ (τ₁ ⟨→⟩ τ₂) = τ₂
codᵗ _ = ⊥

cod⁺ : ⟪ ⇧ type ⇒ ⇧ type ⟫
cod⁺ = witness-x (curry⸢λ↑⸣ id⸢λ↑⸣) $ mk[witness] codᵗ ppr
  where
    ppr : proper (_⊴_ ⇉ _⊴_) codᵗ
    ppr ⊥ = ⊥
    ppr ⟨𝔹⟩ = ⊥
    ppr (⊴₁ ⟨→⟩ ⊴₂) = ⊴₂

equate : type → type → type
equate ⟨𝔹⟩ ⟨𝔹⟩ = ⟨𝔹⟩
equate (τ₁₁ ⟨→⟩ τ₂₁) (τ₁₂ ⟨→⟩ τ₂₂) = equate τ₁₁ τ₁₂ ⟨→⟩ equate τ₂₁ τ₂₂
equate _ _ = ⊥

right-zero[equate] : ∀ τ → equate τ ⊥ ≡ ⊥
right-zero[equate] ⊥ = ↯
right-zero[equate] ⟨𝔹⟩ = ↯
right-zero[equate] (τ₁ ⟨→⟩ τ₂) = ↯

equate⁺ : ⟪ ⇧ type ⇒ ⇧ type ⇒ ⇧ type ⟫
equate⁺ = witness-x (curry⸢λ↑⸣ $ curry⸢λ↑⸣ id⸢λ↑⸣) $ mk[witness] equate ppr
  where
    ppr : proper (_⊴_ ⇉ _⊴_ ⇉ _⊴_) equate
    ppr ⟨𝔹⟩ ⟨𝔹⟩ = ⟨𝔹⟩
    ppr (τ₁₁ ⟨→⟩ τ₂₁) (τ₁₂ ⟨→⟩ τ₂₂) = ppr τ₁₁ τ₁₂ ⟨→⟩ ppr τ₂₁ τ₂₂
    ppr ⊥ _ = ⊥
    ppr {τ₁} {τ₂} _ ⊥ rewrite right-zero[equate] τ₁ =  ⊥
    ppr ⟨𝔹⟩ (_ ⟨→⟩ _) =  ⊥
    ppr (_ ⟨→⟩ _) ⟨𝔹⟩ =  ⊥

-----------
-- terms --
-----------

data context : Set where
  [] : context
  _∷_ : type → context → context

data _∈_ : type → context → Set where
  Zero : ∀ {Γ τ} → τ ∈ τ ∷ Γ
  Suc : ∀ {Γ τ₁ τ₂} → τ₁ ∈ Γ → τ₁ ∈ τ₂ ∷ Γ

data _⊢_ : context → type → Set where
  ⟨𝔹⟩ : ∀ {Γ} → 𝔹 → Γ ⊢ ⟨𝔹⟩
  ⟨if⟩_⟨then⟩_⟨else⟩ : ∀ {Γ τ₁ τ₂}
    → Γ ⊢ ⟨𝔹⟩
    → Γ ⊢ τ₁
    → Γ ⊢ τ₂
    → Γ ⊢ equate τ₁ τ₂
  Var : ∀ {Γ τ}
    → τ ∈ Γ
    → Γ ⊢ τ
  ⟨λ⟩ : ∀ {Γ τ₁ τ₂}
    → τ₁ ∷ Γ ⊢ τ₂
    → Γ ⊢ (τ₁ ⟨→⟩ τ₂)
  _⟨⋅⟩_‖_ : ∀ {Γ τ₁ τ₂}
    → Γ ⊢ τ₁
    → Γ ⊢ τ₂
    → τ₂ ≡ domᵗ τ₁
    → Γ ⊢ codᵗ τ₁
  _⦂_ : ∀ {Γ τ₁ τ₂}
    → Γ ⊢ τ₁
    → τ₁ ≡ τ₂
    → Γ ⊢ τ₂
