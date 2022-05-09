#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

struct simbol_table_variables
{
    char nume[1000];
    char tip[1000];
    int init;
    void *adresa;
};

struct simbol_table_functions
{
    char nume[1000];
    char tip[1000];
    int nr_parametrii;
    int init;
};

int poz_variable(char *nume, struct simbol_table_variables *tabela, int nr)
{
    int poz = -1;

    for (int i = 0; i <= nr; i++)
        if (strcmp(nume, tabela[i].nume) == 0)
            poz = i;

    return poz;
};



int add_variable(char *nume, char *tip, int poz, struct simbol_table_variables tabela[])
{

    if (poz_variable(nume, tabela, poz) != -1)
        return 0;

    struct simbol_table_variables c;

    if (strcmp(tip, "int") == 0)
        c.adresa = malloc(sizeof(int));
    else if (strcmp(tip, "char") == 0)
        c.adresa = malloc(sizeof(char));
    else if (strcmp(tip, "float") == 0)
        c.adresa = malloc(sizeof(float));
    else if (strcmp(tip, "string") == 0)
        c.adresa = malloc(1000 * sizeof(char));
    else if (strcmp(tip, "bool") == 0)
        c.adresa = malloc(sizeof(int));

    strcpy(c.nume, nume);
    strcpy(c.tip, tip);
    c.init = 0;
    tabela[poz] = c;

    return 1;
}

int set_value(char *nume, char *valoare, struct simbol_table_variables *tabela, int nr)
{
    int poz1 = poz_variable(nume, tabela, nr);

    if (poz1 == -1)
        return 0;

    char nume_aux1[1000];
    char tip_aux1[1000];

    for (int i = 0; i < 1000; i++)
    {
        nume_aux1[i] = '\0';
        tip_aux1[i] = '\0';
    }

    strcpy(nume_aux1, tabela[poz1].nume);
    strcpy(tip_aux1, tabela[poz1].tip);

    if ((valoare[0] >= 'a' && valoare[0] <= 'z') || (valoare[0] >= 'A' && valoare[0] <= 'Z'))
    {
        int poz2 = poz_variable(valoare, tabela, nr);

        if (poz2 == -1)
            return 0;

        char nume_aux2[1000];
        char tip_aux2[1000];

        for (int i = 0; i < 1000; i++)
        {
            nume_aux2[i] = '\0';
            tip_aux2[i] = '\0';
        }

        strcpy(nume_aux2, tabela[poz2].nume);
        strcpy(tip_aux2, tabela[poz2].tip);

        if (strcmp(tip_aux1, tip_aux2) == 0)
        {
            int dimensiune;
            if (strcmp(tip_aux1, "int") == 0)
                dimensiune = sizeof(int);

            if (strcmp(tip_aux1, "char") == 0)
                dimensiune = sizeof(char);

            if (strcmp(tip_aux1, "float") == 0)
                dimensiune = sizeof(float);

            if (strcmp(tip_aux1, "bool") == 0)
                dimensiune = sizeof(int);

            if (strcmp(tip_aux1, "string") == 0)
                strcpy(tabela[poz1].adresa, tabela[poz2].adresa);
            else
                memcpy(tabela[poz1].adresa, tabela[poz2].adresa, dimensiune);

            return 1;
        }
        return 0;
    }
    if (strcmp(tip_aux1, "int") == 0 && valoare[0] >= '0' && valoare[0] <= '9')
    {
        int valoareInt = atoi(valoare);
        memcpy(tabela[poz1].adresa, &valoareInt, sizeof(int));
        tabela[poz1].init = 1;

        return 1;
    }
    if (strcmp(tip_aux1, "bool") == 0 && valoare[0] >= '0' && valoare[0] <= '1' && valoare[1] == '\0')
    {
        int valoareInt = atoi(valoare);
        memcpy(tabela[poz1].adresa, &valoareInt, sizeof(int));
        tabela[poz1].init = 1;

        return 1;
    }
    if (strcmp(tip_aux1, "char") == 0 && valoare[0] == '\'' && valoare[2] == '\'')
    {
        char valoareChar = valoare[1];
        memcpy(tabela[poz1].adresa, &valoareChar, sizeof(char));
        tabela[poz1].init = 1;

        return 1;
    }
    if (strcmp(tip_aux1, "float") == 0 && valoare[0] >= '0' && valoare[0] <= '9')
    {
        float valoareFloat = atof(valoare);
        memcpy(tabela[poz1].adresa, &valoareFloat, sizeof(float));
        tabela[poz1].init = 1;

        return 1;
    }
    if (strcmp(tip_aux1, "string") == 0 && valoare[0] == '\"')
    {
        char *p = (char *)malloc(1000 * sizeof(char));
        for (int i = 0; i < strlen(valoare) - 2; i++)
            p[i] = valoare[i + 1];

        p[strlen(valoare) - 2] = '\0';

        strcpy(tabela[poz1].adresa, p);
        tabela[poz1].init = 1;

        return 1;
    }

    return 0;
}

