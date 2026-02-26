# 🔎 find og fd

`find` er gammel og god Linux-kommando, én av Linux-hverdagens virkelige arbeidshester. Den finner filer, kataloger og tilsvarende etter ulike søkekriterer, og kan også utføre bestemt handlinger på disse. Den er en selvsagt del av en hver Linux-distribusjon.

Men det fins etter hvert også en nyere variant som er lettere å bruke, vel så kjapp og (for det meste) har de samme mulighetene. Denne heter `fd`, og vi skal ta for oss begge. Fordelene med den siste er ikke minst at den ved default aksepterer såkalt regulære uttrykk (regex), mens `find` for dette krever opsjoner og en syntaks som er vanskelig å huske.

## 🔎 find - grunnleggende eksempler

Den generelle syntaksen er:

```bash
find [options] [path...] [expression]
```

Følgende finner f.eks. alle vanlige filer på gjeldende katalog og alle underkataloger hvis navn slutter på .pdf:

```bash
find . -type f -name *.pdf
```

Uttrykket `-type f` etterspør regulære filer. Opsjon `-type d` ville søkt etter kataloger. Droppes typeangivelsen, returneres både filer og kataloger. Gjeldende katalog (.) er angitt som startsted for søket.

Det følgende søker etter PNG-filer på ~/Pictures:

```bash
find ~/Pictures -name *.png
```

Merk: Uttrykket `*.png` tolkes som en tekststreng, og vi kunne godt ha skrevet både `'*.png'` og `"*.png"`. Begge typer anførselstegn omslutter strenger i Linux. Dette (og forskjellene) vil bli utbrodert i skall-kapittelet. Inntil videre kan vi si vi anførselstegn må inkluderes når en tekststreng omfatter flere ordgrupper.

`-name` angir case-sensitivt søk. Ønsker man ikke å skille på små og store bokstaver, benytt `-iname`.

Følgende eksempel finner altså alle JPG-filer (under ulike ulike navnkonvensjoner) i gjeldende filtre:

```bash
find . -iname *.jpg -or -iname *.jpeg
```

Vi ser også bruk av logisk operator på uttrykk her, nærmere bestemt `-or`. Andre tilgjengelige logiske operatorer er `-and` og `-not`.

Ofte har man å gjøre med store filtrær, og det kan være ønskelig å begrense hvor dypt find skal søke. `-maxdepth` kan da benyttes. `-maxdepth 1` begrenser seg til angitt startkatalog, mens `-maxdepth 2` søker gjennom startkatalog og første nivå av underkataloger osv. Følgende eksemplifiserer notasjonen:

```bash
find . -maxdepth 3 -name *.txt
```

En annen måte å begrense find på, er å droppe uaktuelle subtrær. For dette fins opsjonen `-prune`. Følgende find-kommando finner eksempelvis alle filer Python-filer under gjeldende katalog, unntatt i katalog bin:

```bash
find . -type d -name bin -prune -o -type f -name *.py -print
```

Under finner man tilsvarende alle Python-filer under gjeldende katalog, unntatt i katalog `.vscode` og katalog `.config`:

```bash
find . -type d \( -name .vscode -o -name .config \) -prune -o -name *.py -print
```

Under finnes alle filer som er endret de siste 3 minuttene på hjemmekatalog og i alle dens underkataloger, unntatt under katalog snap:

```bash
find $HOME -type d -name snap -prune -o -type f -mmin -3 -print
```

Merk: `-print`, som vi la på i de tre siste eksemplene, er egentlig en aksjon (som vi snart skal se). Den er til og med standardaksjon, som vi derfor normalt kunne droppet. Men akkurat her inkluderes den fordi den (viser det seg) ikke skriver ut navn på kataloger som har Python-filer.

Andre ganger vil søkekriterier dreie seg tidspunkter for siste endring. Eksemplene

```bash
find . -type f -mmin -30
find . -type f -mtime -2
```

finner filer modifisert for mindre enn hhv. 30 minutter og 2 dager siden (dvs. yngre enn dette). Hadde man skrevet +30 og +2, ville man fått returnert filer som sist var modifisert hhv. likt eller mer enn 30 minutter og 2 dager siden (dvs. eldre enn dette). Uten pluss og minus mener man nøyaktig tidsangivelse. Man kan også bytte om før (-) og etter (+) med å inkludere `-not` eller `!`, altså det følgende er det samme:

