%{
#include <stdio.h>
#include <stdlib.h>
#include "simbol_table.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
int yylex();


struct simbol_table_variables tabela_Variabile[1000];
struct simbol_table_functions tabela_Functii[1000];
int nr_Variabile = 0;
int nr_Functii = 0;
int nr_parametri=0;
char sir[256];

typedef struct nod {
	int value;
        char* op;
        char* type;
	struct nod *left;
	struct nod *right;
} nod;

nod* buildAST(char* op, nod*left,nod*right,char*type,nod *nodcurent);
void printAST(nod *tree);
int evalAST(nod *tree);

%}

%union {
int intval;
float floatval;
char* strval;
struct nod* expr;
}

%token <strval> PRINT
%token <strval> RETURN
%token <strval> TIP
%token <strval> MAIN 
%token <strval> VECTOR 
%token <strval> CARACTER 
%token <strval> CARACTERE 
%token <strval> STRING
%token <strval> NUMAR 
%token <strval> INTEGER 
%token <strval> STRUCT 
%token <strval> ATRIBUIRE 
%token <strval> MARE 
%token <strval> MIC 
%token <strval> DIFERIT 
%token <strval> EGAL 
%token <strval> PRODUS 
%token <strval> IMPARTIRE 
%token <strval> PLUS 
%token <strval> MINUS 
%token <strval> SI 
%token <strval> SAU 
%token IF 
%token ELSE 
%token FOR 
%token WHILE 
%token <strval> STRCPY 
%token <strval> STRCMP
%token <strval> TRUE
%token <strval> FALSE

%type <strval> Lista_Parametrii
%type <strval> Apeluri_Functie
%type <expr> Expresie_INT


%right IF ELSE
%left '(' ')'
%left MINUS PLUS
%left PRODUS IMPARTIRE
%left ATRIBUIRE
%left UMINUS
%left SI
%left SAU
%left MARE MIC DIFERIT EGAL


%start progr

%%

progr: Declaratii Functie_main Definitii_Functii
     ;

Lista_Parametrii : TIP STRING { for (int i = 0; i < 1000; i++)  $$[i] = $1[i]; }
                 | Lista_Parametrii ',' TIP STRING
                  { 
                  char s[1000]; 
                   for (int i = 0; i < 1000; i++) 
                   s[i]='\0';
                  strcpy(s, $1); 
                  strcat(s, " "); 
                  strcat(s, $3); 
                  for (int i = 0; i < 1000; i++) 
                   $$[i] = s[i]; 
                  }
                 ;   

Declaratie : TIP STRING  
{ 

   if (add_variable($2, $1, nr_Variabile, tabela_Variabile) == 0)
  printf("Variabila %s a fost declarata deja! Linia: %d\n", $2, yylineno); 
   else nr_Variabile++;
}   
           | TIP VECTOR  
           
