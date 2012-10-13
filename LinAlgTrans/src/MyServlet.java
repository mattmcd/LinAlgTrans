import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.Servlet;
import javax.servlet.ServletContext;

public class MyServlet extends HttpServlet {
  public void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws IOException {
      resp.setContentType("text/plain");
      resp.getWriter().println("POST input");
    }
  
  public void doPost(HttpServletRequest req, HttpServletResponse resp)
    throws IOException {
      String input = req.getParameter( "input" );

      String outType = req.getParameter( "generate" );

      String processed;
      
      // Name of template file to use

      String filename;
      if ( outType != null ) {
        if ( outType.equals( "javascript") ) {
          filename = "/WEB-INF/MEXWrapper.stg";
        } else {
          filename = "/WEB-INF/Python.stg";
        }
      } else {
        filename = "/WEB-INF/Python.stg";
      }
      ServletContext context = this.getServletContext();
      String pathname = context.getRealPath( filename );
      
      try {
        processed = LinAlg.generate( input, pathname );
      }
      catch ( Exception e ) {
        processed = "FAIL:" + e.getMessage();
      };

      resp.setContentType("text/plain");
      resp.getWriter().println( processed );
    }
}
