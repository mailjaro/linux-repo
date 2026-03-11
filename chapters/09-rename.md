# ✏️ rename

For å navnendre eller flytte en større mengde filer, kan man benytte `mv` i mer eller mindre smarte skripts – eller man kan benytte `rename` (som typisk må installeres ved `sudo apt install rename`). Den utnytter `sed`-aktige mønstre i erstatninger av filnavn.

Det følgende endrer f.eks. alle filendelser **.jpeg** til .**jpg**:

```bash
rename 's/.jpeg/.jpg/' *.jpeg
```

Det neste navnendrer noen C-filer

```bash
rename 's/config/cfg/' *.c
```

slik at f.eks. **run-config-2.c** blir til **run-cfg-2.c**, og **mainconfig.c** blir til **maincfg.**c osv.

For neste eksempel, la oss først opprette tre filer: **fil1.txt**, **fil2.txt** og **fil3.txt**. Det kan kjapt gjøres ved:

```bash
touch fil{1..3}.txt
```

```output
fil1.txt
fil2.txt
fil3.txt
```

Hvis vi ønsker å ende navnene til **fil_001.txt**, **fil_002.txt** og **fil_003.txt**, gjør:

```bash
rename 's/^fil([0-9]+)/fil-00\1/' fil*
```

```output
fil-001.txt
fil-002.txt
fil-003.txt
```

Videre har man ofte overført noen filer fra Windows med æ-er, ø-er og å-er, samt mellomrom, parenteser og annet som er upraktisk i Linux. Vi kan f.eks. ha en hærskare av dokumenter som dette:

```output
’Lønnsslipp 1.pdf’
’Logg kjørebok.ods’
’RF 1306 Kontakt Skatteetaten (næringsdrivende).pdf’
’Stiftelse av aksjeselskap.pdf’
```

Det kan for det første se ut som `'` er en del av disse filnavnene, men det er ikke tilfelle. Linux rapporterer bare filer med slike spesielle tegn i navnet på denne måten. Vi kan bl.a. søke etter filene på vanlig måte (uten å ta hensyn til apostrof).

Men vi kan ønske å overføre disse navnene til vanlig Linux-filnavn. Følgende ordner dette for alle filer (og kataloger) på gjeldende katalog (`opsjon -v` informer underveis om hvilke filer som endrer):

```bash
rename -v 's/æ/ae/' *		# Erstatter alle æ med ae
rename -v 's/ø/oe/' *		# Erstatter alle ø med oe
rename -v 's/å/aa/' *		# Erstatter alle å med aa
rename -v 's/\(//' *		# Fjerner venstreparenteser
rename -v 's/\)//' *		# Fjerner høyreparenteser
rename -v 's/ /-/'g *		# Erstatter alle blanke med -
```

```output
Loennsslipp-1.pdf
Logg-kjoerebok.ods
RF-1306-Kontakt-Skatteetaten-naeringsdrivende.pdf
Stiftelse-av-aksjeselskap.pdf
```

Hvilket i Linux ser mye bedre ut.

Ønsker man å samle flere `rename`-kommandoer i én linje, kan man f.eks. fjerne både venstre og høyreparenteser ved:

```bash
rename -v 's/\(//; s/\)//' *
```

Tilsvarende kan vi erstatte våre norske tegn samlet ved:

```bash
rename -v 's/æ/ae/; s/ø/ae/; s/å/aa/' *
```