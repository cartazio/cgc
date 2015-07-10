module OSet.GaloisConnection.Constructive where

open import Prelude
open import OSet.OSet
open import OSet.Fun
open import OSet.Power
open import OSet.Product
open import OSet.ProofMode
open import OSet.Lib

open import OSet.GaloisConnection.Classical
open import OSet.GaloisConnection.Kleisli

infixr 4 _η⇄γ_
record _η⇄γ_ {𝓁} (A B : POSet 𝓁) : Set (sucˡ 𝓁) where
  field
    η[_] : ⟪ A ⇒ B ⟫
    γ⸢η⸣[_] : ⟪ B ⇒ 𝒫 A ⟫
    expansive⸢η⸣[_] : return ⊑ γ⸢η⸣[_] ⟐ pure ⋅ η[_]
    contractive⸢η⸣[_] : pure ⋅ η[_] ⟐ γ⸢η⸣[_] ⊑ return
open _η⇄γ_ public

expansive↔⸢pure⸣ : ∀ {𝓁} {A B : POSet 𝓁} {η : ⟪ A ⇒ B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → return ⊑ γ ⟐ pure ⋅ η ↔ return ⊑ γ ⊙ η
expansive↔⸢pure⸣ {A = A} {B} {η} {γ} = LHS , RHS
  where
    LHS : return ⊑ γ ⟐ pure ⋅ η → return ⊑ γ ⊙ η
    LHS return⊑γ⟐η = xRx[] right-unit[⟐]⸢pure⸣ ⌾ return⊑γ⟐η
    RHS : return ⊑ γ ⊙ η → return ⊑ γ ⟐ pure ⋅ η
    RHS return⊑γ⊙η = xRx[] (◇ right-unit[⟐]⸢pure⸣) ⌾ return⊑γ⊙η

expansive↔sound⸢η⸣ : ∀ {𝓁} {A B : POSet 𝓁} {η : ⟪ A ⇒ B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → return ⊑ γ ⟐ pure ⋅ η ↔ (∀ {x} → x ⋿ γ ⋅ (η ⋅ x))
expansive↔sound⸢η⸣ {A = A} {B} {η} {γ} = LHS , RHS
  where
    LHS : return ⊑ γ ⟐ pure ⋅ η → ∀ {x} → x ⋿ γ ⋅ (η ⋅ x)
    LHS expansive = π₁ return↔⋿ $ res-f[λ]⸢⊑⸣ $ π₁ expansive↔⸢pure⸣ expansive
    RHS : (∀ {x} → x ⋿ γ ⋅ (η ⋅ x)) → return ⊑ γ ⟐ pure ⋅ η
    RHS sound = π₂ expansive↔⸢pure⸣ $ ext[λ]⸢⊑⸣ $ π₂ return↔⋿ sound

contractive↔complete⸢η⸣ : ∀ {𝓁} {A B : POSet 𝓁} {η : ⟪ A ⇒ B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → pure ⋅ η ⟐ γ ⊑ return ↔ (∀ {x^ x} → x ⋿ γ ⋅ x^ → η ⋅ x ⊑ x^)
contractive↔complete⸢η⸣ {A = A} {B} {η} {γ} = LHS , RHS
  where
    LHS : pure ⋅ η ⟐ γ ⊑ return → ∀ {x^ x} → x ⋿ γ ⋅ x^ → η ⋅ x ⊑ x^
    LHS contractive {x^} {x} x∈γ[x^] = π₁ return↔⋿ $ res-f[λ]⸢⊑⸣ contractive ⌾ [⊑-proof-mode]
      do [⊑][[ (pure ⋅ η) ⋅ x ]]
      ⊑‣ [⊑-≈] (pure ⋅ η) * ⋅ (return ⋅ x) ⟅ ◇ right-unit[*] ⟆
      ⊑‣ [⊑-focus-right [⋅] 𝑜𝑓 (pure ⋅ η) * ] [⊑] γ ⋅ x^ ⟅ π₂ return↔⋿ x∈γ[x^] ⟆
      ⊑‣ [⊑][[ (pure ⋅ η) * ⋅ (γ ⋅ x^) ]]
      ⬜
    RHS : (∀ {x^ x} → x ⋿ γ ⋅ x^ → η ⋅ x ⊑ x^) → pure ⋅ η ⟐ γ ⊑ return
    RHS complete = ext[λ]⸢⊑⸣ $ ext[ω]⸢⊑⸣ H
      where
        H : ∀ {x^ y^} → y^ ⋿ (pure ⋅ η) * ⋅ (γ ⋅ x^) → y^ ⊑ x^
        H (∃𝒫 x ,, x∈γ[x^] ,, y^⊑η[x]) = complete x∈γ[x^] ⌾ y^⊑η[x]

sound⸢η⸣[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A η⇄γ B) → ∀ {x} → x ⋿ γ⸢η⸣[ A⇄B ] ⋅ (η[ A⇄B ] ⋅ x)
sound⸢η⸣[ A⇄B ] = π₁ expansive↔sound⸢η⸣ expansive⸢η⸣[ A⇄B ]

complete⸢η⸣[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A η⇄γ B) → ∀ {x^ x} → x ⋿ γ⸢η⸣[ A⇄B ] ⋅ x^ → η[ A⇄B ] ⋅ x ⊑ x^
complete⸢η⸣[ A⇄B ] = π₁ contractive↔complete⸢η⸣ contractive⸢η⸣[ A⇄B ]

◇left-unit[⟐]⸢expansive⸢η⸣⸣[_] : ∀ {𝓁} {A B₁ B₂ : POSet 𝓁} (⇄A⇄ : B₁ η⇄γ B₂) {f : ⟪ A ⇒ 𝒫 B₁ ⟫} → f ⊑ γ⸢η⸣[ ⇄A⇄ ] ⟐ pure ⋅ η[ ⇄A⇄ ] ⟐ f
◇left-unit[⟐]⸢expansive⸢η⸣⸣[ ⇄A⇄ ] {f} = [⊑-proof-mode]
  do [⊑][[ f ]]
  ⊑‣ [⊑-≈] return ⟐ f ⟅ ◇ left-unit[⟐] ⟆
  ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 f ] [⊑] γ⸢η⸣[ ⇄A⇄ ] ⟐ pure ⋅ η[ ⇄A⇄ ] ⟅ expansive⸢η⸣[ ⇄A⇄ ] ⟆
  ⊑‣ [⊑][[ (γ⸢η⸣[ ⇄A⇄ ] ⟐ pure ⋅ η[ ⇄A⇄ ]) ⟐ f ]]
  ⊑‣ [⊑-≈] γ⸢η⸣[ ⇄A⇄ ] ⟐ pure ⋅ η[ ⇄A⇄ ] ⟐ f ⟅ associative[⟐] ⟆
  ⬜

◇right-unit[⟐]⸢expansive⸢η⸣⸣[_] : ∀ {𝓁} {A₁ A₂ B : POSet 𝓁} (⇄A⇄ : A₁ η⇄γ A₂) {f : ⟪ A₁ ⇒ 𝒫 B ⟫} → f ⊑ f ⟐ γ⸢η⸣[ ⇄A⇄ ] ⟐ pure ⋅ η[ ⇄A⇄ ]
◇right-unit[⟐]⸢expansive⸢η⸣⸣[ ⇄A⇄ ] {f} = [⊑-proof-mode]
  do [⊑][[ f ]]
  ⊑‣ [⊑-≈] f ⟐ return ⟅ ◇ right-unit[⟐] ⟆
  ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 f ] [⊑] γ⸢η⸣[ ⇄A⇄ ] ⟐ pure ⋅ η[ ⇄A⇄ ] ⟅ expansive⸢η⸣[ ⇄A⇄ ] ⟆
  ⊑‣ [⊑][[ f ⟐ γ⸢η⸣[ ⇄A⇄ ] ⟐ pure ⋅ η[ ⇄A⇄ ] ]]
  ⬜

left-unit[⟐]⸢contractive⸢η⸣⸣[_] : ∀ {𝓁} {A B₁ B₂ : POSet 𝓁} (⇄A⇄ : B₁ η⇄γ B₂) {f : ⟪ A ⇒ 𝒫 B₂ ⟫} → pure ⋅ η[ ⇄A⇄ ] ⟐ γ⸢η⸣[ ⇄A⇄ ] ⟐ f ⊑ f
left-unit[⟐]⸢contractive⸢η⸣⸣[ ⇄A⇄ ] {f} = [⊑-proof-mode]
  do [⊑][[ pure ⋅ η[ ⇄A⇄ ] ⟐ γ⸢η⸣[ ⇄A⇄ ] ⟐ f ]]
  ⊑‣ [⊑-≈] (pure ⋅ η[ ⇄A⇄ ] ⟐ γ⸢η⸣[ ⇄A⇄ ]) ⟐ f ⟅ ◇ associative[⟐] ⟆
  ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 f ] [⊑] return ⟅ contractive⸢η⸣[ ⇄A⇄ ] ⟆
  ⊑‣ [⊑][[ return ⟐ f ]]
  ⊑‣ [⊑-≈] f ⟅ left-unit[⟐] ⟆
  ⬜

