# 1️⃣ sort

`sort` er en nyttig kommando som kanskje mest benyttes i kombinasjon med andre for sortering av output. Den grunnleggende `sort`-notasjonen er:

```bash
sort [options] [fil]
```

slik at denne også kan sortere tekstfiler etter ulike kriterier. Den sorterer i utgangspunktet alfabetisk etter første bokstav på linjer, men uten å endre filen. For å ta vare på resultatet, må man sende output til fil. Dette kan gjøres på to måter:

```bash
sort fil.txt  > sortert-fil.txt
sort fil.txt -o sortert-fil.txt
```

`sort` vil ikke skille på små og store bokstaver i de flest distribusjoner, men for å være sikker kan man inkludere opsjonen `-f`.

Skal man sortere etter numeriske verdier, benyttes opsjonen `-n`, evt. `-h` for tall i såkalt *human readable form*, hvor tall som f.eks. 999k og 1M kan sammenliknes. Opsjon `-r` reverserer sorteringen og `-u` fjerner eventuelle duplikatlinjer.

**MERK:** `sort` har en svakhet i tolking av tall på *human readable form*. Dersom den blandes med tall som ikke er omgjort, kan `sort` sortere feil. F.eks. gir

```bash
printf "4k\n8000\n1M" | sort -h -r
```

sorteringen

```output
1M
4k
8000
```

som jo er matematisk feil. Derimot gir

```bash
printf "4k\n8k\n1M" | sort -h -r
```

korrekt output:

```output
1M
8k
4k
```

Opsjonen `-M` sørger for månedssortering, altså sortering etter måneder og ikke alfabetisk. Vanlig sortering av

```output
mar
feb
jan
```

ville f.eks. gitt rekkefølgen **feb-jan-mar**. Men `-M`.opsjonen forstår flere (engelske) månedformater og ville gitt det riktige:

```bash
printf "mar\nfeb\njan\n" | sort -M
```

```output
jan
feb
mar
```

Mange filer og flere kommando-outputs grupperer data i kolonner. For å sortere etter kolonner benyttes opsjon `-k` etterfulgt av kolonnenummer. Dvs, om man har denne filen **fil.txt**:

```output
1 bente 3k
3 adam 4k
2 cathrine 2k
```

kan man

1 - sorterer alfabetisk etter andre kolonne ved:


```bash
sort -k2  fil.txt
```

```output
3 adam 4k
1 bente 3k
2 cathrine 2k
```

2 - sortere numerisk etter tredje kolonne ved: 

```bash
sort -hk3 fil.txt
```

```output
2 cathrine 2k
1 bente 3k
3 adam 4k
```

3 - sortere omvendt numerisk etter første kolonne ved:

```bash
sort -nk1r fil.txt
```

```output
3 adam 4k
2 cathrine 2k
1 bente 3k
```

Kolonner skilles fra hverandre ved blanke tegn. Om det er benyttet andre skilletegn, som komma eller kolon, benyttes opsjonen `-t` etterfulgt av tegnet, altså f.eks. `-t,`, eller `-t:` osv.

Sortering av output fra en shell-commando er som nevnt en mye brukt anvendelse. Den følgende sortere en full fillisting etter filstørrelse (5. kolonne) fra stor til liten:

```bash
ls -lh | sort -k5 -h -r
```

**Merk:** Vi har tidligere nevnt at det er tryggeste å ikke slå sammen opsjoner, men å holde dem separat. I dette tilfellet ville  `-k5hr` faktisk *ikke* reversert sorteringen på tross av `-r`.

Det tryggeste her ville vært å skrive

```bash
ls -lh | sort -k5,5h -h -r
```

siden også `-k5,5h` kun sorterer etter 5. kolonne alene, mens `-k5 -h` egentlig sorterer fra 5. kolonne og ut linjen.

Her er et annet eksempel som finner de første prosessene som er startet:

```bash
ps -ef | sort -k2 -n | head
```

```output
UID     PID    PPID  C STIME TTY    TIME CMD
root      1       0  0 Feb25 ?      00:00:11 ...
root      2       0  0 Feb25 ?      00:00:00 ...
root      3       2  0 Feb25 ?      00:00:00 ...
root      4       2  0 Feb25 ?      00:00:00 ...
root      5       2  0 Feb25 ?      00:00:00 ...
root      6       2  0 Feb25 ?      00:00:00 ...
root      7       2  0 Feb25 ?      00:00:00 ...
root      8       2  0 Feb25 ?      00:00:00 ...
root     10       2  0 Feb25 ?      00:00:00 ...
```

Ofte har filer og output (som ovennevte) en overskrift i første linje,som man normalt vil ekskludere i sorteringen. Det er flere måter å få til det på. Anta vi har følgende fil

```output
NR NAVN      VERDI
1  bente     3k
3  adam      4k
2  cathrine  2k
```

og ønsker å sortere stigende etter verdi-kolonnen. Da kan vi gjøre:

```bash
{ head -n1 fil.txt; tail -n +2 fil.txt | sort -k3,3h; }
```

```output
NR NAVN      VERDI
2  cathrine  2k
1  bente     3k
3  adam      4k
```

Her gir`head -n1 fil.txt` overskriftsraden og `tail -n +2 fil.txt` resten av filen, og sistnevnte sorteres.

En alternativ løsning er følgende, som utnytter `awk`-kommandoen vi skal komme tilbake til.

```bash
awk 'NR==1{print; next} {print | "sort -k3,3h"}' fil.txt
```

```output
NR NAVN      VERDI
2  cathrine  2k
1  bente     3k
3  adam      4k

```