```bash
find . -type f -mtime -1
find . -type f -not -mtime +1
find . -type f ! -mtime +1
```

Ønsker man å finne filer ut fra et tidsintervall, kan man benytte `-and`, altså f.eks.

```bash
find . -type f -mtime +2 -and -mtime -3
```

Var man interessert i filer som bare var aksessert før eller etter slike tider, kunne man tilsvarende benyttet hhv. `-amin` og `-atime`.

Merk også at det er en liten forskjell mellom en filmodifisering og en filforandring (*change*). Det første er en reell redigering av filinnhold, mens det siste kun er en endring av filens tidsdata, som jo kan oppdateres med `touch`. For søk iht. dette kunne man benyttet hhv. `-cmin` og `-ctime`.

Søkekriterier kan også handle om rettigheter og eierskap. En fil har rettigheter iht.

```output
r = read
w = write
x = execute
```

for hhv. eier, gruppe og andre. (For kataloger er forskjellen at x betyr rettighet til å foreta cd til, samt å passere den på vei til underkataloger.) I filen under har f.eks. eier alle rettigheter, gruppen lese- og skriverettigheter, mens andre kun har leserettigheter.

```output
-rwxrw-r-- 1 jan jan   15 Feb  5 12:46 fil-1
```

De ulike rettighetene kan settes ved `chmod`-kommandoen og søkes opp ved find, gjerne ved hjelp av numeriske verdier iht.:

```output
7 = rwx
6 = rw-
5 = r-x
4 = r--
3 = -wx
2 = -w-
1 = --x
0 = -
```

Her ser vi (kun for å illustrere tallverdiene) tre filer med rettigheter satt f.eks. av `chmod` med koder 764, 241 og 350 hhv.:

```output
-rwxrw-r-- 1 jan jan   15 Feb  5 12:46 fil-1
--w-r----x 1 jan jan   15 Feb  5 12:47 fil-2
-rwxr-x--- 1 jan jan   15 Feb  5 12:52 fil-3
```

Følgende kommander finner hhv. fil 1, 2 eller 3 her:

```bash
find . -type f -perm 764
find . -type f -perm 241
find . -type f -perm 350
```

Man kan også bruke bokstaver `u`, `g` og `o` for user, group og other, og angi søk som:

```bash
find . -perm -u+w
find . -perm -g+r,o+x
find . -perm -u+w,g+x
```

Her finnes hhv. filer bruker har skriverettigheter til, er lesbare for gruppen og kjørbare av andre, samt filer som skrivbare av eier og eksekverbare for gruppen.

Man kan også velge å bruke skråstrek eller ikke foran perm-koden. Ved å bruke dette er det nok at én av kriteriene for eier, gruppe eller andre matcher. Følgende kommandoer finner eksempelvis filer som er eksekverbare for en eller annen, det være seg eier, gruppe eller andre:

```bash
find . -type f -perm /u=x,g=x,o=x
find . -type f -perm /111
```

Følgende kommandoer er også hendig, men disse finner da bare filer som er hhv. lesbare, skrivbare eller eksekverbare for eier:

```bash
find . -readable
find . -writable
find . -executable
```

Ønsker man å finne filer eid av en bestemt bruker, kan man bruke `-user`:

```bash
find . -type f -name *.py -user jan
```

Filstørrelse styrer ofte også ens søkekriterier. Det følgende finner hhv. filer mellom 100 og 200 MB, mellom 20 og 30 kB, under 100 byte og over 1 GB:

```bash
find . -type f -size +100M -and -size -200M
find . -type f -size +20k -and -size -30k
find . -size -100c
find . -size +1G
```

For mer avanserte søk etter tekstmønstre, kan `find` utnytte såkalte regulære uttrykk. Regulære uttrykk beskrives nærmere i `grep`-kapittelet, og fins sogar i flere varianter. Viktigst er at vi har grunnleggende og utvidede uttrykk. De grunnleggende får ved bruk av `-regex` eller (evt. `-iregex` om man ikke vil skille mellom store og små bokstaver). Her ser vi da et eksempel for å finner alle filer som inneholder cat, cut, cot osv. et sted inne i filnavnet, men unngår dem med coat og cust:

```bash
find . -type f -regex '.*c.t.+'
```

```output
./dogs-and-cats.txt
./she-is-cute.txt
```

Søkemønsteret er forklart grep-kapittelet. Om vi må ty til utvidede regulære uttrykk, som i `egrep`, må vi benytte notasjonen under.

