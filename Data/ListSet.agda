module Data.ListSet where

open import Core
open import Relations
open import Classes

data list-set {𝓁} (A : Set 𝓁) : Set 𝓁 where
  [] : list-set A
  _∷_ : A → list-set A → list-set A

infixr 5 _∪⸢list-set⸣_
_∪⸢list-set⸣_ : ∀ {𝓁} {A : Set 𝓁} → list-set A → list-set A → list-set A
[] ∪⸢list-set⸣ ys = ys
(x ∷ xs) ∪⸢list-set⸣ ys = x ∷ (xs ∪⸢list-set⸣ ys)

left-unit[∪⸢list-set⸣] : ∀ {𝓁} {A : Set 𝓁} (xs : list-set A) → [] ∪⸢list-set⸣ xs ≡ xs
left-unit[∪⸢list-set⸣] xs = ↯

right-unit[∪⸢list-set⸣] : ∀ {𝓁} {A : Set 𝓁} (xs : list-set A) → xs ∪⸢list-set⸣ [] ≡ xs
right-unit[∪⸢list-set⸣] [] = ↯
right-unit[∪⸢list-set⸣] (x ∷ xs) rewrite right-unit[∪⸢list-set⸣] xs = ↯

associativity[∪⸢list-set⸣] : ∀ {𝓁} {A : Set 𝓁} (xs ys zs : list-set A) → (xs ∪⸢list-set⸣ ys) ∪⸢list-set⸣ zs ≡ xs ∪⸢list-set⸣ ys ∪⸢list-set⸣ zs
associativity[∪⸢list-set⸣] [] ys zs = ↯
associativity[∪⸢list-set⸣] (x ∷ xs) ys zs rewrite associativity[∪⸢list-set⸣] xs ys zs = ↯

instance
  Monoid[list-set] : ∀ {𝓁} {A : Set 𝓁} → Monoid (list-set A)
  Monoid[list-set] = record
    { null = []
    ; _++_ = _∪⸢list-set⸣_
    ; left-unit[++] = left-unit[∪⸢list-set⸣]
    ; right-unit[++] = right-unit[∪⸢list-set⸣]
    ; associativity[++] = associativity[∪⸢list-set⸣]
    }


map⸢list-set⸣ : ∀ {𝓁₁ 𝓁₂} {A : Set 𝓁₁} {B : Set 𝓁₂} → (A → B) → list-set A  → list-set B
map⸢list-set⸣ f [] = []
map⸢list-set⸣ f (x ∷ xs) = f x ∷ map⸢list-set⸣ f xs

unit[map⸢list-set⸣] : ∀ {𝓁} {A : Set 𝓁} (xs : list-set A) → map⸢list-set⸣ id xs ≡ xs
unit[map⸢list-set⸣] [] = ↯
unit[map⸢list-set⸣] (x ∷ xs) rewrite unit[map⸢list-set⸣] xs = ↯

homomorphic[map⸢list-set⸣] : ∀ {𝓁} {A B C : Set 𝓁} (g : B → C) (f : A → B) (xs : list-set A) → map⸢list-set⸣ (g ∘ f) xs ≡ (map⸢list-set⸣ g ∘ map⸢list-set⸣ f) xs
homomorphic[map⸢list-set⸣] g f [] = ↯
homomorphic[map⸢list-set⸣] g f (x ∷ xs) rewrite homomorphic[map⸢list-set⸣] g f xs = ↯

instance
  Functor[list-set] : ∀ {𝓁} → Functor (list-set {𝓁})
  Functor[list-set] = record
    { map = map⸢list-set⸣
    ; unit[map] = unit[map⸢list-set⸣]
    ; homomorphic[map] = homomorphic[map⸢list-set⸣]
    }

infix 8 _∈⸢list-set⸣_
data _∈⸢list-set⸣_ {𝓁} {A : Set 𝓁} : A → list-set A → Set 𝓁 where
  Zero : ∀ {x xs} → x ∈⸢list-set⸣ (x ∷ xs)
  Suc : ∀ {x₁ x₂ xs} → x₂ ∈⸢list-set⸣ xs → x₂ ∈⸢list-set⸣ (x₁ ∷ xs)

single⸢list-set⸣ : ∀ {𝓁} {A : Set 𝓁} → A → list-set A
single⸢list-set⸣ x = x ∷ []

x∈single⸢list-set⸣ : ∀ {𝓁} {A : Set 𝓁} (x : A) → x ∈⸢list-set⸣ single⸢list-set⸣ x
x∈single⸢list-set⸣ x = Zero

