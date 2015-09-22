module CDGAI.FaexpHat where

open import Prelude
open import POSet
open import CDGAI.Syntax
open import CDGAI.Semantics
open import CDGAI.EnvHat

module §-Faexp♯
  (ℤ♯ : POSet zeroˡ)
  (⇄ℤ⇄ : ⇧ ℤ ⇄ᶜ ℤ♯)
  (⊤ℤ♯ : ⟪ ℤ♯ ⟫)
  (η[⊤ℤ] : (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ⋅ all⁺ (⇧ ℤ) ⊑ return ⋅ ⊤ℤ♯)
  (⟦_⟧ᵘ♯ : unary → ⟪ ℤ♯ ⇒ ℤ♯ ⟫)
  (α[⟦⟧ᵘ] : ∀ {o} → α[ ⇄ℤ⇄ ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ (pure ⋅ ⟦ o ⟧ᵘ⁺) ⊑ pure ⋅ ⟦ o ⟧ᵘ♯)
  (⟦_⟧ᵇ♯ : binary → ⟪ ℤ♯ ⇒ ℤ♯ ⇒ ℤ♯ ⟫)
  (α[⟦⟧ᵇ] : ∀ {o} → α[ (⇄ℤ⇄ ×⸢⇄ᶜ⸣ ⇄ℤ⇄) ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ⁺) ⊑ pure ⋅ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯))
  where
  open §-env♯ ℤ♯ ⇄ℤ⇄
  ∃α[Faexp] :
    ∃ Faexp♯[_] ⦂ (∀ {Γ} → aexp Γ → ⟪ ⇧ (env♯ Γ) ⇒ ℤ♯ ⟫)
    𝑠𝑡 (∀ {Γ} (e : aexp Γ) → α[ ⇄env⇄ ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ e ] ⊑ pure ⋅ Faexp♯[ e ])
  ∃α[Faexp] = ∃ Faexp♯[_] ,, α[Faexp]
    where
      Faexp♯[_] : ∀ {Γ} → aexp Γ → ⟪ ⇧ (env♯ Γ) ⇒ ℤ♯ ⟫
      Faexp♯[ Num n ]             = const⁺ ⋅ (ηᶜ[ ⇄ℤ⇄ ] ⋅ ↑ n)
      Faexp♯[ Var x ]             = lookup♯[ x ]
      Faexp♯[ ⊤ℤ ]                = const⁺ ⋅ ⊤ℤ♯
      Faexp♯[ Unary[ o ] e ]      = ⟦ o ⟧ᵘ♯ ⊙ Faexp♯[ e ]
      Faexp♯[ Binary[ o ] e₁ e₂ ] = uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯ ⊙ apply⸢×⁺⸣ ⋅ (Faexp♯[ e₁ ] ,⁺ Faexp♯[ e₂ ]) ⊙ split⁺
      α[Faexp] : ∀ {Γ} (e : aexp Γ) → α[ ⇄env⇄ ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ e ] ⊑ pure ⋅ Faexp♯[ e ]
      α[Faexp] (Num n) = ext[⇒]⸢⊑⸣ $ λ {ρ} → let open §-ProofMode[⊑] in [proof-mode]
        do [[ (α[ ⇄env⇄ ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ Num n ]) ⋅ ρ ]]
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ Faexp[ Num n ] ⟐ γᶜ[ ⇄env⇄ ]) ⋅ ρ ]]
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ⋅ (Faexp[ Num n ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ)) ]]
         ‣ [focus-right [⋅] 𝑜𝑓 (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ] begin
             do [[ (Faexp[ Num n ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ)) ]]
              ‣ ⟅ β-Faexp[Num]⸢⊑⸣ ⟆⸢⊑⸣
              ‣ [[ return ⋅ ↑ n ]]
             end
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ⋅ (return ⋅ ↑ n) ]]
         ‣ ⟅ right-unit[*] ⟆⸢≈⸣
         ‣ [[ pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⋅ ↑ n ]]
         ‣ [[ pure ⋅ (const⁺ ⋅ (ηᶜ[ ⇄ℤ⇄ ] ⋅ ↑ n)) ⋅ ρ ]]
         ‣ [[ pure ⋅ Faexp♯[ Num n ] ⋅ ρ ]]
         ∎ 
      α[Faexp] (Var x) = let open §-ProofMode[⊑] in [proof-mode]
        do [[ α[ ⇄env⇄ ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ Var x ] ]]
         ‣ [[ pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ Faexp[ Var x ] ⟐ γᶜ[ ⇄env⇄ ] ]]
         ‣ [focus-right [⟐] 𝑜𝑓 pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ] begin
             do [focus-left [⟐] 𝑜𝑓 γᶜ[ ⇄env⇄ ] ] begin
                  do [[ Faexp[ Var x ] ]]
                   ‣ ⟅ β-Faexp[Var]⸢⊙⸣ ⟆⸢≈⸣
                   ‣ [[ pure ⋅ lookup[ x ]⁺ ]]
                  end
              ‣ [[ pure ⋅ lookup[ x ]⁺ ⟐ γᶜ[ ⇄env⇄ ] ]]
              ‣ ⟅ π₁ α[f]↔f⟐γᶜ[ ⇄env⇄ , ⇄ℤ⇄ ] $ α[lookup] {x = x} ⟆
              ‣ [[ γᶜ[ ⇄ℤ⇄ ] ⟐ pure ⋅ lookup♯[ x ] ]]
             end
         ‣ [[ pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ γᶜ[ ⇄ℤ⇄ ] ⟐ pure ⋅ lookup♯[ x ] ]]
         ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ γᶜ[ ⇄ℤ⇄ ]) ⟐ pure ⋅ lookup♯[ x ] ]]
         ‣ ⟅ left-unit-contractive[⟐]ᶜ[ ⇄ℤ⇄ ] ⟆
         ‣ [[ pure ⋅ lookup♯[ x ] ]]
         ‣ [[ pure ⋅ Faexp♯[ Var x ] ]]
         ∎ 
      α[Faexp] ⊤ℤ = ext[⇒]⸢⊑⸣ $ λ {ρ} → let open §-ProofMode[⊑] in [proof-mode]
        do [[ (α[ ⇄env⇄ ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ ⊤ℤ ]) ⋅ ρ ]]
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ Faexp[ ⊤ℤ ] ⟐ γᶜ[ ⇄env⇄ ]) ⋅ ρ ]]
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ⋅ (Faexp[ ⊤ℤ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ)) ]]
         ‣ [focus-right [⋅] 𝑜𝑓 (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ] begin
             do [[ (Faexp[ ⊤ℤ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ)) ]]
              ‣ ⟅ β-Faexp[⊤ℤ]⸢⊑⸣ ⟆
              ‣ [[ all⁺ (⇧ ℤ) ]]
             end
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ⋅ all⁺ (⇧ ℤ) ]]
         ‣ ⟅ η[⊤ℤ] ⟆
         ‣ [[ return ⋅ ⊤ℤ♯ ]]
         ‣ [[ pure ⋅ Faexp♯[ ⊤ℤ ] ⋅ ρ ]]
         ∎ 
      α[Faexp] (Unary[ o ] e) with α[Faexp] e
      ... | IH = let open §-ProofMode[⊑] in [proof-mode]
        do [[ α[ ⇄env⇄ ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ Unary[ o ] e ] ]]
         ‣ [[ pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ Faexp[ Unary[ o ] e ] ⟐ γᶜ[ ⇄env⇄ ] ]]
         ‣ [focus-right [⟐] 𝑜𝑓 pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ] begin
             do [focus-left [⟐] 𝑜𝑓 γᶜ[ ⇄env⇄ ] ] begin
                  do [[ Faexp[ Unary[ o ] e ] ]]
                   ‣ ⟅ β-Faexp[Unary]⸢⟐⸣ ⟆⸢≈⸣
                   ‣ [[ pure ⋅ ⟦ o ⟧ᵘ⁺ ⟐ Faexp[ e ] ]]
                  end
              ‣ [[ (pure ⋅ ⟦ o ⟧ᵘ⁺ ⟐ Faexp[ e ]) ⟐ γᶜ[ ⇄env⇄ ] ]]
              ‣ ⟅ associative[⟐] ⟆⸢≈⸣
              ‣ [[ pure ⋅ ⟦ o ⟧ᵘ⁺ ⟐ Faexp[ e ] ⟐ γᶜ[ ⇄env⇄ ] ]]
              ‣ [focus-right [⟐] 𝑜𝑓 pure ⋅ ⟦ o ⟧ᵘ⁺ ] begin
                  do [[ Faexp[ e ] ⟐ γᶜ[ ⇄env⇄ ] ]]
                   ‣ ⟅ π₁ α[f]↔f⟐γᶜ[ ⇄env⇄ , ⇄ℤ⇄ ] IH ⟆
                   ‣ [[ γᶜ[ ⇄ℤ⇄ ] ⟐ pure ⋅ Faexp♯[ e ] ]]
                  end
              ‣ [[ pure ⋅ ⟦ o ⟧ᵘ⁺ ⟐ γᶜ[ ⇄ℤ⇄ ] ⟐ pure ⋅ Faexp♯[ e ] ]]
              ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
              ‣ [[ (pure ⋅ ⟦ o ⟧ᵘ⁺ ⟐ γᶜ[ ⇄ℤ⇄ ]) ⟐ pure ⋅ Faexp♯[ e ] ]]
              ‣ [focus-left [⟐] 𝑜𝑓 pure ⋅ Faexp♯[ e ] ] begin
                  do [[ pure ⋅ ⟦ o ⟧ᵘ⁺ ⟐ γᶜ[ ⇄ℤ⇄ ] ]]
                   ‣ ⟅ π₁ α[f]↔f⟐γᶜ[ ⇄ℤ⇄ , ⇄ℤ⇄ ] α[⟦⟧ᵘ] ⟆
                   ‣ [[ γᶜ[ ⇄ℤ⇄ ] ⟐ pure ⋅ ⟦ o ⟧ᵘ♯ ]]
                  end
              ‣ [[ (γᶜ[ ⇄ℤ⇄ ] ⟐ pure ⋅ ⟦ o ⟧ᵘ♯) ⟐ pure ⋅ Faexp♯[ e ] ]]
              ‣ ⟅ associative[⟐] ⟆⸢≈⸣
              ‣ [[ γᶜ[ ⇄ℤ⇄ ] ⟐ pure ⋅ ⟦ o ⟧ᵘ♯ ⟐ pure ⋅ Faexp♯[ e ] ]]
             end
         ‣ [[ pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ γᶜ[ ⇄ℤ⇄ ] ⟐ pure ⋅ ⟦ o ⟧ᵘ♯ ⟐ pure ⋅ Faexp♯[ e ] ]]
         ‣ ⟅ ◇ associative[⟐] ⟆⸢≈⸣
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ γᶜ[ ⇄ℤ⇄ ]) ⟐ pure ⋅ ⟦ o ⟧ᵘ♯ ⟐ pure ⋅ Faexp♯[ e ] ]]
         ‣ ⟅ left-unit-contractive[⟐]ᶜ[ ⇄ℤ⇄ ] ⟆
         ‣ [[ pure ⋅ ⟦ o ⟧ᵘ♯ ⟐ pure ⋅ Faexp♯[ e ] ]]
         ‣ ⟅ homomorphic[pure]⸢⟐⸣ ⟆⸢≈⸣
         ‣ [[ pure ⋅ (⟦ o ⟧ᵘ♯ ⊙ Faexp♯[ e ]) ]]
         ‣ [[ pure ⋅ Faexp♯[ Unary[ o ] e ] ]]
         ∎
      α[Faexp] (Binary[ o ] e₁ e₂) with α[Faexp] e₁ | α[Faexp] e₂
      ... | IH₁ | IH₂ = ext[⇒]⸢⊑⸣ $ λ {ρ} → let open §-ProofMode[⊑] in [proof-mode]
        do [[ (α[ ⇄env⇄ ⇒⸢⇄ᶜ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ Binary[ o ] e₁ e₂ ]) ⋅ ρ ]]
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ] ⟐ Faexp[ Binary[ o ] e₁ e₂ ] ⟐ γᶜ[ ⇄env⇄ ]) ⋅ ρ ]]
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ⋅ (Faexp[ Binary[ o ] e₁ e₂ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ)) ]]
         ‣ [focus-right [⋅] 𝑜𝑓 (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ] begin
             do [[ Faexp[ Binary[ o ] e₁ e₂ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ) ]]
              ‣ ⟅ β-Faexp[Binary]⸢*⸣⸢⊑⸣ ⟆
              ‣ [[ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ⁺) * ⋅ (γ⸢IA⸣ ⋅ (Faexp[ e₁ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ) ,⁺ Faexp[ e₂ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ))) ]]
              ‣ [focus-right [⋅] 𝑜𝑓 (uncurry⁺ ⋅ ⟦ o ⟧ᵇ⁺) * ] begin
                  do [focus-right [⋅] 𝑜𝑓 γ⸢IA⸣ ] begin
                       do [[ Faexp[ e₁ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ) ,⁺ Faexp[ e₂ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ) ]]
                        ‣ [focus-left [,] 𝑜𝑓 Faexp[ e₂ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ) ] begin
                            do [[ Faexp[ e₁ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ) ]]
                             ‣ ⟅ π₁ α[f]↔f⟐γᶜ*[ ⇄env⇄ , ⇄ℤ⇄ ] IH₁ ⟆
                             ‣ [[ γᶜ[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp♯[ e₁ ] ⋅ ρ) ]]
                             end
                        ‣ [[ γᶜ[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp♯[ e₁ ] ⋅ ρ) ,⁺ Faexp[ e₂ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ) ]]
                        ‣ [focus-right [,] 𝑜𝑓 γᶜ[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp♯[ e₁ ] ⋅ ρ) ] begin
                            do [[ Faexp[ e₂ ] * ⋅ (γᶜ[ ⇄env⇄ ] ⋅ ρ) ]]
                             ‣ ⟅ π₁ α[f]↔f⟐γᶜ*[ ⇄env⇄ , ⇄ℤ⇄ ] IH₂ ⟆
                             ‣ [[ γᶜ[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp♯[ e₂ ] ⋅ ρ) ]]
                            end
                        ‣ [[ γᶜ[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp♯[ e₁ ] ⋅ ρ) ,⁺ γᶜ[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp♯[ e₂ ] ⋅ ρ) ]]
                       end
                   ‣ [[ γ⸢IA⸣ ⋅ (γᶜ[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp♯[ e₁ ] ⋅ ρ) ,⁺ γᶜ[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp♯[ e₂ ] ⋅ ρ)) ]]
                   ‣ ⟅ homomorphic[γ/γ]⸢IA⸣[ ⇄ℤ⇄ , ⇄ℤ⇄ ] ⟆⸢≈⸣
                   ‣ [[ γᶜ[ ⇄ℤ⇄ ×⸢⇄ᶜ⸣ ⇄ℤ⇄ ] * ⋅ (γ⸢IA⸣ ⋅ (pure ⋅ Faexp♯[ e₁ ] ⋅ ρ ,⁺ pure ⋅ Faexp♯[ e₂ ] ⋅ ρ)) ]]
                   ‣ [[ γᶜ[ ⇄ℤ⇄ ×⸢⇄ᶜ⸣ ⇄ℤ⇄ ] * ⋅ (γ⸢IA⸣ ⋅ (return ⋅ (Faexp♯[ e₁ ] ⋅ ρ) ,⁺ return ⋅ (Faexp♯[ e₂ ] ⋅ ρ))) ]]
                   ‣ [focus-right [⋅] 𝑜𝑓 γᶜ[ ⇄ℤ⇄ ×⸢⇄ᶜ⸣ ⇄ℤ⇄ ] * ] begin
                       do [[ γ⸢IA⸣ ⋅ (return ⋅ (Faexp♯[ e₁ ] ⋅ ρ) ,⁺ return ⋅ (Faexp♯[ e₂ ] ⋅ ρ)) ]]
                        ‣ ⟅ homomorphic[γ/return]⸢IA⸣ ⟆⸢≈⸣
                        ‣ [[ return ⋅ (Faexp♯[ e₁ ] ⋅ ρ ,⁺ Faexp♯[ e₂ ] ⋅ ρ) ]]
                       end
                   ‣ [[ γᶜ[ ⇄ℤ⇄ ×⸢⇄ᶜ⸣ ⇄ℤ⇄ ] * ⋅ (return ⋅ (Faexp♯[ e₁ ] ⋅ ρ ,⁺ Faexp♯[ e₂ ] ⋅ ρ)) ]]
                  end
              ‣ [[ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ⁺) * ⋅ (γᶜ[ ⇄ℤ⇄ ×⸢⇄ᶜ⸣ ⇄ℤ⇄ ] * ⋅ (return ⋅ (Faexp♯[ e₁ ] ⋅ ρ ,⁺ Faexp♯[ e₂ ] ⋅ ρ))) ]]
              ‣ ⟅ π₁ α[f]↔f⟐γᶜ*X[ ⇄ℤ⇄ ×⸢⇄ᶜ⸣ ⇄ℤ⇄ , ⇄ℤ⇄ ] α[⟦⟧ᵇ] ⟆
              ‣ [[ γᶜ[ ⇄ℤ⇄ ] * ⋅ ((pure ⋅ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯)) * ⋅ (return ⋅ (Faexp♯[ e₁ ] ⋅ ρ ,⁺ Faexp♯[ e₂ ] ⋅ ρ))) ]]
             end
         ‣ [[ (pure ⋅ ηᶜ[ ⇄ℤ⇄ ]) * ⋅ (γᶜ[ ⇄ℤ⇄ ] * ⋅ ((pure ⋅ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯)) * ⋅ (return ⋅ (Faexp♯[ e₁ ] ⋅ ρ ,⁺ Faexp♯[ e₂ ] ⋅ ρ)))) ]]
         ‣ ⟅ contractiveᶜ[X*][ ⇄ℤ⇄ ] ⟆
         ‣ [[ (pure ⋅ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯)) * ⋅ (return ⋅ (Faexp♯[ e₁ ] ⋅ ρ ,⁺ Faexp♯[ e₂ ] ⋅ ρ)) ]]
         ‣ ⟅ right-unit[*] ⟆⸢≈⸣
         ‣ [[ pure ⋅ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯) ⋅ (Faexp♯[ e₁ ] ⋅ ρ ,⁺ Faexp♯[ e₂ ] ⋅ ρ) ]]
         ‣ [[ pure ⋅ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯) ⋅ ((apply⸢×⁺⸣ ⋅ (Faexp♯[ e₁ ] ,⁺ Faexp♯[ e₂ ])  ⊙ split⁺) ⋅ ρ) ]]
         ‣ ⟅ ◇ $ homomorphic[pure] {g = (uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯)} {f = apply⸢×⁺⸣ ⋅ (Faexp♯[ e₁ ] ,⁺ Faexp♯[ e₂ ]) ⊙ split⁺} ⟆⸢≈⸣
         ‣ [[ pure ⋅ (uncurry⁺ ⋅ ⟦ o ⟧ᵇ♯ ⊙ apply⸢×⁺⸣ ⋅ (Faexp♯[ e₁ ] ,⁺ Faexp♯[ e₂ ]) ⊙ split⁺) ⋅ ρ ]]
         ‣ [[ pure ⋅ Faexp♯[ Binary[ o ] e₁ e₂ ] ⋅ ρ ]]
         ∎
