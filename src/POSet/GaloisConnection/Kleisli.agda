module POSet.GaloisConnection.Kleisli where

open import Prelude
open import POSet.POSet
open import POSet.Fun
open import POSet.Power
open import POSet.Product
open import POSet.Lib
open import POSet.ProofMode
open import POSet.PowerMonad

open import POSet.GaloisConnection.Classical

infixr 4 _⇄ᵐ_
record _⇄ᵐ_ {𝓁} (A B : POSet 𝓁) : Set (sucˡ 𝓁) where
  field
    αᵐ[_] : ⟪ A ⇒ 𝒫 B ⟫
    γᵐ[_] : ⟪ B ⇒ 𝒫 A ⟫
    expansiveᵐ[_] : return ⊑ γᵐ[_] ⟐ αᵐ[_]
    contractiveᵐ[_] : αᵐ[_] ⟐ γᵐ[_] ⊑ return
open _⇄ᵐ_ public

expansive↔soundᵐ : ∀ {𝓁} {A B : POSet 𝓁} {α : ⟪ A ⇒ 𝒫 B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → return ⊑ γ ⟐ α ↔ (∀ {x} → x ⋿ γ * ⋅ (α ⋅ x))
expansive↔soundᵐ {A = A} {B} {α} {γ} = LHS , RHS
  where
    LHS : return ⊑ γ ⟐ α → ∀ {x} → x ⋿ γ * ⋅ (α ⋅ x)
    LHS expansive = π₁ return↔⋿ $ res-f[⇒]⸢⊑⸣ expansive
    RHS : (∀ {x} → x ⋿ γ * ⋅ (α ⋅ x)) → return ⊑ γ ⟐ α
    RHS sound = ext[⇒]⸢⊑⸣ $ π₂ return↔⋿ sound

contractive↔completeᵐ : ∀ {𝓁} {A B : POSet 𝓁} {α : ⟪ A ⇒ 𝒫 B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → α ⟐ γ ⊑ return ↔ (∀ {x♯ y♯} → y♯ ⋿ α * ⋅ (γ ⋅ x♯) → y♯ ⊑ x♯)
contractive↔completeᵐ {A = A} {B} {α} {γ} = LHS , RHS
  where
    LHS : α ⟐ γ ⊑ return → ∀ {x♯ y♯} → y♯ ⋿ α * ⋅ (γ ⋅ x♯) → y♯ ⊑ x♯
    LHS contractive x♯∈α[γ[y♯]] = π₁ return↔⋿ $ res-f[⇒]⸢⊑⸣ contractive ⌾ π₂ return↔⋿ x♯∈α[γ[y♯]]

    RHS : (∀ {x♯ y♯} → y♯ ⋿ α * ⋅ (γ ⋅ x♯) → y♯ ⊑ x♯) → α ⟐ γ ⊑ return
    RHS complete = ext[⇒]⸢⊑⸣ $ ext[𝒫]⸢⊑⸣ $ complete

soundᵐ[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A ⇄ᵐ B) → ∀ {x} → x ⋿ γᵐ[ A⇄B ] * ⋅ (αᵐ[ A⇄B ] ⋅ x)
soundᵐ[ A⇄B ] = π₁ expansive↔soundᵐ expansiveᵐ[ A⇄B ]

completeᵐ[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A ⇄ᵐ B) → ∀ {x♯ y♯} → y♯ ⋿ αᵐ[ A⇄B ] * ⋅ (γᵐ[ A⇄B ] ⋅ x♯) → y♯ ⊑ x♯
completeᵐ[ A⇄B ] = π₁ contractive↔completeᵐ contractiveᵐ[ A⇄B ]

left-unit-expansive[⟐]ᵐ[_] : ∀ {𝓁} {A B₁ B₂ : POSet 𝓁} (⇄B⇄ : B₁ ⇄ᵐ B₂) {f : ⟪ A ⇒ 𝒫 B₁ ⟫} → f ⊑ (γᵐ[ ⇄B⇄ ] ⟐ αᵐ[ ⇄B⇄ ]) ⟐ f
left-unit-expansive[⟐]ᵐ[ ⇄B⇄ ] {f} = let open §-ProofMode[⊑] in [proof-mode]
  do [[ f ]]
   ‣ ⟅ ◇ left-unit[⟐] ⟆⸢≈⸣
   ‣ [[ return ⟐ f ]]
   ‣ [focus-left [⟐] 𝑜𝑓 f ] ⟅ expansiveᵐ[ ⇄B⇄ ] ⟆
   ‣ [[ (γᵐ[ ⇄B⇄ ] ⟐ αᵐ[ ⇄B⇄ ]) ⟐ f ]]
   ∎

right-unit-expansive[⟐]ᵐ[_] : ∀ {𝓁} {A₁ A₂ B : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᵐ A₂) {f : ⟪ A₁ ⇒ 𝒫 B ⟫} → f ⊑ f ⟐ γᵐ[ ⇄A⇄ ] ⟐ αᵐ[ ⇄A⇄ ]
right-unit-expansive[⟐]ᵐ[ ⇄A⇄ ] {f} = let open §-ProofMode[⊑] in [proof-mode]
  do [[ f ]]
   ‣ ⟅ ◇ right-unit[⟐] ⟆⸢≈⸣
   ‣ [[ f ⟐ return ]]
   ‣ [focus-right [⟐] 𝑜𝑓 f ] ⟅ expansiveᵐ[ ⇄A⇄ ] ⟆
   ‣ [[ f ⟐ γᵐ[ ⇄A⇄ ] ⟐ αᵐ[ ⇄A⇄ ] ]]
   ∎

left-unit-contractive[⟐]ᵐ[_] : ∀ {𝓁} {A B₁ B₂ : POSet 𝓁} (⇄B⇄ : B₁ ⇄ᵐ B₂) {f : ⟪ A ⇒ 𝒫 B₂ ⟫} → (αᵐ[ ⇄B⇄ ] ⟐ γᵐ[ ⇄B⇄ ]) ⟐ f ⊑ f
left-unit-contractive[⟐]ᵐ[ ⇄B⇄ ] {f} = let open §-ProofMode[⊑] in [proof-mode]
  do [[ (αᵐ[ ⇄B⇄ ] ⟐ γᵐ[ ⇄B⇄ ]) ⟐ f ]]
   ‣ [focus-left [⟐] 𝑜𝑓 f ] ⟅ contractiveᵐ[ ⇄B⇄ ] ⟆
   ‣ [[ return ⟐ f ]]
   ‣ ⟅ left-unit[⟐] ⟆⸢≈⸣
   ‣ [[ f ]]
   ∎

right-unit-contractive[⟐]ᵐ[_] : ∀ {𝓁} {A₁ A₂ B : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᵐ A₂) {f : ⟪ A₂ ⇒ 𝒫 B ⟫} → f ⟐ αᵐ[ ⇄A⇄ ] ⟐ γᵐ[ ⇄A⇄ ] ⊑ f
right-unit-contractive[⟐]ᵐ[ ⇄A⇄ ] {f} = let open §-ProofMode[⊑] in [proof-mode]
  do [[ f ⟐ αᵐ[ ⇄A⇄ ] ⟐ γᵐ[ ⇄A⇄ ] ]]
   ‣ [focus-right [⟐] 𝑜𝑓 f ] ⟅ contractiveᵐ[ ⇄A⇄ ] ⟆
   ‣ [[ f ⟐ return ]]
   ‣ ⟅ right-unit[⟐] ⟆⸢≈⸣
   ‣ [[ f ]]
   ∎

weaken[α]ᵐ : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B₁ A⇄B₂ : A ⇄ᵐ B) → γᵐ[ A⇄B₂ ] ⊑ γᵐ[ A⇄B₁ ] → αᵐ[ A⇄B₁ ] ⊑ αᵐ[ A⇄B₂ ]
weaken[α]ᵐ A⇄B₁ A⇄B₂ γ₂⊑γ₁ = let open §-ProofMode[⊑] in [proof-mode]
  do [[ αᵐ[ A⇄B₁ ] ]]
   ‣ ⟅ right-unit-expansive[⟐]ᵐ[ A⇄B₂ ] ⟆
   ‣ [[ αᵐ[ A⇄B₁ ] ⟐ γᵐ[ A⇄B₂ ] ⟐ αᵐ[ A⇄B₂ ] ]]
   ‣ [focus-right [⟐] 𝑜𝑓 αᵐ[ A⇄B₁ ] ] $ [focus-left [⟐] 𝑜𝑓 αᵐ[ A⇄B₂ ] ] ⟅ γ₂⊑γ₁ ⟆
   ‣ [[ αᵐ[ A⇄B₁ ] ⟐ γᵐ[ A⇄B₁ ] ⟐ αᵐ[ A⇄B₂ ] ]]
   ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
   ‣ [[ (αᵐ[ A⇄B₁ ] ⟐ γᵐ[ A⇄B₁ ]) ⟐ αᵐ[ A⇄B₂ ] ]]
   ‣ ⟅ left-unit-contractive[⟐]ᵐ[ A⇄B₁ ] ⟆
   ‣ [[ αᵐ[ A⇄B₂ ] ]]
   ∎

unique[α]ᵐ : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B₁ A⇄B₂ : A ⇄ᵐ B) → γᵐ[ A⇄B₁ ] ≈ γᵐ[ A⇄B₂ ] → αᵐ[ A⇄B₁ ] ≈ αᵐ[ A⇄B₂ ]
unique[α]ᵐ A⇄B₁ A⇄B₂ γ₁≈γ₂ = ⋈[] (weaken[α]ᵐ A⇄B₁ A⇄B₂ $ xRx[] $ ◇ γ₁≈γ₂) (weaken[α]ᵐ A⇄B₂ A⇄B₁ $ xRx[] γ₁≈γ₂)