Her finner vi det meste av bilder:

```bash
find . -regextype egrep -iregex '.*\.(jpg|jpeg|png|gif)$'
```

Under letes det etter filer med navn som inneholder \*CV\*pdf eller \*CV\*odt.

```bash
find . -type f -regextype egrep -regex '.*(CV).+(pdf|odt)'
```
som f.eks. kunne funnet

```output
CV-JRS.pdf
doc/myCVfil.odt
```

Under søkes filer hvis navn inneholder fil- etterfulgt av ett eller to sifre, før avsluttende .txt.

```bash
find . -type f -regextype egrep -regex '.*fil-[0-9]{1,2}\.txt'
```

```output
./fil-01.txt
./fil-02.txt
./fil-1.txt
```

mens denne forlanger nøyaktig tre sifre:

```bash
find . -type f -regextype egrep -regex '.*fil-[0-9]{3}\.txt'
```

```output
/fil-001.txt
```

Flere former for regulære søkemønstre omtales altså i `grep`-kapittelet

Merk: I tillegg til vanlige filattributter som navn, størrelse, tidstempel og eierskap fins de to typer utvidede attributter, hvilket vi skal komme tilbake til. Det kan imidlertid nevnes at `find` ikke kan søke etter disse.

Merk: Medfølgende grafisk filutforskere har gjerne også gode søkemuligheter, og noen, bl.a. Dolphin, har også mulighet til å søke i utvidede attributter.

## 🔎 find - eksempler med aksjoner

Standardaksjon for `find` er `-print`, som skriver søkeresultatet til standard output. Skal man skrive til fil, kan man eksplisitt bruke `-print0`, `-fprint` eller `-fprint0`, avhengig av ønskede valg for linjeendelser og formater.

Andre mye brukte aksjoner er `-delete`, for fjerning av filer, og `-ls` som lister flere detaljer for de funnede filene:

```bash
find . -name *.tmp -delete
find . -name *.tmp -ls
```

Mer generelt kan man få til flere og mer generelle aksjoner ved et par varianter av `-exec` og `-ok`. En funnet fil vil da mates til en nærmere angitt skallkommando, og filen (current file) representeres der av `{}` i spesifiseringen. La oss se på et eksempel der skallkommandoen `ls -la` anvendes på de funnede filene. Merk at den samlede kommandoen fins i to varianter:

```bash
find . -name '*.tmp' -exec ls -la {} ";"
find . -name '*.tmp' -exec ls -la {} +
```

Merk: Her må det benyttes anførselstegn for at det skal fungere.

Begge kommandoene fører til samme output, men `ls`-kommandoen anvendes i tur og orden på hver enkelt fil i det første tilfellet, mens følgen av filer legges til som argumenter til én og samme ` ls `-kommando i det andre tilfellet. Det siste kan være mer CPU-effektivt, men godtas ikke av alle skallkommandoer.

Disse skallkommandoene kjøres her fra katalogen som find-kommandoen ble kalt fra. Ønsker man isteden å kjøre skallkommandoene fra katalogen til filen, kan man benytte `-execdir` isteden. Sistnevnte kommer også i de samme to variantene som vist over.

Ofte kan det være greit å bli bedt om bekreftelse før man utfører noe drastisk, f.eks. ved sletting av filer. Aksjonen `-ok` er til for dette. Den fungerer ellers som `-exec` (og `-okdir` som `-execdir`), med det unntaket at den bare fins for den førstnevnte notasjonen (den med avsluttende "`;`"). Følgende eksempel har til hensikt å slette noen temporære filer, men vil spørre før en faktisk sletting finner sted. Brukeren kan svare y for ja og n for nei før hver enkelt sletting:

```bash
find . -name '*.tmp' -ok rm {} ";"
```

En annen nyttig aksjon er ""dirname"". Den returnere navn til kataloger til funnede filer. F.eks. kan man ønske å finne alle kataloger som inneholder bilder på systemet:

```bash
find . \( -name "*.jpg" -o -name "*.png" \) -exec dirname {} \; | sort -u
```


## 🔎 fd-eksempler

La oss så se på hvordan den nyere varianten `fd` fungerer. Det er en viss fleksibilitet i rekkefølgen av argumentene, men den generelle formen er 

```bash
fd [FLAGS/OPTIONS] [PATTERN] [PATH] [COMMAND]
```