void afisare_variabila(char *nume, struct simbol_table_variables *tabela, int nr,FILE *fp) 
{
	int poz = poz_variable(nume, tabela, nr);

	if (poz== -1) 
		return;
	
	if (tabela[poz].init == 0) 
        {
		fprintf(fp,"Variabila nu este Initializata!\n");
		return;
	}

	if (strcmp(tabela[poz].tip, "int") == 0) 
        {
		int valoareInt = *((int *)tabela[poz].adresa);
		fprintf(fp,"%s = %d\n", nume, valoareInt);
		return ;
	}
	if (strcmp(tabela[poz].tip, "char") == 0) 
        {
		char valoareChar = *((char *)tabela[poz].adresa);
		fprintf(fp,"%s = \'%c\'\n",nume, valoareChar);
		return ;
	}
	if (strcmp(tabela[poz].tip, "float") == 0) 
        {
     		float valoareFloat = *((float *)tabela[poz].adresa);
		fprintf(fp,"%s = %f\n", nume, valoareFloat);
		return ;	
	}
	if (strcmp(tabela[poz].tip, "string") == 0) 
        {
		fprintf(fp,"%s = \"%s\"\n", nume, (char *)tabela[poz].adresa);
		return ;
	}
    if (strcmp(tabela[poz].tip, "bool") == 0) 
        {
		int valoareBool = *((int *)tabela[poz].adresa);
		fprintf(fp,"%s = %d\n", nume, valoareBool);
		return ;
	}
	
}

       void add_function(char *numefunc, char *tipfunc, char *parametriifunc, int poz, struct simbol_table_functions *table, int rez, char s[])
    {
        struct simbol_table_functions t;
        strcpy(t.nume, numefunc);
        strcpy(t.tip, tipfunc);
        t.nr_parametrii=0;
        char *aux=(char *)malloc(sizeof(char)*1000);
        
        strcpy(aux, parametriifunc);
        char *p;
        p=strstr(aux, "int");
        if(p!=NULL)
        	{
        		strcpy(s, p);
        		strcat(s, " ");
        		t.nr_parametrii++;
        	}
        p=strstr(aux, "float");
        if(p!=NULL)
        	{
        		strcpy(s, p);
        		strcat(s, p);
        		t.nr_parametrii++;
        	}
        p=strstr(aux, "char");
        if(p!=NULL)
        	{
        		strcpy(s, p);
        		strcat(s, " ");
        		t.nr_parametrii++;
        	}
	
        t.init=rez;
        table[poz]=t;

    }

    /*int verif_func(char *numefunc, char *parametriifunc, struct simbol_table_functions *table_func, struct simbol_table_variables *table_var, int nr_func, int nr_var)
    {
        int poz_func=-1;
        for (int i=0; i<nr_func; i++)
        {
            if(strcmp(table_func[i].nume, numefunc)==0){
                poz_func=i;
                break;
            }
        }

        if(poz_func==-1){
            printf("Nu exista functia %s\n", numefunc);
            return -1;
        }

        int parametrii=0, ok=1, poz_var=-1;

        char tip_var[256], nume_var[256];
        char *aux=(char *)malloc(sizeof(char)*10001);

        strcpy(aux, parametriifunc);

        char *p=strtok(aux, " ");

        while(p)
        {
            if(parametrii>table_func[poz_func].nr_parametri)
                return -2;
            poz_var=poz_variable(p, table_var, nr_var);

            if(poz_var!=-1)
            {
                strcpy(nume_var, table_var->nume);
                strcpy(tip_var, table_var->tip);
                if(strcmp(tip_var, table_func[poz_func].tip_parametri[parametrii])!=0)
                    ok=0;
                
            }
            else
                 ok=-4;
            p=strtok(NULL, " ");
            parametrii++;

        }

        if(parametrii<table_func[poz_func].nr_parametri)
            return -1;

        return ok;
    };*/


