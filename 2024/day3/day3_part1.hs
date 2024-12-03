main :: IO ()
main = do
  filePath <- readFile "day3.txt"
  let linesOfFiles = lines filePath
  mapM_ putStrLn linesOfFiles 
