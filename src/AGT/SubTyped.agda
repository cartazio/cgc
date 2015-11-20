module AGT.SubTyped where

open import Prelude
open import POSet

module § (L : ℕ) where

  infix   8 _⊢_
  infix   8 _⊢♯_
  infix   8 _∈_
  infix   8 _∈♯_
  infixr 10 _∷_
  infixr 10 _⦂_∷_
  
  label : Set
  label = fin L

  --==========--
  -- Concrete --
  --==========--
  
  mutual
    data type : Set where
      ⊥ : type
      ⟨𝔹⟩ : type
      _⟨→⟩_ : type → type → type
      Rec : rec-type → type
    data rec-type : Set where
      [] : rec-type
      _⦂_∷_ : label → type → rec-type → rec-type

  -- partial order
  -- (arrows are monotonic)

  mutual
    data _⊴ᵗ_ : type → type → Set where
      ⊥ : ∀ {τ} → ⊥ ⊴ᵗ τ
      ⟨𝔹⟩ : ⟨𝔹⟩ ⊴ᵗ ⟨𝔹⟩
      _⟨→⟩_ : ∀ {τ₁₁ τ₂₁ τ₁₂ τ₂₂}
        → τ₁₁ ⊴ᵗ τ₂₁
        → τ₁₂ ⊴ᵗ τ₂₂
        → (τ₁₁ ⟨→⟩ τ₁₂) ⊴ᵗ (τ₂₁ ⟨→⟩ τ₂₂)
      Rec : ∀ {rτ₁ rτ₂}
        → rτ₁ ⊴ᵗ* rτ₂
        → Rec rτ₁ ⊴ᵗ Rec rτ₂
    data _⊴ᵗ*_  : rec-type → rec-type → Set where
      [] : [] ⊴ᵗ* []
      _∷_ : ∀ {l τ₁ τ₂ rτ₁ rτ₂}
        → τ₁ ⊴ᵗ τ₂
        → rτ₁ ⊴ᵗ* rτ₂
        → (l ⦂ τ₁ ∷ rτ₁) ⊴ᵗ* (l ⦂ τ₂ ∷ rτ₂)

  mutual
    xRx⸢⊴ᵗ⸣ : reflexive _⊴ᵗ_
    xRx⸢⊴ᵗ⸣ {⊥} = ⊥
    xRx⸢⊴ᵗ⸣ {⟨𝔹⟩} = ⟨𝔹⟩
    xRx⸢⊴ᵗ⸣ {τ₁ ⟨→⟩ τ₂} = xRx⸢⊴ᵗ⸣ ⟨→⟩ xRx⸢⊴ᵗ⸣
    xRx⸢⊴ᵗ⸣ {Rec rτ} = Rec xRx⸢⊴ᵗ*⸣

    xRx⸢⊴ᵗ*⸣ : reflexive _⊴ᵗ*_
    xRx⸢⊴ᵗ*⸣ {[]} = []
    xRx⸢⊴ᵗ*⸣ {l ⦂ τ ∷ rτ} = xRx⸢⊴ᵗ⸣ ∷ xRx⸢⊴ᵗ*⸣

  mutual
    _⌾⸢⊴ᵗ⸣_ : transitive _⊴ᵗ_
    _ ⌾⸢⊴ᵗ⸣ ⊥ = ⊥
    ⟨𝔹⟩ ⌾⸢⊴ᵗ⸣ ⟨𝔹⟩ = ⟨𝔹⟩
    (⊴₁₁ ⟨→⟩ ⊴₂₁) ⌾⸢⊴ᵗ⸣ (⊴₁₂ ⟨→⟩ ⊴₂₂) = (⊴₁₁ ⌾⸢⊴ᵗ⸣ ⊴₁₂) ⟨→⟩ (⊴₂₁ ⌾⸢⊴ᵗ⸣ ⊴₂₂)
    Rec ⊴*₁ ⌾⸢⊴ᵗ⸣ Rec ⊴*₂ = Rec (⊴*₁ ⌾⸢⊴ᵗ*⸣ ⊴*₂)

    _⌾⸢⊴ᵗ*⸣_ : transitive _⊴ᵗ*_
    [] ⌾⸢⊴ᵗ*⸣ [] = []
    (⊴₁ ∷ ⊴*₁) ⌾⸢⊴ᵗ*⸣ (⊴₂ ∷ ⊴*₂) = (⊴₁ ⌾⸢⊴ᵗ⸣ ⊴₂) ∷ (⊴*₁ ⌾⸢⊴ᵗ*⸣ ⊴*₂)

  instance
    Reflexive[⊴ᵗ] : Reflexive _⊴ᵗ_
    Reflexive[⊴ᵗ] = record { xRx = xRx⸢⊴ᵗ⸣ }
    Reflexive[⊴ᵗ*] : Reflexive _⊴ᵗ*_
    Reflexive[⊴ᵗ*] = record { xRx = xRx⸢⊴ᵗ*⸣ }
    Transitive[⊴ᵗ] : Transitive _⊴ᵗ_
    Transitive[⊴ᵗ] = record { _⌾_ = _⌾⸢⊴ᵗ⸣_ }
    Transitive[⊴ᵗ*] : Transitive _⊴ᵗ*_
    Transitive[⊴ᵗ*] = record { _⌾_ = _⌾⸢⊴ᵗ*⸣_ }
    PreOrder[type] : PreOrder zeroˡ type
    PreOrder[type] = record { _⊴_ = _⊴ᵗ_ }
    PreOrder[rec-type] : PreOrder zeroˡ rec-type
    PreOrder[rec-type] = record { _⊴_ = _⊴ᵗ*_ }

  -- subtype order
  -- (arrows are co/contra-variant)

  mutual
    data _<:_ : type → type → Set where
      ⟨𝔹⟩ : ⟨𝔹⟩ <: ⟨𝔹⟩
      _⟨→⟩_ : ∀ {τ₁₁ τ₂₁ τ₁₂ τ₂₂}
        → τ₂₁ <: τ₁₁
        → τ₁₂ <: τ₂₂
        → (τ₁₁ ⟨→⟩ τ₁₂) <: (τ₂₁ ⟨→⟩ τ₂₂)
      Rec : ∀ {rτ₁ rτ₂}
        → rτ₁ <:* rτ₂
        → Rec rτ₁ <: Rec rτ₂
    data _<:*_ : rec-type → rec-type → Set where
      [] : [] <:* []
      <[_] : ∀ {l τ rτ₁ rτ₂}
        → rτ₁ <:* rτ₂
        → (l ⦂ τ ∷ rτ₁) <:* rτ₂
      _∷_ : ∀ {l τ₁ τ₂ rτ₁ rτ₂}
        → τ₁ <: τ₂
        → rτ₁ <:* rτ₂
        → (l ⦂ τ₁ ∷ rτ₁) <:* (l ⦂ τ₂ ∷ rτ₂)

  -- dom and cod

  domᵗ : type → type
  domᵗ (τ₁ ⟨→⟩ τ₂) = τ₁
  domᵗ _ = ⊥

  monotonic[domᵗ] : proper (_⊴_ ⇉ _⊴_) domᵗ
  monotonic[domᵗ] ⊥ = ⊥
  monotonic[domᵗ] ⟨𝔹⟩ = ⊥
  monotonic[domᵗ] (⊴₁ ⟨→⟩ ⊴₂) = ⊴₁
  monotonic[domᵗ] (Rec ⊴*₁) = ⊥

  codᵗ : type → type
  codᵗ (τ₁ ⟨→⟩ τ₂) = τ₂
  codᵗ _ = ⊥

  monotonic[codᵗ] : proper (_⊴_ ⇉ _⊴_) codᵗ
  monotonic[codᵗ] ⊥ = ⊥
  monotonic[codᵗ] ⟨𝔹⟩ = ⊥
  monotonic[codᵗ] (⊴₁ ⟨→⟩ ⊴₂) = ⊴₂
  monotonic[codᵗ] (Rec ⊴*₁) = ⊥

  -- subtype join and meet

  mutual
    _∨:_ : type → type → type
    ⟨𝔹⟩ ∨: ⟨𝔹⟩ = ⟨𝔹⟩
    (τ₁₁ ⟨→⟩ τ₂₁) ∨: (τ₁₂ ⟨→⟩ τ₂₂) = (τ₁₁ ∧: τ₂₁) ⟨→⟩ (τ₁₂ ∨: τ₂₂)
    Rec rτ₁ ∨: Rec rτ₂ = TODO
      where TODO = ⊥
    ⊥ ∨: τ = ⊥
    τ ∨: ⊥ = ⊥
    ⟨𝔹⟩ ∨: _ = ⊥
    _ ∨: ⟨𝔹⟩ = ⊥
    (τ₁ ⟨→⟩ τ₂) ∨: _ = ⊥
    _ ∨: (τ₁ ⟨→⟩ τ₂) = ⊥

    _∧:_ : type → type → type
    ⟨𝔹⟩ ∧: ⟨𝔹⟩ = ⟨𝔹⟩
    (τ₁₁ ⟨→⟩ τ₂₁) ∧: (τ₁₂ ⟨→⟩ τ₂₂) = (τ₁₁ ∨: τ₂₁) ⟨→⟩ (τ₁₂ ∧: τ₂₂)
    Rec rτ₁ ∧: Rec rτ₂ = TODO
      where TODO = ⊥
    ⊥ ∧: τ = ⊥
    τ ∧: ⊥ = ⊥
    ⟨𝔹⟩ ∧: _ = ⊥
    _ ∧: ⟨𝔹⟩ = ⊥
    (τ₁ ⟨→⟩ τ₂) ∧: _ = ⊥
    _ ∧: (τ₁ ⟨→⟩ τ₂) = ⊥
  
  -- terms

  data context : Set where
    [] : context
    _∷_ : type → context → context
  
  data _∈_ : type → context → Set where
    Zero : ∀ {Γ τ} → τ ∈ τ ∷ Γ
    Suc : ∀ {Γ τ₁ τ₂} → τ₁ ∈ Γ → τ₁ ∈ τ₂ ∷ Γ
  
  data _⦂_∈_ : label → type → rec-type → Set where
    Zero : ∀ {l τ rτ} → l ⦂ τ ∈ (l ⦂ τ ∷ rτ)
    Suc : ∀ {l₁ l₂ τ₁ τ₂ rτ} → l₁ ⦂ τ₁ ∈ rτ → l₁ ⦂ τ₁ ∈ (l₂ ⦂ τ₂ ∷ rτ)

  mutual
    data _⊢_ : context → type → Set where
      Bool : ∀ {Γ} → 𝔹 → Γ ⊢ ⟨𝔹⟩
      ⟨if⟩_⟨then⟩_⟨else⟩_‖_ : ∀ {Γ τ₁ τ₂ τ₃}
        → Γ ⊢ τ₁
        → Γ ⊢ τ₂
        → Γ ⊢ τ₃
        → τ₁ <: ⟨𝔹⟩
        → Γ ⊢ τ₂ ∨: τ₃
      Var : ∀ {Γ τ}
        → τ ∈ Γ
        → Γ ⊢ τ
      ⟨λ⟩ : ∀ {Γ τ₁ τ₂}
        → τ₁ ∷ Γ ⊢ τ₂
        → Γ ⊢ (τ₁ ⟨→⟩ τ₂)
      _⟨⋅⟩_‖_ : ∀ {Γ τ₁ τ₂}
        → Γ ⊢ τ₁
        → Γ ⊢ τ₂
        → τ₂ <: domᵗ τ₁
        → Γ ⊢ codᵗ τ₁
      Rec : ∀ {Γ rτ}
        → Γ ⊢* rτ
        → Γ ⊢ Rec rτ
      Proj : ∀ {Γ l τ rτ}
        → l ⦂ τ ∈ rτ
        → Γ ⊢* rτ
        → Γ ⊢ τ
      _⦂⦂_ : ∀ {Γ τ₁ τ₂}
        → Γ ⊢ τ₁
        → τ₁ <: τ₂
        → Γ ⊢ τ₂
    data _⊢*_ : context → rec-type → Set where
      [] : ∀ {Γ} → Γ ⊢* []
      _≔_∷_ : ∀ {Γ τ rτ} (l : fin L)
        → Γ ⊢ τ
        → Γ ⊢* rτ
        → Γ ⊢* (l ⦂ τ ∷ rτ)

  --==========--
  -- Abstract --
  --==========--

  mutual
    data type♯ : Set where
      ⊥ : type♯
      ⊤ : type♯
      ⟨𝔹⟩ : type♯
      _⟨→⟩_ : type♯ → type♯ → type♯
      Rec : rec-type♯ → type♯
    data rec-type♯ : Set where
      [] : rec-type♯
      _⦂_∷_ : label → type♯ → rec-type♯ → rec-type♯

  -- partial order
  -- (arrows are monotonic)

  mutual
    data _⊴♯_ : type♯ → type♯ → Set where
      ⊥ : ∀ {τ} → ⊥ ⊴♯ τ
      ⊤ : ∀ {τ} → τ ⊴♯ ⊤
      ⟨𝔹⟩ : ⟨𝔹⟩ ⊴♯ ⟨𝔹⟩
      _⟨→⟩_ : ∀ {τ₁₁ τ₂₁ τ₁₂ τ₂₂}
        → τ₁₁ ⊴♯ τ₂₁
        → τ₁₂ ⊴♯ τ₂₂
        → (τ₁₁ ⟨→⟩ τ₁₂) ⊴♯ (τ₂₁ ⟨→⟩ τ₂₂)
      Rec : ∀ {rτ₁ rτ₂}
        → rτ₁ ⊴*♯ rτ₂
        → Rec rτ₁ ⊴♯ Rec rτ₂
    data _⊴*♯_  : rec-type♯ → rec-type♯ → Set where
      [] : [] ⊴*♯ []
      _∷_ : ∀ {l τ₁ τ₂ rτ₁ rτ₂}
        → τ₁ ⊴♯ τ₂
        → rτ₁ ⊴*♯ rτ₂
        → (l ⦂ τ₁ ∷ rτ₁) ⊴*♯ (l ⦂ τ₂ ∷ rτ₂)

  mutual
    xRx⸢⊴♯⸣ : reflexive _⊴♯_
    xRx⸢⊴♯⸣ {⊥} = ⊥
    xRx⸢⊴♯⸣ {⊤} = ⊤
    xRx⸢⊴♯⸣ {⟨𝔹⟩} = ⟨𝔹⟩
    xRx⸢⊴♯⸣ {τ₁ ⟨→⟩ τ₂} = xRx⸢⊴♯⸣ ⟨→⟩ xRx⸢⊴♯⸣
    xRx⸢⊴♯⸣ {Rec rτ} = Rec xRx⸢⊴*♯⸣

    xRx⸢⊴*♯⸣ : reflexive _⊴*♯_
    xRx⸢⊴*♯⸣ {[]} = []
    xRx⸢⊴*♯⸣ {l ⦂ τ ∷ rτ} = xRx⸢⊴♯⸣ ∷ xRx⸢⊴*♯⸣

  mutual
    _⌾⸢⊴♯⸣_ : transitive _⊴♯_
    _ ⌾⸢⊴♯⸣ ⊥ = ⊥
    ⊤ ⌾⸢⊴♯⸣ _ = ⊤
    ⟨𝔹⟩ ⌾⸢⊴♯⸣ ⟨𝔹⟩ = ⟨𝔹⟩
    (⊴₁₁ ⟨→⟩ ⊴₂₁) ⌾⸢⊴♯⸣ (⊴₁₂ ⟨→⟩ ⊴₂₂) = (⊴₁₁ ⌾⸢⊴♯⸣ ⊴₁₂) ⟨→⟩ (⊴₂₁ ⌾⸢⊴♯⸣ ⊴₂₂)
    Rec ⊴*₁ ⌾⸢⊴♯⸣ Rec ⊴*₂ = Rec (⊴*₁ ⌾⸢⊴*♯⸣ ⊴*₂)

    _⌾⸢⊴*♯⸣_ : transitive _⊴*♯_
    [] ⌾⸢⊴*♯⸣ [] = []
    (⊴₁ ∷ ⊴*₁) ⌾⸢⊴*♯⸣ (⊴₂ ∷ ⊴*₂) = (⊴₁ ⌾⸢⊴♯⸣ ⊴₂) ∷ (⊴*₁ ⌾⸢⊴*♯⸣ ⊴*₂)

  instance
    Reflexive[⊴♯] : Reflexive _⊴♯_
    Reflexive[⊴♯] = record { xRx = xRx⸢⊴♯⸣ }
    Reflexive[⊴♯*] : Reflexive _⊴*♯_
    Reflexive[⊴♯*] = record { xRx = xRx⸢⊴*♯⸣ }
    Transitive[⊴♯] : Transitive _⊴♯_
    Transitive[⊴♯] = record { _⌾_ = _⌾⸢⊴♯⸣_ }
    Transitive[⊴♯*] : Transitive _⊴*♯_
    Transitive[⊴♯*] = record { _⌾_ = _⌾⸢⊴*♯⸣_ }
    PreOrder[type♯] : PreOrder zeroˡ type♯
    PreOrder[type♯] = record { _⊴_ = _⊴♯_ }
    PreOrder[rec-type♯] : PreOrder zeroˡ rec-type♯
    PreOrder[rec-type♯] = record { _⊴_ = _⊴*♯_ }

  -- subtype order
  -- (arrows are co/contra-variant)

  mutual
    data _<:♯_ : type♯ → type♯ → Set where
      ⊤<:τ : ∀ {τ} → ⊤ <:♯ τ
      τ<:⊤ : ∀ {τ} → τ <:♯  ⊤
      ⟨𝔹⟩ : ⟨𝔹⟩ <:♯ ⟨𝔹⟩
      _⟨→⟩_ : ∀ {τ₁₁ τ₂₁ τ₁₂ τ₂₂}
        → τ₁₂ <:♯ τ₁₁
        → τ₂₁ <:♯ τ₂₂
        → (τ₁₁ ⟨→⟩ τ₂₁) <:♯ (τ₁₂ ⟨→⟩ τ₂₂)
      Rec : ∀ {rτ₁ rτ₂}
        → rτ₁ <:♯* rτ₂
        → Rec rτ₁ <:♯ Rec rτ₂
    data _<:♯*_ : rec-type♯ → rec-type♯ → Set where
      [] : [] <:♯* []
      <[_] : ∀ {l τ rτ₁ rτ₂}
        → rτ₁ <:♯* rτ₂
        → (l ⦂ τ ∷ rτ₁) <:♯* rτ₂
      _∷_ : ∀ {l τ₁ τ₂ rτ₁ rτ₂}
        → τ₁ <:♯ τ₂
        → rτ₁ <:♯* rτ₂
        → (l ⦂ τ₁ ∷ rτ₁) <:♯* (l ⦂ τ₂ ∷ rτ₂)
      
  -- dom and cod

  dom♯ : type♯ → type♯
  dom♯ ⊤ = ⊤
  dom♯ (τ₁ ⟨→⟩ τ₂) = τ₁
  dom♯ _ = ⊥

  monotonic[dom♯] : proper (_⊴_ ⇉ _⊴_) dom♯
  monotonic[dom♯] ⊥ = ⊥
  monotonic[dom♯] ⊤ = ⊤
  monotonic[dom♯] ⟨𝔹⟩ = ⊥
  monotonic[dom♯] (⊴₁ ⟨→⟩ ⊴₂) = ⊴₁
  monotonic[dom♯] (Rec _) = ⊥

  cod♯ : type♯ → type♯
  cod♯ ⊤ = ⊤
  cod♯ (τ₁ ⟨→⟩ τ₂) = τ₂
  cod♯ _ = ⊥

  monotonic[cod♯] : proper (_⊴_ ⇉ _⊴_) cod♯
  monotonic[cod♯] ⊥ = ⊥
  monotonic[cod♯] ⊤ = ⊤
  monotonic[cod♯] ⟨𝔹⟩ = ⊥
  monotonic[cod♯] (⊴₁ ⟨→⟩ ⊴₂) = ⊴₂
  monotonic[cod♯] (Rec _) = ⊥

  -- subtype join and meet

  mutual
    _∨:♯_ : type♯ → type♯ → type♯
    ⊥ ∨:♯ τ = ⊥
    τ ∨:♯ ⊥ = ⊥
    ⊤ ∨:♯ _ = ⊤
    _ ∨:♯ ⊤ = ⊤
    ⟨𝔹⟩ ∨:♯ ⟨𝔹⟩ = ⟨𝔹⟩
    (τ₁₁ ⟨→⟩ τ₂₁) ∨:♯ (τ₁₂ ⟨→⟩ τ₂₂) = (τ₁₁ ∧:♯ τ₂₁) ⟨→⟩ (τ₁₂ ∨:♯ τ₂₂)
    Rec rτ₁ ∨:♯ Rec rτ₂ = TODO
      where TODO = ⊥
    ⟨𝔹⟩ ∨:♯ _ = ⊥
    _ ∨:♯ ⟨𝔹⟩ = ⊥
    (τ₁ ⟨→⟩ τ₂) ∨:♯ _ = ⊥
    _ ∨:♯ (τ₁ ⟨→⟩ τ₂) = ⊥

    _∧:♯_ : type♯ → type♯ → type♯
    ⊥ ∧:♯ τ = ⊥
    τ ∧:♯ ⊥ = ⊥
    ⊤ ∧:♯ _ = ⊤
    _ ∧:♯ ⊤ = ⊤
    ⟨𝔹⟩ ∧:♯ ⟨𝔹⟩ = ⟨𝔹⟩
    (τ₁₁ ⟨→⟩ τ₂₁) ∧:♯ (τ₁₂ ⟨→⟩ τ₂₂) = (τ₁₁ ∨:♯ τ₂₁) ⟨→⟩ (τ₁₂ ∧:♯ τ₂₂)
    Rec rτ₁ ∧:♯ Rec rτ₂ = TODO
      where TODO = ⊥
    ⟨𝔹⟩ ∧:♯ _ = ⊥
    _ ∧:♯ ⟨𝔹⟩ = ⊥
    (τ₁ ⟨→⟩ τ₂) ∧:♯ _ = ⊥
    _ ∧:♯ (τ₁ ⟨→⟩ τ₂) = ⊥

  _⊓_ : type♯ → type♯ → type♯
  ⊤ ⊓ τ = τ
  τ ⊓ ⊤ = τ
  ⟨𝔹⟩ ⊓ ⟨𝔹⟩ = ⟨𝔹⟩
  (τ₁₁ ⟨→⟩ τ₂₁) ⊓ (τ₁₂ ⟨→⟩ τ₂₂) = (τ₁₁ ⊓ τ₂₁) ⟨→⟩ (τ₁₂ ⊓ τ₂₂)
  Rec rτ₁ ⊓ Rec rτ₂ = {!!}
  _ ⊓ _ = ⊥
  
  data context♯ : Set where
    [] : context♯
    _∷_ : type♯ → context♯ → context♯
  
  data _∈♯_ : type♯ → context♯ → Set where
    Zero : ∀ {Γ τ} → τ ∈♯ τ ∷ Γ
    Suc : ∀ {Γ τ₁ τ₂} → τ₁ ∈♯ Γ → τ₁ ∈♯ τ₂ ∷ Γ
  
  data _⦂_∈♯_ : label → type♯ → rec-type♯ → Set where
    Zero : ∀ {l τ rτ} → l ⦂ τ ∈♯ (l ⦂ τ ∷ rτ)
    Suc : ∀ {l₁ l₂ τ₁ τ₂ rτ} → l₁ ⦂ τ₁ ∈♯ rτ → l₁ ⦂ τ₁ ∈♯ (l₂ ⦂ τ₂ ∷ rτ)

  mutual
    data _⊢♯_ : context♯ → type♯ → Set where
      Bool : ∀ {Γ} → 𝔹 → Γ ⊢♯ ⟨𝔹⟩
      ⟨if⟩_⟨then⟩_⟨else⟩_‖_ : ∀ {Γ τ₁ τ₂ τ₃}
        → Γ ⊢♯ τ₁
        → Γ ⊢♯ τ₂
        → Γ ⊢♯ τ₃
        → τ₁ <:♯ ⟨𝔹⟩
        → Γ ⊢♯ τ₂ ∨:♯ τ₃
      Var : ∀ {Γ τ}
        → τ ∈♯ Γ
        → Γ ⊢♯ τ
      ⟨λ⟩ : ∀ {Γ τ₁ τ₂}
        → τ₁ ∷ Γ ⊢♯ τ₂
        → Γ ⊢♯ (τ₁ ⟨→⟩ τ₂)
      _⟨⋅⟩_‖_,_ : ∀ {Γ τ₁ τ₂ τ₁₁ τ₂₁}
        → Γ ⊢♯ τ₁
        → Γ ⊢♯ τ₂
        → τ₁ <:♯ (τ₁₁ ⟨→⟩ τ₂₁)
        → τ₂ <:♯ τ₁₁
        → Γ ⊢♯ τ₂₁
      Rec : ∀ {Γ rτ}
        → Γ ⊢*♯ rτ
        → Γ ⊢♯ Rec rτ
      Proj : ∀ {Γ l τ rτ}
        → Γ ⊢*♯ rτ
        → l ⦂ τ ∈♯ rτ
        → Γ ⊢♯ τ
      _⦂⦂_ : ∀ {Γ τ₁ τ₂}
        → Γ ⊢♯ τ₁
        → τ₁ <:♯ τ₂
        → Γ ⊢♯ τ₂
    data _⊢*♯_ : context♯ → rec-type♯ → Set where
      [] : ∀ {Γ} → Γ ⊢*♯ []
      _≔_∷_ : ∀ {Γ τ rτ} (l : fin L)
        → Γ ⊢♯ τ
        → Γ ⊢*♯ rτ
        → Γ ⊢*♯ (l ⦂ τ ∷ rτ)

  --========--
  -- Proofs --
  --========--

  -----------------------
  -- Galois Connection --
  -----------------------

  mutual
    data _∈γ[_] : type → type♯ → Set where
      ⊤ : ∀ {τ} → τ ∈γ[ ⊤ ]
      ⊥ : ∀ {τ} → ⊥ ∈γ[ τ ]
      ⟨𝔹⟩ : ⟨𝔹⟩ ∈γ[ ⟨𝔹⟩ ]
      _⟨→⟩_ : ∀ {τ₁ τ₂ τ₁♯ τ₂♯}
        → τ₁ ∈γ[ τ₁♯ ]
        → τ₂ ∈γ[ τ₂♯ ]
        → (τ₁ ⟨→⟩ τ₂) ∈γ[ τ₁♯ ⟨→⟩ τ₂♯ ]
      Rec : ∀ {rτ rτ♯} → rτ ∈γ*[ rτ♯ ] → Rec rτ ∈γ[ Rec rτ♯ ]
    data _∈γ*[_] : rec-type → rec-type♯ → Set where
      [] : [] ∈γ*[ [] ]
      _∷_ : ∀ {l τ τ♯ rτ rτ♯}
        → τ ∈γ[ τ♯ ]
        → rτ ∈γ*[ rτ♯ ]
        → (l ⦂ τ ∷ rτ) ∈γ*[ l ⦂ τ♯ ∷ rτ♯ ]

  mutual
    monotonic[γ] : proper (flip _⊴_ ⇉ _⊴_ ⇉ [→]) _∈γ[_]
    monotonic[γ] ⟨𝔹⟩ ⟨𝔹⟩ ⟨𝔹⟩ = ⟨𝔹⟩
    monotonic[γ] (⊴₁₁ ⟨→⟩ ⊴₂₁) (⊴₁₂ ⟨→⟩ ⊴₂₂) (∈₁ ⟨→⟩ ∈₂) = monotonic[γ] ⊴₁₁ ⊴₁₂ ∈₁ ⟨→⟩ monotonic[γ] ⊴₂₁ ⊴₂₂ ∈₂
    monotonic[γ] (Rec ⊴*₁) (Rec ⊴*₂) (Rec ∈*₁) = Rec (monotonic[γ*] ⊴*₁ ⊴*₂ ∈*₁)
    monotonic[γ] _ ⊤ _ = ⊤
    monotonic[γ] ⊥ _ _ = ⊥

    monotonic[γ*] : proper (flip _⊴_ ⇉ _⊴_ ⇉ [→]) _∈γ*[_]
    monotonic[γ*] [] [] [] = []
    monotonic[γ*] (⊴₁ ∷ ⊴*₁) (⊴₂ ∷ ⊴*₂) (∈₁ ∷ ∈*₁) = (monotonic[γ] ⊴₁ ⊴₂ ∈₁) ∷ (monotonic[γ*] ⊴*₁ ⊴*₂ ∈*₁)

  mutual
    η : type → type♯
    η ⊥ = ⊥
    η ⟨𝔹⟩ = ⟨𝔹⟩
    η (τ₁ ⟨→⟩ τ₂) = η τ₁ ⟨→⟩ η τ₂
    η (Rec rτ) = Rec (η* rτ)

    η* : rec-type → rec-type♯
    η* [] = []
    η* (l ⦂ τ ∷ rτ) = l ⦂ η τ ∷ η* rτ

  mutual
    monotonic[η] : proper (_⊴_ ⇉ _⊴_) η
    monotonic[η] ⊥ = ⊥
    monotonic[η] ⟨𝔹⟩ = ⟨𝔹⟩
    monotonic[η] (⊴₁ ⟨→⟩ ⊴₂) = monotonic[η] ⊴₁ ⟨→⟩ monotonic[η] ⊴₂
    monotonic[η] (Rec ⊴₁) = Rec (monotonic[η*] ⊴₁)

    monotonic[η*] : proper (_⊴_ ⇉ _⊴_) η*
    monotonic[η*] [] = []
    monotonic[η*] (⊴₁ ∷ ∈₁) = monotonic[η] ⊴₁ ∷ monotonic[η*] ∈₁

  mutual
    sound[ηγ] : ∀ τ → τ ∈γ[ η τ ]
    sound[ηγ] ⊥ = ⊥
    sound[ηγ] ⟨𝔹⟩ = ⟨𝔹⟩
    sound[ηγ] (τ₁ ⟨→⟩ τ₂) = sound[ηγ] τ₁ ⟨→⟩ sound[ηγ] τ₂
    sound[ηγ] (Rec rτ) = Rec (sound[η*] rτ)

    sound[η*] : ∀ rτ → rτ ∈γ*[ η* rτ ]
    sound[η*] [] = []
    sound[η*] (l ⦂ τ ∷ rτ) = sound[ηγ] τ ∷ sound[η*] rτ

  mutual
    complete[ηγ] : ∀ {τ τ♯} → τ ∈γ[ τ♯ ] → η τ ⊴ τ♯
    complete[ηγ] ⊤ = ⊤
    complete[ηγ] ⊥ = ⊥
    complete[ηγ] ⟨𝔹⟩ = ⟨𝔹⟩
    complete[ηγ] (∈₁ ⟨→⟩ ∈₂) = complete[ηγ] ∈₁ ⟨→⟩ complete[ηγ] ∈₂
    complete[ηγ] (Rec ∈*₁) = Rec (complete[ηγ*] ∈*₁)

    complete[ηγ*] : ∀ {rτ rτ♯} → rτ ∈γ*[ rτ♯ ] → η* rτ ⊴ rτ♯
    complete[ηγ*] [] = []
    complete[ηγ*] (∈₁ ∷ ∈*₁) = complete[ηγ] ∈₁ ∷ complete[ηγ*] ∈*₁

  --------------------------
  -- Abstract dom and cod --
  --------------------------

  sound[dom♯] : ∀ τ → η (domᵗ τ) ⊴ dom♯ (η τ)
  sound[dom♯] ⊥ = ⊥
  sound[dom♯] ⟨𝔹⟩ = ⊥
  sound[dom♯] (τ₁ ⟨→⟩ τ₂) = xRx
  sound[dom♯] (Rec _) = ⊥

  sound[cod♯] : ∀ τ → η (codᵗ τ) ⊴ cod♯ (η τ)
  sound[cod♯] ⊥ = ⊥
  sound[cod♯] ⟨𝔹⟩ = ⊥
  sound[cod♯] (τ₁ ⟨→⟩ τ₂) = xRx
  sound[cod♯] (Rec _) = ⊥

  -------------------------------
  -- Abstract <: meet and join --
  -------------------------------

  -- TODO

  --==========--
  -- Dynamics --
  --==========--
   
  data _⊴⸢φ⸣_ : context♯ → context♯ → Set where
    [] : ∀ {Γ} → [] ⊴⸢φ⸣ Γ 
    _∷_ : ∀ {Γ₁ Γ₂ τ} → τ ∈♯ Γ₂ → Γ₁ ⊴⸢φ⸣ Γ₂ → (τ ∷ Γ₁) ⊴⸢φ⸣ Γ₂

  intro⸢φ⸣ : ∀ {τ Γ₁ Γ₂} → Γ₁ ⊴⸢φ⸣ Γ₂ → Γ₁ ⊴⸢φ⸣ (τ ∷ Γ₂)
  intro⸢φ⸣ [] = []
  intro⸢φ⸣ (x ∷ φ) = Suc x ∷ intro⸢φ⸣ φ

  rename⸢var⸣ : ∀ {τ Γ₁ Γ₂} → Γ₁ ⊴⸢φ⸣ Γ₂ → τ ∈♯ Γ₁ → τ ∈♯ Γ₂
  rename⸢var⸣ (x ∷ φ) Zero = x
  rename⸢var⸣ (x₂ ∷ φ) (Suc x₁) = rename⸢var⸣ φ x₁

  xRx[⊴⸢φ⸣] : reflexive _⊴⸢φ⸣_
  xRx[⊴⸢φ⸣] {[]} = []
  xRx[⊴⸢φ⸣] {τ ∷ Γ} = Zero ∷ intro⸢φ⸣ xRx[⊴⸢φ⸣]

  _⌾[⊴⸢φ⸣]_ : transitive _⊴⸢φ⸣_
  _ ⌾[⊴⸢φ⸣] [] = []
  (x₂ ∷ φ₂) ⌾[⊴⸢φ⸣] (Zero ∷ φ₁) = x₂ ∷ ((x₂ ∷ φ₂) ⌾[⊴⸢φ⸣] φ₁)
  (x₂ ∷ φ₂) ⌾[⊴⸢φ⸣] (Suc x₁ ∷ φ₁) = rename⸢var⸣ φ₂ x₁ ∷ ((x₂ ∷ φ₂) ⌾[⊴⸢φ⸣] φ₁)

  instance
    Reflexive[⊴⸢φ⸣] : Reflexive _⊴⸢φ⸣_
    Reflexive[⊴⸢φ⸣] = record { xRx = xRx[⊴⸢φ⸣] }
    Transitive[⊴⸢φ⸣] : Transitive _⊴⸢φ⸣_
    Transitive[⊴⸢φ⸣] = record { _⌾_ = _⌾[⊴⸢φ⸣]_ }

  rename⸢term⸣ : ∀ {τ Γ₁ Γ₂} → Γ₁ ⊴⸢φ⸣ Γ₂ → Γ₁ ⊢♯ τ → Γ₂ ⊢♯ τ
  rename⸢term⸣ φ (Bool b) = Bool b
  rename⸢term⸣ φ (⟨if⟩ e₁ ⟨then⟩ e₂ ⟨else⟩ e₃ ‖ ε) = ⟨if⟩ rename⸢term⸣ φ e₁ ⟨then⟩ rename⸢term⸣ φ e₂ ⟨else⟩ rename⸢term⸣ φ e₃ ‖ ε
  rename⸢term⸣ φ (Var x) = Var (rename⸢var⸣ φ x)
  rename⸢term⸣ φ (⟨λ⟩ e) = ⟨λ⟩ (rename⸢term⸣ (Zero ∷ intro⸢φ⸣ φ) e)
  rename⸢term⸣ φ (e₁ ⟨⋅⟩ e₂ ‖ ε₁ , ε₂) = rename⸢term⸣ φ e₁ ⟨⋅⟩ rename⸢term⸣ φ e₂ ‖ ε₁ , ε₂
  rename⸢term⸣ φ (Rec e) = {!!}
  rename⸢term⸣ φ (Proj e ε) = Proj {!!} ε
  rename⸢term⸣ φ (e ⦂⦂ ε) = rename⸢term⸣ φ e ⦂⦂ ε

  swap⸢φ⸣ : ∀ {Γ τ₁ τ₂} → (τ₁ ∷ (τ₂ ∷ Γ)) ⊴⸢φ⸣ (τ₂ ∷ (τ₁ ∷ Γ))
  swap⸢φ⸣ = (Suc Zero) ∷ (Zero ∷ (intro⸢φ⸣ (intro⸢φ⸣ xRx)))

  cut⸢var⸣ : ∀ {Γ₁ Γ₂ τ₁ τ₂}
    → Γ₂ ⊴⸢φ⸣ (τ₁ ∷ Γ₁)
    → τ₂ ∈♯ Γ₂
    → Γ₁ ⊢♯ τ₁
    → Γ₁ ⊢♯ τ₂
  cut⸢var⸣ (Zero ∷ φ) Zero esub = esub
  cut⸢var⸣ (Suc x₂ ∷ φ) Zero esub = Var x₂
  cut⸢var⸣ (x₂ ∷ φ) (Suc x₁) esub = cut⸢var⸣ φ x₁ esub
  
  cutsub : ∀ {Γ₁ Γ₂ τ₁ τ₂}
    → Γ₂ ⊴⸢φ⸣ (τ₁ ∷ Γ₁)
    → Γ₂ ⊢♯ τ₂
    → Γ₁ ⊢♯ τ₁
    → Γ₁ ⊢♯ τ₂
  cutsub φ (Bool b) esub = Bool b
  cutsub φ (⟨if⟩ e₁ ⟨then⟩ e₂ ⟨else⟩ e₃ ‖ ε) esub = ⟨if⟩ cutsub φ e₁ esub ⟨then⟩ cutsub φ e₂ esub ⟨else⟩ cutsub φ e₃ esub ‖ ε
  cutsub φ (Var x) esub = cut⸢var⸣ φ x esub
  cutsub φ (⟨λ⟩ e) esub = ⟨λ⟩ (cutsub (swap⸢φ⸣ ⌾ Zero ∷ intro⸢φ⸣ φ) e (rename⸢term⸣ (intro⸢φ⸣ xRx) esub))
  cutsub φ (e₁ ⟨⋅⟩ e₂ ‖ ε₁ , ε₂) esub = cutsub φ e₁ esub ⟨⋅⟩ cutsub φ e₂ esub ‖ ε₁ , ε₂
  cutsub φ (Rec e) esub = {!!}
  cutsub φ (Proj e ε) esub = {!!}
  cutsub φ (e ⦂⦂ ε) esub = cutsub φ e esub ⦂⦂ ε

  cut : ∀ {Γ τ₁ τ₂}
    → τ₁ ∷ Γ ⊢♯ τ₂
    → Γ ⊢♯ τ₁
    → Γ ⊢♯ τ₂
  cut e esub = cutsub xRx e esub
