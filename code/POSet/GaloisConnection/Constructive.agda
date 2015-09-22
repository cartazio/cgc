module POSet.GaloisConnection.Constructive where

open import Prelude
open import POSet.POSet
open import POSet.Fun
open import POSet.Power
open import POSet.Product
open import POSet.ProofMode
open import POSet.Lib
open import POSet.PowerMonad

open import POSet.GaloisConnection.Classical
open import POSet.GaloisConnection.Kleisli

infixr 4 _⇄ᶜ_
record _⇄ᶜ_ {𝓁} (A B : POSet 𝓁) : Set (sucˡ 𝓁) where
  field
    ηᶜ[_] : ⟪ A ⇒ B ⟫
    γᶜ[_] : ⟪ B ⇒ 𝒫 A ⟫
    expansiveᶜ[x⟐][_] : return ⊑ γᶜ[_] ⟐ pure ⋅ ηᶜ[_]
    contractiveᶜ[x⟐][_] : pure ⋅ ηᶜ[_] ⟐ γᶜ[_] ⊑ return
open _⇄ᶜ_ public

αᶜ[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A ⇄ᶜ B) → ⟪ A ⇒ 𝒫 B ⟫
αᶜ[ A⇄B ] = pure ⋅ ηᶜ[ A⇄B ]

expansiveᶜ[x*][_] : ∀ {𝓁} {A B : POSet 𝓁} (⇄A⇄ : A ⇄ᶜ B) {x : ⟪ A ⟫} → return ⋅ x ⊑ γᶜ[ ⇄A⇄ ] * ⋅ (αᶜ[ ⇄A⇄ ] ⋅ x)
expansiveᶜ[x*][ ⇄A⇄ ] {x} = res-f[⇒]⸢⊑⸣ expansiveᶜ[x⟐][ ⇄A⇄ ]

contractive[x*][_] : ∀ {𝓁} {A B : POSet 𝓁} (⇄A⇄ : A ⇄ᶜ B) {y : ⟪ B ⟫} → αᶜ[ ⇄A⇄ ] * ⋅ (γᶜ[ ⇄A⇄ ] ⋅ y) ⊑ return ⋅ y
contractive[x*][ ⇄A⇄ ] = res-f[⇒]⸢⊑⸣ contractiveᶜ[x⟐][ ⇄A⇄ ]

expansive[X⊙][_] : ∀ {𝓁} {A B : POSet 𝓁} (⇄A⇄ : A ⇄ᶜ B) → id⁺ ⊑ γᶜ[ ⇄A⇄ ] * ⊙ αᶜ[ ⇄A⇄ ] *
expansive[X⊙][ ⇄A⇄ ] = let open §-ProofMode[⊑] in [proof-mode]
  do [[ id⁺ ]]
   ‣ ⟅ ◇ left-unit[*]⸢ext⸣ ⟆⸢≈⸣
   ‣ [[ return * ]]
   ‣ [focus-in [*] ] begin
       do [[ return ]]
        ‣ ⟅ expansiveᶜ[x⟐][ ⇄A⇄ ] ⟆
        ‣ [[ γᶜ[ ⇄A⇄ ] ⟐ αᶜ[ ⇄A⇄ ] ]]
       end
   ‣ [[ (γᶜ[ ⇄A⇄ ] ⟐ αᶜ[ ⇄A⇄ ]) * ]]
   ‣ ⟅ associative[*]⸢⊙⸣ ⟆⸢≈⸣
   ‣ [[ γᶜ[ ⇄A⇄ ] * ⊙ αᶜ[ ⇄A⇄ ] * ]]
   ∎

contractive[X⊙][_] : ∀ {𝓁} {A B : POSet 𝓁} (⇄A⇄ : A ⇄ᶜ B) → αᶜ[ ⇄A⇄ ] * ⊙ γᶜ[ ⇄A⇄ ] * ⊑ id⁺
contractive[X⊙][ ⇄A⇄ ] = let open §-ProofMode[⊑] in [proof-mode]
  do [[ αᶜ[ ⇄A⇄ ] * ⊙ γᶜ[ ⇄A⇄ ] * ]]
   ‣ ⟅ ◇ associative[*]⸢⊙⸣ ⟆⸢≈⸣
   ‣ [[ (αᶜ[ ⇄A⇄ ] * ⊙ γᶜ[ ⇄A⇄ ]) * ]]
   ‣ [focus-in [*] ] begin
       do [[ αᶜ[ ⇄A⇄ ] * ⊙ γᶜ[ ⇄A⇄ ] ]]
        ‣ ⟅ contractiveᶜ[x⟐][ ⇄A⇄ ] ⟆
        ‣ [[ return ]]
       end
   ‣ [[ return * ]]
   ‣ ⟅ left-unit[*]⸢ext⸣ ⟆⸢≈⸣
   ‣ [[ id⁺ ]]
   ∎

expansiveᶜ[X*][_] : ∀ {𝓁} {A B : POSet 𝓁} (⇄A⇄ : A ⇄ᶜ B) {X : ⟪ 𝒫 A ⟫} → X ⊑ γᶜ[ ⇄A⇄ ] * ⋅ (αᶜ[ ⇄A⇄ ] * ⋅ X)
expansiveᶜ[X*][ ⇄A⇄ ] = res-f[⇒]⸢⊑⸣ expansive[X⊙][ ⇄A⇄ ]

contractiveᶜ[X*][_] : ∀ {𝓁} {A B : POSet 𝓁} (⇄A⇄ : A ⇄ᶜ B) {Y : ⟪ 𝒫 B ⟫} → αᶜ[ ⇄A⇄ ] * ⋅ (γᶜ[ ⇄A⇄ ] * ⋅ Y) ⊑ Y
contractiveᶜ[X*][ ⇄A⇄ ] = res-f[⇒]⸢⊑⸣ contractive[X⊙][ ⇄A⇄ ]