left-unit[*]⸢contractive⸢η⸣⸣[_] : ∀ {𝓁} {B₁ B₂ : POSet 𝓁} (⇄A⇄ : B₁ η⇄γ B₂) {X : ⟪ 𝒫 B₂ ⟫} → (pure ⋅ η[ ⇄A⇄ ]) * ⋅ (γ⸢η⸣[ ⇄A⇄ ] * ⋅ X) ⊑ X
left-unit[*]⸢contractive⸢η⸣⸣[ ⇄A⇄ ] {X = X} = [⊑-proof-mode]
  do [⊑][[ (pure ⋅ η[ ⇄A⇄ ]) * ⋅ (γ⸢η⸣[ ⇄A⇄ ] * ⋅ X) ]]
  ⊑‣ [⊑-≈] (pure ⋅ η[ ⇄A⇄ ] ⟐ γ⸢η⸣[ ⇄A⇄ ]) * ⋅ X ⟅ ◇ associative[⟐]⸢*⸣ ⟆
  ⊑‣ [⊑-focus-left [⋅] 𝑜𝑓 X ] $
     [⊑-focus-in [*] ] [⊑] return ⟅ contractive⸢η⸣[ ⇄A⇄ ] ⟆
  ⊑‣ [⊑][[ return * ⋅ X ]]
  ⊑‣ [⊑-≈] X ⟅ left-unit[*] ⟆
  ⬜

