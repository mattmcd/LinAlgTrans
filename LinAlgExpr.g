grammar LinAlgExpr;

options {
  output = AST;
  ASTLabelType = CommonTree;
  backtrack = true;
}

tokens {
  FUNCTION;
  OUTARGS;
  INARGS;
  NAME;
  HORZCAT;
  VERTCAT;
  MATRIX;
  ASSIGN;
}

file	    :	function+ EOF;

function	:	'function' outArgs? ID inArgs body 'end'?
            -> ^(FUNCTION ^(NAME ID) inArgs outArgs body );
	
outArgs	  :	ID 	-> ^(OUTARGS ID)
	        |	'[' idList ']' 	-> ^(OUTARGS idList)
	        ;
	

inArgs	  :	'(' idList? ')' -> ^(INARGS idList? )
	        |	 	-> INARGS ;	

body      : stat+;

stat      : outArgs '=' expr -> ^(ASSIGN outArgs expr)
          | expr;

expr      : e0;
e0        : e1;
e1        : base_expr (RDIVIDE^ base_expr)*;

base_expr : vmatrix -> ^(MATRIX vmatrix)
          | ID
          ;

vmatrix   : '[' hmatrix? (';' hmatrix)* ']' -> ^(VERTCAT hmatrix*)
          ;

hmatrix   : expr (','? expr)*  -> ^(HORZCAT expr+ )
          ;
          
/*          
catExpr   : (','? matrix )+ -> ^(HORZ matrix+ )
          | (';' matrix )+  -> ^(VERT matrix+ )
          ;
*/
idList	:	ID (',' ID)* -> ID+;

RDIVIDE : '\\';

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