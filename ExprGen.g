tree grammar ExprGen;

options {
  tokenVocab = LinAlgExpr;
  ASTLabelType = CommonTree;
  output = template;
}

expr      : matrix EOF -> {$matrix.st};

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