-- expansive↔⸢pure⸣ : ∀ {𝓁} {A B : POSet 𝓁} {η : ⟪ A ⇒ B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → return ⊑ γ ⟐ pure ⋅ η ↔ return ⊑ γ ⊙ η
-- expansive↔⸢pure⸣ {A = A} {B} {η} {γ} = LHS , RHS
--   where
--     LHS : return ⊑ γ ⟐ pure ⋅ η → return ⊑ γ ⊙ η
--     LHS return⊑γ⟐η = xRx[] right-unit[⟐]⸢pure⸣ ⌾ return⊑γ⟐η
--     RHS : return ⊑ γ ⊙ η → return ⊑ γ ⟐ pure ⋅ η
--     RHS return⊑γ⊙η = xRx[] (◇ right-unit[⟐]⸢pure⸣) ⌾ return⊑γ⊙η

expansive↔soundᶜ : ∀ {𝓁} {A B : POSet 𝓁} {η : ⟪ A ⇒ B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → return ⊑ γ ⟐ pure ⋅ η ↔ (∀ {x} → x ⋿ γ ⋅ (η ⋅ x))
expansive↔soundᶜ {A = A} {B} {η} {γ} = LHS , RHS
  where
    LHS : return ⊑ γ ⟐ pure ⋅ η → ∀ {x} → x ⋿ γ ⋅ (η ⋅ x)
    LHS expansive = π₁ return↔⋿ $ res-f[⇒]⸢⊑⸣ $ xRx[] right-unit[⟐]⸢pure⸣ ⌾ expansive
    RHS : (∀ {x} → x ⋿ γ ⋅ (η ⋅ x)) → return ⊑ γ ⟐ pure ⋅ η
    RHS sound = xRx[] (◇ right-unit[⟐]⸢pure⸣) ⌾ ext[⇒]⸢⊑⸣ (π₂ return↔⋿ sound)

contractive↔completeᶜ : ∀ {𝓁} {A B : POSet 𝓁} {η : ⟪ A ⇒ B ⟫} {γ : ⟪ B ⇒ 𝒫 A ⟫} → pure ⋅ η ⟐ γ ⊑ return ↔ (∀ {x♯ x} → x ⋿ γ ⋅ x♯ → η ⋅ x ⊑ x♯)
contractive↔completeᶜ {A = A} {B} {η} {γ} = LHS , RHS
  where
    LHS : pure ⋅ η ⟐ γ ⊑ return → ∀ {x♯ x} → x ⋿ γ ⋅ x♯ → η ⋅ x ⊑ x♯
    LHS contractive {x♯} {x} x∈γ[x♯] = π₁ return↔⋿ $ res-f[⇒]⸢⊑⸣ contractive ⌾ let open §-ProofMode[⊑] in [proof-mode]
      do [[ (pure ⋅ η) ⋅ x ]]
       ‣ ⟅ ◇ right-unit[*] ⟆⸢≈⸣
       ‣ [[ (pure ⋅ η) * ⋅ (return ⋅ x) ]]
       ‣ [focus-right [⋅] 𝑜𝑓 (pure ⋅ η) * ] ⟅ π₂ return↔⋿ x∈γ[x♯] ⟆
       ‣ [[ (pure ⋅ η) * ⋅ (γ ⋅ x♯) ]]
       ∎
    RHS : (∀ {x♯ x} → x ⋿ γ ⋅ x♯ → η ⋅ x ⊑ x♯) → pure ⋅ η ⟐ γ ⊑ return
    RHS complete = ext[⇒]⸢⊑⸣ $ ext[𝒫]⸢⊑⸣ H
      where
        H : ∀ {x♯ y♯} → y♯ ⋿ (pure ⋅ η) * ⋅ (γ ⋅ x♯) → y♯ ⊑ x♯
        H (∃𝒫 x ,, x∈γ[x♯] ,, y♯⊑η[x]) = complete x∈γ[x♯] ⌾ y♯⊑η[x]

soundᶜ[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A ⇄ᶜ B) → ∀ {x} → x ⋿ γᶜ[ A⇄B ] ⋅ (ηᶜ[ A⇄B ] ⋅ x)
soundᶜ[ A⇄B ] = π₁ expansive↔soundᶜ expansiveᶜ[x⟐][ A⇄B ]

completeᶜ[_] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A ⇄ᶜ B) → ∀ {x♯ x} → x ⋿ γᶜ[ A⇄B ] ⋅ x♯ → ηᶜ[ A⇄B ] ⋅ x ⊑ x♯
completeᶜ[ A⇄B ] = π₁ contractive↔completeᶜ contractiveᶜ[x⟐][ A⇄B ]

left-unit-expansive[⟐]ᶜ[_] : ∀ {𝓁} {A B₁ B₂ : POSet 𝓁} (⇄B⇄ : B₁ ⇄ᶜ B₂) {f : ⟪ A ⇒ 𝒫 B₁ ⟫} → f ⊑ (γᶜ[ ⇄B⇄ ] ⟐ αᶜ[ ⇄B⇄ ]) ⟐ f
left-unit-expansive[⟐]ᶜ[ ⇄B⇄ ] {f} = let open §-ProofMode[⊑] in [proof-mode]
  do [[ f ]]
   ‣ ⟅ ◇ left-unit[⟐] ⟆⸢≈⸣
   ‣ [[ return ⟐ f ]]
   ‣ [focus-left [⟐] 𝑜𝑓 f ] ⟅ expansiveᶜ[x⟐][ ⇄B⇄ ] ⟆
   ‣ [[ (γᶜ[ ⇄B⇄ ] ⟐ αᶜ[ ⇄B⇄ ]) ⟐ f ]]
   ∎

right-unit-expansive[⟐]ᶜ[_] : ∀ {𝓁} {A₁ A₂ B : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᶜ A₂) {f : ⟪ A₁ ⇒ 𝒫 B ⟫} → f ⊑ f ⟐ γᶜ[ ⇄A⇄ ] ⟐ αᶜ[ ⇄A⇄ ]
right-unit-expansive[⟐]ᶜ[ ⇄A⇄ ] {f} = let open §-ProofMode[⊑] in [proof-mode]
  do [[ f ]]
   ‣ ⟅ ◇ right-unit[⟐] ⟆⸢≈⸣
   ‣ [[ f ⟐ return ]]
   ‣ [focus-right [⟐] 𝑜𝑓 f ] ⟅ expansiveᶜ[x⟐][ ⇄A⇄ ] ⟆
   ‣ [[ f ⟐ γᶜ[ ⇄A⇄ ] ⟐ αᶜ[ ⇄A⇄ ] ]]
   ∎

left-unit-contractive[⟐]ᶜ[_] : ∀ {𝓁} {A B₁ B₂ : POSet 𝓁} (⇄B⇄ : B₁ ⇄ᶜ B₂) {f : ⟪ A ⇒ 𝒫 B₂ ⟫} → (αᶜ[ ⇄B⇄ ] ⟐ γᶜ[ ⇄B⇄ ]) ⟐ f ⊑ f
left-unit-contractive[⟐]ᶜ[ ⇄B⇄ ] {f} = let open §-ProofMode[⊑] in [proof-mode]
  do [[ (αᶜ[ ⇄B⇄ ] ⟐ γᶜ[ ⇄B⇄ ]) ⟐ f ]]
   ‣ [focus-left [⟐] 𝑜𝑓 f ] ⟅ contractiveᶜ[x⟐][ ⇄B⇄ ] ⟆
   ‣ [[ return ⟐ f ]]
   ‣ ⟅ left-unit[⟐] ⟆⸢≈⸣
   ‣ [[ f ]]
   ∎

right-unit-contractive[⟐]ᶜ[_] : ∀ {𝓁} {A₁ A₂ B : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᶜ A₂) {f : ⟪ A₂ ⇒ 𝒫 B ⟫} → f ⟐ αᶜ[ ⇄A⇄ ] ⟐ γᶜ[ ⇄A⇄ ] ⊑ f
right-unit-contractive[⟐]ᶜ[ ⇄A⇄ ] {f} = let open §-ProofMode[⊑] in [proof-mode]
  do [[ f ⟐ αᶜ[ ⇄A⇄ ] ⟐ γᶜ[ ⇄A⇄ ] ]]
   ‣ [focus-right [⟐] 𝑜𝑓 f ] ⟅ contractiveᶜ[x⟐][ ⇄A⇄ ] ⟆
   ‣ [[ f ⟐ return ]]
   ‣ ⟅ right-unit[⟐] ⟆⸢≈⸣
   ‣ [[ f ]]
   ∎

-- left-unit-contractive[*]ᶜ[_] : ∀ {𝓁} {A₁ A₂ B : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᶜ A₂) {f : ⟪ A₂ ⇒ 𝒫 B ⟫} {X : ⟪ 𝒫 A₂ ⟫} → f * ⋅ (αᶜ[ ⇄A⇄ ] * ⋅ (γᶜ[ ⇄A⇄ ] * ⋅ X)) ⊑ f * ⋅ X
-- left-unit-contractive[*]ᶜ[ ⇄A⇄ ] {f} {x} = res-f[⇒]⸢⊑⸣ let open §-ProofMode[⊑] in [proof-mode]
--   do [[ f * ⊙ αᶜ[ ⇄A⇄ ] * ⊙ γᶜ[ ⇄A⇄ ] * ]]
--    ‣ [focus-right [⊙] 𝑜𝑓 f * ] begin
--        do [[ αᶜ[ ⇄A⇄ ] * ⊙ γᶜ[ ⇄A⇄ ] * ]]
--         ‣ ⟅ ◇ associative[*]⸢⊙⸣ ⟆⸢≈⸣
--         ‣ [[ (αᶜ[ ⇄A⇄ ] * ⊙ γᶜ[ ⇄A⇄ ]) * ]]
--         ‣ [focus-in [*] ] begin
--             do [[ αᶜ[ ⇄A⇄ ] * ⊙ γᶜ[ ⇄A⇄ ] ]]
--              ‣ [[ αᶜ[ ⇄A⇄ ] ⟐ γᶜ[ ⇄A⇄ ] ]]
--              ‣ ⟅ contractiveᶜ[x⟐][ ⇄A⇄ ] ⟆
--              ‣ [[ return ]]
--             end
--         ‣ [[ return * ]]
--         ‣ ⟅ left-unit[*]⸢ext⸣ ⟆⸢≈⸣
--         ‣ [[ id⁺ ]]
--        end
--    ‣ [[ f * ⊙ id⁺ ]]
--    ‣ ⟅ right-unit[⊙] ⟆⸢≈⸣
--    ‣ [[ f * ]]
--   ∎

infixr 4 _η⇄γ⸢↑⸣_
record _η⇄γ⸢↑⸣_ {𝓁} (A B : Set 𝓁) {{A-PO : PreOrder 𝓁 A}} {{B-PO : PreOrder 𝓁 B}} : Set (sucˡ 𝓁) where
  field
    η : A → B
    monotonic[η] : proper (_⊴_ ⇉ _⊴_) η
    γ : B → A → Set 𝓁
    monotonic[γ] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) γ
    sound : ∀ {x : A} → γ (η x) x
    complete : ∀ {x x♯} → γ x♯ x → η x ⊴ x♯
    
