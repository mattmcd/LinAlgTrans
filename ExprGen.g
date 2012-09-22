tree grammar ExprGen;

options {
  tokenVocab = LinAlgExpr;
  ASTLabelType = CommonTree;
  output = template;
}

/*
file	    :	function+ EOF;

function	:	'function' outArgs ID inArgs body 'end'?
            -> function( name={$ID.text}, in={$inArgs.st}, out={$outArgs.st} );
	
outArgs	  :	ID '=' 	-> ^(OUTARGS ID)
	        |	'[' idList ']' '=' 	-> ^(OUTARGS idList)
	        |		-> OUTARGS;
	

inArgs	  :	'(' idList? ')' -> ^(INARGS idList? )
	        |	 	-> INARGS ;	

body      : stat+;

stat      : matrix;

matrix    : ID -> ^(MATRIX ID)
          | '[' matrix (','? matrix)+ ']' -> ^(HORZCAT matrix+ )
//          | '[' matrix (';' matrix)+ ']' -> ^(VERTCAT matrix+ )
          ;
*/

matrix    : ^(MATRIX ID) -> matrix( el = {$ID.text} )
          | ^(HORZCAT m+=matrix+ ) -> horzcat( el = {$m} )
          | ^(VERTCAT m+=matrix+ ) -> vertcat( el = {$m} )
          ;

/*
catExpr   : ^(HORZ matrix+ ) -> 
          | ^(VERT matrix+ ) -> 
          ;
          */


