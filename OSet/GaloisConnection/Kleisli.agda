module OSet.GaloisConnection.Kleisli where

open import Prelude
open import OSet.OSet
open import OSet.Fun
open import OSet.Power
open import OSet.Product
open import OSet.Lib
open import OSet.ProofMode

open import OSet.GaloisConnection.Classical

infixr 4 _α⇄γᵐ_
record _α⇄γᵐ_ {𝓁} (A B : POSet 𝓁) : Set (sucˡ 𝓁) where
  field
    αᵐ[_] : ⟪ A ⇒ 𝒫 B ⟫
    γᵐ[_] : ⟪ B ⇒ 𝒫 A ⟫
    expansiveᵐ[_] : return ⊑ γᵐ[_] ⟐ αᵐ[_]
    contractiveᵐ[_] : αᵐ[_] ⟐ γᵐ[_] ⊑ return
open _α⇄γᵐ_ public

expansive↔soundᵐ : ∀ {𝓁} {A B : POSet 𝓁} {α : ⟪ A ⇒ 𝒫 B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → return ⊑ γ ⟐ α ↔ (∀ {x} → x ⋿ γ * ⋅ (α ⋅ x))
expansive↔soundᵐ {A = A} {B} {α} {γ} = LHS , RHS
  where
    LHS : return ⊑ γ ⟐ α → ∀ {x} → x ⋿ γ * ⋅ (α ⋅ x)
    LHS expansive = π₁ return↔⋿ $ res-f[λ]⸢⊑⸣ expansive
    RHS : (∀ {x} → x ⋿ γ * ⋅ (α ⋅ x)) → return ⊑ γ ⟐ α
    RHS sound = ext[λ]⸢⊑⸣ $ π₂ return↔⋿ sound

contractive↔completeᵐ : ∀ {𝓁} {A B : POSet 𝓁} {α : ⟪ A ⇒ 𝒫 B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → α ⟐ γ ⊑ return ↔ (∀ {x^ y^} → y^ ⋿ α * ⋅ (γ ⋅ x^) → y^ ⊑ x^)
contractive↔completeᵐ {A = A} {B} {α} {γ} = LHS , RHS
  where
    LHS : α ⟐ γ ⊑ return → ∀ {x^ y^} → y^ ⋿ α * ⋅ (γ ⋅ x^) → y^ ⊑ x^
    LHS contractive x^∈α[γ[y^]] = π₁ return↔⋿ $ res-f[λ]⸢⊑⸣ contractive ⌾ π₂ return↔⋿ x^∈α[γ[y^]]
    RHS : (∀ {x^ y^} → y^ ⋿ α * ⋅ (γ ⋅ x^) → y^ ⊑ x^) → α ⟐ γ ⊑ return
    RHS complete = ext[λ]⸢⊑⸣ $ ext[ω]⸢⊑⸣ $ complete

soundᵐ[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A α⇄γᵐ B) → ∀ {x} → x ⋿ γᵐ[ A⇄B ] * ⋅ (αᵐ[ A⇄B ] ⋅ x)
soundᵐ[ A⇄B ] = π₁ expansive↔soundᵐ expansiveᵐ[ A⇄B ]

completeᵐ[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A α⇄γᵐ B) → ∀ {x^ y^} → y^ ⋿ αᵐ[ A⇄B ] * ⋅ (γᵐ[ A⇄B ] ⋅ x^) → y^ ⊑ x^
completeᵐ[ A⇄B ] = π₁ contractive↔completeᵐ contractiveᵐ[ A⇄B ]

infixr 4 _α⇄γᵐ⸢↑⸣_
record _α⇄γᵐ⸢↑⸣_ {𝓁} (A B : Set 𝓁) {{A-PO : PreOrder 𝓁 A}} {{B-PO : PreOrder 𝓁 B}} : Set (sucˡ 𝓁) where
  field
    αᵐ⸢↑⸣ : A → B → Set 𝓁
    monotonic[αᵐ⸢↑⸣] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) αᵐ⸢↑⸣
    γᵐ⸢↑⸣ : B → A → Set 𝓁
    monotonic[γᵐ⸢↑⸣] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) γᵐ⸢↑⸣
    sound[αγᵐ]⸢↑⸣ : ∀ {x : A} → ∃ x^ 𝑠𝑡 αᵐ⸢↑⸣ x x^ × γᵐ⸢↑⸣ x^ x
    complete[αγᵐ]⸢↑⸣ : ∀ {x₁^ x₂^ x} → γᵐ⸢↑⸣ x₁^ x → αᵐ⸢↑⸣ x x₂^ → x₂^ ⊴ x₁^

