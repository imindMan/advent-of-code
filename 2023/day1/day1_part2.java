// Idea: just scan every single characters and parsing it


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
        System.out.println(total);
      myReader.close();
    } catch (FileNotFoundException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }

  }

  public static int readNumber(String str) {
    int counting = 0;
    char firstDigit = '0'; char secondDigit = '0';
    int i = 0;
    while (i < str.length())
    {
        if (Character.isDigit(str.charAt(i))) {
            counting++;
            if (counting == 1) {
                firstDigit = str.charAt(i);
            }
            else {
                secondDigit = str.charAt(i);
            }
            i += 1;
        }
        else if (str.charAt(i) == 'o') 
        {
            if (i + 3 <= str.length() && str.substring(i, i+3).equals("one")) {
                counting++;
                if (counting == 1) 
                {
                    firstDigit = '1';
                }
                else {
                    secondDigit = '1';
                }
            }
                i += 1;
        }
        else if (str.charAt(i) == 't') 
        {
            if (i + 3 <= str.length() && str.substring(i, i+3).equals("two")) {
                counting++;
                if (counting == 1) 
                {
                    firstDigit = '2';
                }
                else {
                    secondDigit = '2';
                }
            } 
            else if (i + 5 <= str.length() && str.substring(i, i + 5).equals("three")) {
                counting++;
                if (counting == 1) 
                {
                    firstDigit = '3';
                }
                else {
                    secondDigit = '3';
                }
            }
                i += 1;
        }
        else if (str.charAt(i) == 'f') 
        {
            if (i + 4 <= str.length() && str.substring(i, i+4).equals("four")) {
                counting++;
                if (counting == 1) 
                {
                    firstDigit = '4';
                }
                else {
                    secondDigit = '4';
                }
            } 
            else if (i + 4 <= str.length() && str.substring(i, i + 4).equals("five")) {

                counting++;
                if (counting == 1) 
                {
                    firstDigit = '5';
                }
                else {
                    secondDigit = '5';
                }
            }
                i += 1;
        }
        else if (str.charAt(i) == 's') 
        {
            if (i + 3 <= str.length() && str.substring(i, i+3).equals("six")) {
                counting++;
                if (counting == 1) 
                {
                    firstDigit = '6';
                }
                else {
                    secondDigit = '6';
                }
            } 
            else if (i + 5 <= str.length() && str.substring(i, i + 5).equals("seven")) {
                counting++;
                if (counting == 1) 
                {
                    firstDigit = '7';
                }
                else {
                    secondDigit = '7';
                }
            }
                i += 1;
        }
        else if (str.charAt(i) == 'e') 
        {
            if (i + 5 <= str.length() && str.substring(i, i+5).equals("eight")) {
                counting++;
                if (counting == 1) 
                {
                    firstDigit = '8';
                }
                else {
                    secondDigit = '8';
                }
            } 
                i += 1;
        }
        else if (str.charAt(i) == 'n') 
        {
            if (i + 4 <= str.length() && str.substring(i, i+4).equals("nine")) {
                counting++;
                if (counting == 1) 
                {
                    firstDigit = '9';
                }
                else {
                    secondDigit = '9';
                }
            } 
                i += 1;
        }
        else {
            i += 1;
        }


    }
    if (counting == 1) {

        return Integer.valueOf(Character.toString(firstDigit) + Character.toString(firstDigit));
    }
    else {

        return Integer.valueOf(Character.toString(firstDigit) + Character.toString(secondDigit));
    }
  }
}