right-unit[⟐]⸢contractive⸢η⸣⸣[_] : ∀ {𝓁} {A₁ A₂ B : POSet 𝓁} (⇄A⇄ : A₁ η⇄γ A₂) {f : ⟪ A₂ ⇒ 𝒫 B ⟫} → f ⟐ pure ⋅ η[ ⇄A⇄ ] ⟐ γ⸢η⸣[ ⇄A⇄ ] ⊑ f
right-unit[⟐]⸢contractive⸢η⸣⸣[ ⇄A⇄ ] {f} = [⊑-proof-mode]
  do [⊑][[ f ⟐ pure ⋅ η[ ⇄A⇄ ] ⟐ γ⸢η⸣[ ⇄A⇄ ] ]]
  ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 f ] [⊑] return ⟅ contractive⸢η⸣[ ⇄A⇄ ] ⟆
  ⊑‣ [⊑][[ f ⟐ return ]]
  ⊑‣ [⊑-≈] f ⟅ right-unit[⟐] ⟆
  ⬜

infixr 4 _η⇄γ⸢↑⸣_
record _η⇄γ⸢↑⸣_ {𝓁} (A B : Set 𝓁) {{A-PO : PreOrder 𝓁 A}} {{B-PO : PreOrder 𝓁 B}} : Set (sucˡ 𝓁) where
  field
    η⸢↑⸣ : A → B
    monotonic[η⸢↑⸣] : proper (_⊴_ ⇉ _⊴_) η⸢↑⸣
    γ⸢↑⸣ : B → A → Set 𝓁
    monotonic[γ⸢↑⸣] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) γ⸢↑⸣
    sound[ηγ]⸢↑⸣ : ∀ {x : A} → γ⸢↑⸣ (η⸢↑⸣ x) x
    complete[ηγ]⸢↑⸣ : ∀ {x x^} → γ⸢↑⸣ x^ x → η⸢↑⸣ x ⊴ x^
    
mk[η⇄γ]⸢↑⸣ :
  ∀ {𝓁} {A B : Set 𝓁}
    {{A-PO : PreOrder 𝓁 A}} {{A-REX : Reflexive (_⊴_ {A = A})}}
    {{B-PO : PreOrder 𝓁 B}} {{B-REX : Reflexive (_⊴_ {A = B})}}
  → A η⇄γ⸢↑⸣ B → ⇧ A η⇄γ ⇧ B
mk[η⇄γ]⸢↑⸣ {A = A} {B} A⇄B = record
  { η[_] = witness-x (curry⸢λ↑⸣ id⸢λ↑⸣) $ mk[witness] η⸢↑⸣ monotonic[η⸢↑⸣]
  ; γ⸢η⸣[_] = witness-x (curry⸢λ↑⸣ id⸢ω↑⸣) $ mk[witness] γ⸢↑⸣ monotonic[γ⸢↑⸣]
  ; expansive⸢η⸣[_] = π₂ expansive↔sound⸢η⸣ sound[ηγ]⸢↑⸣
  ; contractive⸢η⸣[_] = π₂ contractive↔complete⸢η⸣ (intro[⊑]⸢↓⸣ ∘ complete[ηγ]⸢↑⸣)
  }
  where open _η⇄γ⸢↑⸣_ A⇄B

