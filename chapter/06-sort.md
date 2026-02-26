# 1️⃣ sort

**`sort`** er en nyttig kommando som mest benyttes i kombinasjon med andre for sortering av output. Den grunnleggende **`sort`**-notasjonen er:

```bash
sort [options] [fil]
```

slik at denne også kan sortere tekstfiler etter ulike kriterier. Den sorterer i utgangspunktet alfabetisk etter første bokstav på linjer, men uten å endre filen. For å ta vare på resultatet, må man sende output til fil. Dette kan gjøres på to måter:

```bash
sort fil.txt  > sortert-fil.txt
sort fil.txt -o sortert-fil.txt
```

**`sort`** vil ikke skille på små og store bokstaver i de flest distribusjoner, men for å være sikker kan man inkludere opsjonen **`-f`**.

Skal man sortere etter numeriske verdier, benyttes opsjonen **`-n`**, evt. **`-h`** for tall i såkalt human readable form, hvor tall som f.eks. 999k og 1M kan sammenliknes.

Ofte vil man sortere etter innhold i bestemte kolonner. Da benyttes opsjon **`-k`**, så hvis man f.eks. har denne filen **fil.txt**:

```output
1 bente 3k
3 adam 4k
2 cathrine 2k
```

kan man naturlig gjøre følgende tre sorteringer:

```bash
sort -nk1 fil.txt
sort -k2  fil.txt
sort -hk3 fil.txt
```

**Merk**: **`-h`** forstår at f.eks. 247 er mindre enn 1k, men ikke at 2000 er større enn 1k. Stort sett går det bra om vi sortere output fra en skallkommando (fordi den ville skrevet 2k istedenfor 2000 ved bruk av human readable form), men for egenlagde data, må man huske på å gjøre om alle tall (eller ingen) til formen. Man må også skrive 2M og ikke 2000k osv. for at sorteringen skal bli riktig.

Opsjon **`-r`** reverserer sorteringen og **`-u`** fjerner duplikatlinjer. Følgende kommando sorterer en fillisting etter filstørrelse (5. kolonne) fra stor til liten:

```bash
l -lh | sort -hrk5
```

Dersom filen har en overskrift i første linje, vil vi gjerne ekskludere den i sorteringen. Det er flere måter å få til det på. Vet man hvor mange linjer filen har totalt (f.eks. 4), vil

```bash
tail -n3 fil.txt | grep -hk3
```

kunne benyttes. Evt. vil

```bash
wc -l < fil.txt
```

telle antall linjer i filen for deg, hvilket vi sammen kan kombinere ved

```bash
tail -n$(($(wc -l < fil.txt)-1)) fil.txt | sort -hk3
```

Ved **awk**-kommandoen, som forklares senere, kan det hele enklere gjøres ved:

```bash
awk 'NR!=1' < fil.txt | sort -hk3
```

Ønsker man å lage seg en ny sortert fil, med samme overskrift øverst, kan man gjøre:

```bash
head -n1 fil.txt > sortert-fil.txt;
awk 'NR!=1' < fil.txt | sort -hk3 >> sortert-fil.txt
```

Dermed får man også vist styrken av omdirigering i Linux.

Kolonner skilles fra hverandre ved blanke tegn. Om det er benyttet andre skilletegn, som komma eller kolon, benyttes opsjonen **`-t`** etterfulgt av tegnet, altså f.eks. **`-t,`**, eller **`-t:`   ** osv.