Som sagt er den raskere enn `find`, inkluderer regulære uttrykk og er (for de fleste søk) enklere i bruk. La oss se på noen eksempler.

```bash
fd linux
```

finner alle filer og kataloger under gjeldene katalog som inneholder linux i navnet, f.eks.

```output
Backup-Linux/
Bruk-av-Linux.txt
Diverse-linux/
FEDORA-LINUX.pdf
ubuntu-linux.pfd
```

Når man bare benytter små bokstaver i søkemønsteret, gjøres insensitive søk. Det kan man også eksplisitt be om ved hjelp av opsjonen `-i`, altså:

```bash
fd -i linux
```

```output
Backup-Linux/
Bruk-av-Linux.txt
Diverse-linux/
FEDORA-LINUX.pdf
ubuntu-linux.pfd
```

Opsjon `-s` angir eksplisitt sensitivt søk:

```bash
fd -s linux
```

```output
Diverse-linux/
ubuntu-linux.pfd
```

Benytter man en eller flere store bokstaver i søkemønsteret, gjøres også sensitive søk:

```bash
fd Linux
```

```output
Backup-Linux/
Bruk-av-Linux.txt
```

Her finner man filer og kataloger som har doc i navnet:

```bash
fd doc
```
f.eks.

```output
doc/
tmp/pandoc-installasjon.txt
Kontrakt.doc
```

Ønsker man å søke etter filer/kataloger med navn som inneholder to mønstre, kan man benytte `--and`:

```bash
fd kontrakt --and oppsigelse
```

Denne kunne f.eks. ha returnert

```output
Kontrakter-og-Oppsigelser/
oppsigelse-mai-kontrakt.pdf
```

Det følgende finner tekstfiler under gjeldende katalog:

```bash
fd .txt
```

Det følgende finner JPG-filer under mappen ~/Pictures:

```bash
fd .jpg ~/Pictures
```

Selv om dette gjerne fungerer i praksis, er det egentlig en liten forenkling her. Alt vi ber om er hhv. at .txt eller .jpg er inneholdt i navnet. Førstnevnte vil også matche filer som

```output
brev.txt.doc
my.txtfil
```

og sistnevnte også filer som

```output
bilde.jpg.bak
marilyn.jpg.zip
```

`fd` benytter nemlig regulære uttrykk som default, og fordi mønstrene er uten anførselstegn, tolkes de egentlig som hhv. `'.*\.txt.*'` og `'.*\.jpg.*'` (altså tilsvarende glob-mønstrene `'*.txt*'` og `'*.jpg*'`). Dette trenger vi vanligvis ikke å bry oss om. Eksemplene fungerer som oftest i praksis og er hendige og kjappe i bruk.

Av samme grunn tolkes også et enslig punktum `.` uten anførselstegn som en samling av alle tegn. Det tolkes tilsvarende av `fd` som `'.*'`

Ønsker man å være mer presis, kan man uansett utnytte regulære uttrykk som

```bash
fd '\.txt'
```

eller benytte den hendige opsjonen `-e` (kort for `--extension`) som i

```bash
fd -e txt
```

Begge søk finner alle filer med endelse txt og fungerer fint.

En fin ting med opsjonen `-e` er at den kan repeteres. F.eks. finner

```bash
fd -e jpg -e png -e gif
```

alle JPG-, PNG- og GIF filer under gjeldende katalog på en oversiktlig og huskbar måte.

Det er riktignok en god vane å angi et mønster *eksplisitt* ved bruk av opsjoner som `-e`, f.eks. `.` for en samling av alle tegn, som følger:

```bash
fd -e txt .
```

Grunnen til det er at om man også hadde angitt en startkatalog i søket, f.eks.

```bash
fd -e txt doc
```

ville startkatalogen doc blitt tolket som et mønster, og kommandoen ville ikke fungert. Ordet txt blir et argument til `-e`, og `fd`-kommandoen blir uten annet mønster. Det korrekte i dette tilfellet er derfor å skrive

```bash
fd -e txt . doc
```

som finner filer med endelse txt under katalogen doc.

Tilsvarende finner følgende alle JPG.-filer under billedkatalogen ved `-e`-opsjonen:

```bash
fd -e jpg . ~/Pictures
```

Igjen er punktum (eller annet mønster nødvendig), ettersom en startkatalog er angitt.

Bruker man alternativene

```bash
fd .jpg ~/Pictures
fd '\.jpg$' ~/Pictures
```

