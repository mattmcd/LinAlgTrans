tree grammar ExprGen;

options {
  tokenVocab = LinAlgExpr;
  ASTLabelType = CommonTree;
  output = template;
}

body      : s+=stat+ -> body( stat =  { $s } )
          ;

stat      : ^(ASSIGN a=outArgs e=expr) 
              -> assign( var={$a.st}, expr = {$e.st})
          | e=expr -> { $e.st }
          ;

outArgs   : ^(OUTARGS a+=ID* ) -> outArgs( args = {$a} )
          ;

expr      : ^(RDIVIDE A=base_expr b=base_expr ) 
              -> solve( A={$A.st}, b={$b.st})
          | e=base_expr -> {$e.st}
          ;

base_expr : ^(MATRIX e=vmatrix ) -> matrix( el = { $e.st } )
          | ID -> { %{$ID.text} }
          | NUMBER -> { %{$NUMBER.text}}
          | funCall -> { $funCall.st }
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
          ;

callArgs  : ^(CALLARGS e+=expr* ) -> callArgs( args = {$e} )
          ;
