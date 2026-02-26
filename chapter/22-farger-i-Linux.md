## Farger i Linux

Kodingen av farger i Linux fremkommer her av tabell og eksempler. Utgangspunktet er at når Linux (i relevante situasjoner) møter kombinasjonen **`ESC[`** i en tekststreng, vil etterfølgende tallkoder fram til avsluttende karakter m angi farge og fonteffekt-instruksjoner etter bestemte regler/verdier. Kodingen er i rekkefølge **`FG;BG;Effekt`**, men de to siste trengs ikke å angis (om standardverdier ønskes).

Det første eksempelet benytter **`echo -e`**. Opsjonen sørger for at **`\e`** tolkes som ESC i strenger. Andre kommandoer kan kreve angivelse av ESC på andre måter, f.eks. **`awk`**.

Forgrunns- og bakgrunnsfarge, samt fonteffekt, angis med tallkoder iht. tabell og liste under.

For **`echo -e`** betyr det at

```bash
echo -e "\e[33;104;1mDette er tekst.\e[0m"
``` 

skriver ut **Dette er tekst.**  med gul tekst (FG=33) på blå bakgrunn (BG=104) i fet skrift (EFFEKT=1). Teksthalen **`\e[0m`** sørger (høflig) for at det etterfølgende får standardverdier.

Det er definert tallverdier for flere fonteffekt. (Noen skrur av definerte effekter også, som blinking.) Ikke all støttes i alle installasjoner. Hos meg virker i det minst de ovennevnte.

Merk at verdi 0 betyr å skru av attributter, slik at man f.eks. må angi 1 som bakgrunnsfarge når man ønsker en forgrunnsfarge forskjellig fra standard (og ikke 0), og man bør angi 22 som font-effekt når man ønsker normal effekt (og ikke 0).

ESC representeres altså ved **`\e`** ved bruk av **`echo -e`** , mens det er **`\033`** f.eks. for **`awk`** (dvs. tresifret oktal angivelse av ASCII-karakter nr. 27 ESC). Begge prefikser representerer altså **ESC[**, men på to måter.

Slik kan **`awk`** farge en **`ls`**-output tilsvarende fet og blå-gul:

```bash
ls -1 | awk '{print "\033[33;104;1m", $0, "\033[0m"}'
```

En heksadesimal angivelse av ESC er forresten også mulig i **`awk`**.