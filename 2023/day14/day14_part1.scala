import scala.io.Source

@main def readFile(): Unit =
  val filename = "day14.txt" // Replace with your file path
  val linesArray: Array[String] = Source.fromFile(filename).getLines().toArray

  // Print the array to verify the content
  linesArray.foreach(println)

