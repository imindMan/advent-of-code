input_through_star :: [[a]] -> [[a]]
input_through_star contents = 
    zipWith (\n m -> concat (n ++ m)) [
    [[contents !! (i + k) !! (j + k)] | k <- [0..2]] | i <- [0..(length contents) - 3], j <- [0..(length contents) - 3]] 
    [[[contents !! (i + k) !! (j - k)] | k <- [0..2] ] | i <- [0..(length contents) - 3], j <- [2..(length contents) - 1]]


main :: IO()
main = do
    contents <- readFile "day4.txt"
    print $ 
      length $
        filter (\n -> or [n == "MASMAS", n == "MASSAM", n == "SAMMAS", n =="SAMSAM"]) $ 
          input_through_star $ 
            lines contents