η⇄γ↔α⇄γᵐ : ∀ {𝓁} {A B : POSet 𝓁} → (A η⇄γ B) ↔ (A α⇄γᵐ B)
η⇄γ↔α⇄γᵐ = LHS , RHS
  where
    LHS : ∀ {𝓁} {A B : POSet 𝓁} → A η⇄γ B → A α⇄γᵐ B
    LHS A⇄B = record
      { αᵐ[_] = pure ⋅ η[ A⇄B ]
      ; γᵐ[_] = γ⸢η⸣[ A⇄B ]
      ; expansiveᵐ[_] = expansive⸢η⸣[ A⇄B ]
      ; contractiveᵐ[_] = contractive⸢η⸣[ A⇄B ]
      }
    RHS : ∀ {𝓁} {A B : POSet 𝓁} → A α⇄γᵐ B → A η⇄γ B
    RHS {A = A} {B} A⇄B = record
      { η[_] = η
      ; γ⸢η⸣[_] = γᵐ[ A⇄B ]
      ; expansive⸢η⸣[_] = π₂ expansive↔sound⸢η⸣ sound
      ; contractive⸢η⸣[_] = π₂ contractive↔complete⸢η⸣ complete
      }
      where
        fun : ⟪ A ⟫ → ⟪ B ⟫
        fun x with soundᵐ[ A⇄B ] {x}
        ... | ∃𝒫 y ,, y∈α[x] ,, x∈γ[y] = y
        abstract
          ppr : proper (_⊑_ ⇉ _⊑_) fun
          ppr {x} {y} x⊑y with soundᵐ[ A⇄B ] {x} | soundᵐ[ A⇄B ] {y}
          ... | ∃𝒫 x^ ,, x^∈α[x] ,, x∈γ[x^] | ∃𝒫 y^ ,, y^∈α[y] ,, y∈γ[y^] =
            res-X[ω]⸢⊑⸣ (res-f[λ]⸢⊑⸣ $ contractiveᵐ[ A⇄B ]) $
            ∃𝒫 x ,, res-x[ω]⸢⊑⸣ {X = γᵐ[ A⇄B ] ⋅ y^} x⊑y y∈γ[y^] ,, x^∈α[x]
        η : ⟪ A ⇒ B ⟫
        η = witness-x (curry⸢λ⸣ $ id⸢λ⸣) $ mk[witness] fun ppr
        sound : ∀ {x} → x ⋿ γᵐ[ A⇄B ] ⋅ (η ⋅ x)
        sound {x} with soundᵐ[ A⇄B ] {x}
        ... | ∃𝒫 x^ ,, x^∈α[x] ,, x∈γ[x^] = x∈γ[x^]
        complete : ∀ {x x^} → x ⋿ γᵐ[ A⇄B ] ⋅ x^ → η ⋅ x ⊑ x^
        complete {x} {x^} x∈γ[x^] with soundᵐ[ A⇄B ] {x}
        ... | ∃𝒫 y^ ,, y^∈α[x] ,, x∈γ[y^] = completeᵐ[ A⇄B ] $ ∃𝒫 x ,, x∈γ[x^] ,, y^∈α[x]

αᵐ→η[_] : ∀ {𝓁} {A B : POSet 𝓁} → A α⇄γᵐ B → A η⇄γ B
αᵐ→η[_] = π₂ η⇄γ↔α⇄γᵐ

η→αᵐ[_] : ∀ {𝓁} {A B : POSet 𝓁} → A η⇄γ B → A α⇄γᵐ B
η→αᵐ[_] = π₁ η⇄γ↔α⇄γᵐ

α≈pure[η] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A α⇄γᵐ B) → αᵐ[ A⇄B ] ≈ pure ⋅ η[ αᵐ→η[ A⇄B ] ]
α≈pure[η] A⇄B = unique[α]ᵐ A⇄B η→αᵐ[ αᵐ→η[ A⇄B ] ] xRx⸢≈⸣

pure[η]≈α : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A η⇄γ B) → pure ⋅ η[ A⇄B ] ≈ αᵐ[ η→αᵐ[ A⇄B ] ]
pure[η]≈α A⇄B = unique[α]ᵐ η→αᵐ[ A⇄B ] η→αᵐ[ A⇄B ] xRx⸢≈⸣

