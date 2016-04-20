module RegExpParser

import public Lightyear
import public Lightyear.Char
import public Lightyear.Strings

import RegExp
import SmartCons

%access public export

toNat' : Char -> Nat
toNat' = fromInt . ord
        where
           fromInt n = if n <= 0 then 0 else S (fromInt (n - 1))

pChar : Parser RegExp
<<<<<<< HEAD
pChar = Chr <$> noneOf "[]()*+"
=======
pChar = (Chr . toNat)  <$> noneOf "[]()*+"
>>>>>>> 2b4e4597351505d7ad90c865432deebdf7bf2970

pAtom : Parser RegExp
pAtom = foldl1 (.@.) <$> some pChar

pstar : Parser (RegExp -> RegExp)
pstar = const star <$> lexeme (char '*')
<<<<<<< HEAD

pPlus : Parser (RegExp -> RegExp)
pPlus = const (\e => Cat e (star e)) <$> lexeme (char '+')

pInBracketsChar : Parser RegExp
pInBracketsChar = Chr <$> noneOf "[]^"

pBrackets : Parser RegExp
pBrackets = foldl Alt Zero <$> (brackets (many pInBracketsChar))

=======

pPlus : Parser (RegExp -> RegExp)
pPlus = const (\e => Cat e (star e)) <$> lexeme (char '+')

pInBracketsChar : Parser RegExp
pInBracketsChar = (Chr . toNat) <$> noneOf "[]^"

pBrackets : Parser RegExp
pBrackets = foldl Alt Zero <$> (brackets (many pInBracketsChar))

>>>>>>> 2b4e4597351505d7ad90c865432deebdf7bf2970
pStar : Parser (RegExp -> RegExp)
pStar = pstar <|> pure id

mutual
  pFactor : Parser RegExp
  pFactor =  pBrackets <|>| pAtom <|>| (parens pExp)

  pTerm : Parser RegExp
  pTerm = f <$> pFactor <*> (pPlus <|>| pStar)
          where
            f e g = g e

  pExp : Parser RegExp
  pExp = foldl Cat Eps <$> many pTerm
