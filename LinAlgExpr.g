grammar LinAlgExpr;

options {
  output = AST;
  ASTLabelType = CommonTree;
  backtrack = true;
}

tokens {
  FILE;
  FUNCTIONS;
  SCRIPTS;

  FUNCTION;
  OUTARGS;
  INARGS;
  NAME;
  BODY;
  HORZCAT;
  VERTCAT;
  MATRIX;
  ASSIGN;
  CALL;
  CALLARGS;
  PARENS;
  UMINUS;
  // Transpose operators
  TRANS;  // .'
  CTRANS; // '
  // Library functions
  SVD;
  EIG;
  RAND;
  RANDN;
  SIZE;
}

file	    :	(function | body)+ EOF -> 
              ^(FILE ^(FUNCTIONS function*) 
                     ^(SCRIPTS ^(BODY body)*));

function	:	'function' outArgs? ID inArgs? body  'end'?
            -> ^(FUNCTION ^(NAME ID) inArgs outArgs ^(BODY body) );
	
outArgs	  :	ID 	'=' -> ^(OUTARGS ID)
	        |	'[' idList ']' '=' -> ^(OUTARGS idList)
	        ;
	
// Function definition argument list
inArgs	  :	'(' idList? ')' -> ^(INARGS idList? )
	        ;

// Function call argument list
callArgs  : '(' exprList? ')' -> ^(CALLARGS exprList? )
          ;

// Matrix constructor argument - single arg creates square matrix
ctorArgs  : expr (',' expr)+ -> ^(CALLARGS expr+ )
          | expr -> ^(CALLARGS expr expr )
          ;

body      : stat+;

stat      : outArgs expr ';'? -> ^(ASSIGN outArgs expr)
          | expr ';'? -> expr
          ;

expr      : mulExpr (('+'^|'-'^) mulExpr )*
          ;

mulExpr   : powExpr (('*'^|'/'^|'.*'^|'./'^|RDIVIDE^) powExpr)*
          ;

powExpr   : transExpr (('^'^|'.^'^) transExpr)*
          ;

transExpr : groupExpr (TRANS^ | CTRANS^)?
          ;
          

groupExpr : base_expr^
          | '(' expr ')' -> ^(PARENS expr) 
          ;

base_expr : vmatrix -> ^(MATRIX vmatrix)
          | ID callArgs -> ^(CALL ID callArgs)
          | libCall
          | '-' id_expr -> ^(UMINUS id_expr)
          | id_expr
          ;

id_expr   : ID 
          | NUMBER
          ;

vmatrix   : '[' hmatrix? (';' hmatrix)* ']' -> ^(VERTCAT hmatrix*)
          ;

hmatrix   : expr (','? expr)*  -> ^(HORZCAT expr+ )
          ;
          
libCall   : 'svd' callArgs -> ^(SVD callArgs)
          | 'eig' callArgs -> ^(EIG callArgs)
          | 'rand' '(' ctorArgs ')' -> ^(RAND ctorArgs)
          | 'randn' '(' ctorArgs ')' -> ^(RANDN ctorArgs)
          | 'dot' '(' a=expr ',' b=expr ')' -> ^('*' $a $b)
          | 'size' '(' expr ')' -> ^(SIZE expr)
          ;

/*          
catExpr   : (','? matrix )+ -> ^(HORZ matrix+ )
          | (';' matrix )+  -> ^(VERT matrix+ )
          ;
*/
idList	:	ID (',' ID)* -> ID+;

exprList: expr (',' expr)* -> expr+;

RDIVIDE : '\\';

TRANS   : '.\'';

CTRANS  : '\'';

ID  :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

NUMBER 
    : INT FLOAT_SUFFIX? 
    ;

fragment
INT :	'0'..'9'+
    ;

fragment

FLOAT_SUFFIX
    :   '.' ('0'..'9')+ EXPONENT?
    |    EXPONENT
    ;

// FLOAT
//    :   '.' ('0'..'9')+ EXPONENT?
//    ;

WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
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