_⌾⸢η⇄γ⸣_ : ∀ {𝓁} {A₁ A₂ A₃ : POSet 𝓁} → A₂ η⇄γ A₃ → A₁ η⇄γ A₂ → A₁ η⇄γ A₃
_⌾⸢η⇄γ⸣_ {𝓁} {A₁} {A₂} {A₃} ⇄A⇄₂ ⇄A⇄₁ = record
  { η[_] = η[ ⇄A⇄₂ ] ⊙ η[ ⇄A⇄₁ ]
  ; γ⸢η⸣[_] = γ⸢η⸣[ ⇄A⇄₁ ] ⟐ γ⸢η⸣[ ⇄A⇄₂ ]
  ; expansive⸢η⸣[_] = [⊑-proof-mode]
      do [⊑][[ return ]]
      ⊑‣ [⊑] γᵐ[ η→αᵐ[ ⇄A⇄₂ ] ⌾⸢α⇄γᵐ⸣ η→αᵐ[ ⇄A⇄₁ ] ] ⟐ αᵐ[ η→αᵐ[ ⇄A⇄₂ ] ⌾⸢α⇄γᵐ⸣ η→αᵐ[ ⇄A⇄₁ ] ] ⟅ expansiveᵐ[ η→αᵐ[ ⇄A⇄₂ ] ⌾⸢α⇄γᵐ⸣ η→αᵐ[ ⇄A⇄₁ ] ] ⟆
      ⊑‣ [⊑-≡] (γ⸢η⸣[ ⇄A⇄₁ ] ⟐ γ⸢η⸣[ ⇄A⇄₂ ]) ⟐ (pure ⋅ η[ ⇄A⇄₂ ] ⟐ pure ⋅ η[ ⇄A⇄₁ ]) ⟅ ↯ ⟆
      ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 (γ⸢η⸣[ ⇄A⇄₁ ] ⟐ γ⸢η⸣[ ⇄A⇄₂ ]) ] [⊑-≈] pure ⋅ (η[ ⇄A⇄₂ ] ⊙ η[ ⇄A⇄₁ ]) ⟅ homomorphic[⟐]⸢pure⸣ ⟆
      ⊑‣ [⊑][[ (γ⸢η⸣[ ⇄A⇄₁ ] ⟐ γ⸢η⸣[ ⇄A⇄₂ ]) ⟐ pure ⋅ (η[ ⇄A⇄₂ ] ⊙ η[ ⇄A⇄₁ ]) ]]
      ⬜
  ; contractive⸢η⸣[_] = [⊑-proof-mode]
      do [⊑][[ pure ⋅ (η[ ⇄A⇄₂ ] ⊙ η[ ⇄A⇄₁ ]) ⟐ (γ⸢η⸣[ ⇄A⇄₁ ] ⟐ γ⸢η⸣[ ⇄A⇄₂ ]) ]]
      ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 (γ⸢η⸣[ ⇄A⇄₁ ] ⟐ γ⸢η⸣[ ⇄A⇄₂ ]) ] [⊑-≈] pure ⋅ η[ ⇄A⇄₂ ] ⟐ pure ⋅ η[ ⇄A⇄₁ ] ⟅ ◇ homomorphic[⟐]⸢pure⸣ ⟆
      ⊑‣ [⊑][[ (pure ⋅ η[ ⇄A⇄₂ ] ⟐ pure ⋅ η[ ⇄A⇄₁ ]) ⟐ (γ⸢η⸣[ ⇄A⇄₁ ] ⟐ γ⸢η⸣[ ⇄A⇄₂ ]) ]]
      ⊑‣ [⊑-≡] αᵐ[ η→αᵐ[ ⇄A⇄₂ ] ⌾⸢α⇄γᵐ⸣ η→αᵐ[ ⇄A⇄₁ ] ] ⟐ γᵐ[ η→αᵐ[ ⇄A⇄₂ ] ⌾⸢α⇄γᵐ⸣ η→αᵐ[ ⇄A⇄₁ ] ] ⟅ ↯ ⟆
      ⊑‣ [⊑] return ⟅ contractiveᵐ[ η→αᵐ[ ⇄A⇄₂ ] ⌾⸢α⇄γᵐ⸣ η→αᵐ[ ⇄A⇄₁ ] ] ⟆
      ⬜
  }

_×⸢η⇄γ⸣_ : ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} → A₁ η⇄γ B₁ → A₂ η⇄γ B₂ → (A₁ ⟨×⟩ A₂) η⇄γ (B₁ ⟨×⟩ B₂)
_×⸢η⇄γ⸣_ {𝓁} {A₁} {A₂} {B₁} {B₂} A₁⇄B₁ A₂⇄B₂ = mk[η⇄γ]⸢↑⸣ record
  { η⸢↑⸣ = η
  ; monotonic[η⸢↑⸣] = monotonic[η]
  ; γ⸢↑⸣ = γ
  ; monotonic[γ⸢↑⸣] = monotonic[γ]
  ; sound[ηγ]⸢↑⸣ = λ {x} → sound {x}
  ; complete[ηγ]⸢↑⸣ = complete
  }
  where
    η : prod A₁ A₂ → prod B₁ B₂
    η (x , y) = η[ A₁⇄B₁ ] ⋅ x , η[ A₂⇄B₂ ] ⋅ y
    monotonic[η] : proper (_⊴_ ⇉ _⊴_) η
    monotonic[η] (x₁⊑x₂ , y₁⊑y₂) = res-x[λ]⸢⊑⸣ {f = η[ A₁⇄B₁ ]} x₁⊑x₂ , res-x[λ]⸢⊑⸣ {f = η[ A₂⇄B₂ ]} y₁⊑y₂
    γ : prod B₁ B₂ → prod A₁ A₂ → Set 𝓁
    γ (x^ , y^) (x , y) = (x ⋿ γ⸢η⸣[ A₁⇄B₁ ] ⋅ x^) × (y ⋿ γ⸢η⸣[ A₂⇄B₂ ] ⋅ y^)
    monotonic[γ] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) γ
    monotonic[γ] (x₁^⊑x₂^ , y₁^⊑y₂^) (x₁⊵x₂ , y₁⊵y₂) (x₁∈γ[x₁^] , y₁∈γ[y₁^]) =
        res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = γ⸢η⸣[ A₁⇄B₁ ]} x₁^⊑x₂^) x₁⊵x₂ x₁∈γ[x₁^]
      , res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = γ⸢η⸣[ A₂⇄B₂ ]} y₁^⊑y₂^) y₁⊵y₂ y₁∈γ[y₁^]
    sound : ∀ {xy} → γ (η xy) xy
    sound {x , y} = sound⸢η⸣[ A₁⇄B₁ ] {x} , sound⸢η⸣[ A₂⇄B₂ ] {y}
    complete : ∀ {xy^ xy} → γ xy^ xy → η xy ⊴ xy^
    complete {x^ , y^} {x , y} (x₁∈γ[x₁^] , y₁∈γ[y₁^]) = complete⸢η⸣[ A₁⇄B₁ ] x₁∈γ[x₁^] , complete⸢η⸣[ A₂⇄B₂ ] y₁∈γ[y₁^]

