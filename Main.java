import org.antlr.runtime.*;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.BufferedReader;

public class Main {
  public static void main(String[] args) throws Exception {
    CharStream input;
    if ( args.length > 0 ) 
    {
      input = new ANTLRFileStream(args[0]);
    } else {
      BufferedReader is = new BufferedReader( 
        new InputStreamReader( System.in ));
      input = new ANTLRStringStream( is.readLine() );
    }  
    String templateFile;
    if ( args.length > 1 ) {
        templateFile = args[1];
    } else {
        templateFile = "Python.stg";
    }
    String output = LinAlg.generate( input, templateFile );
    System.out.println( output );
  }
}
