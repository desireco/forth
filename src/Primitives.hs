module Primitives where

import           Eval
import           Types

dictionary =
  [("+", numBinOp (+)),
   ("-", numBinOp (-)),
   ("*", numBinOp (*)),
   ("/", numBinOp quot),
   ("max", numBinOp max),
   ("min", numBinOp min),
   ("negate", numOp negate),
   ("abs", numOp abs),

   ("=", equal),
   ("if", if'),

   (".", pop),
   ("dup", dup),
   ("swap", swap),
   ("call", call),
   ("compose", compose),
   ("curry", curry'),

   (":", compileMode),
   (";", interpretMode),

   ("words", printDict)]


-- Quotations
call = do
  (Word _ (User stack)) <- pop
  evalBody stack

compose = do
  (Word _ (User stackY)) <- pop
  (Word _ (User stackX)) <- pop
  push $ makeWord (stackX ++ stackY)

curry' = do
  (Word _ (User stack)) <- pop
  x <- pop
  push $ makeWord (x : stack)


-- Helpers
numOp f = do
  (Number x) <- pop
  push (Number (f x))

numBinOp f = do
  (Number x) <- pop
  (Number y) <- pop
  push (Number (f x y))


-- Equality
equal = do
  x <- pop
  y <- pop
  push (Bool (x == y))

if' = do
  y <- pop
  x <- pop
  b <- pop
  if b == Bool False then
    invoke y
  else
    invoke x


-- Stack Manipulation
dup = do
  x <- pop
  push x
  push x

swap = do
  x <- pop
  y <- pop
  push x
  push y
