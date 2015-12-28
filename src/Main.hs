{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle
import Paths_any_tool (version)
import Data.Version (showVersion)

-- main
mainSubroutine :: IO ()
mainSubroutine = echo "Any tool just works!"

parseMain :: Parser (IO ())
parseMain = pure mainSubroutine

-- version
version' :: IO()
version' = putStrLn (showVersion version)

verboseVersion :: IO()
verboseVersion = do
                 version'
                 echo "Verbose version information about any-tool"

parseVersion :: Parser (IO ())
parseVersion =
    (subcommand "version" "Show any-tool version" (pure verboseVersion))

-- print text
printText :: (Maybe Int, Text) -> IO()
printText (Nothing, text) = echo text
printText ((Just i), text) = replicateM_ i (echo text)

printArgs :: Parser (Maybe Int, Text)
printArgs = (,) <$> optional (optInt "times" 'n' "Number of times")
                 <*> (argText "text" "Text to print")

parsePrint :: Parser (IO ())
parsePrint = fmap printText
    (subcommand "print" "Print specified text specified number of times" printArgs)

-- main parser
parser :: Parser (IO ())
parser = parseMain <|> parseVersion <|> parsePrint

-- main
main :: IO ()
main = do
    cmd <- options "Just any tool you could imagine" parser
    cmd