mk[α⇄γᵐ]⸢↑⸣ :
  ∀ {𝓁} {A B : Set 𝓁}
    {{A-PO : PreOrder 𝓁 A}} {{A-REX : Reflexive (_⊴_ {A = A})}}
    {{B-PO : PreOrder 𝓁 B}} {{B-REX : Reflexive (_⊴_ {A = B})}}
  → A α⇄γᵐ⸢↑⸣ B → ⇧ A α⇄γᵐ ⇧ B
mk[α⇄γᵐ]⸢↑⸣ {A = A} {B} A⇄B = record
  { αᵐ[_] = α
  ; γᵐ[_] = γ
  ; expansiveᵐ[_] = π₂ expansive↔soundᵐ $ λ {x} → sound {x}
  ; contractiveᵐ[_] = π₂ contractive↔completeᵐ complete
  }
  where
    open _α⇄γᵐ⸢↑⸣_ A⇄B
    α : ⟪ ⇧ A ⇒ 𝒫 (⇧ B) ⟫
    α = witness-x (curry⸢λ↑⸣ id⸢ω↑⸣) $ mk[witness] αᵐ⸢↑⸣ monotonic[αᵐ⸢↑⸣]
    γ : ⟪ ⇧ B ⇒ 𝒫 (⇧ A) ⟫
    γ = witness-x (curry⸢λ↑⸣ id⸢ω↑⸣) $ mk[witness] γᵐ⸢↑⸣ monotonic[γᵐ⸢↑⸣]
    sound : ∀ {x} → x ⋿ γ * ⋅ (α ⋅ x)
    sound {x} with sound[αγᵐ]⸢↑⸣ {x = ↓ x}
    ... | ∃ x^ ,, x^∈α[x] , x∈γ[x^]  = ∃𝒫 ↑ x^ ,, x^∈α[x] ,, x∈γ[x^]
    complete : ∀ {x^ y^} → x^ ⋿ α * ⋅ (γ ⋅ y^) → x^ ⊑ y^
    complete (∃𝒫 x ,, x∈γ[x^] ,, y^∈α[x]) = intro[⊑]⸢↓⸣ $ complete[αγᵐ]⸢↑⸣ x∈γ[x^] y^∈α[x]


α⇄γᵐ→α⇄γ : ∀ {𝓁} {A B : POSet 𝓁} → A α⇄γᵐ B → 𝒫 A α⇄γ 𝒫 B
α⇄γᵐ→α⇄γ A⇄B = record
  { α[_] = αᵐ[ A⇄B ] *
  ; γ[_] = γᵐ[ A⇄B ] *
  ; expansive[_] = [⊑-proof-mode]
      do [⊑][[ ↑id ]]
      ⊑‣ [⊑-≈] return * ⟅ ◇ left-unit[*]⸢id⸣ ⟆
      ⊑‣ [⊑-focus-in [*] ] [⊑] γᵐ[ A⇄B ] ⟐ αᵐ[ A⇄B ] ⟅ expansiveᵐ[ A⇄B ] ⟆
      ⊑‣ [⊑][[ (γᵐ[ A⇄B ] ⟐ αᵐ[ A⇄B ]) * ]]
      ⊑‣ [⊑-≈] γᵐ[ A⇄B ] * ⊙ αᵐ[ A⇄B ] * ⟅ associative[⟐]⸢⊙⸣ ⟆
      ⬜
  ; contractive[_] = [⊑-proof-mode]
      do [⊑][[ αᵐ[ A⇄B ] * ⊙ γᵐ[ A⇄B ] * ]]
      ⊑‣ [⊑-≈] (αᵐ[ A⇄B ] ⟐ γᵐ[ A⇄B ]) * ⟅ ◇ associative[⟐]⸢⊙⸣ ⟆
      ⊑‣ [⊑-focus-in [*] ] [⊑] return ⟅ contractiveᵐ[ A⇄B ] ⟆
      ⊑‣ [⊑][[ return * ]]
      ⊑‣ [⊑-≈] ↑id ⟅ left-unit[*]⸢id⸣ ⟆
      ⬜
  }