mk[η⇄γ]⸢↑⸣ :
  ∀ {𝓁} {A B : Set 𝓁}
    {{A-PO : PreOrder 𝓁 A}} {{A-REX : Reflexive (_⊴_ {A = A})}}
    {{B-PO : PreOrder 𝓁 B}} {{B-REX : Reflexive (_⊴_ {A = B})}}
  → A η⇄γ⸢↑⸣ B → ⇧ A ⇄ᶜ ⇧ B
mk[η⇄γ]⸢↑⸣ {A = A} {B} A⇄B = record
  { ηᶜ[_] = witness-x (curry⸢λ↑⸣ id⸢λ↑⸣) $ mk[witness] η monotonic[η]
  ; γᶜ[_] = witness-x (curry⸢λ↑⸣ id⸢ω↑⸣) $ mk[witness] γ monotonic[γ]
  ; expansiveᶜ[x⟐][_] = π₂ expansive↔soundᶜ sound
  ; contractiveᶜ[x⟐][_] = π₂ contractive↔completeᶜ (intro[⊑]⸢↓⸣ ∘ complete)
  }
  where open _η⇄γ⸢↑⸣_ A⇄B

⇄ᶜ↔⇄ᵐ : ∀ {𝓁} {A B : POSet 𝓁} → (A ⇄ᶜ B) ↔ (A ⇄ᵐ B)
⇄ᶜ↔⇄ᵐ = LHS , RHS
  where
    LHS : ∀ {𝓁} {A B : POSet 𝓁} → A ⇄ᶜ B → A ⇄ᵐ B
    LHS A⇄B = record
      { αᵐ[_] = αᶜ[ A⇄B ]
      ; γᵐ[_] = γᶜ[ A⇄B ]
      ; expansiveᵐ[_] = expansiveᶜ[x⟐][ A⇄B ]
      ; contractiveᵐ[_] = contractiveᶜ[x⟐][ A⇄B ]
      }
    RHS : ∀ {𝓁} {A B : POSet 𝓁} → A ⇄ᵐ B → A ⇄ᶜ B
    RHS {A = A} {B} A⇄B = record
      { ηᶜ[_] = η
      ; γᶜ[_] = γᵐ[ A⇄B ]
      ; expansiveᶜ[x⟐][_] = π₂ expansive↔soundᶜ sound
      ; contractiveᶜ[x⟐][_] = π₂ contractive↔completeᶜ complete
      }
      where
        fun : ⟪ A ⟫ → ⟪ B ⟫
        fun x with soundᵐ[ A⇄B ] {x}
        ... | ∃𝒫 y ,, y∈α[x] ,, x∈γ[y] = y
        abstract
          ppr : proper (_⊑_ ⇉ _⊑_) fun
          ppr {x} {y} x⊑y with soundᵐ[ A⇄B ] {x} | soundᵐ[ A⇄B ] {y}
          ... | ∃𝒫 x♯ ,, x♯∈α[x] ,, x∈γ[x♯] | ∃𝒫 y♯ ,, y♯∈α[y] ,, y∈γ[y♯] =
            res-X[𝒫]⸢⊑⸣ (res-f[⇒]⸢⊑⸣ $ contractiveᵐ[ A⇄B ]) $
            ∃𝒫 x ,, res-x[𝒫]⸢⊑⸣ {X = γᵐ[ A⇄B ] ⋅ y♯} x⊑y y∈γ[y♯] ,, x♯∈α[x]
        η : ⟪ A ⇒ B ⟫
        η = witness-x (curry⸢λ⸣ $ id⸢λ⸣) $ mk[witness] fun ppr
        sound : ∀ {x} → x ⋿ γᵐ[ A⇄B ] ⋅ (η ⋅ x)
        sound {x} with soundᵐ[ A⇄B ] {x}
        ... | ∃𝒫 x♯ ,, x♯∈α[x] ,, x∈γ[x♯] = x∈γ[x♯]
        complete : ∀ {x x♯} → x ⋿ γᵐ[ A⇄B ] ⋅ x♯ → η ⋅ x ⊑ x♯
        complete {x} {x♯} x∈γ[x♯] with soundᵐ[ A⇄B ] {x}
        ... | ∃𝒫 y♯ ,, y♯∈α[x] ,, x∈γ[y♯] = completeᵐ[ A⇄B ] $ ∃𝒫 x ,, x∈γ[x♯] ,, y♯∈α[x]

