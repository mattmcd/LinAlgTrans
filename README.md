LinAlgTrans
===========

Translator for a Linear Algebra
[DSL](http://en.wikipedia.org/wiki/Domain-specific_language) to a 
number of output formats. 

This project uses 
[ANTLR](http://www.antlr.org) and
[StringTemplate](http://www.stringtemplate.org) to parse the input 
and produce the output target language.

The Linear Algebra DSL is similar to the matrix manipulation 
subset of the MATLAB&reg; language.  See
[mparser](http://www.mathworks.de/matlabcentral/fileexchange/32769-mparser)
by [David Wingate](http://www.mit.edu/~wingated/resources.html) for a more
complete MATLAB grammar.  

Dependencies
============
[ANTLRWorks](http://www.antlr.org/works/index.html) must be on the Java
classpath.  Version 1.4.3 was the version used.

Online
======
Try it at [linalgtrans.appspot.com](http://linalgtrans.appspot.com) or POST
directly e.g.

    curl http://linalgtrans.appspot.com/Translate -d input="A=rand(10) b=rand(10,1) x=A\b"

Example
=======

Input
-----
    function fitParams = fitLine( xData, yData )
    designMat = [ xData, ones(size(xData)) ]
    fitParams = designMat\yData
    end
    
    x = [0; 1; 2; 3]
    y = [-1; 0.2; 0.9; 2.1]
    fitLine( x, y )
    
Output
------
    def fitLine(xData, yData):
      designMat = vstack([hstack([xData, ones(shape( xData ))])]);
      fitParams = linalg.lstsq( designMat, yData)[0];
      return (fitParams)

    x = vstack([hstack([0]), hstack([1]), hstack([2]), hstack([3])]);
    y = vstack([hstack([-1]), hstack([0.2]), hstack([0.9]),
    hstack([2.1])]);
    fitLine(x, y)
