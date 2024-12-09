{-# LANGUAGE LambdaCase #-}

module Main where

import Text.Printf
import Control.Exception (Exception, throwIO, catch)
import System.IO (hFlush, stdout)

-- Custom Exception for Integration Errors
data IntegrationException 
  = InvalidLimits 
  | InvalidIntervals 
  deriving (Show)

-- Integration Configuration Data Type specifications
data IntegrationConfig = IntegrationConfig 
  { lowerLimit :: Double
  , upperLimit :: Double
  , subIntervals :: Int
  } deriving (Show)

-- Validate Integration Configuration
validateConfig :: IntegrationConfig -> Either IntegrationException IntegrationConfig
validateConfig config
  | lowerLimit config >= upperLimit config = Left InvalidLimits
  | subIntervals config <= 0 || odd (subIntervals config) = Left InvalidIntervals
  | otherwise = Right config

-- Simpson's Rule Integration Function
simpsonsRule :: (Double -> Double) -> IntegrationConfig -> Double
simpsonsRule func config = 
  let 
    a = lowerLimit config
    b = upperLimit config
    n = subIntervals config
    h = (b - a) / fromIntegral n
    
    -- Generate x values
    xValues = [a, a + h .. b]
    
    -- Weight function for Simpson's Rule
    weight i
      | i == 0 || i == n = 1.0
      | even i = 2.0
      | otherwise = 4.0
    
    -- Calculate weighted function values
    weightedValues = zipWith (\x i -> weight i * func x) xValues [0..]
  in 
    (h / 3.0) * sum weightedValues

-- Example Integration Functions
exampleFunctions :: [(String, Double -> Double)]
exampleFunctions = 
  [ ("f(x) = x³ * e^(-x) / (x+1)", \x -> (x**3) * exp(-x) / (x + 1))
  , ("f(x) = 1/x", \x -> 1/x)
  , ("f(x) = sin(x)", sin)
  , ("f(x) = cos(x)", cos)
  ]

-- Interactive Integration Prompt
promptIntegration :: IO ()
promptIntegration = do
  putStrLn "Simpson's Rule Numerical Integration"
  putStrLn "------------------------------------"
  
  -- Function Selection
  putStrLn "Available Functions:"
  mapM_ displayFunction (zip [(1::Int)..] exampleFunctions)
  
  -- Get Function Choice
  putStr "Select function (1-4): "
  hFlush stdout
  functionChoice <- readLn

  let maybeFunc = exampleFunctions !? (functionChoice - 1)
  case maybeFunc of
    Nothing -> putStrLn "Invalid function choice"
    Just (funcName, func) -> do
      -- Get Integration Limits
      putStr "Enter lower limit (a): "
      hFlush stdout
      lowerLim <- readLn

      putStr "Enter upper limit (b): "
      hFlush stdout
      upperLim <- readLn

      -- Get Sub-Intervals
      putStr "Enter number of sub-intervals (must be even): "
      hFlush stdout
      intervals <- readLn

      -- Perform Integration with Error Handling
      let config = IntegrationConfig lowerLim upperLim intervals
      case validateConfig config of
        Left InvalidLimits -> 
          putStrLn "Error: Lower limit must be less than upper limit"
        Left InvalidIntervals -> 
          putStrLn "Error: Number of intervals must be a positive even number"
        Right validConfig -> do
          let result = simpsonsRule func validConfig
          printf "Numerical Integration of %s from %.2f to %.2f: %.6f\n" 
                 funcName lowerLim upperLim result
  where
    -- Separate function to resolve type ambiguity
    displayFunction :: (Int, (String, a)) -> IO ()
    displayFunction (i, (name, _)) = printf "%d. %s\n" i name

-- Safe list indexing
(!?) :: [a] -> Int -> Maybe a
xs !? i
  | i < 0 || i >= length xs = Nothing
  | otherwise = Just (xs !! i)

-- Main Execution
main :: IO ()
main = do
  putStrLn "Numerical Integration Calculator"
  
  -- Recursive interaction loop
  let interactionLoop = do
        promptIntegration

        -- Option to continue
        putStr "Do another integration? (y/n): "
        hFlush stdout
        response <- getLine
        case response of
          "y" -> interactionLoop
          "n" -> putStrLn "Thank you for using the integration calculator!"
          _ -> putStrLn "Invalid input. Exiting."
  
  interactionLoop