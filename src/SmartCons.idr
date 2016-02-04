module SmartCons

import RegExp

%default total

appendNilR : (xs : List a) -> xs = xs ++ []
appendNilR [] = Refl
appendNilR (x :: xs) = cong (appendNilR xs)

inRegLemma : InRegExp xs1 e -> xs = xs1 ++ [] -> InRegExp xs e
inRegLemma {xs1} pr eq with (trans (appendNilR xs1) (sym eq))
                 | Refl = pr
infixl 4 .|.

(.|.) : RegExp -> RegExp -> RegExp
Zero .|. e = e
e .|. Zero = e
e .|. e'   = Alt e e'

infixl 5 .@.

(.@.) : RegExp -> RegExp -> RegExp
Zero .@. e = Zero
Eps .@. e  = e
e .@. Zero = Zero
e .@. Eps  = e
e .@. e'   = Cat e e'

star : RegExp -> RegExp
star Zero = Eps
star Eps = Eps
star e = Star e

altOptSound : (l : RegExp)     ->
              (r : RegExp)     ->
              (xs : List Char) ->
              InRegExp xs (l .|. r) ->
              InRegExp xs (Alt l r)
altOptSound Zero r xs pr = InAltR pr
altOptSound Eps Zero xs pr = InAltL pr
altOptSound Eps Eps xs pr = pr
altOptSound Eps (Chr x) xs pr = pr
altOptSound Eps (Cat x y) xs pr = pr
altOptSound Eps (Alt x y) xs pr = pr
altOptSound Eps (Star x) xs pr = pr
altOptSound Eps (Comp x) xs pr = pr
altOptSound (Chr x) Zero xs pr = InAltL pr
altOptSound (Chr x) Eps xs pr = pr
altOptSound (Chr x) (Chr y) xs pr = pr
altOptSound (Chr x) (Cat y z) xs pr = pr
altOptSound (Chr x) (Alt y z) xs pr = pr
altOptSound (Chr x) (Star y) xs pr = pr
altOptSound (Chr x) (Comp y) xs pr = pr
altOptSound (Cat x y) Zero xs pr = InAltL pr
altOptSound (Cat x y) Eps xs pr = pr
altOptSound (Cat x y) (Chr z) xs pr = pr
altOptSound (Cat x y) (Cat z w) xs pr = pr
altOptSound (Cat x y) (Alt z w) xs pr = pr
altOptSound (Cat x y) (Star z) xs pr = pr
altOptSound (Cat x y) (Comp z) xs pr = pr
altOptSound (Alt x y) Zero xs pr = InAltL pr
altOptSound (Alt x y) Eps xs pr = pr
altOptSound (Alt x y) (Chr z) xs pr = pr
altOptSound (Alt x y) (Cat z w) xs pr = pr
altOptSound (Alt x y) (Alt z w) xs pr = pr
altOptSound (Alt x y) (Star z) xs pr = pr
altOptSound (Alt x y) (Comp z) xs pr = pr
altOptSound (Star x) Zero xs pr = InAltL pr
altOptSound (Star x) Eps xs pr = pr
altOptSound (Star x) (Chr y) xs pr = pr
altOptSound (Star x) (Cat y z) xs pr = pr
altOptSound (Star x) (Alt y z) xs pr = pr
altOptSound (Star x) (Star y) xs pr = pr
altOptSound (Star x) (Comp y) xs pr = pr
altOptSound (Comp x) Zero xs pr = InAltL pr
altOptSound (Comp x) Eps xs pr = pr
altOptSound (Comp x) (Chr y) xs pr = pr
altOptSound (Comp x) (Cat y z) xs pr = pr
altOptSound (Comp x) (Alt y z) xs pr = pr
altOptSound (Comp x) (Star y) xs pr = pr
altOptSound (Comp x) (Comp y) xs pr = pr

altOptComplete : (l : RegExp)  ->
                 (r : RegExp)  ->
                 (xs : List Char) ->
                 InRegExp xs (Alt l r) ->
                 InRegExp xs (l .|. r)