weaken[α]ᵐ : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B₁ A⇄B₂ : A α⇄γᵐ B) → γᵐ[ A⇄B₂ ] ⊑ γᵐ[ A⇄B₁ ] → αᵐ[ A⇄B₁ ] ⊑ αᵐ[ A⇄B₂ ]
weaken[α]ᵐ A⇄B₁ A⇄B₂ γ₂⊑γ₁ = [⊑-proof-mode]
  do [⊑][[ αᵐ[ A⇄B₁ ] ]]
  ⊑‣ [⊑-≈] αᵐ[ A⇄B₁ ] ⟐ return ⟅ ◇ right-unit[⟐] ⟆
  ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 αᵐ[ A⇄B₁ ] ] begin
       do [⊑] γᵐ[ A⇄B₂ ] ⟐ αᵐ[ A⇄B₂ ] ⟅ expansiveᵐ[ A⇄B₂ ] ⟆
       ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 αᵐ[ A⇄B₂ ] ] [⊑] γᵐ[ A⇄B₁ ] ⟅ γ₂⊑γ₁ ⟆
       end
  ⊑‣ [⊑][[ αᵐ[ A⇄B₁ ] ⟐ γᵐ[ A⇄B₁ ] ⟐ αᵐ[ A⇄B₂ ] ]]
  ⊑‣ [⊑-≈] (αᵐ[ A⇄B₁ ] ⟐ γᵐ[ A⇄B₁ ]) ⟐ αᵐ[ A⇄B₂ ] ⟅ ◇ associative[⟐] ⟆
  ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 αᵐ[ A⇄B₂ ] ] [⊑] return ⟅ contractiveᵐ[ A⇄B₁ ] ⟆
  ⊑‣ [⊑][[ return ⟐ αᵐ[ A⇄B₂ ] ]]
  ⊑‣ [⊑-≈] αᵐ[ A⇄B₂ ] ⟅ left-unit[⟐] ⟆
  ⬜

unique[α]ᵐ : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B₁ A⇄B₂ : A α⇄γᵐ B) → γᵐ[ A⇄B₁ ] ≈ γᵐ[ A⇄B₂ ] → αᵐ[ A⇄B₁ ] ≈ αᵐ[ A⇄B₂ ]
unique[α]ᵐ A⇄B₁ A⇄B₂ γ₁≈γ₂ = ⋈[] (weaken[α]ᵐ A⇄B₁ A⇄B₂ $ xRx[] $ ◇ γ₁≈γ₂) (weaken[α]ᵐ A⇄B₂ A⇄B₁ $ xRx[] γ₁≈γ₂)

weaken[γ]ᵐ : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B₁ A⇄B₂ : A α⇄γᵐ B) → αᵐ[ A⇄B₂ ] ⊑ αᵐ[ A⇄B₁ ] → γᵐ[ A⇄B₁ ] ⊑ γᵐ[ A⇄B₂ ]
weaken[γ]ᵐ A⇄B₁ A⇄B₂ α₂⊑α₁ = [⊑-proof-mode]
  do [⊑][[ γᵐ[ A⇄B₁ ] ]]
  ⊑‣ [⊑-≈] return ⟐ γᵐ[ A⇄B₁ ] ⟅ ◇ left-unit[⟐] ⟆
  ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 γᵐ[ A⇄B₁ ] ] begin
       do [⊑] γᵐ[ A⇄B₂ ] ⟐ αᵐ[ A⇄B₂ ] ⟅ expansiveᵐ[ A⇄B₂ ] ⟆
       ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 γᵐ[ A⇄B₂ ] ] [⊑] αᵐ[ A⇄B₁ ] ⟅ α₂⊑α₁ ⟆
       end
  ⊑‣ [⊑][[ (γᵐ[ A⇄B₂ ] ⟐ αᵐ[ A⇄B₁ ]) ⟐ γᵐ[ A⇄B₁ ] ]]
  ⊑‣ [⊑-≈] γᵐ[ A⇄B₂ ] ⟐ αᵐ[ A⇄B₁ ] ⟐ γᵐ[ A⇄B₁ ] ⟅ associative[⟐] ⟆
  ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 γᵐ[ A⇄B₂ ] ] [⊑] return ⟅ contractiveᵐ[ A⇄B₁ ] ⟆
  ⊑‣ [⊑][[ γᵐ[ A⇄B₂ ] ⟐ return ]]
  ⊑‣ [⊑-≈] γᵐ[ A⇄B₂ ] ⟅ right-unit[⟐] ⟆
  ⬜