weaken[γ]ᵐ : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B₁ A⇄B₂ : A ⇄ᵐ B) → αᵐ[ A⇄B₂ ] ⊑ αᵐ[ A⇄B₁ ] → γᵐ[ A⇄B₁ ] ⊑ γᵐ[ A⇄B₂ ]
weaken[γ]ᵐ A⇄B₁ A⇄B₂ α₂⊑α₁ = let open §-ProofMode[⊑] in [proof-mode]
  do [[ γᵐ[ A⇄B₁ ] ]]
   ‣ ⟅ left-unit-expansive[⟐]ᵐ[ A⇄B₂ ] ⟆
   ‣ [[ (γᵐ[ A⇄B₂ ] ⟐ αᵐ[ A⇄B₂ ]) ⟐ γᵐ[ A⇄B₁ ] ]]
   ‣ [focus-left [⟐] 𝑜𝑓 γᵐ[ A⇄B₁ ] ] $ [focus-right [⟐] 𝑜𝑓 γᵐ[ A⇄B₂ ] ] ⟅ α₂⊑α₁ ⟆
   ‣ [[ (γᵐ[ A⇄B₂ ] ⟐ αᵐ[ A⇄B₁ ]) ⟐ γᵐ[ A⇄B₁ ] ]]
   ‣ ⟅ associative[⟐] ⟆⸢≈⸣
   ‣ [[ γᵐ[ A⇄B₂ ] ⟐ αᵐ[ A⇄B₁ ] ⟐ γᵐ[ A⇄B₁ ] ]]
   ‣ ⟅ right-unit-contractive[⟐]ᵐ[ A⇄B₁ ] ⟆
   ‣ [[ γᵐ[ A⇄B₂ ] ]]
   ∎

