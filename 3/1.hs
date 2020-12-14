import Data.Bool

trees :: [[Bool]] -> Int
trees = trees' 0

trees' :: Int -> [[Bool]] -> Int
trees' _ []    = 0
trees' x input = (bool 0 1 $ head input !! (x `mod` width))
                 + (trees' ((x + 3) `mod` width) $ tail input)
    where width = length $ head input

parseInput :: String -> [[Bool]]
parseInput input = map (\line -> map ( == '#') line) $ lines input

main = do
    input <- readFile "in"
    print $ trees $ parseInput $ input
