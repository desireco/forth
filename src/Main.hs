module Main where

import           Control.Lens             ((&))
import           Control.Monad.State
import           Control.Monad.Trans
import           Data.IORef
import           Eval
import           Parser
import           Primitives
import           System.Console.Haskeline
import           System.Console.Repl
import           Types

evalLine :: String -> Forth ()
evalLine line =
  case parseLine line of
    Right vs -> do
      evalMany vs
      liftIO $ putStrLn "ok"
    Left e   -> liftIO (printError e)

showResult rs =
  liftIO $ putStrLn (rstr ++ ok)
  where rstr = map show rs
             & reverse
             & filter (/= "")
             & unwords
        ok = if null rstr then "ok" else " ok"


main =
  repl
  where repl =
          runInputT defaultSettings (loop (new dictionary))
        loop state = do
          line <- getInputLine "=> "
          case line of
            Just ":q" ->
              return ()
            Just input -> do
              (r, state) <- liftIO $ run (evalLine input) state
              loop state
            Nothing ->
              loop state