⇄ᵐ→⇄ᶜ[_] : ∀ {𝓁} {A B : POSet 𝓁} → A ⇄ᵐ B → A ⇄ᶜ B
⇄ᵐ→⇄ᶜ[_] = π₂ ⇄ᶜ↔⇄ᵐ

⇄ᶜ→⇄ᵐ[_] : ∀ {𝓁} {A B : POSet 𝓁} → A ⇄ᶜ B → A ⇄ᵐ B
⇄ᶜ→⇄ᵐ[_] = π₁ ⇄ᶜ↔⇄ᵐ

α≈pure[η] : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A ⇄ᵐ B) → αᵐ[ A⇄B ] ≈ αᶜ[ ⇄ᵐ→⇄ᶜ[ A⇄B ] ]
α≈pure[η] A⇄B = unique[α]ᵐ A⇄B ⇄ᶜ→⇄ᵐ[ ⇄ᵐ→⇄ᶜ[ A⇄B ] ] xRx⸢≈⸣

pure[η]≈α : ∀ {𝓁} {A B : POSet 𝓁} (A⇄B : A ⇄ᶜ B) → αᶜ[ A⇄B ] ≈ αᵐ[ ⇄ᶜ→⇄ᵐ[ A⇄B ] ]
pure[η]≈α A⇄B = unique[α]ᵐ ⇄ᶜ→⇄ᵐ[ A⇄B ] ⇄ᶜ→⇄ᵐ[ A⇄B ] xRx⸢≈⸣