altOptComplete Zero r xs (InAltL x) = void (inZeroInv x)
altOptComplete Zero r xs (InAltR x) = x
altOptComplete Eps Zero xs (InAltL x) = x
altOptComplete Eps Zero xs (InAltR x) = void (inZeroInv x)
altOptComplete Eps Eps xs pr = pr
altOptComplete Eps (Chr x) xs pr = pr
altOptComplete Eps (Cat x y) xs pr = pr
altOptComplete Eps (Alt x y) xs pr = pr
altOptComplete Eps (Star x) xs pr = pr
altOptComplete Eps (Comp x) xs pr = pr
altOptComplete (Chr x) Zero xs (InAltL y) = y
altOptComplete (Chr x) Zero xs (InAltR y) = void (inZeroInv y)
altOptComplete (Chr x) Eps xs pr = pr
altOptComplete (Chr x) (Chr y) xs pr = pr
altOptComplete (Chr x) (Cat y z) xs pr = pr
altOptComplete (Chr x) (Alt y z) xs pr = pr
altOptComplete (Chr x) (Star y) xs pr = pr
altOptComplete (Chr x) (Comp y) xs pr = pr
altOptComplete (Cat x y) Zero xs (InAltL z) = z
altOptComplete (Cat x y) Zero xs (InAltR z) = void (inZeroInv z)
altOptComplete (Cat x y) Eps xs pr = pr
altOptComplete (Cat x y) (Chr z) xs pr = pr
altOptComplete (Cat x y) (Cat z w) xs pr = pr
altOptComplete (Cat x y) (Alt z w) xs pr = pr
altOptComplete (Cat x y) (Star z) xs pr = pr
altOptComplete (Cat x y) (Comp z) xs pr = pr
altOptComplete (Alt x y) Zero xs (InAltL z) = z
altOptComplete (Alt x y) Zero xs (InAltR z) = void (inZeroInv z)
altOptComplete (Alt x y) Eps xs pr = pr
altOptComplete (Alt x y) (Chr z) xs pr = pr
altOptComplete (Alt x y) (Cat z w) xs pr = pr
altOptComplete (Alt x y) (Alt z w) xs pr = pr
altOptComplete (Alt x y) (Star z) xs pr = pr
altOptComplete (Alt x y) (Comp z) xs pr = pr
altOptComplete (Star x) Zero xs (InAltL y) = y
altOptComplete (Star x) Zero xs (InAltR y) = void (inZeroInv y)
altOptComplete (Star x) Eps xs pr = pr
altOptComplete (Star x) (Chr y) xs pr = pr
altOptComplete (Star x) (Cat y z) xs pr = pr
altOptComplete (Star x) (Alt y z) xs pr = pr
altOptComplete (Star x) (Star y) xs pr = pr
altOptComplete (Star x) (Comp y) xs pr = pr
altOptComplete (Comp x) Zero xs (InAltL y) = y
altOptComplete (Comp x) Zero xs (InAltR y) = void (inZeroInv y)
altOptComplete (Comp x) Eps xs pr = pr
altOptComplete (Comp x) (Chr y) xs pr = pr
altOptComplete (Comp x) (Cat y z) xs pr = pr
altOptComplete (Comp x) (Alt y z) xs pr = pr
altOptComplete (Comp x) (Star y) xs pr = pr
altOptComplete (Comp x) (Comp y) xs pr = pr

catOptSound : (l : RegExp) ->
              (r : RegExp) ->
              (xs : List Char) ->
              InRegExp xs (l .@. r) ->
              InRegExp xs (Cat l r)
catOptSound Zero r xs pr = void (inZeroInv pr)
catOptSound Eps r xs pr = InCat InEps pr Refl
catOptSound (Chr x) Zero xs pr = void (inZeroInv pr)
catOptSound (Chr x) Eps xs pr = InCat pr InEps (appendNilR xs)
catOptSound (Chr x) (Chr y) xs pr = pr
catOptSound (Chr x) (Cat y z) xs pr = pr
catOptSound (Chr x) (Alt y z) xs pr = pr
catOptSound (Chr x) (Star y) xs pr = pr
catOptSound (Chr x) (Comp y) xs pr = pr
catOptSound (Cat x y) Zero xs pr = void (inZeroInv pr)
catOptSound (Cat x y) Eps xs pr = InCat pr InEps (appendNilR xs)
catOptSound (Cat x y) (Chr z) xs pr = pr
catOptSound (Cat x y) (Cat z w) xs pr = pr
catOptSound (Cat x y) (Alt z w) xs pr = pr
catOptSound (Cat x y) (Star z) xs pr = pr
catOptSound (Cat x y) (Comp z) xs pr = pr
catOptSound (Alt x y) Zero xs pr = void (inZeroInv pr)
catOptSound (Alt x y) Eps xs pr = InCat pr InEps (appendNilR xs)
catOptSound (Alt x y) (Chr z) xs pr = pr
catOptSound (Alt x y) (Cat z w) xs pr = pr
catOptSound (Alt x y) (Alt z w) xs pr = pr
catOptSound (Alt x y) (Star z) xs pr = pr
catOptSound (Alt x y) (Comp z) xs pr = pr
catOptSound (Star x) Zero xs pr = void (inZeroInv pr)
catOptSound (Star x) Eps xs pr = InCat pr InEps (appendNilR xs)
catOptSound (Star x) (Chr y) xs pr = pr
catOptSound (Star x) (Cat y z) xs pr = pr
catOptSound (Star x) (Alt y z) xs pr = pr
catOptSound (Star x) (Star y) xs pr = pr
catOptSound (Star x) (Comp y) xs pr = pr
catOptSound (Comp x) Zero xs pr = void (inZeroInv pr)
catOptSound (Comp x) Eps xs pr = InCat pr InEps (appendNilR xs)
catOptSound (Comp x) (Chr y) xs pr = pr
catOptSound (Comp x) (Cat y z) xs pr = pr
catOptSound (Comp x) (Alt y z) xs pr = pr
catOptSound (Comp x) (Star y) xs pr = pr
catOptSound (Comp x) (Comp y) xs pr = pr

