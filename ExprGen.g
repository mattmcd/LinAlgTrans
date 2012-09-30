tree grammar ExprGen;

options {
  tokenVocab = LinAlgExpr;
  ASTLabelType = CommonTree;
  output = template;
}

stat      : ^(ASSIGN a=outArgs e=expr) -> assign( var={$a.st}, expr = {$e.st})
          | expr -> { $expr.st }
          ;

outArgs   : ^(OUTARGS a+=ID* ) -> outArgs( args = {$a} )
          ;

expr      : ^(RDIVIDE A=matrix b=matrix ) -> solve( A={$A.st}, b={$b.st})
          | matrix -> {$matrix.st};

matrix    : ^(MATRIX e=matrix ) -> matrix( el = { $e.st } )
          | ^(HORZCAT m+=matrix+ ) -> horzcat( el = {$m} )
          | ^(VERTCAT n+=matrix+ ) -> vertcat( el = {$n} )
          | ID -> { %{$ID.text} }
          ;

/*
catExpr   : ^(HORZ matrix+ ) -> 
          | ^(VERT matrix+ ) -> 
          ;
          */