unique[γ]ᵐ : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B₁ A⇄B₂ : A α⇄γᵐ B) → αᵐ[ A⇄B₁ ] ≈ αᵐ[ A⇄B₂ ] → γᵐ[ A⇄B₁ ] ≈ γᵐ[ A⇄B₂ ]
unique[γ]ᵐ A⇄B₁ A⇄B₂ α₁≈α₂ = ⋈[] (weaken[γ]ᵐ A⇄B₁ A⇄B₂ $ xRx[] $ ◇ α₁≈α₂) (weaken[γ]ᵐ A⇄B₂ A⇄B₁ $ xRx[] α₁≈α₂)

xRx⸢α⇄γᵐ⸣ : ∀ {𝓁} {A : POSet 𝓁} → A α⇄γᵐ A
xRx⸢α⇄γᵐ⸣ = record
  { αᵐ[_] = return
  ; γᵐ[_] = return
  ; expansiveᵐ[_] = xRx[] $ ◇ left-unit[⟐]
  ; contractiveᵐ[_] = xRx[] left-unit[⟐]
  }

infixr 9 _⌾⸢α⇄γᵐ⸣_
_⌾⸢α⇄γᵐ⸣_ : ∀ {𝓁} {A B C : POSet 𝓁} → B α⇄γᵐ C → A α⇄γᵐ B → A α⇄γᵐ C
B⇄C ⌾⸢α⇄γᵐ⸣ A⇄B = record
  { αᵐ[_] = αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]
  ; γᵐ[_] = γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]
  ; expansiveᵐ[_] = [⊑-proof-mode]
      do [⊑][[ return ]]
      ⊑‣ [⊑] γᵐ[ A⇄B ] ⟐ αᵐ[ A⇄B ] ⟅ expansiveᵐ[ A⇄B ] ⟆
      ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 αᵐ[ A⇄B ] ] begin
           do [⊑-≈] γᵐ[ A⇄B ] ⟐ return ⟅ ◇ right-unit[⟐] ⟆
           ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 γᵐ[ A⇄B ] ] [⊑] γᵐ[ B⇄C ] ⟐ αᵐ[ B⇄C ] ⟅ expansiveᵐ[ B⇄C ] ⟆
           ⊑‣ [⊑][[ γᵐ[ A⇄B ] ⟐ (γᵐ[ B⇄C ] ⟐ αᵐ[ B⇄C ]) ]]
           end
      ⊑‣ [⊑][[ (γᵐ[ A⇄B ] ⟐ (γᵐ[ B⇄C ] ⟐ αᵐ[ B⇄C ])) ⟐ αᵐ[ A⇄B ] ]]
      ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 αᵐ[ A⇄B ] ] [⊑-≈] (γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]) ⟐ αᵐ[ B⇄C ] ⟅ ◇ associative[⟐] ⟆
      ⊑‣ [⊑][[ ((γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]) ⟐ αᵐ[ B⇄C ]) ⟐ αᵐ[ A⇄B ] ]]
      ⊑‣ [⊑-≈] (γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]) ⟐ (αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]) ⟅ associative[⟐] ⟆
      ⬜
  ; contractiveᵐ[_] = [⊑-proof-mode]
      do [⊑][[ (αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]) ⟐ (γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]) ]]
      ⊑‣ [⊑-≈] ((αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]) ⟐ γᵐ[ A⇄B ]) ⟐ γᵐ[ B⇄C ] ⟅ ◇ associative[⟐] ⟆
      ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 γᵐ[ B⇄C ] ] begin
           do [⊑-≈] αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ] ⟐ γᵐ[ A⇄B ] ⟅ associative[⟐] ⟆
           ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 αᵐ[ B⇄C ] ] [⊑] return ⟅ contractiveᵐ[ A⇄B ] ⟆
           ⊑‣ [⊑][[ αᵐ[ B⇄C ] ⟐ return ]]
           ⊑‣ [⊑-≈] αᵐ[ B⇄C ] ⟅ right-unit[⟐] ⟆
           end
      ⊑‣ [⊑][[ αᵐ[ B⇄C ] ⟐ γᵐ[ B⇄C ] ]]
      ⊑‣ [⊑] return ⟅ contractiveᵐ[ B⇄C ] ⟆
      ⬜
  }

