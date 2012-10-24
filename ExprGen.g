tree grammar ExprGen;

options {
  tokenVocab = LinAlgExpr;
  ASTLabelType = CommonTree;
  output = template;
}

file      : ^(FILE 
              ^(FUNCTIONS f+=function*) 
              ^(SCRIPTS s+=script*)) 
            -> file( functions={$f}, scripts={$s})
          ;

function  : ^(FUNCTION ^(NAME id_expr) inArgs outArgs ^(BODY body)) 
              -> function( name={$id_expr.st}, 
                           inArgs = {$inArgs.st},
                           outArgs = {$outArgs.st}, 
                           body = {$body.st} )
          ;

script    : ^(BODY body) -> { $body.st }
          ;

body      : s+=stat+ -> body( stat =  { $s } )
          ;

stat      : ^(ASSIGN a=outArgs e=expr) 
              -> assign( var={$a.st}, expr = {$e.st})
          | e=expr -> { $e.st }
          ;

inArgs	  :	^(INARGS a+=ID* ) -> inArgs( args = {$a} )
          ;

outArgs   : ^(OUTARGS a+=ID* ) -> outArgs( args = {$a} )
          ;

expr      : ^('+' a=expr b=expr) -> add( a={$a.st}, b={$b.st} )
          | ^('-' a=expr b=expr) -> sub( a={$a.st}, b={$b.st} )
          | ^(RDIVIDE A=expr b=expr ) -> solve( A={$A.st}, b={$b.st})
          | ^('.*' a=expr b=expr ) -> elmul( a={$a.st}, b={$b.st})
          | ^('./' a=expr b=expr ) -> eldiv( a={$a.st}, b={$b.st})
          | ^('/' a=expr b=expr ) -> matdiv( a={$a.st}, b={$b.st})
          | ^('*' a=expr b=expr ) -> matmul( a={$a.st}, b={$b.st})
          | ^('.^' a=expr b=expr ) -> elpow( a={$a.st}, b={$b.st})
          | ^('^' a=expr b=expr ) -> matpow( a={$a.st}, b={$b.st})
          | ^(TRANS e=expr) -> trans( x = { $e.st } ) 
          | ^(CTRANS e=expr) -> ctrans( x = { $e.st } ) 
          | ^(PARENS e=expr) -> { $e.st }
          | ^(MATRIX e=expr ) -> matrix( el = { $e.st } )
          | funCall -> { $funCall.st }
          | ^(UMINUS id_expr) -> uminus( x = { $id_expr.st } )
          | id_expr -> { $id_expr.st }
          | vmatrix -> { $vmatrix.st }
          | hmatrix -> { $hmatrix.st }
          ;

id_expr   : ID -> { %{$ID.text} }
          | NUMBER -> { %{$NUMBER.text}}
          ;

funCall   : libCall -> { $libCall.st }
          | ^(CALL ID callArgs ) -> 
              call( name={$ID.text}, args = { $callArgs.st } )
          ;

vmatrix   : ^(VERTCAT n+=hmatrix+ ) -> vertcat( el = {$n} )
          ;

hmatrix   : ^(HORZCAT m+=expr+ ) -> horzcat( el = {$m} )
          ;

libCall   : ^(SVD callArgs ) -> svd( args = {$callArgs.st} )
          | ^(EIG callArgs ) -> eig( args = {$callArgs.st} ) 
          | ^(RAND callArgs ) -> rand( args = {$callArgs.st} ) 
          | ^(RANDN callArgs ) -> randn( args = {$callArgs.st} ) 
          | ^(SIZE expr ) -> size( a = {$expr.st} ) 
          ;

callArgs  : ^(CALLARGS e+=expr* ) -> callArgs( args = {$e} )
          ;