_⌾⸢⇄ᶜ⸣_ : ∀ {𝓁} {A B C : POSet 𝓁} → B ⇄ᶜ C → A ⇄ᶜ B → A ⇄ᶜ C
_⌾⸢⇄ᶜ⸣_ {𝓁} {A₁} {A₂} {A₃} B⇄C A⇄B = record
  { ηᶜ[_] = ηᶜ[ B⇄C ] ⊙ ηᶜ[ A⇄B ]
  ; γᶜ[_] = γᶜ[ A⇄B ] ⟐ γᶜ[ B⇄C ]
  ; expansiveᶜ[x⟐][_] = let open §-ProofMode[⊑] in [proof-mode]
      do [[ return ]]
       ‣ ⟅ expansiveᵐ[ ⇄ᶜ→⇄ᵐ[ B⇄C ] ⌾⸢⇄ᵐ⸣ ⇄ᶜ→⇄ᵐ[ A⇄B ] ] ⟆
       ‣ [[ γᵐ[ ⇄ᶜ→⇄ᵐ[ B⇄C ] ⌾⸢⇄ᵐ⸣ ⇄ᶜ→⇄ᵐ[ A⇄B ] ] ⟐ αᵐ[ ⇄ᶜ→⇄ᵐ[ B⇄C ] ⌾⸢⇄ᵐ⸣ ⇄ᶜ→⇄ᵐ[ A⇄B ] ] ]]
       ‣ [[ (γᶜ[ A⇄B ] ⟐ γᶜ[ B⇄C ]) ⟐ (αᶜ[ B⇄C ] ⟐ αᶜ[ A⇄B ]) ]]
       ‣ [focus-right [⟐] 𝑜𝑓 (γᶜ[ A⇄B ] ⟐ γᶜ[ B⇄C ]) ] ⟅ homomorphic[pure]⸢⟐⸣ ⟆⸢≈⸣
       ‣ [[ (γᶜ[ A⇄B ] ⟐ γᶜ[ B⇄C ]) ⟐ pure ⋅ (ηᶜ[ B⇄C ] ⊙ ηᶜ[ A⇄B ]) ]]
       ∎
  ; contractiveᶜ[x⟐][_] = let open §-ProofMode[⊑] in [proof-mode]
      do [[ pure ⋅ (ηᶜ[ B⇄C ] ⊙ ηᶜ[ A⇄B ]) ⟐ (γᶜ[ A⇄B ] ⟐ γᶜ[ B⇄C ]) ]]
       ‣ [focus-left [⟐] 𝑜𝑓 (γᶜ[ A⇄B ] ⟐ γᶜ[ B⇄C ]) ] ⟅ ◇ homomorphic[pure]⸢⟐⸣ ⟆⸢≈⸣
       ‣ [[ (αᶜ[ B⇄C ] ⟐ αᶜ[ A⇄B ]) ⟐ (γᶜ[ A⇄B ] ⟐ γᶜ[ B⇄C ]) ]]
       ‣ [[ αᵐ[ ⇄ᶜ→⇄ᵐ[ B⇄C ] ⌾⸢⇄ᵐ⸣ ⇄ᶜ→⇄ᵐ[ A⇄B ] ] ⟐ γᵐ[ ⇄ᶜ→⇄ᵐ[ B⇄C ] ⌾⸢⇄ᵐ⸣ ⇄ᶜ→⇄ᵐ[ A⇄B ] ] ]]
       ‣ ⟅ contractiveᵐ[ ⇄ᶜ→⇄ᵐ[ B⇄C ] ⌾⸢⇄ᵐ⸣ ⇄ᶜ→⇄ᵐ[ A⇄B ] ] ⟆
       ‣ [[ return ]]
       ∎
  }

_×⸢⇄ᶜ⸣_ : ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} → A₁ ⇄ᶜ A₂ → B₁ ⇄ᶜ B₂ → (A₁ ×⁺ B₁) ⇄ᶜ (A₂ ×⁺ B₂)
_×⸢⇄ᶜ⸣_ {𝓁} {A₁} {A₂} {B₁} {B₂} ⇄A⇄ ⇄B⇄ = mk[η⇄γ]⸢↑⸣ record
  { η = η
  ; monotonic[η] = monotonic[η]
  ; γ = γ
  ; monotonic[γ] = monotonic[γ]
  ; sound = sound
  ; complete = complete
  }
  where
    η : prod A₁ B₁ → prod A₂ B₂
    η (x , y) = ηᶜ[ ⇄A⇄ ] ⋅ x , ηᶜ[ ⇄B⇄ ] ⋅ y
    abstract
      monotonic[η] : proper (_⊴_ ⇉ _⊴_) η
      monotonic[η] (x₁⊑x₂ , y₁⊑y₂) = res-x[⇒]⸢⊑⸣ {f = ηᶜ[ ⇄A⇄ ]} x₁⊑x₂ , res-x[⇒]⸢⊑⸣ {f = ηᶜ[ ⇄B⇄ ]} y₁⊑y₂
    γ : prod A₂ B₂ → prod A₁ B₁ → Set 𝓁
    γ (x♯ , y♯) (x , y) = (x ⋿ γᶜ[ ⇄A⇄ ] ⋅ x♯) × (y ⋿ γᶜ[ ⇄B⇄ ] ⋅ y♯)
    abstract
      monotonic[γ] : proper (_⊴_ ⇉ _⊵_ ⇉ [→]) γ
      monotonic[γ] (x₁♯⊑x₂♯ , y₁♯⊑y₂♯) (x₁⊵x₂ , y₁⊵y₂) (x₁∈γ[x₁♯] , y₁∈γ[y₁♯]) =
          res-X-x[𝒫]⸢⊑⸣ (res-x[⇒]⸢⊑⸣ {f = γᶜ[ ⇄A⇄ ]} x₁♯⊑x₂♯) x₁⊵x₂ x₁∈γ[x₁♯]
        , res-X-x[𝒫]⸢⊑⸣ (res-x[⇒]⸢⊑⸣ {f = γᶜ[ ⇄B⇄ ]} y₁♯⊑y₂♯) y₁⊵y₂ y₁∈γ[y₁♯]
    sound : ∀ {xy} → γ (η xy) xy
    sound {x , y} = soundᶜ[ ⇄A⇄ ] {x} , soundᶜ[ ⇄B⇄ ] {y}
    complete : ∀ {xy♯ xy} → γ xy♯ xy → η xy ⊴ xy♯
    complete {x♯ , y♯} {x , y} (x₁∈γ[x₁♯] , y₁∈γ[y₁♯]) = completeᶜ[ ⇄A⇄ ] x₁∈γ[x₁♯] , completeᶜ[ ⇄B⇄ ] y₁∈γ[y₁♯]