er mønstre eksplisitt angitt, og man slipper å tenke på problematikken.

Man har også tilgang til glob-mønstre ved `-g`-opsjonen, (kort for `--glob`), slik at de find-aktige kommandoene for de ovennevnte eksemplene blir:

```bash
fd -g '*.txt'
fd -g '*.jpg' ~/Pictures
```

Det er også mulig å angi flere søkekataloger, f.eks.

```bash
fd JavaScriptCore /usr/share /var
```

 Eksempelet er i dette tilfellet lettlest. Mindre lesbart blir det følgende:
 
 ```bash
fd doc doc brev
```
 
 Her blir første doc tolket som mønsteret `'.*doc.*'`, andre doc som en startkatalog `doc/` og brev som startkatalog `brev/`. For lesbarhetens skyld kan man inkludere `--` i forkant stedangivelsene slik:

 ```bash
fd doc -- doc brev
```

De to siste kommandoene kunne eksempelvis funnet:

 ```output
brev/julehilsen.doc
doc/Documents/
doc/pandoc.md
doc/kontrakt.doc
```

Ønsker man å matche starten av et fil-/katalognavn, benyttes `'^navn'`, og ønsker man å matche slutten, benyttes `navn$`.

Ønsker man å matche et helt navn eksakt, kombinerer man disse. Det følgende finner alle Makefiles under gjeldende katalog:

```bash
fd '^Makefile$'
fd --glob 'Makefile'
```

`fd` ignorere skjulte filer og kataloger, deriblant .git, og alle andre filer/kataloger nevnt i .gitignore. Normalt vil dette være ønskelig. (Vi vet at `find` til forskjell søker gjennom alt dette, med mindre man hindrer det ved `-prune` eller tilsvarende.)

- Vi skal komme tilbake til git, men kort fortalt er det et versjonskontrollverktøy for å holde orden på prosjektfiler/-kataloger under en gitt katalog, unntatt filer/kataloger nevnt i .gitignore (f.eks. temporære filer man ikke trenger å ha noen versjonskontroll på).

Det er også mulig å sette opp en egen .fdignore-fil med filer og kataloger `fd` skal ignorere. I tillegg sjekkes også etter forekomst av eventuell .ignore-fil som flere kommandoer, deriblant `fd`, respekterer tilsvarende.

Dersom man ønsker å inkludere skjulte filer, benyttes opsjonen `-H` (kort for `--hidden`). F.eks. vil starship (et verktøy for fancy kommandprompt) ha en konfigurasjonsfiler på .config, men ettersom katalogen er skjult, finnes ikke denne (fra hjemmekatalog) med mindre nevnte opsjon benyttes:

```bash
fd -H starship
```

Man kan selvsagt eksplisitt søke i skjulte kataloger som .config uten opsjonen, om man ønsker det:

```bash
fd config .config/ 
```

```output
.config/atuin/config.toml
.config/bat/config
.config/fish/config.fish
.config/pop-shell/config.json
.config/terminator/config
``` 

Opsjonen `-I` (kort for `--no-ignore`) sørger for at filene/ktalogene nevnt i .gitignore, .fdignore og .ignore likevel gjennomsøkes. F.eks. for å finne flere logg-filer, kan man gjøre følgende:

```bash
fd -Ie log
```

Dersom man ønsker å søke uten alle disse begrensningene, kan man benytte opsjonen `-u` (kort for `--unrestricted`, som altså er både `-H` og `-I`). Det følgende finner dermed, på to måter, abslolutt alle JPG- og PNG-filer under gjeldende katalog:

```bash
fd -u '(jpg|png)$'
```

```bash
fd -u -e jpg -e png
```

Normalt vil man søke etter mønstre i filnavn, men man kan også søke i hele filstien ved opsjonen `-p` (kort for `--full-path`). F.eks. kunne 

```bash
fd -p 'div.*linux'
```
funnet filen

```output
Diverse/doc/Printing-Linux.txt
```

`fd` har i likhet med `find` muligheter til å avgrense søk i bestemte kataloger med `--prune`. Syntaksen for `find` er nokså brysom, som f.eks. i

```bash
find . -type d -name bin -prune -o -type f -name *.py -print
```

som fant Python-filer under gjeldende katalog, untatt i katalogene bin/, eller (enda verre) i 

```bash
find . -type d \( -name .vscode -o -name .config \) -prune -o -name *.py -print
```

