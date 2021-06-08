%lex
%%

\s+     /* skip whitespace */
\d+     return 'NUMBER'
\w+     return 'KEY'
":"		return 'COLON'
\".+?\"|\'.+?\'  return 'STRING'
"{"		return 'BEGIN_OBJ'
"}"		return 'END_OBJ'
"["     return 'BEGIN_ARR'
"]"     return 'END_ARR'
","     return 'COMMA'
<<EOF>>	return 'EOF'
.		return 'INVALID'

/lex

%start experssions
%%

experssions
	: BEGIN_OBJ kvs END_OBJ EOF
		{ console.log("result: \n",$2); }
	;

kvs 
	: kvs COMMA kv
		{ $$ = Object.assign($1, $3); }
	| kv 
		{ $$ = $1; }
	;

kv
	: KEY COLON NUMBER
		{ const o = {}; o[$1] = $3 ; $$ = o; }
	| KEY COLON STRING
		{ const o = {}; o[$1] = $3 ; $$ = o; }
	| KEY COLON	obj 
		{ const o = {}; o[$1] = $3 ; $$ = o; }
	| KEY COLON arr
		{ const o = {}; o[$1] = $3 ; $$ = o; }
	;

obj 
	: BEGIN_OBJ kvs END_OBJ
  		{ $$ = $2; } 
	;

arr
	: BEGIN_ARR items END_ARR
		{ $$ = $2; }
	| BEGIN_ARR items COMMA END_ARR
		{ $$ = $2; }
	| BEGIN_ARR objs END_ARR
		{ $$ = $2; }
	| BEGIN_ARR objs COMMA END_ARR
		{ $$ = $2; }	
	;

items 
	: items COMMA item 
		{ $$ = $1.concat($3); }
	| item
		{ $$ = [$1]; }
	;

item
	: NUMBER
		{ $$ = $1; }
	| STRING
		{ $$ = $1; }
	;

objs 
	: objs COMMA obj 
		{ $$ = $1.concat($3); }
	| obj
		{ $$ = [$1]; }
	;	