import scala.io.Source
import scala.util.control.Breaks._


def rotate90(arr: Array[String]): Unit = 
    val n = arr.length
    val m = arr(0).length

    // Step 1: Transpose (convert rows into columns)
    val transposed = (0 until m).map { col =>
      (0 until n).map { row =>
        arr(n - row - 1)(col) // Rotating by changing index positions
      }.mkString // Convert character list back to string
    }.toArray

    for i <- 0 to transposed.length - 1 do
      arr(i) = transposed(i)

def upward_push(map:Array[String]): Unit = 
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

def cycle(map:Array[String]): Array[String] = 
  val map_copy = map.clone()
  for i <- 0 to 3 do
    upward_push(map_copy)
    rotate90(map_copy)
  map_copy

def findDuplicateRec(x: Array[String], A: List[Array[String]] = List(), count: Int = 0): (Int, Int, List[Array[String]]) = 
  if (A.exists(_.sameElements(x))) (count, A.indexWhere(_.sameElements(x)), A) // Base case: duplicate found
  else findDuplicateRec(cycle(x), A :+ x, count + 1) // Recursive case: append x and continue

def total_beams(arr:Array[String]):Int =
  var sum = 0 
  for i <- 0 to arr.length - 1 do 
    sum += arr(i).count(_ == 'O') * (arr.length - i)
  sum

@main def readFile(): Unit =
  val filename = "day14.txt" // Replace with your file path
  val linesArray: Array[String] = Source.fromFile(filename).getLines().toArray

  val (iter, first, arr) = findDuplicateRec(cycle(linesArray), List(linesArray), 1)
  val final_arr = arr((1000000000 - first)%(iter - first) + first)
  println(total_beams(final_arr))