som fant samme type filer, men eksluderte katalogene .vscode/ og .config/. 

`fd` har i følge man-siden også en opsjon `--prune`, med dels får jeg den ikke til å virke i min versjon, og dels kan den erstattes med den mer hendige `-E`-opsjonen (kort for `--exclude`). Det kan både repeteres og godtar glob-mønstre for spesifisering av kataloger.

Det følgende finner PNG-filer, men ignorer katalogen tmp:

```bash
fd -E tmp .png
```

Det følgende finner PNG-filer, men eksludere filer/kataloger som inneholder tmp i navnet og alle filer/kataloger hvis navn inneholder ba\*up:


```bash
fd -E tmp -E ba*up .png
```

Som for `find`, kan man videre dybdebegrense søk, hvilket gjøres med `-d` (kort for `--max-depth`):

```bash
fd -e md -d 3
```

Denne finner Markdown-filer på gjeldende katalog samt to på to nivåer ned.

Man kan også eller antallsbegrense resultater ved `--max-results` eller `-1` (kort for `--max-results` 1 ). Man kan benytte likhetstegn eller mellom angivelse av antall:

```bash
fd -e md -max-results 10
fd -e md -max-results=10
fd -e md -1
```

For å søke etter bestemt type fil (vanlig, eksekverbar, link, katalog, socket osv.) benyttes opsjonen `-t` (kort for `--type`) etterfulgt av en spesifikk bokstav, hhv. f, x, l, d, s m.fl. Men har også en tom type, e, slik at det følgende finner alle tomme filer og kataloger under gjeldende katalog:

```bash
fd -te
```

Den følgende finner bare tomme filer,

```bash
fd -te -tf
```

og den følgende bare tomme kataloger

```bash
fd -te -td
```

Merk: Vi kan *ikke* dra sammen de to typeangivelsene til `-tef` eller `-ted` her. Opsjonene må angis separat som vist.

`fd` kan selvsagt også utføre søke etter andre kriterier, som søk basert på filstørrelse, tidspunkter, eierskap osv.

Her finner man alle filer over 1 GB under gjeldende katalog:

```bash
fd -S +1G
```

Ved å inkludere opsjon `-l` (kort for `--list-details`), får man dessten langlistet søkeresultatene:

```bash
fd -S +1G -l
```

```output
-rwxr-xr-x. 1 jan jan 1.1G Sep 1  2024  ./Videos/Fargo.mp4
-rwxr-xr-x. 1 jan jan 1.4G Sep 1  2024 './Videos/The-Apartment.mp4'
```

Her finner man alle filer under 30b under gjeldende katalog:

```bash
fd -S -30b
```

For søk basert på tidskriterier er mulighetene også mange. 

Når det gjelder regulære uttrykk, har `fd` flere fordeler sammenliknet med `find`. For det første er regex inkludert som default, og vi slipper å huske/slå opp brysomme opsjoner som `-regextype` og `-regex`. Dessuten trenger man ikke å spesifisere hele mønstre som søkemønsteret er en del av, men kan klare seg med den essensielle delen. Dette ser vi i det tidligere eksempelet 

```bash
find . -type f -regextype egrep -regex '.*(CV).+(pdf|odt)'
```

som finner filer som

```output
CV-JRS.pdf
doc/myCVfil.odt
```

 `find` trenger et innledende `.*` for å si at *noe* kan komme foran CV-ordet, mens man slipper dette for `fd`. Tilsvarende søk med `fd` blir dermed både kortere og langt mer naturlig å sette opp/huske:

```bash
fd -tf '(CV).+(pdf|odt)'
```

```output
CV-JRS.pdf
doc/myCVfil.odt
```

 På samme måte blir `find`-eksempelet

```bash
find . -type f -regextype egrep -regex '.*fil-[0-9]{1,2}\.txt'
```

```output
./fil-01.txt
./fil-02.txt
./utfil-fil-1.txt
```

til det mye enklere `fd`-eksempelet:

```bash
fd 'fil-[0-9]{1,2}\.txt'
```

```output
./fil-01.txt
./fil-02.txt
../utfil-fil-1.txt
```

```bash
fd '\.tar\.gz$' --changed-within 1w
```

Opsjon `-x` (kort for `--exec`)

Opsjon `-X` (kort for `--exec-batch`)

```bash
fd -e zip -x unzip
```

```bash
fd -u -e jpg -e png -x dirname | sort -u
```