_⇒⸢⇄ᶜ⸣_ : ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} → A₁ ⇄ᶜ A₂ → B₁ ⇄ᶜ B₂ → (A₁ ⇒ 𝒫 B₁) ⇄ (A₂ ⇒ 𝒫 B₂)
_⇒⸢⇄ᶜ⸣_ {A₁ = A₁} {A₂} {B₁} {B₂} ⇄A⇄ ⇄B⇄ = ⇄ᶜ→⇄ᵐ[ ⇄A⇄ ] ⇒⸢⇄ᵐ⸣ ⇄ᶜ→⇄ᵐ[ ⇄B⇄ ]

α[f]↔α⟐fᶜ[_,_] :
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᶜ A₂) (⇄B⇄ : B₁ ⇄ᶜ B₂) {f : ⟪ A₁ ⇒ 𝒫 B₁ ⟫} {f♯ : ⟪ A₂ ⇒ 𝒫 B₂ ⟫}
  → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯ ↔ αᶜ[ ⇄B⇄ ] ⟐ f ⊑ f♯ ⟐ αᶜ[ ⇄A⇄ ]
α[f]↔α⟐fᶜ[ ⇄A⇄ , ⇄B⇄ ] {f} {f♯} = LHS , RHS
  where
    LHS : α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯ → αᶜ[ ⇄B⇄ ] ⟐ f ⊑ f♯ ⟐ αᶜ[ ⇄A⇄ ]
    LHS α[f]⊑f♯ = let open §-ProofMode[⊑] in [proof-mode]
      do [[ αᶜ[ ⇄B⇄ ] ⟐ f ]]
       ‣ [focus-right [⟐] 𝑜𝑓 αᶜ[ ⇄B⇄ ] ] begin
           do [[ f ]]
            ‣ ⟅ right-unit-expansive[⟐]ᶜ[ ⇄A⇄ ] ⟆
            ‣ [[ f ⟐ γᶜ[ ⇄A⇄ ] ⟐ αᶜ[ ⇄A⇄ ] ]]
            ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
            ‣ [[ (f ⟐ γᶜ[ ⇄A⇄ ]) ⟐ αᶜ[ ⇄A⇄ ] ]]
           end
       ‣ [[ αᶜ[ ⇄B⇄ ] ⟐ (f ⟐ γᶜ[ ⇄A⇄ ]) ⟐ αᶜ[ ⇄A⇄ ] ]]
       ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
       ‣ [[ (αᶜ[ ⇄B⇄ ] ⟐ f ⟐ γᶜ[ ⇄A⇄ ]) ⟐ αᶜ[ ⇄A⇄ ] ]]
       ‣ [[ α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⟐ αᶜ[ ⇄A⇄ ] ]]
       ‣ [focus-left [⟐] 𝑜𝑓 αᶜ[ ⇄A⇄ ] ] ⟅ α[f]⊑f♯ ⟆
       ‣ [[ f♯ ⟐ αᶜ[ ⇄A⇄ ] ]]
       ∎
    RHS : αᶜ[ ⇄B⇄ ] ⟐ f ⊑ f♯ ⟐ αᶜ[ ⇄A⇄ ] → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯
    RHS η⟐f⊑f♯⟐η = let open §-ProofMode[⊑] in [proof-mode]
      do [[ α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ]]
       ‣ [[ αᶜ[ ⇄B⇄ ] ⟐ f ⟐ γᶜ[ ⇄A⇄ ] ]]
       ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
       ‣ [[ (αᶜ[ ⇄B⇄ ] ⟐ f) ⟐ γᶜ[ ⇄A⇄ ] ]]
       ‣ [focus-left [⟐] 𝑜𝑓 γᶜ[ ⇄A⇄ ] ] ⟅ η⟐f⊑f♯⟐η ⟆
       ‣ [[ (f♯ ⟐ αᶜ[ ⇄A⇄ ]) ⟐ γᶜ[ ⇄A⇄ ] ]]
       ‣ ⟅ associative[⟐] ⟆⸢≈⸣
       ‣ [[ f♯ ⟐ αᶜ[ ⇄A⇄ ] ⟐ γᶜ[ ⇄A⇄ ] ]]
       ‣ ⟅ right-unit-contractive[⟐]ᶜ[ ⇄A⇄ ] ⟆
       ‣ [[ f♯ ]]
       ∎

