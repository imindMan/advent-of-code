import scala.io.Source
import scala.util.control.Breaks._

def analyze(map:Array[String]): Unit = 
  var sum = 0
  for i <- 0 to map.length - 1 do 
    for j <- 0 to map(i).length - 1 do
      if map(i)(j) == 'O' then
        var final_k = -1
        breakable {
          for (k <- i - 1 to -1 by -1) do
            if k != -1 && (map(k)(j) == 'O' || map(k)(j) == '#') then 
              final_k = k 
              break
        }
        if final_k + 1 != i then
          map(final_k + 1) = map(final_k + 1).substring(0, j) + 'O' + map(final_k + 1).substring(j + 1)
          map(i) = map(i).substring(0, j) + '.' + map(i).substring(j + 1)
        sum = sum + map.length - final_k - 1
  println(sum)

@main def readFile(): Unit =
  val filename = "day14.txt" // Replace with your file path
  val linesArray: Array[String] = Source.fromFile(filename).getLines().toArray

  // Print the array to verify the content
  analyze(linesArray)
