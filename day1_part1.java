// Day 1 part 1 submission for the AoC in Java
// Since the wheel told me to do so.

import java.io.File;  // Import the File class
import java.io.FileNotFoundException;  // Import this class to handle errors
import java.util.*;
import java.lang.*;

public class Main {
  public static void main(String[] args) {
    try {
      File myObj = new File("day1.txt");
      Scanner myReader = new Scanner(myObj);
      int total = 0;
      while (myReader.hasNextLine()) {
        String data = myReader.nextLine();
        // initialize this 
        total += readNumber(data);
        
      }
      myReader.close();
      System.out.println(total);
    } catch (FileNotFoundException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }

  }

  public static int readNumber(String str) {
    int counting = 0;
    char firstDigit = '0'; char secondDigit = '0';
    for (int i = 0; i < str.length(); i++)
    {
        if (Character.isDigit(str.charAt(i))) {
            counting++;
            if (counting == 1) {
                firstDigit = str.charAt(i);
            }
            else {
                secondDigit = str.charAt(i);
            }
        }

    }
    if (counting == 1) {
        return Integer.valueOf(Character.toString(firstDigit) + Character.toString(firstDigit));
    }
    return Integer.valueOf(Character.toString(firstDigit) + Character.toString(secondDigit));
  }
}
