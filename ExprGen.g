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

inArgs	  :	^(INARGS a+=ID* ) -> outArgs( args = {$a} )
          ;

outArgs   : ^(OUTARGS a+=ID* ) -> outArgs( args = {$a} )
          ;

expr      : ^('+' a=mulExpr b=mulExpr) -> add( a={$a.st}, b={$b.st} )
          | ^('-' a=mulExpr b=mulExpr) -> sub( a={$a.st}, b={$b.st} )
          | mulExpr -> { $mulExpr.st }
          ;

mulExpr   : ^(RDIVIDE A=powExpr b=powExpr ) -> solve( A={$A.st}, b={$b.st})
          | ^('.*' a=powExpr b=powExpr ) -> elmul( a={$a.st}, b={$b.st})
          | ^('./' a=powExpr b=powExpr ) -> eldiv( a={$a.st}, b={$b.st})
          | ^('/' a=powExpr b=powExpr ) -> matdiv( a={$a.st}, b={$b.st})
          | ^('*' a=powExpr b=powExpr ) -> matmul( a={$a.st}, b={$b.st})
          | powExpr -> { $powExpr.st }
          ;

powExpr   : ^('.^' a=transExpr b=transExpr ) -> elpow( a={$a.st}, b={$b.st})
          | ^('^' a=transExpr b=transExpr ) -> matpow( a={$a.st}, b={$b.st})
          | transExpr -> { $transExpr.st }
          ;

transExpr : ^(TRANS grpExpr) -> trans( x = { $grpExpr.st } ) 
          | ^(CTRANS grpExpr) -> ctrans( x = { $grpExpr.st } ) 
          | grpExpr -> { $grpExpr.st }
          ;

grpExpr   : base_expr -> { $base_expr.st }
          | ^(PARENS expr) -> { $expr.st }
          ;

base_expr : ^(MATRIX e=vmatrix ) -> matrix( el = { $e.st } )
          | funCall -> { $funCall.st }
          |^(UMINUS id_expr) -> uminus( x = { $id_expr.st } )
          | id_expr -> { $id_expr.st }
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
