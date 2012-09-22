grammar LinAlgExpr;

options {
  output = AST;
  ASTLabelType = CommonTree;
}

tokens {
  FUNCTION;
  OUTARGS;
  INARGS;
  NAME;
  HORZCAT;
  VERTCAT;
  /*
  CAT;
  HORZ;
  VERT;
  */
  MATRIX;
}

file	    :	function+ EOF;

function	:	'function' outArgs ID inArgs body 'end'?
            -> ^(FUNCTION ^(NAME ID) inArgs outArgs body );
	
outArgs	  :	ID '=' 	-> ^(OUTARGS ID)
	        |	'[' idList ']' '=' 	-> ^(OUTARGS idList)
	        |		-> OUTARGS;
	

inArgs	  :	'(' idList? ')' -> ^(INARGS idList? )
	        |	 	-> INARGS ;	

body      : stat+;

stat      : matrix;

matrix    : ID -> ^(MATRIX ID)
          | '[' matrix (catOp matrix)+ ']' -> ^(catOp matrix+ )
          ;
          
catOp     : ','? -> HORZCAT
          | ';'  -> VERTCAT
          ;
/*          
catExpr   : (','? matrix )+ -> ^(HORZ matrix+ )
          | (';' matrix )+  -> ^(VERT matrix+ )
          ;
*/
idList	:	ID (',' ID)* -> ID+;

ID  :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

INT :	'0'..'9'+
    ;

FLOAT
    :   ('0'..'9')+ '.' ('0'..'9')* EXPONENT?
    |   '.' ('0'..'9')+ EXPONENT?
    |   ('0'..'9')+ EXPONENT
    ;

WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;

STRING
    :  '\'' ( ESC_SEQ | ~('\\'|'\'') )* '\''
    ;

fragment
EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;