infixr 4 _⇒⸢α⇄γᵐ⸣_
_⇒⸢α⇄γᵐ⸣_ : ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} → A₁ α⇄γᵐ B₁ → A₂ α⇄γᵐ B₂ → (A₁ ⇒ 𝒫 A₂) α⇄γ (B₁ ⇒ 𝒫 B₂)
_⇒⸢α⇄γᵐ⸣_ {A₁ = A₁} {A₂} {B₁} {B₂} A₁⇄B₁ A₂⇄B₂ = record
  { α[_] = α
  ; γ[_] = γ
  ; expansive[_] = ext[λ]⸢⊑⸣ $ λ {f} → [⊑-proof-mode]
      do [⊑][[ f ]]
      ⊑‣ [⊑-≈] return ⟐ f ⟅ ◇ left-unit[⟐] ⟆
      ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 f ] [⊑] γᵐ[ A₂⇄B₂ ] ⟐ αᵐ[ A₂⇄B₂ ] ⟅ expansiveᵐ[ A₂⇄B₂ ] ⟆
      ⊑‣ [⊑][[ (γᵐ[ A₂⇄B₂ ] ⟐ αᵐ[ A₂⇄B₂ ]) ⟐ f ]]
      ⊑‣ [⊑-≈] γᵐ[ A₂⇄B₂ ] ⟐ αᵐ[ A₂⇄B₂ ] ⟐ f ⟅ associative[⟐] ⟆
      ⊑‣ [⊑-≈] (γᵐ[ A₂⇄B₂ ] ⟐ αᵐ[ A₂⇄B₂ ] ⟐ f) ⟐ return ⟅ ◇ right-unit[⟐] ⟆
      ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 (γᵐ[ A₂⇄B₂ ] ⟐ αᵐ[ A₂⇄B₂ ] ⟐ f) ] [⊑] γᵐ[ A₁⇄B₁ ] ⟐ αᵐ[ A₁⇄B₁ ] ⟅ expansiveᵐ[ A₁⇄B₁ ] ⟆
      ⊑‣ [⊑][[ (γᵐ[ A₂⇄B₂ ] ⟐ αᵐ[ A₂⇄B₂ ] ⟐ f) ⟐ γᵐ[ A₁⇄B₁ ] ⟐ αᵐ[ A₁⇄B₁ ] ]]
      ⊑‣ [⊑-≈]  γᵐ[ A₂⇄B₂ ] ⟐ (αᵐ[ A₂⇄B₂ ] ⟐ f) ⟐ γᵐ[ A₁⇄B₁ ] ⟐ αᵐ[ A₁⇄B₁ ] ⟅ associative[⟐] ⟆
      ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 γᵐ[ A₂⇄B₂ ] ] begin
           do [⊑-≈] ((αᵐ[ A₂⇄B₂ ] ⟐ f) ⟐ γᵐ[ A₁⇄B₁ ]) ⟐ αᵐ[ A₁⇄B₁ ] ⟅ ◇ associative[⟐] ⟆
           ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 αᵐ[ A₁⇄B₁ ] ] [⊑-≈] αᵐ[ A₂⇄B₂ ] ⟐ f ⟐ γᵐ[ A₁⇄B₁ ] ⟅ associative[⟐] ⟆
           ⊑‣ [⊑][[ (αᵐ[ A₂⇄B₂ ] ⟐ f ⟐ γᵐ[ A₁⇄B₁ ]) ⟐ αᵐ[ A₁⇄B₁ ] ]]
           end
      ⊑‣ [⊑][[ γᵐ[ A₂⇄B₂ ] ⟐ (αᵐ[ A₂⇄B₂ ] ⟐ f ⟐ γᵐ[ A₁⇄B₁ ]) ⟐ αᵐ[ A₁⇄B₁ ] ]]
      ⊑‣ [⊑-≡] (γ ⊙ α) ⋅ f ⟅ ↯ ⟆
      ⬜
  ; contractive[_] = ext[λ]⸢⊑⸣ $ λ {f} → [⊑-proof-mode]
      do [⊑][[ (α ⊙ γ) ⋅ f ]]
      ⊑‣ [⊑-≡] αᵐ[ A₂⇄B₂ ] ⟐ (γᵐ[ A₂⇄B₂ ] ⟐ f ⟐ αᵐ[ A₁⇄B₁ ]) ⟐ γᵐ[ A₁⇄B₁ ] ⟅ ↯ ⟆
      ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 αᵐ[ A₂⇄B₂ ] ] begin
           do [⊑-≈] γᵐ[ A₂⇄B₂ ] ⟐ (f ⟐ αᵐ[ A₁⇄B₁ ]) ⟐ γᵐ[ A₁⇄B₁ ] ⟅ associative[⟐] ⟆
           ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 γᵐ[ A₂⇄B₂ ] ] begin
                do [⊑-≈] f ⟐ αᵐ[ A₁⇄B₁ ] ⟐ γᵐ[ A₁⇄B₁ ] ⟅ associative[⟐] ⟆
                ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 f ] [⊑] return ⟅ contractiveᵐ[ A₁⇄B₁ ] ⟆
                ⊑‣ [⊑-≈] f ⟅ right-unit[⟐] ⟆
                end
           end
      ⊑‣ [⊑][[ αᵐ[ A₂⇄B₂ ] ⟐ γᵐ[ A₂⇄B₂ ] ⟐ f ]]
      ⊑‣ [⊑-≈] (αᵐ[ A₂⇄B₂ ] ⟐ γᵐ[ A₂⇄B₂ ]) ⟐ f ⟅ ◇ associative[⟐] ⟆
      ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 f ] [⊑] return ⟅ contractiveᵐ[ A₂⇄B₂ ] ⟆
      ⊑‣ [⊑-≈] f ⟅ left-unit[⟐] ⟆
      ⬜
  }
  where
    α-fun : ⟪ A₁ ⇒ 𝒫 A₂ ⟫ → ⟪ B₁ ⇒ 𝒫 B₂ ⟫
    α-fun f = αᵐ[ A₂⇄B₂ ] ⟐ f ⟐ γᵐ[ A₁⇄B₁ ]
    abstract
      α-ppr : proper (_⊑_ ⇉ _⊑_) α-fun
      α-ppr f₁⊑f₂ = [⊑-proof-mode] [⊑-focus-right [⟐] 𝑜𝑓 _ ] $ [⊑-focus-left [⟐] 𝑜𝑓 _ ] [⊑] _ ⟅ f₁⊑f₂ ⟆ ⬜
    α : ⟪ (A₁ ⇒ 𝒫 A₂) ⇒ (B₁ ⇒ 𝒫 B₂) ⟫
    α = witness-x (curry⸢λ⸣ id⸢λ⸣) $ mk[witness] α-fun α-ppr
    γ-fun : ⟪ B₁ ⇒ 𝒫 B₂ ⟫ → ⟪ A₁ ⇒ 𝒫 A₂ ⟫
    γ-fun f^ = γᵐ[ A₂⇄B₂ ] ⟐ f^ ⟐ αᵐ[ A₁⇄B₁ ]
    abstract
      γ-ppr : proper (_⊑_ ⇉ _⊑_) γ-fun
      γ-ppr f₁⊑f₂ = [⊑-proof-mode] [⊑-focus-right [⟐] 𝑜𝑓 _ ] $ [⊑-focus-left [⟐] 𝑜𝑓 _ ] [⊑] _ ⟅ f₁⊑f₂ ⟆ ⬜
    γ : ⟪ (B₁ ⇒ 𝒫 B₂) ⇒ (A₁ ⇒ 𝒫 A₂) ⟫
    γ = witness-x (curry⸢λ⸣ id⸢λ⸣) $ mk[witness] γ-fun γ-ppr