_⇒⸢η⇄γ⸣_ : ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} → A₁ η⇄γ B₁ → A₂ η⇄γ B₂ → (A₁ ⇒ 𝒫 A₂) α⇄γ (B₁ ⇒ 𝒫 B₂)
_⇒⸢η⇄γ⸣_ {A₁ = A₁} {A₂} {B₁} {B₂} A₁⇄B₁ A₂⇄B₂ = η→αᵐ[ A₁⇄B₁ ] ⇒⸢α⇄γᵐ⸣ η→αᵐ[ A₂⇄B₂ ]

α[f]⊑f^[_,_]⸢η⸣ :
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (A₁⇄B₁ : A₁ η⇄γ B₁) (A₂⇄B₂ : A₂ η⇄γ B₂) {f : ⟪ A₁ ⇒ 𝒫 A₂ ⟫} {f^ : ⟪ B₁ ⇒ 𝒫 B₂ ⟫}
  → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^ ↔ pure ⋅ η[ A₂⇄B₂ ] ⟐ f ⊑ f^ ⟐ pure ⋅ η[ A₁⇄B₁ ]
α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢η⸣ {f} {f^} = LHS , RHS
  where
    LHS : α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^ → pure ⋅ η[ A₂⇄B₂ ] ⟐ f ⊑ f^ ⟐ pure ⋅ η[ A₁⇄B₁ ]
    LHS α[f]⊑f^ = [⊑-proof-mode]
      do [⊑][[ pure ⋅ η[ A₂⇄B₂ ] ⟐ f ]]
      ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 pure ⋅ η[ A₂⇄B₂ ] ] begin
           do [⊑] f ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⟐ pure ⋅ η[ A₁⇄B₁ ] ⟅ ◇right-unit[⟐]⸢expansive⸢η⸣⸣[ A₁⇄B₁ ] ⟆
           ⊑‣ [⊑-≈] (f ⟐ γ⸢η⸣[ A₁⇄B₁ ]) ⟐ pure ⋅ η[ A₁⇄B₁ ] ⟅ ◇ associative[⟐] ⟆
           end
      ⊑‣ [⊑][[ pure ⋅ η[ A₂⇄B₂ ] ⟐ (f ⟐ γ⸢η⸣[ A₁⇄B₁ ]) ⟐ pure ⋅ η[ A₁⇄B₁ ] ]]
      ⊑‣ [⊑-≈] (pure ⋅ η[ A₂⇄B₂ ] ⟐ f ⟐ γ⸢η⸣[ A₁⇄B₁ ]) ⟐ pure ⋅ η[ A₁⇄B₁ ] ⟅ ◇ associative[⟐] ⟆
      ⊑‣ [⊑-≡] α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⟐ pure ⋅ η[ A₁⇄B₁ ] ⟅ ↯ ⟆
      ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 pure ⋅ η[ A₁⇄B₁ ] ] [⊑] f^ ⟅ α[f]⊑f^ ⟆
      ⊑‣ [⊑][[ f^ ⟐ pure ⋅ η[ A₁⇄B₁ ] ]]
      ⬜
    RHS : pure ⋅ η[ A₂⇄B₂ ] ⟐ f ⊑ f^ ⟐ pure ⋅ η[ A₁⇄B₁ ] → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^
    RHS η⟐f⊑f^⟐η = [⊑-proof-mode]
      do [⊑][[ α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ]]
      ⊑‣ [⊑-≡] pure ⋅ η[ A₂⇄B₂ ] ⟐ f ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⟅ ↯ ⟆
      ⊑‣ [⊑-≈] (pure ⋅ η[ A₂⇄B₂ ] ⟐ f) ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⟅ ◇ associative[⟐] ⟆
      ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 γ⸢η⸣[ A₁⇄B₁ ] ] [⊑] f^ ⟐ pure ⋅ η[ A₁⇄B₁ ] ⟅ η⟐f⊑f^⟐η ⟆
      ⊑‣ [⊑][[ (f^ ⟐ pure ⋅ η[ A₁⇄B₁ ]) ⟐ γ⸢η⸣[ A₁⇄B₁ ] ]]
      ⊑‣ [⊑-≈] f^ ⟐ pure ⋅ η[ A₁⇄B₁ ] ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⟅ associative[⟐] ⟆
      ⊑‣ [⊑] f^ ⟅ right-unit[⟐]⸢contractive⸢η⸣⸣[ A₁⇄B₁ ] ⟆
      ⬜

