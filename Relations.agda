module Relations where

open import Core

[→] : ∀ {𝓁₁ 𝓁₂} (A : Set 𝓁₁) (B : Set 𝓁₂) → Set (𝓁₁ ⊔ˡ 𝓁₂)
[→] A B = A → B

infixr 4 _↔_
_↔_ : ∀ {𝓁₁ 𝓁₂} → Set 𝓁₁ → Set 𝓁₂ → Set (𝓁₁ ⊔ˡ 𝓁₂)
A ↔ B = (A → B) × (B → A)

predicate : ∀ {𝓁} 𝓁' → Set 𝓁 → Set (sucˡ 𝓁' ⊔ˡ 𝓁)
predicate 𝓁' A = A → Set 𝓁'

relation : ∀ {𝓁} 𝓁' → Set 𝓁 → Set (sucˡ 𝓁' ⊔ˡ 𝓁)
relation 𝓁' A = A → A → Set 𝓁'

proper : ∀ {𝓁 𝓁'} {A : Set 𝓁} (_R_ : relation 𝓁' A) → A → Set 𝓁'
proper _R_ x = x R x

infixr 4 _⇉_
_⇉_ : ∀ {𝓁₁ 𝓁₁' 𝓁₂ 𝓁₂'} {A : Set 𝓁₁} {B : Set 𝓁₂} (_R₁_ : relation 𝓁₁' A) (_R₂_ : relation 𝓁₂' B) → relation (𝓁₁ ⊔ˡ 𝓁₁' ⊔ˡ 𝓁₂') (A → B)
(_R₁_ ⇉ _R₂_) f g = ∀ {x y} → x R₁ y → f x R₂ g y

reflexive : ∀ {𝓁 𝓁'} {A : Set 𝓁} → relation 𝓁' A → Set (𝓁 ⊔ˡ 𝓁')
reflexive _R_ = ∀ {x} → x R x

reflexive[_] : ∀ {𝓁 𝓁ᵉ 𝓁'} {A : Set 𝓁} → relation 𝓁ᵉ A → relation 𝓁' A → Set (𝓁 ⊔ˡ 𝓁ᵉ ⊔ˡ 𝓁')
reflexive[ _EQV_ ] _R_ = ∀ {x y} → x EQV y → x R y

transitive : ∀ {𝓁 𝓁'} {A : Set 𝓁} → relation 𝓁' A → Set (𝓁 ⊔ˡ 𝓁')
transitive _R_ = ∀ {x y z} → y R z → x R y → x R z

symmetric : ∀ {𝓁 𝓁'} {A : Set 𝓁} (_R_ : relation 𝓁' A) → Set (𝓁 ⊔ˡ 𝓁')
symmetric _R_ = ∀ {x y} → x R y → y R x

symmetric→[_] : ∀ {𝓁 𝓁' 𝓁''} {A : Set 𝓁} (_REV_ : relation 𝓁' A) (_R_ : relation 𝓁'' A ) → Set (𝓁 ⊔ˡ 𝓁' ⊔ˡ 𝓁'')
symmetric→[ _REV_ ] _R_ = ∀ {x y} → x R y → y REV x

symmetric←[_] : ∀ {𝓁 𝓁' 𝓁''} {A : Set 𝓁} (_REV_ : relation 𝓁' A) (_R_ : relation 𝓁'' A ) → Set (𝓁 ⊔ˡ 𝓁' ⊔ˡ 𝓁'')
symmetric←[ _REV_ ] _R_ = ∀ {x y} → x REV y → y R x

antisymmetric : ∀ {𝓁 𝓁'} {A : Set 𝓁} (_R_ : relation 𝓁' A) → Set (𝓁 ⊔ˡ 𝓁')
antisymmetric _R_ = ∀ {x y} → x R y → y R x → x ≡ y

antisymmetric[_] : ∀ {𝓁 𝓁ᵉ 𝓁'} {A : Set 𝓁} (_EQV_ : relation 𝓁ᵉ A) (_R_ : relation 𝓁' A) → Set (𝓁 ⊔ˡ 𝓁ᵉ ⊔ˡ 𝓁')
antisymmetric[ _EQV_ ] _R_ = ∀ {x y} → x R y → y R x → x EQV y

data ordering {𝓁 𝓁' 𝓁''} {A : Set 𝓁} (_~_ : relation 𝓁' A) (_R_ : relation 𝓁'' A) (x y : A) : Set (𝓁 ⊔ˡ 𝓁' ⊔ˡ 𝓁'') where
  [<] : x R y → not (y R x) → ordering _~_ _R_ x y
  [~] : x ~ y → ordering _~_ _R_ x y
  [>] : y R x → not (x R y) → ordering _~_ _R_ x y

dec-total-order : ∀ {𝓁 𝓁' 𝓁''} {A : Set 𝓁} (_~_ : relation 𝓁' A) (_R_ : relation 𝓁'' A) → Set (𝓁 ⊔ˡ 𝓁' ⊔ˡ 𝓁'')
dec-total-order _~_ _R_ = ∀ x y → ordering _~_ _R_ x y

data rel-decision {𝓁 𝓁'} {A : Set 𝓁} (_R_ : relation 𝓁' A) (x y : A) : Set 𝓁' where
  yes : x R y → rel-decision _R_ x y
  no : not (x R y) → rel-decision _R_ x y

data is-yes {𝓁 𝓁'} {A : Set 𝓁} {_R_ : relation 𝓁' A} {x y : A} : rel-decision _R_ x y → Set 𝓁' where
  yep : ∀ {p : x R y} → is-yes (yes p)

rel-dec : ∀ {𝓁 𝓁'} {A : Set 𝓁} (_R_ : relation 𝓁' A) → Set (𝓁 ⊔ˡ 𝓁')
rel-dec _R_ = ∀ x y → rel-decision _R_ x y

data pred-decision {𝓁} {𝓁'} {A : Set 𝓁} (P : predicate 𝓁' A) (x : A) : Set 𝓁' where
  Yes : P x → pred-decision P x
  No : not (P x) → pred-decision P x