α[f]↔η⊙fᶜ[_,_] : 
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᶜ A₂) (⇄B⇄ : B₁ ⇄ᶜ B₂) {f : ⟪ A₁ ⇒ B₁ ⟫} {f♯ : ⟪ A₂ ⇒ B₂ ⟫}
  → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ (pure ⋅ f) ⊑ pure ⋅ f♯ ↔ ηᶜ[ ⇄B⇄ ] ⊙ f ⊑ f♯ ⊙ ηᶜ[ ⇄A⇄ ]
α[f]↔η⊙fᶜ[ ⇄A⇄ , ⇄B⇄ ] {f} {f♯} = LHS , RHS
  where
    LHS : α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ (pure ⋅ f) ⊑ pure ⋅ f♯ → ηᶜ[ ⇄B⇄ ] ⊙ f ⊑ f♯ ⊙ ηᶜ[ ⇄A⇄ ]
    LHS α[f]⊑f♯ = injective[pure]⸢⊑⸣ $ let open §-ProofMode[⊑] in [proof-mode]
      do [[ pure ⋅ (ηᶜ[ ⇄B⇄ ] ⊙ f) ]]
       ‣ ⟅ ◇ homomorphic[pure]⸢⟐⸣ ⟆⸢≈⸣
       ‣ [[ pure ⋅ ηᶜ[ ⇄B⇄ ] ⟐ pure ⋅ f ]]
       ‣ ⟅ π₁ α[f]↔α⟐fᶜ[ ⇄A⇄ , ⇄B⇄ ] α[f]⊑f♯ ⟆
       ‣ [[ pure ⋅ f♯ ⟐ pure ⋅ ηᶜ[ ⇄A⇄ ] ]]
       ‣ ⟅ homomorphic[pure]⸢⟐⸣ ⟆⸢≈⸣
       ‣ [[ pure ⋅ (f♯ ⊙ ηᶜ[ ⇄A⇄ ]) ]]
       ∎
    RHS : ηᶜ[ ⇄B⇄ ] ⊙ f ⊑ f♯ ⊙ ηᶜ[ ⇄A⇄ ] → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ (pure ⋅ f) ⊑ pure ⋅ f♯
    RHS η⊙f⊑f♯⊙η = π₂ α[f]↔α⟐fᶜ[ ⇄A⇄ , ⇄B⇄ ] $ let open §-ProofMode[⊑] in [proof-mode]
      do [[ pure ⋅ ηᶜ[ ⇄B⇄ ] ⟐ pure ⋅ f ]]
       ‣ ⟅ homomorphic[pure]⸢⟐⸣ ⟆⸢≈⸣
       ‣ [[ pure ⋅ (ηᶜ[ ⇄B⇄ ] ⊙ f) ]]
       ‣ [focus-right [⋅] 𝑜𝑓 pure ] ⟅ η⊙f⊑f♯⊙η ⟆
       ‣ ⟅ ◇ homomorphic[pure]⸢⟐⸣ ⟆⸢≈⸣
       ‣ [[ pure ⋅ f♯ ⟐ pure ⋅ ηᶜ[ ⇄A⇄ ] ]]
       ∎

α[f]↔f⟐γᶜ[_,_] :
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᶜ A₂) (⇄B⇄ : B₁ ⇄ᶜ B₂) {f : ⟪ A₁ ⇒ 𝒫 B₁ ⟫} {f♯ : ⟪ A₂ ⇒ 𝒫 B₂ ⟫}
  → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯ ↔ f ⟐ γᶜ[ ⇄A⇄ ] ⊑ γᶜ[ ⇄B⇄ ] ⟐ f♯
α[f]↔f⟐γᶜ[ ⇄A⇄ , ⇄B⇄ ] {f} {f♯} = LHS , RHS
  where
    LHS : α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯ → f ⟐ γᶜ[ ⇄A⇄ ] ⊑ γᶜ[ ⇄B⇄ ] ⟐ f♯
    LHS α[f]⊑f♯ = let open §-ProofMode[⊑] in [proof-mode]
      do [[ f ⟐ γᶜ[ ⇄A⇄ ] ]]
       ‣ ⟅ left-unit-expansive[⟐]ᶜ[ ⇄B⇄ ] ⟆
       ‣ [[ (γᶜ[ ⇄B⇄ ] ⟐ αᶜ[ ⇄B⇄ ]) ⟐ f ⟐ γᶜ[ ⇄A⇄ ] ]]
       ‣ ⟅ associative[⟐] ⟆⸢≈⸣
       ‣ [[ γᶜ[ ⇄B⇄ ] ⟐ αᶜ[ ⇄B⇄ ] ⟐ f ⟐ γᶜ[ ⇄A⇄ ] ]]
       ‣ [[ γᶜ[ ⇄B⇄ ] ⟐ α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ]]
       ‣ [focus-right [⟐] 𝑜𝑓 γᶜ[ ⇄B⇄ ] ] ⟅ α[f]⊑f♯ ⟆
       ‣ [[ γᶜ[ ⇄B⇄ ] ⟐ f♯ ]]
       ∎
    RHS : f ⟐ γᶜ[ ⇄A⇄ ] ⊑ γᶜ[ ⇄B⇄ ] ⟐ f♯ → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯
    RHS f⟐γ⊑γ⟐f♯ = let open §-ProofMode[⊑] in [proof-mode]
      do [[ α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ]]
       ‣ [[ αᶜ[ ⇄B⇄ ] ⟐ f ⟐ γᶜ[ ⇄A⇄ ] ]]
       ‣ [focus-right [⟐] 𝑜𝑓 αᶜ[ ⇄B⇄ ] ] ⟅ f⟐γ⊑γ⟐f♯ ⟆
       ‣ [[ αᶜ[ ⇄B⇄ ] ⟐ γᶜ[ ⇄B⇄ ] ⟐ f♯ ]]
       ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
       ‣ [[ (αᶜ[ ⇄B⇄ ] ⟐ γᶜ[ ⇄B⇄ ]) ⟐ f♯ ]]
       ‣ ⟅ left-unit-contractive[⟐]ᶜ[ ⇄B⇄ ] ⟆
       ‣ [[ f♯ ]]
       ∎
  