unique[γ]ᵐ : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B₁ A⇄B₂ : A ⇄ᵐ B) → αᵐ[ A⇄B₁ ] ≈ αᵐ[ A⇄B₂ ] → γᵐ[ A⇄B₁ ] ≈ γᵐ[ A⇄B₂ ]
unique[γ]ᵐ A⇄B₁ A⇄B₂ α₁≈α₂ = ⋈[] (weaken[γ]ᵐ A⇄B₁ A⇄B₂ $ xRx[] $ ◇ α₁≈α₂) (weaken[γ]ᵐ A⇄B₂ A⇄B₁ $ xRx[] α₁≈α₂)

infixr 9 _⌾⸢⇄ᵐ⸣_
_⌾⸢⇄ᵐ⸣_ : ∀ {𝓁} {A B C : POSet 𝓁} → B ⇄ᵐ C → A ⇄ᵐ B → A ⇄ᵐ C
B⇄C ⌾⸢⇄ᵐ⸣ A⇄B = record
  { αᵐ[_] = αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]
  ; γᵐ[_] = γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]
  ; expansiveᵐ[_] = let open §-ProofMode[⊑] in [proof-mode]
      do [[ return ]]
       ‣ ⟅ expansiveᵐ[ A⇄B ] ⟆
       ‣ [[ γᵐ[ A⇄B ] ⟐ αᵐ[ A⇄B ] ]]
       ‣ [focus-left [⟐] 𝑜𝑓 αᵐ[ A⇄B ] ] begin
           do [[ γᵐ[ A⇄B ] ]]
            ‣ ⟅ right-unit-expansive[⟐]ᵐ[ B⇄C ] ⟆
            ‣ [[ γᵐ[ A⇄B ] ⟐ (γᵐ[ B⇄C ] ⟐ αᵐ[ B⇄C ]) ]]
            ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
            ‣ [[ (γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]) ⟐ αᵐ[ B⇄C ] ]]
           end
       ‣ [[ ((γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]) ⟐ αᵐ[ B⇄C ]) ⟐ αᵐ[ A⇄B ] ]]
       ‣ ⟅ associative[⟐] ⟆⸢≈⸣
       ‣ [[ (γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]) ⟐ (αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]) ]]
       ∎
  ; contractiveᵐ[_] = let open §-ProofMode[⊑] in [proof-mode]
      do [[ (αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]) ⟐ (γᵐ[ A⇄B ] ⟐ γᵐ[ B⇄C ]) ]]
       ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
       ‣ [[ ((αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]) ⟐ γᵐ[ A⇄B ]) ⟐ γᵐ[ B⇄C ] ]]
       ‣ [focus-left [⟐] 𝑜𝑓 γᵐ[ B⇄C ] ] begin
           do [[ (αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ]) ⟐ γᵐ[ A⇄B ] ]]
            ‣ ⟅ associative[⟐] ⟆⸢≈⸣
            ‣ [[ αᵐ[ B⇄C ] ⟐ αᵐ[ A⇄B ] ⟐ γᵐ[ A⇄B ] ]]
            ‣ ⟅ right-unit-contractive[⟐]ᵐ[ A⇄B ] ⟆
            ‣ [[ αᵐ[ B⇄C ] ]]
           end
       ‣ [[ αᵐ[ B⇄C ] ⟐ γᵐ[ B⇄C ] ]]
       ‣ ⟅ contractiveᵐ[ B⇄C ] ⟆
       ‣ [[ return ]]
       ∎
  }

