module OSet.Power where

open import Prelude
open import OSet.OSet
open import OSet.Fun

data pow {𝓁} (A : POSet 𝓁) : Set (sucˡ 𝓁) where
  [ω_] : (X : ⟪ A ⟫ → Set 𝓁) → {X-proper : proper (_⊒_ ⇉ [→]) X} → pow A

data _⊴⸢pow⸣_ {𝓁} {A : POSet 𝓁} : relation (sucˡ 𝓁) (pow A) where
  ↑⟨_⟩ :
    ∀ {X : ⟪ A ⟫ → Set 𝓁} {X-proper : proper (_⊒_ ⇉ [→]) X} {Y : ⟪ A ⟫ → Set 𝓁} {Y-proper : proper (_⊒_ ⇉ [→]) Y}
    → (_⊒_ ⇉ [→]) X Y → [ω X ] {X-proper} ⊴⸢pow⸣ [ω Y ] {Y-proper}

xRx⸢⊴⸢pow⸣⸣ : ∀ {𝓁} {A : POSet 𝓁} → reflexive (_⊴⸢pow⸣_ {A = A})
xRx⸢⊴⸢pow⸣⸣ {x = [ω X ] {X-proper}} = ↑⟨ X-proper ⟩

_⌾⸢⊴⸢pow⸣⸣_ : ∀ {𝓁} {A : POSet 𝓁} → transitive (_⊴⸢pow⸣_ {A = A})
↑⟨ Y⊴Z ⟩ ⌾⸢⊴⸢pow⸣⸣ ↑⟨ X⊴Y ⟩ = ↑⟨ (λ x⊒y → Y⊴Z xRx ∘ X⊴Y x⊒y) ⟩

instance
  Reflexive[pow] : ∀ {𝓁} {A : POSet 𝓁} → Reflexive (_⊴⸢pow⸣_ {A = A})
  Reflexive[pow] = record { xRx = xRx⸢⊴⸢pow⸣⸣ }
  Transitive[pow] : ∀ {𝓁} {A : POSet 𝓁} → Transitive (_⊴⸢pow⸣_ {A = A})
  Transitive[pow] = record { _⌾_ = _⌾⸢⊴⸢pow⸣⸣_ }
  PreOrder[pow] : ∀ {𝓁} {A : POSet 𝓁} → PreOrder (sucˡ 𝓁) (pow A)
  PreOrder[pow] = record { _⊴_ = _⊴⸢pow⸣_ }

intro[⊑]⸢ω⸣ :
  ∀ {𝓁} {A : POSet 𝓁} {X : ⟪ A ⟫ → Set 𝓁} {X-proper : proper (_⊒_ ⇉ [→]) X} {Y : ⟪ A ⟫ → Set 𝓁} {Y-proper : proper (_⊒_ ⇉ [→]) Y}
  → (_⊒_ ⇉ [→]) X Y → [ω X ] {X-proper} ⊴ [ω Y ] {Y-proper}
intro[⊑]⸢ω⸣ X⊑Y = ↑⟨ X⊑Y ⟩

elim[⊑]⸢ω⸣ : 
  ∀ {𝓁} {A : POSet 𝓁} {X : ⟪ A ⟫ → Set 𝓁} {X-proper : proper (_⊒_ ⇉ [→]) X} {Y : ⟪ A ⟫ → Set 𝓁} {Y-proper : proper (_⊒_ ⇉ [→]) Y}
  → [ω X ] {X-proper} ⊴ [ω Y ] {Y-proper} → (_⊒_ ⇉ [→]) X Y
elim[⊑]⸢ω⸣ ↑⟨ X⊑Y ⟩ = X⊑Y