α[f]⊑f^[_,_]⸢η-pure⸣ : 
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (A₁⇄B₁ : A₁ η⇄γ B₁) (A₂⇄B₂ : A₂ η⇄γ B₂) {f : ⟪ A₁ ⇒ A₂ ⟫} {f^ : ⟪ B₁ ⇒ B₂ ⟫}
  → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ (pure ⋅ f) ⊑ pure ⋅ f^ ↔ η[ A₂⇄B₂ ] ⊙ f ⊑ f^ ⊙ η[ A₁⇄B₁ ]
α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢η-pure⸣ {f} {f^} = LHS , RHS
  where
    LHS : α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ (pure ⋅ f) ⊑ pure ⋅ f^ → η[ A₂⇄B₂ ] ⊙ f ⊑ f^ ⊙ η[ A₁⇄B₁ ]
    LHS α[f]⊑f^ = injective[pure]⸢⊑⸣ [⊑-proof-mode]
      do [⊑][[ pure ⋅ (η[ A₂⇄B₂ ] ⊙ f) ]]
      ⊑‣ [⊑-≈] pure ⋅ η[ A₂⇄B₂ ] ⟐ pure ⋅ f ⟅ ◇ homomorphic[⟐]⸢pure⸣ ⟆
      ⊑‣ [⊑] pure ⋅ f^ ⟐ pure ⋅ η[ A₁⇄B₁ ] ⟅ π₁ α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢η⸣ α[f]⊑f^ ⟆
      ⊑‣ [⊑-≈] pure ⋅ (f^ ⊙ η[ A₁⇄B₁ ]) ⟅ homomorphic[⟐]⸢pure⸣ ⟆
      ⬜
    RHS : η[ A₂⇄B₂ ] ⊙ f ⊑ f^ ⊙ η[ A₁⇄B₁ ] → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ (pure ⋅ f) ⊑ pure ⋅ f^
    RHS η⊙f⊑f^⊙η = π₂ α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢η⸣ [⊑-proof-mode]
      do [⊑][[ pure ⋅ η[ A₂⇄B₂ ] ⟐ pure ⋅ f ]]
      ⊑‣ [⊑-≈] pure ⋅ (η[ A₂⇄B₂ ] ⊙ f) ⟅ homomorphic[⟐]⸢pure⸣ ⟆
      ⊑‣ [⊑-focus-right [⋅] 𝑜𝑓 pure ] [⊑] f^ ⊙ η[ A₁⇄B₁ ] ⟅ η⊙f⊑f^⊙η ⟆
      ⊑‣ [⊑-≈] pure ⋅ f^ ⟐ pure ⋅ η[ A₁⇄B₁ ] ⟅ ◇ homomorphic[⟐]⸢pure⸣ ⟆
      ⬜

α[f]⊑f^[_,_]⸢γ⸣ :
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (A₁⇄B₁ : A₁ η⇄γ B₁) (A₂⇄B₂ : A₂ η⇄γ B₂) {f : ⟪ A₁ ⇒ 𝒫 A₂ ⟫} {f^ : ⟪ B₁ ⇒ 𝒫 B₂ ⟫}
  → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^ ↔ f ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⊑ γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^
α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢γ⸣ {f} {f^} = LHS , RHS
  where
    LHS : α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^ → f ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⊑ γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^
    LHS α[f]⊑f^ = [⊑-proof-mode]
      do [⊑][[ f ⟐ γ⸢η⸣[ A₁⇄B₁ ] ]]
      ⊑‣ [⊑] γ⸢η⸣[ A₂⇄B₂ ] ⟐ pure ⋅ η[ A₂⇄B₂ ] ⟐ f ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⟅ ◇left-unit[⟐]⸢expansive⸢η⸣⸣[ A₂⇄B₂ ] ⟆
      ⊑‣ [⊑-≡] γ⸢η⸣[ A₂⇄B₂ ] ⟐ α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⟅ ↯ ⟆
      ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 γ⸢η⸣[ A₂⇄B₂ ] ] [⊑] f^ ⟅ α[f]⊑f^ ⟆
      ⊑‣ [⊑][[ γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^ ]]
      ⬜
    RHS : f ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⊑ γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^ → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^
    RHS f⟐γ⊑γ⟐f^ = [⊑-proof-mode]
      do [⊑][[ α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ]]
      ⊑‣ [⊑-≡] pure ⋅ η[ A₂⇄B₂ ] ⟐ f ⟐ γ⸢η⸣[ A₁⇄B₁ ] ⟅ ↯ ⟆
      ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 pure ⋅ η[ A₂⇄B₂ ] ] [⊑] γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^ ⟅ f⟐γ⊑γ⟐f^ ⟆
      ⊑‣ [⊑][[ pure ⋅ η[ A₂⇄B₂ ] ⟐ γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^ ]]
      ⊑‣ [⊑] f^ ⟅ left-unit[⟐]⸢contractive⸢η⸣⸣[ A₂⇄B₂ ] ⟆
      ⬜
  