{
     int k=0;
     while($2[k]!='[')
      k++;           

     char aux[1000]; 
     
     for(int j=0;j<1000;j++)
       aux[j]='\0';
     
     strncpy(aux,$2,strlen($2)-1);
      
     
     int n=atoi(aux+k+1);
     
      
       for( int i=0;i<n;i++)  
   {
     char s[1000];
     
     for(int j=0;j<1000;j++)
     s[j]='\0';
     
     
     strncat(s,$2,k);
     strcat(s,"[");
     
     char str[1000];
     sprintf(str, "%d", i);
     
     strcat(s,str);
     strcat(s,"]");
  
     
   if (add_variable(s, $1, nr_Variabile, tabela_Variabile) == 0)
  printf("Variabila %s a fost declarata deja! Linia: %d\n", s, yylineno); 
   else nr_Variabile++;
  }
}  
	  | TIP STRING  '(' Lista_Parametrii ')' { add_function($2, $1, $4, nr_Functii++, tabela_Functii, 0, sir); }	
            
          |TIP STRING ATRIBUIRE Expresie_INT
          
            {
            
             if (add_variable($2, $1, nr_Variabile, tabela_Variabile) == 0)
  printf("Variabila %s a fost declarata deja! Linia: %d\n", $2, yylineno); 
   else nr_Variabile++;
   
              if(strcmp($1,"int")==0)
             {
             char aux[1000];
             sprintf(aux, "%d", evalAST($4));
                if (set_value($2, aux, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
                else printf("Eroare semantica la linia %d\n", yylineno);
              }
              else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $2, yylineno); 
            
            }
                     
                        
           | TIP STRING ATRIBUIRE CARACTERE
           {
           
           if (add_variable($2, $1, nr_Variabile, tabela_Variabile) == 0)
  printf("Variabila %s a fost declarata deja! Linia: %d\n", $2, yylineno); 
   else nr_Variabile++;
    
         
           if(strcmp($1,"string")==0)
           {
          if (set_value($2, $4, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
           else printf("Eroare semantica la linia %d\n", yylineno);
           }
          else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $2, yylineno);
          
           }
            
           | TIP STRING ATRIBUIRE NUMAR
          {
            if (add_variable($2, $1, nr_Variabile, tabela_Variabile) == 0)
  printf("Variabila %s a fost declarata deja! Linia: %d\n", $2, yylineno); 
   else nr_Variabile++;
   
          if(strcmp($1,"float")==0)
           {
          if (set_value($2, $4, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
           else printf("Eroare semantica la linia %d\n", yylineno);
           }
          else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $2, yylineno);
         }
           | TIP STRING  '('')'  
           | STRUCT STRING '{' Declaratii '}' 
           ;


  
    

      


Declaratii : Declaratie ';'
           | Declaratii Declaratie ';'
           ;

Functie_main : MAIN returneaza
             ;             

returneaza :'{' Lista_Instructiuni RETURN NUMAR ';' '}'
           |'{' Lista_Instructiuni RETURN INTEGER ';' '}'
             ;
                
Lista_Instructiuni :                    
                   | Lista_Instructiuni Instructiune ';' 
                   | Lista_Instructiuni Instructiune_Control
                   ;
                  
                  
Instructiune_Control : IF '(' Conditie ')' '{' Lista_Instructiuni '}'
                     
                     | IF '(' Conditie ')' '{' Lista_Instructiuni '}' ELSE '{' Lista_Instructiuni '}'
                     | FOR '(' Instructiune ';' Conditie ';' Lista_Instructiuni ')' '{' Lista_Instructiuni '}'
                     | WHILE '(' Conditie ')' '{' Lista_Instructiuni '}'
                     ;
                     
Conditie : Conditie MARE Conditie   
         | Conditie MIC Conditie        
         | Conditie DIFERIT Conditie
         | Conditie EGAL Conditie
         | Conditie SI Conditie
         | Conditie SAU Conditie
         | '('  Conditie ')'
         | STRING
         { 
            int poz = poz_variable($1, tabela_Variabile, nr_Variabile);
            if (poz== -1) {
              printf("Variabila %s nu a fost declarata! Linia: %d\n", $1, yylineno);
            }
         }
         | CARACTER
         | CARACTERE
         | INTEGER
         | NUMAR
         | TRUE
         | FALSE
         ;

Instructiune: 
            | STRING ATRIBUIRE Expresie_INT 
            {
            
            int poz=poz_variable($1,tabela_Variabile,nr_Variabile);
            if(poz==-1)
            {
              printf("Variabila %s nu a fost declarata! Linia: %d\n", $1, yylineno);
            }
            
            if(strcmp(tabela_Variabile[poz].tip,"int")==0)
            {
             char aux[1000];
             sprintf(aux, "%d", evalAST($3));
                if (set_value($1, aux, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
                else printf("Eroare semantica la linia %d\n", yylineno);
                printAST($3);
             }         
             else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $1, yylineno);    
             
            }
            | STRING ATRIBUIRE NUMAR
            {
            
            int poz=poz_variable($1,tabela_Variabile,nr_Variabile);
            if(poz==-1)
            {
              printf("Variabila %s nu a fost declarata! Linia: %d\n", $1, yylineno);
            }
            
            if(strcmp(tabela_Variabile[poz].tip,"float")==0)
            {
             
                if (set_value($1, $3, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
                else printf("Eroare semantica la linia %d\n", yylineno);
                
             }         
             else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $1, yylineno);    
             
            }
            | VECTOR ATRIBUIRE Expresie_INT
            {
            int poz=poz_variable($1,tabela_Variabile,nr_Variabile);
            if(poz==-1)
            {
              printf("Variabila %s nu a fost declarata! Linia: %d\n", $1, yylineno);
            }
            
              if(strcmp(tabela_Variabile[poz].tip,"int")==0)
            {
             char aux[1000];
             sprintf(aux, "%d", evalAST($3));
                if (set_value($1, aux, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
                else printf("Eroare semantica la linia %d\n", yylineno);
                printAST($3);
             }           
             else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $1, yylineno); 
                
            }
            
             | VECTOR ATRIBUIRE NUMAR
            {
            int poz=poz_variable($1,tabela_Variabile,nr_Variabile);
            if(poz==-1)
            {
              printf("Variabila %s nu a fost declarata! Linia: %d\n", $1, yylineno);
            }
            
              if(strcmp(tabela_Variabile[poz].tip,"float")==0)
            {
            
                if (set_value($1, $3, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
                else printf("Eroare semantica la linia %d\n", yylineno);
                
             }           
             else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $1, yylineno); 
                
            }
            
            | STRCPY '(' STRING ',' CARACTERE ')'
            {
            
             int poz=poz_variable($3,tabela_Variabile,nr_Variabile);
             
            if(poz==-1)
            {
              printf("Variabila %s nu a fost declarata! Linia: %d\n", $3, yylineno);
            }
            
            
             if(strcmp(tabela_Variabile[poz].tip,"string")==0)
              {
              if (set_value($3, $5, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
                else printf("Eroare semantica la linia %d\n", yylineno);
              }
            else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $3, yylineno); 
                
            }
            | STRCPY '(' STRING ',' STRING ')'
            {
              int poz1=poz_variable($3,tabela_Variabile,nr_Variabile);
             int poz2=poz_variable($5,tabela_Variabile,nr_Variabile);
            if(poz1==-1)
            {
              printf("Variabila %s nu a fost declarata! Linia: %d\n", $3, yylineno);
            }
            if(poz1==-1)
            {
              printf("Variabila %s nu a fost declarata! Linia: %d\n", $5, yylineno);
            }
            
                  if(strcmp(tabela_Variabile[poz1].tip,"string")==0||strcmp(tabela_Variabile[poz2].tip,"string")==0)
                {
              if (set_value($3, $5, tabela_Variabile, nr_Variabile) ==1) 
                    ; 
                else printf("Eroare semantica la linia %d\n", yylineno);
                }
                  else printf("Tipul variabilei %s este gresit ! Linia: %d\n", $3, yylineno); 
             
           
            }
            | STRING '(' Apeluri_Functie ')' 
            /*{
                int ok;
                if(ok=(verif_func($1, $3, tabela_Functii, tabela_Variabile, nr_Functii, nr_Variabile))==1)
                    printf("Functia de la linia %d este corecta.\n", yylineno);
                else
                    printf("Functia de la linia %d nu este corecta. Cod eroare: %d\n", yylineno, ok);
                if(ok==1)
                {
                    int p=-1;
                    for (int i=0; i<nr_Functii; i++)
                        if(strcmp(tabela_Functii[i].nume, $1)==0)
                            {
                                p=i;
                                break;
                            }  
            }
            }*/
            | STRING '.' STRING ATRIBUIRE NUMAR
            | STRING '.' STRING ATRIBUIRE STRING '.' STRING
            | STRING '.' STRING ATRIBUIRE STRING
            | STRING ATRIBUIRE STRING '.' STRING
            | Declaratie
            | PRINT '(' STRING ',' Expresie_INT ')' { printf("%s , %d\n",$3,evalAST($5)); printAST($5);}
            | PRINT '(' CARACTERE ',' Expresie_INT ')' { printf("%s , %d\n",$3,evalAST($5)); printAST($5);}
            | PRINT '(' CARACTER ',' Expresie_INT ')' { printf("%s , %d\n",$3,evalAST($5)); printAST($5);}
            ;
          

Expresie_INT: INTEGER { $$=buildAST($1,NULL,NULL,"NUMAR",$$); $$->value = atoi($1);}
        | Expresie_INT MINUS Expresie_INT {  $$=buildAST("-",$1,$3,"MINUS",$$);}
        | Expresie_INT IMPARTIRE Expresie_INT {  $$=buildAST("/",$1,$3,"IMPARTIRE",$$);} 
        | Expresie_INT PLUS Expresie_INT {  $$=buildAST("+",$1,$3,"PLUS",$$);}
        | Expresie_INT PRODUS Expresie_INT { $$=buildAST("*",$1,$3,"PRODUS",$$);}
        | MINUS Expresie_INT       %prec UMINUS { $$=$2; $$->value = -$2->value;}
        | '(' Expresie_INT ')' { $$ = $2;}
        | STRING
        {
         int poz = poz_variable($1, tabela_Variabile, nr_Variabile); 
           if (poz == -1) 
          printf("Variabila %s nu exista! Linia: %d\n", $1, yylineno);           
           else {
         
                     if (tabela_Variabile[poz].init == 0)              
                  printf("Variabila %s nu a fost intializata!\n", $1);                  
                   else  
                     {   
                     if (strcmp(tabela_Variabile[poz].tip, "int") == 0 )  
                          {     
                $$=buildAST($1,NULL,NULL,"IDENTIFIER",$$);
                $$->value = *((int *)(tabela_Variabile[poz].adresa)); 
                          }
                     else 
                     printf("Eroare! Expresie invalida semantic! Linia: %d\n",yylineno); 
                     }
                    
              }
               
        }
        | VECTOR
        {
         int poz = poz_variable($1, tabela_Variabile, nr_Variabile); 
           if (poz == -1) 
          printf("Variabila %s nu exista! Linia: %d\n", $1, yylineno);           
           else {
         
                     if (tabela_Variabile[poz].init == 0)              
                  printf("Variabila %s nu a fost intializata!\n", $1);                  
                   else  
                         {   
                     if (strcmp(tabela_Variabile[poz].tip, "int") == 0 )  
                          {     
                $$=buildAST($1,NULL,NULL,"IDENTIFIER",$$);
                $$->value = *((int *)(tabela_Variabile[poz].adresa)); 
                          }
                     else 
                     printf("Eroare! Expresie invalida semantic! Linia: %d\n",yylineno); 
                         }
                    
              }
               
        }
        | STRING '(' Apeluri_Functie ')'
        /*{
          int ok;
            if(ok=(verif_func($1, $3, tabela_Functii, tabela_Variabile, nr_Functii, nr_Variabile))==1)
                printf("Functia de la linia %d este corecta.\n", yylineno);
            else
                printf("Functia de la linia %d nu este corecta. Cod eroare: %d\n", yylineno, ok);
            if(ok==1)
            {
              int p=-1;
              for (int i=1; i<nr_Functii; i++)
                  if(strcmp(tabela_Functii[i].nume, $1)==0)
                  {
                    p=i;
                    break;
                  }
            }
        }*/
        ;

Apeluri_Functie : STRING
		{
			for(int i=0; i<2048; i++)
				$$[i]=$1[i];
		}
		|Apeluri_Functie ',' STRING 
		{ 
			char s[2048]; 
			strcpy(s, $1); 
			strcat(s, " "); 
			strcat(s, $3);
			for(int i=0; i<2048; i++)
				$$[i]=s[i];
		}
                | CARACTERE
                | CARACTER
                | NUMAR
                | Apeluri_Functie ',' NUMAR
                | Apeluri_Functie ',' CARACTER   
                | Apeluri_Functie ',' CARACTERE                
                | STRING '(' Apeluri_Functie ')'
                | Apeluri_Functie ',' STRING '(' Apeluri_Functie ')'
                ;
                 
Definitii_Functii : 
                  | Definitii_Functii TIP STRING '(' Lista_Parametrii ')' returneaza
                  ; 
                  
%%

int yyerror(char * s)
{
printf("eroare: %s la linia:%d\n",s,yylineno);
}


int main(int argc, char* argv[])
{
        yyin=fopen( "test.txt" , "r");
        
        yyparse(); 
        
         FILE *fp = fopen("symbol_table.txt", "w");
        for (int i = 0; i < nr_Variabile; i++) 
        {     
                fprintf(fp,"Nume: %s\n", tabela_Variabile[i].nume);
                fprintf(fp,"Tip: %s\n", tabela_Variabile[i].tip);
                afisare_variabila(tabela_Variabile[i].nume, tabela_Variabile, nr_Variabile,fp);
                fprintf(fp,"\n");
        }
              
        FILE *f_func = fopen("symbol_table_functions.txt", "w");
        for (int i=0; i<nr_Functii; i++)
        {
        
        	for (int i=0; i<nr_Functii; i++)
               {
               	fprintf(f_func, "Nume: %s\n", tabela_Functii[i].nume);
        	fprintf(f_func, "Tip: %s\n", tabela_Functii[i].tip);
        	fprintf(f_func, "Nr_Parametri: %d\n", tabela_Functii[i].nr_parametrii);
        	fprintf(f_func, "Tip_Parametri: %s\n", sir);
        	fprintf(f_func, "\n");
               }
        }
} 

nod* buildAST (char *op,nod *left,nod*right,char*type,nod *nodcurent)
{
 nod *newnode = (nod *)malloc(sizeof(nod));
 char *newop = (char *)malloc(strlen(op)+1);
 char *newtype = (char *)malloc(strlen(type)+1);
 strcpy(newop, op);
 strcpy(newtype,type);
 newnode->left = left;
 newnode->right = right;
 newnode->op = newop;
 newnode->type = newtype;
 newnode->value=nodcurent->value;
 return(newnode); 
}

void printAST(nod *tree)
{
 
 if (tree->left || tree->right)
 printf("(");
 printf(" %s ", tree->op);
 if (tree->left)
 printAST(tree->left);
 if (tree->right)
 printAST(tree->right);
 if (tree->left || tree->right)
 printf(")");
} 

int evalAST(nod *tree)
{

 if(strcmp(tree->type,"NUMAR")==0)
        return tree->value;
        
      if(strcmp(tree->type,"IDENTIFIER")==0)
        return tree->value; 
         
          if(strcmp(tree->type,"PLUS")==0)
     {
        int a = evalAST(tree->left);
        int b = evalAST(tree->right);

        return a + b;
     }
     
     if(strcmp(tree->type,"PRODUS")==0) 
     {
        int a = evalAST(tree->left);
        int b = evalAST(tree->right);

        return a * b;
     }
      if(strcmp(tree->type,"MINUS")==0)
     {
        int a = evalAST(tree->left);
        int b = evalAST(tree->right);

        return a - b;
     }
    if(strcmp(tree->type,"IMPARTIRE")==0)
     {
        int a = evalAST(tree->left);
        int b = evalAST(tree->right);

        return a / b;
     }
  
}