[ω↑_] : ∀ {𝓁} {A : Set 𝓁} {{PO : PreOrder 𝓁 A}} (X : A → Set 𝓁) {X-proper : proper (_⊵_ ⇉ [→]) X} → pow (⇧ A)
[ω↑ X ] {X-proper} = [ω X ∘ ↓ ] {ppr}
  where
    abstract
      ppr : proper (_⊵_ ⇉ [→]) (X ∘ ↓)
      ppr = X-proper ∘ elim[⊑]⸢↓⸣

intro[⊑]⸢ω↑⸣ :
  ∀ {𝓁} {A : Set 𝓁} {{PO : PreOrder 𝓁 A}} {X : A → Set 𝓁} {X-proper : proper (_⊵_ ⇉ [→]) X} {Y : A → Set 𝓁} {Y-proper : proper (_⊵_ ⇉ [→]) Y}
  → (_⊵_ ⇉ [→]) X Y → [ω↑ X ] {X-proper} ⊴ [ω↑ Y ] {Y-proper}
intro[⊑]⸢ω↑⸣ X⊑Y = ↑⟨ X⊑Y ∘ elim[⊑]⸢↓⸣ ⟩

elim[⊑]⸢ω↑⸣ : 
  ∀ {𝓁} {A : Set 𝓁} {{PO : PreOrder 𝓁 A}} {X : A → Set 𝓁} {X-proper : proper (_⊵_ ⇉ [→]) X} {Y : A → Set 𝓁} {Y-proper : proper (_⊵_ ⇉ [→]) Y}
  → [ω↑ X ] {X-proper} ⊴ [ω↑ Y ] {Y-proper} → (_⊵_ ⇉ [→]) X Y
elim[⊑]⸢ω↑⸣ ↑⟨ X⊑Y ⟩ = X⊑Y ∘ intro[⊑]⸢↑⸣

𝒫 : ∀ {𝓁} → POSet 𝓁 → POSet (sucˡ 𝓁)
𝒫 A = ⇧ (pow A)

infix 8 _⋿_
_⋿_ : ∀ {𝓁} {A : POSet 𝓁} → ⟪ A ⟫ → ⟪ 𝒫 A ⟫ → Set 𝓁
x ⋿ ↑⟨ [ω X ] ⟩ = X x

res-X-x[ω]⸢⊑⸣ : ∀ {𝓁} {A : POSet 𝓁} {X Y : ⟪ 𝒫 A ⟫} {x y : ⟪ A ⟫} → X ⊑ Y → x ⊒ y → x ⋿ X → y ⋿ Y
res-X-x[ω]⸢⊑⸣ {X = ↑⟨ [ω X ] ⟩} {↑⟨ [ω Y ] ⟩} X⊑Y = elim[⊑]⸢ω⸣ $ elim[⊑]⸢↑⸣ X⊑Y

res-x[ω]⸢⊑⸣ : ∀ {𝓁} {A : POSet 𝓁} {X : ⟪ 𝒫 A ⟫} {x y : ⟪ A ⟫} → x ⊒ y → x ⋿ X → y ⋿ X
res-x[ω]⸢⊑⸣ {X = X} = res-X-x[ω]⸢⊑⸣ (xRx {x = X})

res-X[ω]⸢⊑⸣ : ∀ {𝓁} {A : POSet 𝓁} {X Y : ⟪ 𝒫 A ⟫} {x : ⟪ A ⟫} → X ⊑ Y → x ⋿ X → x ⋿ Y
res-X[ω]⸢⊑⸣ X⊑Y = res-X-x[ω]⸢⊑⸣ X⊑Y xRx

ext[ω]⸢⊑⸣ : ∀ {𝓁} {A : POSet 𝓁} {X Y : ⟪ 𝒫 A ⟫} → (∀ {x} → x ⋿ X → x ⋿ Y) → X ⊑ Y
ext[ω]⸢⊑⸣ {X = ↑⟨ [ω X ] {X-proper} ⟩} {↑⟨ [ω Y ] ⟩} X⊑Y = intro[⊑]⸢↑⸣ (intro[⊑]⸢ω⸣ (λ x⊒y → X⊑Y ∘ X-proper x⊒y))

