%{ /* Codigo C */
  #include <stdlib.h>
  #include <malloc.h>
  #include <string.h>
  #include "calc.tab.h"
%}

DIGITO [0-9]
LETRA [A-Za-z]

%%


"<"				return(MENORQUE);
">"				return(MAYORQUE);
"<="				return(MENORIGUAL);
">="				return(MAYORIGUAL);
"||"				return(O);
"&&"				return(Y);
"!="				return(DIFERENTE);
"=="				return(IGUAL);

"("|")"				return (yytext[0]);

{DIGITO}+                       { yylval.valor_entero = atoi(yytext);
                                  return (CONSTANTE_ENTERA);
                                }

{DIGITO}+\.{DIGITO}+            { yylval.valor_real = atof(yytext);
                                  return (CONSTANTE_REAL);
                                }

sen|SEN		                return (SENO);
cos|COS                  	return (COSENO);
tan|TAN         	        return (TANGENTE);
if|IF		                return (IF);
then|THEN	                return (THEN);
"?"				return (THEN);
else|ELSE	                return (ELSE);
":"				return (ELSE);

"+"|"-"|"*"|"/"|"="|"^"         return (yytext[0]);

"\n"                            return (yytext[0]);

{LETRA}({LETRA}|_)*             { yylval.texto = (char *) malloc (strlen(yytext) + 1);
                                  strcpy(yylval.texto, yytext);
                                  return (IDENTIFICADOR);
                                }

.                               ;

%%