_×⸢α⇄γᵐ⸣_ : ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} → A₁ α⇄γᵐ B₁ → A₂ α⇄γᵐ B₂ → (A₁ ⟨×⟩ A₂) α⇄γᵐ (B₁ ⟨×⟩ B₂)
_×⸢α⇄γᵐ⸣_ {𝓁} {A₁} {A₂} {B₁} {B₂} A₁⇄B₁ A₂⇄B₂ = mk[α⇄γᵐ]⸢↑⸣ $ record
  { αᵐ⸢↑⸣ = α
  ; monotonic[αᵐ⸢↑⸣] = monotonic[α]
  ; γᵐ⸢↑⸣ = γ
  ; monotonic[γᵐ⸢↑⸣] = monotonic[γ]
  ; sound[αγᵐ]⸢↑⸣ = sound
  ; complete[αγᵐ]⸢↑⸣ = complete
  }
  where
    α : prod A₁ A₂ → prod B₁ B₂ → Set 𝓁
    α (x , y) (x^ , y^) = (x^ ⋿ αᵐ[ A₁⇄B₁ ] ⋅ x) × (y^ ⋿ αᵐ[ A₂⇄B₂ ] ⋅ y)
    abstract
      monotonic[α] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) α
      monotonic[α] (x₁⊑x₂ , y₁⊑y₂) (x₁^⊒x₂^ , y₁^⊒y₂^) (x₁^∈α[x₁] , y₁^∈α[y₁]) =
          res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = αᵐ[ A₁⇄B₁ ]} x₁⊑x₂) x₁^⊒x₂^ x₁^∈α[x₁]
        , res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = αᵐ[ A₂⇄B₂ ]} y₁⊑y₂) y₁^⊒y₂^ y₁^∈α[y₁]
    γ : prod B₁ B₂ → prod A₁ A₂ → Set 𝓁
    γ (x^ , y^) (x , y) = (x ⋿ γᵐ[ A₁⇄B₁ ] ⋅ x^) × (y ⋿ γᵐ[ A₂⇄B₂ ] ⋅ y^)
    abstract
      monotonic[γ] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) γ
      monotonic[γ] (x₁^⊑x₂^ , y₁^⊑y₂^) (x₁⊒x₂ , y₁⊒y₂) (x₁∈γ[x₁^] , y₁∈γ[y₁^]) =
          res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = γᵐ[ A₁⇄B₁ ]} x₁^⊑x₂^) x₁⊒x₂ x₁∈γ[x₁^]
        , res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = γᵐ[ A₂⇄B₂ ]} y₁^⊑y₂^) y₁⊒y₂ y₁∈γ[y₁^]
    sound : ∀ {xy : prod A₁ A₂} → ∃ xy^ 𝑠𝑡 α xy xy^ × γ xy^ xy
    sound {x , y} with soundᵐ[ A₁⇄B₁ ] {x} | soundᵐ[ A₂⇄B₂ ] {y}
    ... | ∃𝒫 x^ ,, x^∈α[x] ,, x∈γ[x^] | ∃𝒫 y^ ,, y∈α[y^] ,, y^∈γ[y] = ∃ (x^ , y^) ,, (x^∈α[x] , y∈α[y^]) , (x∈γ[x^] , y^∈γ[y])
    complete : ∀ {xy₁^ xy₂^ : prod B₁ B₂} {xy : prod A₁ A₂} → γ xy₁^ xy → α xy xy₂^ → xy₂^ ⊴ xy₁^
    complete {x₁^ , y₁^} {x₂^ , y₂^} {x , y} (x∈γ[x₁^] , y∈γ[y₁^]) (x₂^∈α[x] , y₂^∈α[y]) =
        (completeᵐ[ A₁⇄B₁ ] $ ∃𝒫 x ,, x∈γ[x₁^] ,, x₂^∈α[x])
      , (completeᵐ[ A₂⇄B₂ ] $ ∃𝒫 y ,, y∈γ[y₁^] ,, y₂^∈α[y])
