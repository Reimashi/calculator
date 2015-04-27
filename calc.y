%{ /* Codigo C */
#include <stdio.h>
#include <math.h>
#include "diccionario.h"
DICCIONARIO diccionario; /* variable global para el diccionario */
%}

/* Declaraciones de BISON */
%union {
  int valor_entero;
  double valor_real;
  char * texto;
}

%token <valor_real> CONSTANTE_REAL
%token <valor_entero> CONSTANTE_ENTERA
%token <texto> IDENTIFICADOR
%token <texto> SENO
%token <texto> COSENO
%token <texto> TANGENTE
%token <texto> MENORQUE
%token <texto> MAYORQUE
%token <texto> MENORIGUAL
%token <texto> MAYORIGUAL
%token <texto> O
%token <texto> Y
%token <texto> DIFERENTE
%token <texto> IGUAL
%token <texto> IF
%token <texto> THEN
%token <texto> ELSE


%left DIFERENTE MAYORQUE MENORQUE MAYORIGUAL MENORIGUAL Y O
%left '-' '+'
%left '*' '/'
%right '^'

%type <valor_real> expresion
%type <valor_entero> condicion

%%

/* Gramatica */
lineas: /* cadena vacia */
  | lineas linea
;

linea: '\n'
  | IDENTIFICADOR '=' expresion '\n' { insertar_diccionario(&diccionario, $1, $3); }
  | expresion '\n'                   { printf ("resultado: %f\n", $1); }
  | error '\n'                       { yyerrok;}
;

expresion: CONSTANTE_REAL            { $$ = $1; }
  | CONSTANTE_ENTERA                 { $$ = $1; }
  | IDENTIFICADOR                    { ENTRADA * entrada = buscar_diccionario(&diccionario,$1);
                                       if (entrada != NULL) { $$ = entrada->valor; }
                                       else { printf("ERROR: variable %s no definida\n", $1); $$ = 0; } }
  | '(' expresion ')'                { $$ = $2; }
  | expresion '+' expresion          { $$ = $1 + $3; }
  | expresion '-' expresion          { $$ = $1 - $3; }
  | expresion '*' expresion          { $$ = $1 * $3; }
  | expresion '/' expresion          { $$ = $1 / $3; }
  | expresion '^' expresion          { $$ = pow($1, $3); }
  | expresion MENORQUE expresion     { if ($1 < $3) { $$ = 1.0; } else { $$ = 0.0; } }
  | expresion MAYORQUE expresion     { if ($1 > $3) { $$ = 1.0; } else { $$ = 0.0; } }
  | expresion MAYORIGUAL expresion   { if ($1 >= $3) { $$ = 1.0; } else { $$ = 0.0; } }
  | expresion MENORIGUAL expresion   { if ($1 <= $3) { $$ = 1.0; } else { $$ = 0.0; } }
  | expresion DIFERENTE expresion    { if ($1 != $3) { $$ = 1.0; } else { $$ = 0.0; } }
  | expresion IGUAL expresion        { if ($1 == $3) { $$ = 1.0; } else { $$ = 0.0; } }
  | SENO '(' expresion ')'           { $$ = sin($3); }
  | COSENO '(' expresion ')'         { $$ = cos($3); }
  | TANGENTE '(' expresion ')'       { $$ = tan($3); }
  | '-' expresion                    { $$ = -$2; }
  | condicion THEN expresion ELSE expresion             { if($1) { $$ = $3; } else { $$ = $5; } }
;

condicion: expresion { if ($1) { $$ = 1.0; } else { $$ = 0.0; } }
  | condicion Y condicion   { if ($1 && $3) { $$ = 1.0; } else { $$ = 0.0; } }
  | condicion O condicion   { if ($1 || $3) { $$ = 1.0; } else { $$ = 0.0; } }
;

%%

int main(int argc, char** argv) {
  inicializar_diccionario(&diccionario);
  yyparse();
  liberar_diccionario(&diccionario);
}

yyerror (char *s) { printf ("%s\n", s); }

int yywrap() { return 1; }
