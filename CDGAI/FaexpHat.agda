module CDGAI.FaexpHat where

open import Prelude
open import OSet
open import CDGAI.Syntax
open import CDGAI.Semantics
open import CDGAI.EnvHat

module §-Faexp^
  (ℤ^ : POSet zeroˡ)
  (⇄ℤ⇄ : ⇧ ℤ η⇄γ ℤ^)
  (⊤ℤ^ : ⟪ ℤ^ ⟫)
  (η[⊤ℤ] : (pure ⋅ η[ ⇄ℤ⇄ ]) * ⋅ all (⇧ ℤ) ⊑ return ⋅ ⊤ℤ^)
  (↑⟦_⟧ᵘ^ : unary → ⟪ ℤ^ ⇒ ℤ^ ⟫)
  (α[⟦⟧ᵘ] : ∀ {o} → α[ ⇄ℤ⇄ ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ (pure ⋅ ↑⟦ o ⟧ᵘ) ⊑ pure ⋅ ↑⟦ o ⟧ᵘ^)
  (↑⟦_⟧ᵇ^ : binary → ⟪ ℤ^ ⇒ ℤ^ ⇒ ℤ^ ⟫)
  (α[⟦⟧ᵇ] : ∀ {o} → α[ (⇄ℤ⇄ ×⸢η⇄γ⸣ ⇄ℤ⇄) ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ) ⊑ pure ⋅ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ^))
  where
  open §-env^ ℤ^ ⇄ℤ⇄
  ∃α[Faexp] :
    ∃ Faexp^[_] ⦂ (∀ {Γ} → aexp Γ → ⟪ ⇧ (env^ Γ) ⇒ ℤ^ ⟫)
    𝑠𝑡 (∀ {Γ} (e : aexp Γ) → α[ ⇄env⇄ ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ e ] ⊑ pure ⋅ Faexp^[ e ])
  ∃α[Faexp] = ∃ Faexp^[_] ,, α[Faexp]
    where
      Faexp^[_] : ∀ {Γ} → aexp Γ → ⟪ ⇧ (env^ Γ) ⇒ ℤ^ ⟫
      Faexp^[ Num n ]             = ↑const ⋅ (η[ ⇄ℤ⇄ ] ⋅ ↑ n)
      Faexp^[ Var x ]             = ↑lookup^[ x ]
      Faexp^[ ⊤ℤ ]                = ↑const ⋅ ⊤ℤ^
      Faexp^[ Unary[ o ] e ]      = ↑⟦ o ⟧ᵘ^ ⊙ Faexp^[ e ]
      Faexp^[ Binary[ o ] e₁ e₂ ] = ↑uncurry ⋅ ↑⟦ o ⟧ᵇ^ ⊙ ↑apply⸢×⸣ ⋅ (Faexp^[ e₁ ] ⟨,⟩ Faexp^[ e₂ ]) ⊙ ↑split
      α[Faexp] : ∀ {Γ} (e : aexp Γ) → α[ ⇄env⇄ ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ e ] ⊑ pure ⋅ Faexp^[ e ]
      α[Faexp] (Num n) = ext[λ]⸢⊑⸣ $ λ {ρ} → [⊑-proof-mode]
        do [⊑][[ (α[ ⇄env⇄ ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ Num n ]) ⋅ ρ ]]
        ⊑‣ [⊑-≡] (pure ⋅ η[ ⇄ℤ⇄ ] ⟐ Faexp[ Num n ] ⟐ γ⸢η⸣[ ⇄env⇄ ]) ⋅ ρ ⟅ ↯ ⟆
        ⊑‣ [⊑-≡] (pure ⋅ η[ ⇄ℤ⇄ ]) * ⋅ (Faexp[ Num n ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ)) ⟅ ↯ ⟆
        ⊑‣ [⊑-focus-right [⋅] 𝑜𝑓 (pure ⋅ η[ ⇄ℤ⇄ ]) * ] [⊑] return ⋅ ↑ n ⟅ β-Faexp[Num]⸢⊑⸣ ⟆
        ⊑‣ [⊑][[ (pure ⋅ η[ ⇄ℤ⇄ ]) * ⋅ (return ⋅ ↑ n) ]]
        ⊑‣ [⊑-≈] pure ⋅ η[ ⇄ℤ⇄ ] ⋅ ↑ n ⟅ right-unit[*] ⟆
        ⊑‣ [⊑-≡] pure ⋅ (↑const ⋅ (η[ ⇄ℤ⇄ ] ⋅ ↑ n)) ⋅ ρ ⟅ ↯ ⟆
        ⊑‣ [⊑-≡] pure ⋅ Faexp^[ Num n ] ⋅ ρ ⟅ ↯ ⟆
        ⬜ 
      α[Faexp] (Var x) = [⊑-proof-mode]
        do [⊑][[ α[ ⇄env⇄ ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ Var x ] ]]
        ⊑‣ [⊑-≡] pure ⋅ η[ ⇄ℤ⇄ ] ⟐ Faexp[ Var x ] ⟐ γ⸢η⸣[ ⇄env⇄ ] ⟅ ↯ ⟆
        ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 pure ⋅ η[ ⇄ℤ⇄ ] ] begin
             do [⊑-focus-left [⟐] 𝑜𝑓 γ⸢η⸣[ ⇄env⇄ ] ] begin
                  do [⊑][[ Faexp[ Var x ] ]]
                  ⊑‣ [⊑-≈] pure ⋅ ↑lookup[ x ] ⟅ β-Faexp[Var]⸢⊙⸣ ⟆
                  end
             ⊑‣ [⊑][[ pure ⋅ ↑lookup[ x ] ⟐ γ⸢η⸣[ ⇄env⇄ ] ]]
             ⊑‣ [⊑] γ⸢η⸣[ ⇄ℤ⇄ ] ⟐ pure ⋅ ↑lookup^[ x ] ⟅ π₁ α[f]⊑f^[ ⇄env⇄ , ⇄ℤ⇄ ]⸢γ⸣ $ α[lookup] {x = x} ⟆
             end
        ⊑‣ [⊑][[ pure ⋅ η[ ⇄ℤ⇄ ] ⟐ γ⸢η⸣[ ⇄ℤ⇄ ] ⟐ pure ⋅ ↑lookup^[ x ] ]]
        ⊑‣ [⊑] pure ⋅ ↑lookup^[ x ] ⟅ left-unit[⟐]⸢contractive⸢η⸣⸣[ ⇄ℤ⇄ ] ⟆
        ⊑‣ [⊑-≡] pure ⋅ Faexp^[ Var x ] ⟅ ↯ ⟆
        ⬜ 
      α[Faexp] ⊤ℤ = ext[λ]⸢⊑⸣ $ λ {ρ} → [⊑-proof-mode]
        do [⊑][[ (α[ ⇄env⇄ ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ ⊤ℤ ]) ⋅ ρ ]]
        ⊑‣ [⊑-≡] (pure ⋅ η[ ⇄ℤ⇄ ] ⟐ Faexp[ ⊤ℤ ] ⟐ γ⸢η⸣[ ⇄env⇄ ]) ⋅ ρ ⟅ ↯ ⟆
        ⊑‣ [⊑-≡] (pure ⋅ η[ ⇄ℤ⇄ ]) * ⋅ (Faexp[ ⊤ℤ ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ)) ⟅ ↯ ⟆
        ⊑‣ [⊑-focus-right [⋅] 𝑜𝑓 (pure ⋅ η[ ⇄ℤ⇄ ]) * ] [⊑] all (⇧ ℤ) ⟅ β-Faexp[⊤ℤ]⸢⊑⸣ ⟆
        ⊑‣ [⊑][[ (pure ⋅ η[ ⇄ℤ⇄ ]) * ⋅ all (⇧ ℤ) ]]
        ⊑‣ [⊑] return ⋅ ⊤ℤ^ ⟅ η[⊤ℤ] ⟆
        ⊑‣ [⊑-≡] pure ⋅ Faexp^[ ⊤ℤ ] ⋅ ρ ⟅ ↯ ⟆
        ⬜ 
      α[Faexp] (Unary[ o ] e) with α[Faexp] e
      ... | IH = [⊑-proof-mode]
        do [⊑][[ α[ ⇄env⇄ ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ Unary[ o ] e ] ]]
        ⊑‣ [⊑-≡] pure ⋅ η[ ⇄ℤ⇄ ] ⟐ Faexp[ Unary[ o ] e ] ⟐ γ⸢η⸣[ ⇄env⇄ ] ⟅ ↯ ⟆
        ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 pure ⋅ η[ ⇄ℤ⇄ ] ] begin
             do [⊑-focus-left [⟐] 𝑜𝑓 γ⸢η⸣[ ⇄env⇄ ] ] [⊑-≈] pure ⋅ ↑⟦ o ⟧ᵘ ⟐ Faexp[ e ] ⟅ β-Faexp[Unary]⸢⟐⸣ ⟆
             ⊑‣ [⊑][[ (pure ⋅ ↑⟦ o ⟧ᵘ ⟐ Faexp[ e ]) ⟐ γ⸢η⸣[ ⇄env⇄ ] ]]
             ⊑‣ [⊑-≈] pure ⋅ ↑⟦ o ⟧ᵘ ⟐ Faexp[ e ] ⟐ γ⸢η⸣[ ⇄env⇄ ] ⟅ associative[⟐] ⟆
             ⊑‣ [⊑-focus-right [⟐] 𝑜𝑓 pure ⋅ ↑⟦ o ⟧ᵘ ] [⊑] γ⸢η⸣[ ⇄ℤ⇄ ] ⟐ pure ⋅ Faexp^[ e ] ⟅ π₁ α[f]⊑f^[ ⇄env⇄ , ⇄ℤ⇄ ]⸢γ⸣ IH ⟆
             ⊑‣ [⊑][[ pure ⋅ ↑⟦ o ⟧ᵘ ⟐ γ⸢η⸣[ ⇄ℤ⇄ ] ⟐ pure ⋅ Faexp^[ e ] ]]
             ⊑‣ [⊑-≈] (pure ⋅ ↑⟦ o ⟧ᵘ ⟐ γ⸢η⸣[ ⇄ℤ⇄ ]) ⟐ pure ⋅ Faexp^[ e ] ⟅ ◇ associative[⟐] ⟆
             ⊑‣ [⊑-focus-left [⟐] 𝑜𝑓 pure ⋅ Faexp^[ e ] ] [⊑] γ⸢η⸣[ ⇄ℤ⇄ ] ⟐ pure ⋅ ↑⟦ o ⟧ᵘ^ ⟅ π₁ α[f]⊑f^[ ⇄ℤ⇄ , ⇄ℤ⇄ ]⸢γ⸣ α[⟦⟧ᵘ] ⟆
             ⊑‣ [⊑][[ (γ⸢η⸣[ ⇄ℤ⇄ ] ⟐ pure ⋅ ↑⟦ o ⟧ᵘ^) ⟐ pure ⋅ Faexp^[ e ] ]]
             ⊑‣ [⊑-≈] γ⸢η⸣[ ⇄ℤ⇄ ] ⟐ pure ⋅ ↑⟦ o ⟧ᵘ^ ⟐ pure ⋅ Faexp^[ e ] ⟅ associative[⟐] ⟆
             end
        ⊑‣ [⊑][[ pure ⋅ η[ ⇄ℤ⇄ ] ⟐ γ⸢η⸣[ ⇄ℤ⇄ ] ⟐ pure ⋅ ↑⟦ o ⟧ᵘ^ ⟐ pure ⋅ Faexp^[ e ] ]]
        ⊑‣ [⊑] pure ⋅ ↑⟦ o ⟧ᵘ^ ⟐ pure ⋅ Faexp^[ e ] ⟅ left-unit[⟐]⸢contractive⸢η⸣⸣[ ⇄ℤ⇄ ] ⟆
        ⊑‣ [⊑-≈] pure ⋅ (↑⟦ o ⟧ᵘ^ ⊙ Faexp^[ e ]) ⟅ homomorphic[⟐]⸢pure⸣ ⟆
        ⊑‣ [⊑-≡] pure ⋅ Faexp^[ Unary[ o ] e ] ⟅ ↯ ⟆
        ⬜
      α[Faexp] (Binary[ o ] e₁ e₂) with α[Faexp] e₁ | α[Faexp] e₂
      ... | IH₁ | IH₂ = ext[λ]⸢⊑⸣ $ λ {ρ} → [⊑-proof-mode]
        do [⊑][[ (α[ ⇄env⇄ ⇒⸢η⇄γ⸣ ⇄ℤ⇄ ] ⋅ Faexp[ Binary[ o ] e₁ e₂ ]) ⋅ ρ ]]
        ⊑‣ [⊑-≡] (pure ⋅ η[ ⇄ℤ⇄ ] ⟐ Faexp[ Binary[ o ] e₁ e₂ ] ⟐ γ⸢η⸣[ ⇄env⇄ ]) ⋅ ρ ⟅ ↯ ⟆
        ⊑‣ [⊑-≡] (pure ⋅ η[ ⇄ℤ⇄ ]) * ⋅ (Faexp[ Binary[ o ] e₁ e₂ ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ)) ⟅ ↯ ⟆
        ⊑‣ [⊑-focus-right [⋅] 𝑜𝑓 (pure ⋅ η[ ⇄ℤ⇄ ]) * ] begin
             do [⊑][[ Faexp[ Binary[ o ] e₁ e₂ ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ) ]]
             ⊑‣ [⊑] (↑uncurry ⋅ ↑⟦ o ⟧ᵇ) * ⋅ (γ⸢IA⸣ ⋅ (Faexp[ e₁ ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ) ⟨,⟩ Faexp[ e₂ ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ))) ⟅ β-Faexp[Binary]⸢*⸣⸢⊑⸣ ⟆
             ⊑‣ [⊑-focus-right [⋅] 𝑜𝑓 (↑uncurry ⋅ ↑⟦ o ⟧ᵇ) * ] begin
                  do [⊑-focus-right [⋅] 𝑜𝑓 γ⸢IA⸣ ] begin
                       do [⊑][[ Faexp[ e₁ ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ) ⟨,⟩ Faexp[ e₂ ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ) ]]
                       ⊑‣ [⊑-focus-left [,] 𝑜𝑓 Faexp[ e₂ ] * ⋅ (γ⸢η⸣[ ⇄env⇄ ] ⋅ ρ) ] [⊑] γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp^[ e₁ ] ⋅ ρ) ⟅ π₁ α[f]⊑f^[ ⇄env⇄ , ⇄ℤ⇄ ]⸢γ*⸣ IH₁ ⟆
                       ⊑‣ [⊑-focus-right [,] 𝑜𝑓 γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp^[ e₁ ] ⋅ ρ) ] [⊑] γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp^[ e₂ ] ⋅ ρ) ⟅ π₁ α[f]⊑f^[ ⇄env⇄ , ⇄ℤ⇄ ]⸢γ*⸣ IH₂ ⟆
                       ⊑‣ [⊑][[ γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp^[ e₁ ] ⋅ ρ) ⟨,⟩ γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp^[ e₂ ] ⋅ ρ) ]]
                       end
                  ⊑‣ [⊑][[ γ⸢IA⸣ ⋅ (γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp^[ e₁ ] ⋅ ρ) ⟨,⟩ γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ (pure ⋅ Faexp^[ e₂ ] ⋅ ρ)) ]]
                  ⊑‣ [⊑-≈] γ⸢η⸣[ ⇄ℤ⇄ ×⸢η⇄γ⸣ ⇄ℤ⇄ ] * ⋅ (γ⸢IA⸣ ⋅ (pure ⋅ Faexp^[ e₁ ] ⋅ ρ ⟨,⟩ pure ⋅ Faexp^[ e₂ ] ⋅ ρ)) ⟅ exchange[γ⸢IA⸣] ⇄ℤ⇄ ⇄ℤ⇄ ⟆
                  ⊑‣ [⊑-≡] γ⸢η⸣[ ⇄ℤ⇄ ×⸢η⇄γ⸣ ⇄ℤ⇄ ] * ⋅ (γ⸢IA⸣ ⋅ (return ⋅ (Faexp^[ e₁ ] ⋅ ρ) ⟨,⟩ return ⋅ (Faexp^[ e₂ ] ⋅ ρ))) ⟅ ↯ ⟆
                  ⊑‣ [⊑-focus-right [⋅] 𝑜𝑓 γ⸢η⸣[ ⇄ℤ⇄ ×⸢η⇄γ⸣ ⇄ℤ⇄ ] * ] [⊑-≈] return ⋅ (Faexp^[ e₁ ] ⋅ ρ ⟨,⟩ Faexp^[ e₂ ] ⋅ ρ) ⟅ unit[γ⸢IA⸣] ⟆
                  ⊑‣ [⊑][[ γ⸢η⸣[ ⇄ℤ⇄ ×⸢η⇄γ⸣ ⇄ℤ⇄ ] * ⋅ (return ⋅ (Faexp^[ e₁ ] ⋅ ρ ⟨,⟩ Faexp^[ e₂ ] ⋅ ρ)) ]]
                  end
             ⊑‣ [⊑][[ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ) * ⋅ (γ⸢η⸣[ ⇄ℤ⇄ ×⸢η⇄γ⸣ ⇄ℤ⇄ ] * ⋅ (return ⋅ (Faexp^[ e₁ ] ⋅ ρ ⟨,⟩ Faexp^[ e₂ ] ⋅ ρ))) ]]
             ⊑‣ [⊑] γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ ((pure ⋅ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ^)) * ⋅ (return ⋅ (Faexp^[ e₁ ] ⋅ ρ ⟨,⟩ Faexp^[ e₂ ] ⋅ ρ))) ⟅ π₁ α[f]⊑f^[ ⇄ℤ⇄ ×⸢η⇄γ⸣ ⇄ℤ⇄ , ⇄ℤ⇄ ]⸢γ*X⸣ α[⟦⟧ᵇ] ⟆
             end
        ⊑‣ [⊑][[ (pure ⋅ η[ ⇄ℤ⇄ ]) * ⋅ (γ⸢η⸣[ ⇄ℤ⇄ ] * ⋅ ((pure ⋅ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ^)) * ⋅ (return ⋅ (Faexp^[ e₁ ] ⋅ ρ ⟨,⟩ Faexp^[ e₂ ] ⋅ ρ)))) ]]
        ⊑‣ [⊑] (pure ⋅ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ^)) * ⋅ (return ⋅ (Faexp^[ e₁ ] ⋅ ρ ⟨,⟩ Faexp^[ e₂ ] ⋅ ρ)) ⟅ left-unit[*]⸢contractive⸢η⸣⸣[ ⇄ℤ⇄ ]  ⟆
        ⊑‣ [⊑-≈] pure ⋅ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ^) ⋅ (Faexp^[ e₁ ] ⋅ ρ ⟨,⟩ Faexp^[ e₂ ] ⋅ ρ) ⟅ right-unit[*] ⟆
        ⊑‣ [⊑-≡] pure ⋅ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ^) ⋅ ((↑apply⸢×⸣ ⋅ (Faexp^[ e₁ ] ⟨,⟩ Faexp^[ e₂ ])  ⊙ ↑split) ⋅ ρ) ⟅ ↯ ⟆
        ⊑‣ [⊑-≈] pure ⋅ (↑uncurry ⋅ ↑⟦ o ⟧ᵇ^ ⊙ ↑apply⸢×⸣ ⋅ (Faexp^[ e₁ ] ⟨,⟩ Faexp^[ e₂ ]) ⊙ ↑split) ⋅ ρ
           ⟅ associative[pure] {g = (↑uncurry ⋅ ↑⟦ o ⟧ᵇ^)} {f = ↑apply⸢×⸣ ⋅ (Faexp^[ e₁ ] ⟨,⟩ Faexp^[ e₂ ]) ⊙ ↑split} ⟆
        ⊑‣ [⊑-≡] pure ⋅ Faexp^[ Binary[ o ] e₁ e₂ ] ⋅ ρ ⟅ ↯ ⟆
        ⬜