x∈xs⸢list-set⸣ : ∀ {𝓁} {A : Set 𝓁} (x : A) (xs ys : list-set A) → x ∈⸢list-set⸣ xs → x ∈⸢list-set⸣ (xs ∪⸢list-set⸣ ys)
x∈xs⸢list-set⸣ x (.x ∷ xs) ys Zero = Zero
x∈xs⸢list-set⸣ x (x' ∷ xs) ys (Suc x∈xs) = Suc (x∈xs⸢list-set⸣ x xs ys x∈xs)

x∈ys⸢list-set⸣ : ∀ {𝓁} {A : Set 𝓁} (x : A) (xs ys : list-set A) → x ∈⸢list-set⸣ ys → x ∈⸢list-set⸣ (xs ∪⸢list-set⸣ ys)
x∈ys⸢list-set⸣ x []        ys x∈ys = x∈ys
x∈ys⸢list-set⸣ x (x' ∷ xs) ys x∈ys = Suc (x∈ys⸢list-set⸣ x xs ys x∈ys)

x∈xs∪ys→⨄⸢list-set⸣ : ∀ {𝓁} {A : Set 𝓁} (x : A) (xs ys : list-set A) → x ∈⸢list-set⸣ (xs ∪⸢list-set⸣ ys) → x ∈⸢list-set⸣ xs ⨄ x ∈⸢list-set⸣ ys
x∈xs∪ys→⨄⸢list-set⸣ x []        ys x∈xs∪ys       = Inr x∈xs∪ys
x∈xs∪ys→⨄⸢list-set⸣ x (.x ∷ xs) ys Zero          = Inl Zero
x∈xs∪ys→⨄⸢list-set⸣ x (x' ∷ xs) ys (Suc x∈xs∪ys) with x∈xs∪ys→⨄⸢list-set⸣ x xs ys x∈xs∪ys
... | Inl x∈xs = Inl (Suc x∈xs)
... | Inr x∈ys = Inr x∈ys

instance
  FiniteSet[list-set] : ∀ {𝓁} {A : Set 𝓁} → FiniteSet (list-set {𝓁})
  FiniteSet[list-set] = record
    { _∈_ = _∈⸢list-set⸣_
    ; single = single⸢list-set⸣
    ; _∪_ = _∪⸢list-set⸣_
    ; x∈single = x∈single⸢list-set⸣
    ; x∈xs = x∈xs⸢list-set⸣
    ; x∈ys = x∈ys⸢list-set⸣
    ; x∈xs∪ys→⨄ = x∈xs∪ys→⨄⸢list-set⸣
    }

data _⊴⸢list-set⸣_ {𝓁} {A : Set 𝓁} : relation 𝓁 (list-set A) where
  [] : ∀ {ys} → [] ⊴⸢list-set⸣ ys
  _∷_ : ∀ {x xs ys} → x ∈⸢list-set⸣ ys → xs ⊴⸢list-set⸣ ys → (x ∷ xs) ⊴⸢list-set⸣ ys

ext[⊴⸢list-set⸣] : ∀ {𝓁} {A : Set 𝓁} {xs ys : list-set A} → xs ⊴⸢list-set⸣ ys ↔ (∀ {x} → x ∈⸢list-set⸣ xs → x ∈⸢list-set⸣ ys)
ext[⊴⸢list-set⸣] = LHS , RHS
  where
    LHS : ∀ {𝓁} {A : Set 𝓁} {xs ys : list-set A} → xs ⊴⸢list-set⸣ ys → {x : A} → x ∈⸢list-set⸣ xs → x ∈⸢list-set⸣ ys
    LHS (x∈ys ∷ xs⊴ys) Zero = x∈ys
    LHS (x∈ys ∷ xs⊴ys) (Suc x∈xs) = LHS xs⊴ys x∈xs
    RHS : ∀ {𝓁} {A : Set 𝓁} {xs ys : list-set A} → ({x : A} → x ∈⸢list-set⸣ xs → x ∈⸢list-set⸣ ys) → xs ⊴⸢list-set⸣ ys
    RHS {xs = []}     ∀[x]x∈xs = []
    RHS {xs = x ∷ xs} ∀[x]x∈xs = ∀[x]x∈xs Zero ∷ RHS (λ x∈xs → ∀[x]x∈xs (Suc x∈xs))

instance
  Reflexive[⊴⸢list-set⸣] : ∀ {𝓁} {A : Set 𝓁} → Reflexive (_⊴⸢list-set⸣_ {A = A})
  Reflexive[⊴⸢list-set⸣] = record { xRx = π₂ ext[⊴⸢list-set⸣] id }
  Transitive[⊴⸢list-set⸣] : ∀ {𝓁} {A : Set 𝓁} → Transitive (_⊴⸢list-set⸣_ {A = A})
  Transitive[⊴⸢list-set⸣] = record { _⌾_ = λ ys⊴zs xs⊴ys → π₂ ext[⊴⸢list-set⸣]  $ π₁ ext[⊴⸢list-set⸣] ys⊴zs ∘ π₁ ext[⊴⸢list-set⸣] xs⊴ys }
  PreOrder[list-set] : ∀ {𝓁} {A : Set 𝓁} → PreOrder 𝓁 (list-set A)
  PreOrder[list-set] = record { _⊴_ = _⊴⸢list-set⸣_ }

homomorphic[∈⸢list-set⸣] : ∀ {𝓁} {A B : Set 𝓁} {f : A → B} {xs x} → x ∈⸢list-set⸣ xs → f x ∈⸢list-set⸣ map f xs
homomorphic[∈⸢list-set⸣] Zero = Zero
homomorphic[∈⸢list-set⸣] (Suc x∈xs) = Suc (homomorphic[∈⸢list-set⸣] x∈xs)

y∈map→∃x⸢list-set⸣ : ∀ {𝓁} {A B : Set 𝓁} {f : A → B} {xs y} → y ∈⸢list-set⸣ map⸢list-set⸣ f xs → ∃ x 𝑠𝑡 (y ≡ f x) × x ∈⸢list-set⸣ xs
y∈map→∃x⸢list-set⸣ {xs = []} ()
y∈map→∃x⸢list-set⸣ {xs = x ∷ xs} Zero = ∃ x ,, ↯ , Zero
y∈map→∃x⸢list-set⸣ {xs = x ∷ xs} (Suc y∈map[f][xs]) with y∈map→∃x⸢list-set⸣ y∈map[f][xs]
... | ∃ x' ,, y≡f[x'] , x'∈xs = ∃ x' ,, y≡f[x'] , Suc x'∈xs
