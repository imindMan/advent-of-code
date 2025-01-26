import Data.List

-- Function to extract the diagonals of a 2D array
diagonals :: [[a]] -> [[a]]
diagonals matrix = primaryDiagonals ++ secondaryDiagonals
  where
    rows = length matrix
    cols = length (head matrix)

    -- Get all primary diagonals (top-left to bottom-right)
    primaryDiagonals = [ [matrix !! (i + k) !! k | k <- [0..min (rows - i - 1) (cols - 1)]] | i <- [0..rows - 1] ] ++
                       [ [matrix !! k !! (j + k) | k <- [0..min (rows - 1) (cols - j - 1)]] | j <- [1..cols - 1] ] ++
                       (map (reverse) [ [matrix !! (i + k) !! k | k <- [0..min (rows - i - 1) (cols - 1)]] | i <- [0..rows - 1] ])++
                       (map (reverse) [ [matrix !! k !! (j + k) | k <- [0..min (rows - 1) (cols - j - 1)]] | j <- [1..cols - 1] ])

    -- Get all secondary diagonals (top-right to bottom-left)
    secondaryDiagonals = [ [matrix !! (i + k) !! (cols - k - 1) | k <- [0..min (rows - i - 1) (cols - 1)]] | i <- [0..rows - 1] ] ++
                         [ [matrix !! k !! (cols - j - k - 1) | k <- [0..min (rows - 1) (cols - j - 1)]] | j <- [1..cols - 1] ] ++
                         (map (reverse) [ [matrix !! (i + k) !! (cols - k - 1) | k <- [0..min (rows - i - 1) (cols - 1)]] | i <- [0..rows - 1] ] ) ++
                         (map (reverse) [ [matrix !! k !! (cols - j - k - 1) | k <- [0..min (rows - 1) (cols - j - 1)]] | j <- [1..cols - 1] ] ) 
cols :: [[a]] -> [[a]]
cols a = transpose a ++ map (\x -> reverse x) (transpose a)

rows :: [[a]] -> [[a]]
rows a = a ++ map (\x -> reverse x) a

countOverlapping :: Eq a => [a] -> [a] -> Int
countOverlapping _ [] = 0
countOverlapping [] _ = 0
countOverlapping str sub
  | take (length sub) str == sub = 1 + countOverlapping (tail str) sub
  | otherwise = countOverlapping (tail str) sub

main :: IO ()
main = do
    contents <- readFile "day4.txt"
    print $ sum $ [
        foldl (\acc x -> acc + countOverlapping x "XMAS") 0 (diagonals $ lines contents), 
        foldl (\acc x -> acc + countOverlapping x "XMAS") 0 (cols $ lines contents), 
        foldl (\acc x -> acc + countOverlapping x "XMAS") 0 (rows $ lines contents)
        ]