α[f]↔f⟐γᶜ*[_,_] :
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᶜ A₂) (⇄B⇄ : B₁ ⇄ᶜ B₂) {f : ⟪ A₁ ⇒ 𝒫 B₁ ⟫} {f♯ : ⟪ A₂ ⇒ 𝒫 B₂ ⟫}
  → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯ ↔ (∀ {x} → f * ⋅ (γᶜ[ ⇄A⇄ ] ⋅ x) ⊑ γᶜ[ ⇄B⇄ ] * ⋅ (f♯ ⋅ x))
α[f]↔f⟐γᶜ*[ ⇄A⇄ , ⇄B⇄ ] {f} {f♯} = LHS , RHS
  where
    LHS : α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯ → ∀ {x} → f * ⋅ (γᶜ[ ⇄A⇄ ] ⋅ x) ⊑ γᶜ[ ⇄B⇄ ] * ⋅ (f♯ ⋅ x)
    LHS α[f]⊑f♯ {x} = res-f[⇒]⸢⊑⸣ {x = x} (π₁ α[f]↔f⟐γᶜ[ ⇄A⇄ , ⇄B⇄ ] α[f]⊑f♯)
    RHS : (∀ {x} → f * ⋅ (γᶜ[ ⇄A⇄ ] ⋅ x) ⊑ γᶜ[ ⇄B⇄ ] * ⋅ (f♯ ⋅ x)) → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯
    RHS f[γ[x]]⊑γ[f♯[x]] = π₂ α[f]↔f⟐γᶜ[ ⇄A⇄ , ⇄B⇄ ] $ ext[⇒]⸢⊑⸣ $ λ {x} → f[γ[x]]⊑γ[f♯[x]] {x}

α[f]↔f⟐γᶜ*X[_,_] :
  ∀ {𝓁} {A₁ A₂ B₁ B₂ : POSet 𝓁} (⇄A⇄ : A₁ ⇄ᶜ A₂) (⇄B⇄ : B₁ ⇄ᶜ B₂) {f : ⟪ A₁ ⇒ 𝒫 B₁ ⟫} {f♯ : ⟪ A₂ ⇒ 𝒫 B₂ ⟫}
  → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯ ↔ (∀ {X} → f * ⋅ (γᶜ[ ⇄A⇄ ] * ⋅ X) ⊑ γᶜ[ ⇄B⇄ ] * ⋅ (f♯ * ⋅ X))
α[f]↔f⟐γᶜ*X[ ⇄A⇄ , ⇄B⇄ ] {f} {f♯} = LHS , RHS
  where
    LHS : α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯ → ∀ {X} → f * ⋅ (γᶜ[ ⇄A⇄ ] * ⋅ X) ⊑ γᶜ[ ⇄B⇄ ] * ⋅ (f♯ * ⋅ X)
    LHS α[f]⊑f♯ {X} = let open §-ProofMode[⊑] in [proof-mode]
      do [[ f * ⋅ (γᶜ[ ⇄A⇄ ] * ⋅ X) ]]
       ‣ ⟅ ◇ associative[⟐]⸢*⸣ ⟆⸢≈⸣
       ‣ [[ (f ⟐ γᶜ[ ⇄A⇄ ]) * ⋅ X ]]
       ‣ [focus-left [⋅] 𝑜𝑓 X ] $ [focus-in [*] ] begin
           do [[ f ⟐ γᶜ[ ⇄A⇄ ] ]]
            ‣ ⟅ π₁ α[f]↔f⟐γᶜ[ ⇄A⇄ , ⇄B⇄ ] α[f]⊑f♯ ⟆
            ‣ [[ γᶜ[ ⇄B⇄ ] ⟐ f♯ ]]
           end
       ‣ [[ (γᶜ[ ⇄B⇄ ] ⟐ f♯) * ⋅ X ]]
       ‣ ⟅ associative[⟐]⸢*⸣ ⟆⸢≈⸣
       ‣ [[ γᶜ[ ⇄B⇄ ] * ⋅ (f♯ * ⋅ X) ]]
       ∎
    RHS : (∀ {X} → f * ⋅ (γᶜ[ ⇄A⇄ ] * ⋅ X) ⊑ γᶜ[ ⇄B⇄ ] * ⋅ (f♯ * ⋅ X)) → α[ ⇄A⇄ ⇒⸢⇄ᶜ⸣ ⇄B⇄ ] ⋅ f ⊑ f♯
    RHS f[γ[X]]⊑γ[f♯[X]] = π₂ α[f]↔f⟐γᶜ[ ⇄A⇄ , ⇄B⇄ ] $ complete[*]⸢⊑⸣ $ ext[⇒]⸢⊑⸣ $ λ {X} → let open §-ProofMode[⊑] in [proof-mode]
      do [[ (f ⟐ γᶜ[ ⇄A⇄ ]) * ⋅ X ]]
       ‣ ⟅ associative[⟐]⸢*⸣ ⟆⸢≈⸣
       ‣ [[ f * ⋅ (γᶜ[ ⇄A⇄ ] * ⋅ X) ]]
       ‣ ⟅ f[γ[X]]⊑γ[f♯[X]] ⟆
       ‣ [[ γᶜ[ ⇄B⇄ ] * ⋅ (f♯ * ⋅ X) ]]
       ‣ ⟅ ◇ associative[⟐]⸢*⸣ ⟆⸢≈⸣
       ‣ [[ (γᶜ[ ⇄B⇄ ] ⟐ f♯) * ⋅ X ]]
       ∎