infixr 4 _⇒⸢⇄ᵐ⸣_
_⇒⸢⇄ᵐ⸣_ : ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} → A₁ ⇄ᵐ A₂ → B₁ ⇄ᵐ B₂ → (A₁ ⇒ 𝒫 B₁) ⇄ (A₂ ⇒ 𝒫 B₂)
_⇒⸢⇄ᵐ⸣_ {A₁ = A₁} {A₂} {B₁} {B₂} ⇄A⇄ ⇄B⇄ = record
  { α[_] = wrap[⟐] ⋅ αᵐ[ ⇄B⇄ ] ⋅ γᵐ[ ⇄A⇄ ]
  ; γ[_] = wrap[⟐] ⋅ γᵐ[ ⇄B⇄ ] ⋅ αᵐ[ ⇄A⇄ ]
  ; expansive[_] = ext[⇒]⸢⊑⸣ $ λ {f} → let open §-ProofMode[⊑] in [proof-mode]
      do [[ f ]]
       ‣ ⟅ left-unit-expansive[⟐]ᵐ[ ⇄B⇄ ] ⟆
       ‣ [[ (γᵐ[ ⇄B⇄ ] ⟐ αᵐ[ ⇄B⇄ ]) ⟐ f ]]
       ‣ ⟅ associative[⟐] ⟆⸢≈⸣
       ‣ [[ γᵐ[ ⇄B⇄ ] ⟐ αᵐ[ ⇄B⇄ ] ⟐ f ]]
       ‣ ⟅ right-unit-expansive[⟐]ᵐ[ ⇄A⇄ ] ⟆
       ‣ [[ (γᵐ[ ⇄B⇄ ] ⟐ αᵐ[ ⇄B⇄ ] ⟐ f) ⟐ γᵐ[ ⇄A⇄ ] ⟐ αᵐ[ ⇄A⇄ ] ]]
       ‣ ⟅ associative[⟐] ⟆⸢≈⸣
       ‣ [[ γᵐ[ ⇄B⇄ ] ⟐ (αᵐ[ ⇄B⇄ ] ⟐ f) ⟐ γᵐ[ ⇄A⇄ ] ⟐ αᵐ[ ⇄A⇄ ] ]]
       ‣ [focus-right [⟐] 𝑜𝑓 γᵐ[ ⇄B⇄ ] ] begin
           do [[ (αᵐ[ ⇄B⇄ ] ⟐ f) ⟐ γᵐ[ ⇄A⇄ ] ⟐ αᵐ[ ⇄A⇄ ] ]]
            ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
            ‣ [[ ((αᵐ[ ⇄B⇄ ] ⟐ f) ⟐ γᵐ[ ⇄A⇄ ]) ⟐ αᵐ[ ⇄A⇄ ] ]]
            ‣ [focus-left [⟐] 𝑜𝑓 αᵐ[ ⇄A⇄ ] ] ⟅ associative[⟐] ⟆⸢≈⸣
            ‣ [[ (αᵐ[ ⇄B⇄ ] ⟐ f ⟐ γᵐ[ ⇄A⇄ ]) ⟐ αᵐ[ ⇄A⇄ ] ]]
           end
       ‣ [[ γᵐ[ ⇄B⇄ ] ⟐ (αᵐ[ ⇄B⇄ ] ⟐ f ⟐ γᵐ[ ⇄A⇄ ]) ⟐ αᵐ[ ⇄A⇄ ] ]]
       ‣ [[ (wrap[⟐] ⋅ γᵐ[ ⇄B⇄ ] ⋅ αᵐ[ ⇄A⇄ ] ⊙ wrap[⟐] ⋅ αᵐ[ ⇄B⇄ ] ⋅ γᵐ[ ⇄A⇄ ]) ⋅ f ]]
       ∎
  ; contractive[_] = ext[⇒]⸢⊑⸣ $ λ {f} → let open §-ProofMode[⊑] in [proof-mode]
      do [[ (wrap[⟐] ⋅ αᵐ[ ⇄B⇄ ] ⋅ γᵐ[ ⇄A⇄ ] ⊙ wrap[⟐] ⋅ γᵐ[ ⇄B⇄ ] ⋅ αᵐ[ ⇄A⇄ ]) ⋅ f ]]
       ‣ [[ αᵐ[ ⇄B⇄ ] ⟐ (γᵐ[ ⇄B⇄ ] ⟐ f ⟐ αᵐ[ ⇄A⇄ ]) ⟐ γᵐ[ ⇄A⇄ ] ]]
       ‣ [focus-right [⟐] 𝑜𝑓 αᵐ[ ⇄B⇄ ] ] begin
           do [[ (γᵐ[ ⇄B⇄ ] ⟐ f ⟐ αᵐ[ ⇄A⇄ ]) ⟐ γᵐ[ ⇄A⇄ ] ]]
            ‣ ⟅ associative[⟐] ⟆⸢≈⸣
            ‣ [[ γᵐ[ ⇄B⇄ ] ⟐ (f ⟐ αᵐ[ ⇄A⇄ ]) ⟐ γᵐ[ ⇄A⇄ ] ]]
            ‣ [focus-right [⟐] 𝑜𝑓 γᵐ[ ⇄B⇄ ] ] begin
                do [[ (f ⟐ αᵐ[ ⇄A⇄ ]) ⟐ γᵐ[ ⇄A⇄ ] ]]
                 ‣ ⟅ associative[⟐] ⟆⸢≈⸣
                 ‣ [[ f ⟐ αᵐ[ ⇄A⇄ ] ⟐ γᵐ[ ⇄A⇄ ] ]]
                 ‣ ⟅ right-unit-contractive[⟐]ᵐ[ ⇄A⇄ ] ⟆
                 ‣ [[ f ]]
                end
           end
       ‣ [[ αᵐ[ ⇄B⇄ ] ⟐ γᵐ[ ⇄B⇄ ] ⟐ f ]]
       ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
       ‣ [[ (αᵐ[ ⇄B⇄ ] ⟐ γᵐ[ ⇄B⇄ ]) ⟐ f ]]
       ‣ ⟅ left-unit-contractive[⟐]ᵐ[ ⇄B⇄ ] ⟆
       ‣ [[ f ]]
       ∎
  }