res-X-x[ω]⸢≈⸣ : ∀ {𝓁} {A : POSet 𝓁} {X Y : ⟪ 𝒫 A ⟫} {x y : ⟪ A ⟫} → X ≈ Y → x ≈ y → x ⋿ X ↔ y ⋿ Y
res-X-x[ω]⸢≈⸣ X≈Y x≈y = (res-X-x[ω]⸢⊑⸣ (xRx[] X≈Y) (xRx[] $ ◇ x≈y)) , res-X-x[ω]⸢⊑⸣ (xRx[] $ ◇ X≈Y) (xRx[] x≈y)

res-x[ω]⸢≈⸣ : ∀ {𝓁} {A : POSet 𝓁} {X : ⟪ 𝒫 A ⟫} {x y : ⟪ A ⟫} → x ≈ y → x ⋿ X ↔ y ⋿ X
res-x[ω]⸢≈⸣ {X = X} = res-X-x[ω]⸢≈⸣ $ xRx {x = X}

res-X[ω]⸢≈⸣ : ∀ {𝓁} {A : POSet 𝓁} {X Y : ⟪ 𝒫 A ⟫} {x : ⟪ A ⟫} → X ≈ Y → x ⋿ X ↔ x ⋿ Y
res-X[ω]⸢≈⸣ {x = x} X⊑Y = res-X-x[ω]⸢≈⸣ X⊑Y $ xRx {x = x}

ext[ω]⸢≈⸣ : ∀ {𝓁} {A : POSet 𝓁} {X Y : ⟪ 𝒫 A ⟫} → (∀ {x} → x ⋿ X ↔ x ⋿ Y) → X ≈ Y
ext[ω]⸢≈⸣ X≈Y = ⋈[] (ext[ω]⸢⊑⸣ (π₁ X≈Y)) (ext[ω]⸢⊑⸣ (π₂ X≈Y))

mk[ω]-witness : ∀ {𝓁} {A : POSet 𝓁} → ⟪ _⊒_ {A = ⟪ A ⟫} ⇉ [→] {𝓁} ⟫⸢W⸣ → ⟪ 𝒫 A ⟫
mk[ω]-witness X = ↑ $ [ω witness-x X ] {ppr}
  where
    abstract
      ppr : proper (_⊒_ ⇉ [→]) (witness-x X)
      ppr = witness-proper X

id⸢ω⸣ : ∀ {𝓁} {A : POSet 𝓁} → ⟪ (_⊒_ {A = ⟪ A ⟫} ⇉ [→] {𝓁}) ⇉⸢W⸣ _⊑_ {A = ⟪ 𝒫 A ⟫}⟫⸢W⸣
id⸢ω⸣ = mk[witness] mk[ω]-witness (intro[⊑]⸢↑⸣ ∘ intro[⊑]⸢ω⸣)

mk[ω↑]-witness : ∀ {𝓁} {A : Set 𝓁} {{PO : PreOrder 𝓁 A}} → ⟪ _⊵_ {A = A} ⇉ [→] {𝓁}⟫⸢W⸣ → ⟪ 𝒫 (⇧ A) ⟫
mk[ω↑]-witness X = ↑ $ [ω↑ witness-x X ] {ppr}
  where
    abstract
      ppr : proper (_⊵_ ⇉ [→]) (witness-x X)
      ppr = witness-proper X

id⸢ω↑⸣ : ∀ {𝓁} {A : Set 𝓁} {{PO : PreOrder 𝓁 A}} → ⟪ (_⊵_ {A = A} ⇉ [→] {𝓁}) ⇉⸢W⸣ _⊑_ {A = ⟪ 𝒫 (⇧ A) ⟫}⟫⸢W⸣
id⸢ω↑⸣ = mk[witness] mk[ω↑]-witness (intro[⊑]⸢↑⸣ ∘ intro[⊑]⸢ω↑⸣)