catOptComplete : (l : RegExp) ->
                 (r : RegExp) ->
                 (xs : List Char) ->
                 InRegExp xs (Cat l r) ->
                 InRegExp xs (l .@. r)
catOptComplete Zero r xs (InCat x y prf) = void (inZeroInv x)
catOptComplete Eps r xs (InCat InEps y Refl) = y
catOptComplete (Chr x) Zero xs (InCat y z prf) = void (inZeroInv z)
catOptComplete (Chr x) Eps xs (InCat y InEps prf) = inRegLemma y prf
catOptComplete (Chr x) (Chr y) xs pr = pr
catOptComplete (Chr x) (Cat y z) xs pr = pr
catOptComplete (Chr x) (Alt y z) xs pr = pr
catOptComplete (Chr x) (Star y) xs pr = pr
catOptComplete (Chr x) (Comp y) xs pr = pr
catOptComplete (Cat x y) Zero xs (InCat z w prf) = void (inZeroInv w)
catOptComplete (Cat x y) Eps xs (InCat z InEps prf) = inRegLemma z prf
catOptComplete (Cat x y) (Chr z) xs pr = pr
catOptComplete (Cat x y) (Cat z w) xs pr = pr
catOptComplete (Cat x y) (Alt z w) xs pr = pr
catOptComplete (Cat x y) (Star z) xs pr = pr
catOptComplete (Cat x y) (Comp z) xs pr = pr
catOptComplete (Alt x y) Zero xs (InCat z w prf) = void (inZeroInv w)
catOptComplete (Alt x y) Eps xs (InCat z InEps prf) = inRegLemma z prf
catOptComplete (Alt x y) (Chr z) xs pr = pr
catOptComplete (Alt x y) (Cat z w) xs pr = pr
catOptComplete (Alt x y) (Alt z w) xs pr = pr
catOptComplete (Alt x y) (Star z) xs pr = pr
catOptComplete (Alt x y) (Comp z) xs pr = pr
catOptComplete (Star x) Zero xs (InCat y z prf) = void (inZeroInv z)
catOptComplete (Star x) Eps xs (InCat y InEps prf) = inRegLemma y prf
catOptComplete (Star x) (Chr y) xs pr = pr
catOptComplete (Star x) (Cat y z) xs pr = pr
catOptComplete (Star x) (Alt y z) xs pr = pr
catOptComplete (Star x) (Star y) xs pr = pr
catOptComplete (Star x) (Comp y) xs pr = pr
catOptComplete (Comp x) Zero xs (InCat y z prf) = void (inZeroInv z)
catOptComplete (Comp x) Eps xs (InCat y InEps prf) = inRegLemma y prf
catOptComplete (Comp x) (Chr y) xs pr = pr
catOptComplete (Comp x) (Cat y z) xs pr = pr
catOptComplete (Comp x) (Alt y z) xs pr = pr
catOptComplete (Comp x) (Star y) xs pr = pr
catOptComplete (Comp x) (Comp y) xs pr = pr

starOptSound : (l : RegExp) ->
               (xs : List Char) ->
               InRegExp xs (star l) ->
               InRegExp xs (Star l)
starOptSound Zero xs pr = InStar (InAltL pr)
starOptSound Eps xs pr = InStar (InAltL pr)
starOptSound (Chr x) xs pr = pr
starOptSound (Cat x y) xs pr = pr
starOptSound (Alt x y) xs pr = pr
starOptSound (Star x) xs pr = pr
starOptSound (Comp x) xs pr = pr

starOptComplete : (l : RegExp) ->
                  (xs : List Char) ->
                  InRegExp xs (Star l) ->
                  InRegExp xs (star l)
starOptComplete Zero xs (InStar (InAltL x)) = x
starOptComplete Zero xs (InStar (InAltR (InCat x y prf))) = void (inZeroInv x)
starOptComplete Eps xs (InStar (InAltL x)) = x
starOptComplete Eps xs (InStar (InAltR (InCat InEps y Refl))) = starOptComplete _ xs y
starOptComplete (Chr x) xs pr = pr
starOptComplete (Cat x y) xs pr = pr
starOptComplete (Alt x y) xs pr = pr
starOptComplete (Star x) xs pr = pr
starOptComplete (Comp x) xs pr = pr