α[f]⊑f^[_,_]⸢γ*⸣ :
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (A₁⇄B₁ : A₁ η⇄γ B₁) (A₂⇄B₂ : A₂ η⇄γ B₂) {f : ⟪ A₁ ⇒ 𝒫 A₂ ⟫} {f^ : ⟪ B₁ ⇒ 𝒫 B₂ ⟫}
  → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^ ↔ (∀ {x} → f * ⋅ (γ⸢η⸣[ A₁⇄B₁ ] ⋅ x) ⊑ γ⸢η⸣[ A₂⇄B₂ ] * ⋅ (f^ ⋅ x))
α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢γ*⸣ {f} {f^} = LHS , RHS
  where
    LHS : α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^ → ∀ {x} → f * ⋅ (γ⸢η⸣[ A₁⇄B₁ ] ⋅ x) ⊑ γ⸢η⸣[ A₂⇄B₂ ] * ⋅ (f^ ⋅ x)
    LHS α[f]⊑f^ {x} = res-f[λ]⸢⊑⸣ {x = x} (π₁ α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢γ⸣ α[f]⊑f^)
    RHS : (∀ {x} → f * ⋅ (γ⸢η⸣[ A₁⇄B₁ ] ⋅ x) ⊑ γ⸢η⸣[ A₂⇄B₂ ] * ⋅ (f^ ⋅ x)) → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^
    RHS f[γ[x]]⊑γ[f^[x]] = π₂ α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢γ⸣ $ ext[λ]⸢⊑⸣ $ λ {x} → f[γ[x]]⊑γ[f^[x]] {x}

α[f]⊑f^[_,_]⸢γ*X⸣ :
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (A₁⇄B₁ : A₁ η⇄γ B₁) (A₂⇄B₂ : A₂ η⇄γ B₂) {f : ⟪ A₁ ⇒ 𝒫 A₂ ⟫} {f^ : ⟪ B₁ ⇒ 𝒫 B₂ ⟫}
  → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^ ↔ (∀ {X} → f * ⋅ (γ⸢η⸣[ A₁⇄B₁ ] * ⋅ X) ⊑ γ⸢η⸣[ A₂⇄B₂ ] * ⋅ (f^ * ⋅ X))
α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢γ*X⸣ {f} {f^} = LHS , RHS
  where
    LHS : α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^ → ∀ {X} → f * ⋅ (γ⸢η⸣[ A₁⇄B₁ ] * ⋅ X) ⊑ γ⸢η⸣[ A₂⇄B₂ ] * ⋅ (f^ * ⋅ X)
    LHS α[f]⊑f^ {X} = [⊑-proof-mode]
      do [⊑][[ f * ⋅ (γ⸢η⸣[ A₁⇄B₁ ] * ⋅ X) ]]
      ⊑‣ [⊑-≈] (f ⟐ γ⸢η⸣[ A₁⇄B₁ ]) * ⋅ X ⟅ ◇ associative[⟐]⸢*⸣ ⟆
      ⊑‣ [⊑-focus-left [⋅] 𝑜𝑓 X ] $
         [⊑-focus-in [*] ] [⊑] γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^ ⟅ π₁ α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢γ⸣ α[f]⊑f^ ⟆
      ⊑‣ [⊑][[ (γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^) * ⋅ X ]]
      ⊑‣ [⊑-≈] γ⸢η⸣[ A₂⇄B₂ ] * ⋅ (f^ * ⋅ X) ⟅ associative[⟐]⸢*⸣ ⟆
      ⬜
    RHS : (∀ {X} → f * ⋅ (γ⸢η⸣[ A₁⇄B₁ ] * ⋅ X) ⊑ γ⸢η⸣[ A₂⇄B₂ ] * ⋅ (f^ * ⋅ X)) → α[ A₁⇄B₁ ⇒⸢η⇄γ⸣ A₂⇄B₂ ] ⋅ f ⊑ f^
    RHS f[γ[X]]⊑γ[f^[X]] = π₂ α[f]⊑f^[ A₁⇄B₁ , A₂⇄B₂ ]⸢γ⸣ $ injective[*]⸢⊑⸣ $ ext[λ]⸢⊑⸣ $ λ {X} → [⊑-proof-mode]
      do [⊑][[ (f ⟐ γ⸢η⸣[ A₁⇄B₁ ]) * ⋅ X ]]
      ⊑‣ [⊑-≈] f * ⋅ (γ⸢η⸣[ A₁⇄B₁ ] * ⋅ X) ⟅ associative[⟐]⸢*⸣ ⟆
      ⊑‣ [⊑] γ⸢η⸣[ A₂⇄B₂ ] * ⋅ (f^ * ⋅ X) ⟅ f[γ[X]]⊑γ[f^[X]] ⟆
      ⊑‣ [⊑-≈] (γ⸢η⸣[ A₂⇄B₂ ] ⟐ f^) * ⋅ X ⟅ ◇ associative[⟐]⸢*⸣ ⟆
      ⬜