-- infixr 4 _α⇄γᵐ⸢↑⸣_
-- record _α⇄γᵐ⸢↑⸣_ {𝓁} (A B : Set 𝓁) {{A-PO : PreOrder 𝓁 A}} {{B-PO : PreOrder 𝓁 B}} : Set (sucˡ 𝓁) where
--   field
--     αᵐ⸢↑⸣ : A → B → Set 𝓁
--     monotonic[αᵐ⸢↑⸣] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) αᵐ⸢↑⸣
--     γᵐ⸢↑⸣ : B → A → Set 𝓁
--     monotonic[γᵐ⸢↑⸣] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) γᵐ⸢↑⸣
--     sound[αγᵐ]⸢↑⸣ : ∀ {x : A} → ∃ x^ 𝑠𝑡 αᵐ⸢↑⸣ x x^ × γᵐ⸢↑⸣ x^ x
--     complete[αγᵐ]⸢↑⸣ : ∀ {x₁^ x₂^ x} → γᵐ⸢↑⸣ x₁^ x → αᵐ⸢↑⸣ x x₂^ → x₂^ ⊴ x₁^
-- 
-- mk[α⇄γᵐ]⸢↑⸣ :
--   ∀ {𝓁} {A B : Set 𝓁}
--     {{A-PO : PreOrder 𝓁 A}} {{A-REX : Reflexive (_⊴_ {A = A})}}
--     {{B-PO : PreOrder 𝓁 B}} {{B-REX : Reflexive (_⊴_ {A = B})}}
--   → A α⇄γᵐ⸢↑⸣ B → ⇧ A α⇄γᵐ ⇧ B
-- mk[α⇄γᵐ]⸢↑⸣ {A = A} {B} A⇄B = record
--   { αᵐ[_] = α
--   ; γᵐ[_] = γ
--   ; expansiveᵐ[_] = π₂ expansive↔soundᵐ $ λ {x} → sound {x}
--   ; contractiveᵐ[_] = π₂ contractive↔completeᵐ complete
--   }
--   where
--     open _α⇄γᵐ⸢↑⸣_ A⇄B
--     α : ⟪ ⇧ A ⇒ 𝒫 (⇧ B) ⟫
--     α = witness-x (curry⸢λ↑⸣ id⸢ω↑⸣) $ mk[witness] αᵐ⸢↑⸣ monotonic[αᵐ⸢↑⸣]
--     γ : ⟪ ⇧ B ⇒ 𝒫 (⇧ A) ⟫
--     γ = witness-x (curry⸢λ↑⸣ id⸢ω↑⸣) $ mk[witness] γᵐ⸢↑⸣ monotonic[γᵐ⸢↑⸣]
--     sound : ∀ {x} → x ⋿ γ * ⋅ (α ⋅ x)
--     sound {↑⟨ x ⟩} with sound[αγᵐ]⸢↑⸣ {x}
--     ... | ∃ x^ ,, x^∈α[x] , x∈γ[x^]  = ∃𝒫 ↑ x^ ,, x^∈α[x] ,, x∈γ[x^]
--     complete : ∀ {x^ y^} → x^ ⋿ α * ⋅ (γ ⋅ y^) → x^ ⊑ y^
--     complete (∃𝒫 x ,, x∈γ[x^] ,, y^∈α[x]) = intro[⊑]⸢↓⸣ $ complete[αγᵐ]⸢↑⸣ x∈γ[x^] y^∈α[x]
-- 
-- xRx⸢α⇄γᵐ⸣ : ∀ {𝓁} {A : POSet 𝓁} → A α⇄γᵐ A
-- xRx⸢α⇄γᵐ⸣ = record
--   { αᵐ[_] = return
--   ; γᵐ[_] = return
--   ; expansiveᵐ[_] = xRx[] $ ◇ left-unit[⟐]
--   ; contractiveᵐ[_] = xRx[] left-unit[⟐]
--   }
-- 
-- α⇄γᵐ→α⇄γ : ∀ {𝓁} {A B : POSet 𝓁} → A α⇄γᵐ B → 𝒫 A α⇄γ 𝒫 B
-- α⇄γᵐ→α⇄γ A⇄B = record
--   { α[_] = αᵐ[ A⇄B ] *
--   ; γ[_] = γᵐ[ A⇄B ] *
--   ; expansive[_] = let open §-ProofMode[⊑] in [proof-mode]
--       do [[ idᵒ ]]
--        ‣ ⟅ ◇ left-unit[*]⸢ext⸣ ⟆⸢≈⸣
--        ‣ [[ return * ]]
--        ‣ [focus-in [*] ] ⟅ expansiveᵐ[ A⇄B ] ⟆
--        ‣ [[ (γᵐ[ A⇄B ] ⟐ αᵐ[ A⇄B ]) * ]]
--        ‣ ⟅ associative[⟐]⸢⊙⸣ ⟆⸢≈⸣
--        ‣ [[ γᵐ[ A⇄B ] * ⊙ αᵐ[ A⇄B ] * ]]
--        ∎
--   ; contractive[_] = let open §-ProofMode[⊑] in [proof-mode]
--       do [[ αᵐ[ A⇄B ] * ⊙ γᵐ[ A⇄B ] * ]]
--        ‣ ⟅ ◇ associative[⟐]⸢⊙⸣ ⟆⸢≈⸣
--        ‣ [[ (αᵐ[ A⇄B ] ⟐ γᵐ[ A⇄B ]) * ]]
--        ‣ [focus-in [*] ] ⟅ contractiveᵐ[ A⇄B ] ⟆
--        ‣ [[ return * ]]
--        ‣ ⟅ left-unit[*]⸢ext⸣ ⟆⸢≈⸣
--        ‣ [[ idᵒ ]]
--        ∎
--   }
-- 
-- _×⸢α⇄γᵐ⸣_ : ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} → A₁ α⇄γᵐ B₁ → A₂ α⇄γᵐ B₂ → (A₁ ⟨×⟩ A₂) α⇄γᵐ (B₁ ⟨×⟩ B₂)
-- _×⸢α⇄γᵐ⸣_ {𝓁} {A₁} {A₂} {B₁} {B₂} A₁⇄B₁ A₂⇄B₂ = mk[α⇄γᵐ]⸢↑⸣ $ record
--   { αᵐ⸢↑⸣ = α
--   ; monotonic[αᵐ⸢↑⸣] = monotonic[α]
--   ; γᵐ⸢↑⸣ = γ
--   ; monotonic[γᵐ⸢↑⸣] = monotonic[γ]
--   ; sound[αγᵐ]⸢↑⸣ = sound
--   ; complete[αγᵐ]⸢↑⸣ = complete
--   }
--   where
--     α : prod A₁ A₂ → prod B₁ B₂ → Set 𝓁
--     α (x , y) (x^ , y^) = (x^ ⋿ αᵐ[ A₁⇄B₁ ] ⋅ x) × (y^ ⋿ αᵐ[ A₂⇄B₂ ] ⋅ y)
--     abstract
--       monotonic[α] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) α
--       monotonic[α] (x₁⊑x₂ , y₁⊑y₂) (x₁^⊒x₂^ , y₁^⊒y₂^) (x₁^∈α[x₁] , y₁^∈α[y₁]) =
--           res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = αᵐ[ A₁⇄B₁ ]} x₁⊑x₂) x₁^⊒x₂^ x₁^∈α[x₁]
--         , res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = αᵐ[ A₂⇄B₂ ]} y₁⊑y₂) y₁^⊒y₂^ y₁^∈α[y₁]
--     γ : prod B₁ B₂ → prod A₁ A₂ → Set 𝓁
--     γ (x^ , y^) (x , y) = (x ⋿ γᵐ[ A₁⇄B₁ ] ⋅ x^) × (y ⋿ γᵐ[ A₂⇄B₂ ] ⋅ y^)
--     abstract
--       monotonic[γ] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) γ
--       monotonic[γ] (x₁^⊑x₂^ , y₁^⊑y₂^) (x₁⊒x₂ , y₁⊒y₂) (x₁∈γ[x₁^] , y₁∈γ[y₁^]) =
--           res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = γᵐ[ A₁⇄B₁ ]} x₁^⊑x₂^) x₁⊒x₂ x₁∈γ[x₁^]
--         , res-X-x[ω]⸢⊑⸣ (res-x[λ]⸢⊑⸣ {f = γᵐ[ A₂⇄B₂ ]} y₁^⊑y₂^) y₁⊒y₂ y₁∈γ[y₁^]
--     sound : ∀ {xy : prod A₁ A₂} → ∃ xy^ 𝑠𝑡 α xy xy^ × γ xy^ xy
--     sound {x , y} with soundᵐ[ A₁⇄B₁ ] {x} | soundᵐ[ A₂⇄B₂ ] {y}
--     ... | ∃𝒫 x^ ,, x^∈α[x] ,, x∈γ[x^] | ∃𝒫 y^ ,, y∈α[y^] ,, y^∈γ[y] = ∃ (x^ , y^) ,, (x^∈α[x] , y∈α[y^]) , (x∈γ[x^] , y^∈γ[y])
--     complete : ∀ {xy₁^ xy₂^ : prod B₁ B₂} {xy : prod A₁ A₂} → γ xy₁^ xy → α xy xy₂^ → xy₂^ ⊴ xy₁^
--     complete {x₁^ , y₁^} {x₂^ , y₂^} {x , y} (x∈γ[x₁^] , y∈γ[y₁^]) (x₂^∈α[x] , y₂^∈α[y]) =
--         (completeᵐ[ A₁⇄B₁ ] $ ∃𝒫 x ,, x∈γ[x₁^] ,, x₂^∈α[x])
--       , (completeᵐ[ A₂⇄B₂ ] $ ∃𝒫 y ,, y∈γ[y₁^] ,, y₂^∈α[y])
