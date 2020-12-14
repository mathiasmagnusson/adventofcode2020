import Data.Bool

main = do
    input <- readFile "in"
    print $ solve $ parseInput $ input

parseInput :: String -> [[Bool]]
parseInput input = map (\line -> map ( == '#') line) $ lines input

solve :: [[Bool]] -> Int
solve input = product (map (\(a, b) -> trees a b input) [
                  (1, 1),
                  (3, 1),
                  (5, 1),
                  (7, 1),
                  (1, 2)
              ])

trees :: Int -> Int -> [[Bool]] -> Int
trees = trees' 0

trees' :: Int -> Int -> Int -> [[Bool]] -> Int
trees' _ _          _         []    = 0
trees' x slopeRight slopeDown input = (bool 0 1 $ head input !! (x `mod` width))
                                    + (trees'
                                        ((x + slopeRight) `mod` width)
                                        slopeRight
                                        slopeDown
                                        $ drop slopeDown input)
    where width = length $ head input
