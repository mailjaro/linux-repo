# 👀 grep og rg

`grep` (som står for *Global search for Regular Expression*) er en svært nyttig og velbrukt Linux-kommando. Den finner bestemte mønstre i filer og er naturlig inkludert i alle Linux-distribusjoner. Den har etterhvert fått sin moderne variant kalt `rg` (kort for rip-grep) som er kjappere og enklere i bruk. Vi skal se på begge, men la oss starte med `grep`.

## 🔎 grep

Den generell syntaksen er:

```bash
grep [options] pattern [files]
```

Anta vi har følgende fil **testfil.txt**:

```output
Linux er et åpent unix-basert operativsystem.
Ubuntu er en debian-basert linux-variant.
Windows har ikke samme rikdom av kommandoer.
```

Kommandoen

```bash
grep linux testfil.txt
```

returnerer da følgende linje til skjermen:

```output
Ubuntu er en debian-basert [linux]-variant.
```

**MERK:** Ord som matcher søkemønstert, dvs. **linux** her, blir fargemarkert i shell-output. Her vises matchende mønstre isteden gjennomgående inni klammeparenteser.

Benytter man `-i`, skilles det ikke lenger på små og store bokstaver. Opsjoen `-n` sørger for at linjenumre i resultatet:

```bash
grep -in 'linux' testfil.txt
```

```output
1:[Linux] er et åpent unix-basert operativsystem.
2:Ubuntu er en debian-basert [linux]-variant.
```

Opsjonen `-v` gir komplementet, og `-w` angir at mønstret må være et helt ord.

```bash
grep -ivw "linux" testfil.txt
```

```output
Windows har ikke samme rikdom av kommandoer
```

Man kan søke flere filer ved ganske enkelt å inkludere flere filer i søket, som f.eks.

```bash
grep -c linux testfil-1.txt testfil-2.txt *.c *.py
```

Her indikerer opsjonen `-c` at man bare vil ha antallet linjer som matcher i (hver av) filene. Ønsker man å fortsette søk i alle underkataloger, kan man benytte `-r`. Den følger ikke symbolske linker (i motsetning til `-R`). Disse fungerer kanskje best med `*` eller `.` som filangivelse. Prøver man f.eks. ting som `*.py`, og ingen slike fins i gjeldende katalog, vil ikke `grep` gå ned i underkataloger ved bruk av `-r`.

Ønsker man bare å liste filene, kan man benytte `-l`. Følgende kommando lister navnet til alle filer i filtreet under gjeldende katalog som inneholder ordet **while**, med små eller store bokstaver.

```bash
grep -riwl 'while' *
```

Ønsker vi å søke etter flere ordmønstre, benyttes `-E` (som også gir flere muligheter, se neste underkapittel). Bruken fremgår av følgende eksempel (som også ber om linjenumre og ikke-case-sensitivt søk):

```bash
grep -Ein 'linux|windows' testfil.txt
```

```output
1:[Linux] er et åpent unix-basert operativsystem.
2:Ubuntu er en debian-basert [linux]-variant.
3:[Windows] har ikke samme rikdom av kommandoer.
```

Ønsker man å printe bare det som matcher, ikke hele linjen, kan man bruke opsjon `-o`.

```bash
grep -Eino 'linux|windows' testfil.txt
```

```output
1:Linux
2:linux
3:Windows
```

hvor g dokumentets konvensjon med klammeparenteser for matchede mønstre er droppet.

For strengt formaterte filer ønsker man kanskje å søke etter match for hele linjer. Da benyttes `-x`, som i:

```bash
grep -x '20-Jan--06 15:24:35' system.log
```

Ønsker man mer kontekst rundt fillinjene man finner, kan man benytte `-A`,`-B` og `-C`. Eksempelvis sier `-A3` at man i tillegg vil printe ut 3 linjer etter (after), `-B2` at man vil printe ut 2 linjer før (before) og `-C5` at man vil printe ut 5 linjer både før og etter. De følgende to kommandoene har altså samme viste effekt.

```bash
grep -in -A1 -B1 'debian' testfil.txt
grep -in -C1 'debian' testfil.txt
```

```output
1-Linux er et åpent unix-basert operativsystem.
2:Ubuntu er en [debian]-basert linux-variant.
3-Windows har ikke samme rikdom av kommandoer.
```

Søker vi spesielt etter noe på starten av en linje, benyttes tegnet `^`. Tilsvarende symbol for noe på slutten av en linje er `$`.

```bash
grep -i '^linux' testfil.txt
```

```output
[Linux] er et åpent unix-basert operativsystem.
```

```bash
grep -i 'e.$' testfil.txt
```

```output
Ubuntu er en debian-basert linux-varian[t.]
```

Dette er egentlig begge eksempler på såkalte regulære uttrykk (**regex**). Det er mye å si om dette, så vi skal straks se nærmere på dette .

`grep`-eksemplene vår har vært knyttet til søk i filer, men det er også vanlige å finne spesielle ting i output kommando fra kommandoer, f.eks. her hvor søker gjennom en av kjørende prosesser for å finne noe som har med bluetooth å gjøre:

```bash
ps -ef | grep -i bluetooth
```

## Regulære uttrykk, regex og egrep

Til å begynne med, klarer man seg kanskje med eksemplene som er gitt. Men for å ta søkene til neste nivå, trenges **regex**.

Det fins for det første flere standarder her, både POSIX- og Perl-baserte. For førstnevnte, som er av størst interesse for oss, fins det både BRE (*Basic Regular Expressions*) og ERE (*Extended Regular Expressions*). BRE er standard/inkludert i kommandoer som `grep`, `sed` og andre (hvilket vi kommer tilbake til), mens ERE inkluderes først ved bruk av opsjonen `-E`. Og siden datafolk ikke er glad i unødvendig skriving, er dette for grep tatt opp i kommandoen `egrep` (dvs. `egrep` er det samme som `grep -E`.) `egrep` er imidlertid utgående, og det anbefales å benytte `grep -E` med tanke på fremtidig kompatibilitet.

Forskjellen mellom vanlig og utvidet **regex** går i hovedsak på at man ofte slipper escape av metakarakterer i det utvidede tilfellet, hvilket kan være en fordel (se mer om dette lenger ned). Tegn som `?`, `+`, `{`, `}`, `|`, `(` og `)` brukes nemlig mye når man kombinerer mønstre, og disse behandles der som spesielle tegn. I vanlig **regex** må man ha benyttet mange escapes får å få til det samme, og koden blir vanskeligere å lese.

Det fins også en tilsvarende variant av `grep -F`, `fgrep`, som også er utgående. Men `fgrep -F` er nyttig i enkelte sammenhenger der man skal søke gjennom filer med mange metakarakter. Kommandoen ser på teksten som en fiksert samling linjer med tegn som det kan søkes i.

Regulære uttrykk baser seg uansett på følgende fem byggestener:

* Bokstavelighet: for søk etter tekst som matcher eksakt, bokstav for bokstav.
  
* Metakarakterer: spesielle symboler som punktum (`.`), hatt (`^`), dollartegn (`$`), stjerne (`*`), pluss (`+`), spørsmålstegn (`?`), pipe (`|`), parenteser `( )` , krøllparenteser `{}` og backslash (`\`).
  
* Gruppering og gjenbruk: bruk av parenteser for organisering av tekstbiter til tekstenheter, evt. med lagring av det som matcher for senere bruk. Og gjerne i kombinasjon med eller- operatoren `|`.

* Karakterklasser: for søk etter grupper av karakterer, som `[abc]`, `[^abc]`, `[a-z]`, `[A-Z]`, `[a-zA-Z]`, `[0-9]` og `[a-zA-Z0-9]`

* Escaping: bruk av `\` for at spesialtegn skal tolkes kun som tegnet, som f.eks. at spesialtegnet `.` (som matcher alle tegn) ved `\.` bare representerer punktum.

La oss starte med metakarakterene.

Punktum representerer altså alle karakterer, slik at f.eks. `c.t` matcher både **cat**, **cut** og **c-t**, men ikke **ct**. Dette bekreftes av:

```bash
echo 'as[cot] [cat] [cut] [cut]e [cut]ter [c-t] [c:t] car ct' | grep 'c.t'
```

```output
echo 'ascot cat cut cute cutter c-t c:t car ct' | grep 'c.t'
```

`^mønster` representer noe på starten og `mønster$` noe på slutten av en linje:

```bash
echo 'err error' | grep '^e'
```

```output
[e]rr error
```

```bash
echo 'err error' | grep 'r$'
```

```output
err erro[r]
```

Dermed vi kan f.eks. finne filer med bestemte filendelser. Om vi har det følgende:

```bash
ls -1 *txt
```

```output
jan-txt
kari.txt
ola.txt
```

gir nettopp

```bash
ls -1 *txt | grep '\.txt$'
```

```output
kari[.txt]
ola[.txt]
```

Her måtte vi bruke backslash foran punktum for å få med **.txt**, men ikke **-txt**.

Stjerne (`*`) står for ingen eller flere av foregående tegn, slik at `o*h` matcher **h**, **oh**, **ooh**, **oooh** osv, men ikke **o** eller **oo** f.eks.

```bash
echo 'h oh ooh o oo' | grep 'o*h'
```

```output
[h] [oh] [ooh] o oo
```

Pluss (`+`) står for én eller flere forekomster av foregående tegn, slik at `do+g` matcher **dog** og **doog** osv, men ikke **dg**. Men for at det skal fungere, må man enten ta escape av plusstegnet eller bruke utvidet **`regex`**. For kontroll kan gjøre én av følgende (men for fremtiden, altså helst ikke den siste):

```bash
echo 'dg dog doog' | grep 'do\+g'
echo 'dg dog doog' | grep -E 'do+g'
echo 'dg dog doog' | egrep 'do+g'
```

```output
dg [dog] [doog]
```

Vi ser at utvidede regulære uttrykk (ERE) er mer lesbar og å foretrekke.

**Merk**: I eksempelet med filendelse **.txt** lenger opp, må man benytte escape for punktum også med `grep -E`. Punktum behandles spesielt også i det utvidede tilfellet.

`{n}` står for `n` repetisjoner av foregående tegn, `{n,}` står for minst n repetisjoner, mens {n,m} står for minst **n** og høyst **m** repetisjoner av foregående tegn. Dvs at `91{2}` matcher **911**, og `91{2,}` matcher **911**, **9111**, **91111**, ..., mens `91{2,3}` matcher **911** og **9111**, men ikke **91111**. Krøllparentes må espapes i vanlige uttrykk, så her er det greit på benytte den utvidede varianten:

```bash
echo '911 9111 91111 911111 111' | grep -E '91{2}'
```

```output
[911] [911]1 [911]11 [911]111 111
```

```bash
echo '911 9111 91111 911111 111' | grep -E '91{2,}'
```

```output
[911] [9111] [91111] [911111] 111
```

```bash
echo '911 9111 91111 911111 111' | grep -E '91{2,3}'
```

```output
[911] [9111] [9111]1 [9111]11 111
```

Her ser vi bruk av `\b`, som står for ordgrense, altså enten begynnelsen eller slutten av et ord:

```bash
echo "cat scatter catalog scat" | grep -E '\bcat'
```

```output
[cat] scatter [cat]alog scat
```

```bash
echo "cat scatter catalog scat" | grep -E 'cat\b'
```

```output
[cat] scatter catalog s[cat]
```

```bash
echo "cat scatter catalog scat" | grep -E '\bcat\b'
```

```output
[cat] scatter catalog scat
```

`\w` er noe beslektet med `b`. Den representerer bokstaver, tall og underscore. Her er et par eksempler:

```bash
echo ":abc!" | grep -E '\w'
```

```output
:[a][b][c]!
```

Det følgende er veldig likt, men vi legger til et `+` i etterkant, som alyså betyr én eller flere forekomster av foregående tegn:

```bash
echo ":abc!" | grep -E '\w+'
```

```output
:[abc]!
```

og vi får en litt annen match på det samme (hvilket ikke synes ut fra fragekodingen).

Det neste matcher ordlengder på 3 tegn:

```bash
echo 'er err error' | grep -E '\b\w{3}\b'
```

```output
er [err] error
```

Spørsmålstegn (`?`) betyr at tegnet foran er opsjonelt, slik at f.eks. `colou?r` matcher både det amerikanske **color** og det britiske **colour**.

```bash
echo 'color colour coloor' | grep 'colou\?r'
echo 'color colour coloor' | grep -E 'colou?r'
```

```output
[color] [colour] coloor
```

Pipe (`|`) benyttes for flere mønstre, som en eller-operator:

```bash
echo 'cat cats dog dogs ctdg' | grep 'cat\|dog'
echo 'cat cats dog dogs ctdg' | grep -E 'cat|dog'
```

```output
[cat] [cat]s [dog] [dog]s ctdg
```

Vi ser at utvidede uttrykk normalt er å foretrekke. (Og vi ser nå også hva som egentlig foregikk i det tidligere `linux|windows`-eksempelet vårt.)

Parenteser benyttes for gruppering. Her finne vi f.eks. alle forekomster av **set** prefikset med én eller flere **sun**:

```bash
echo 'set sunset sunsunset' | grep -E '(sun)+set'
```

```output
set [sunset] [sunsunset]
```

Klassen `[abc]` representerer **a** eller **b** eller **c**, slik at `[LNT]ine` matcher både **Line**, **Nine** og **Tine**, men ikke **Katrine**.

```bash
echo 'Line Nine Tine Katrine' | grep '[LNT]ine'
```

```output
[Line] [Nine] [Tine] Katrine
```

`[^abc]` representerer det omvendte av `[abc]`, slik at `[^LNT]ine` matcher både **mine**, **sine**, **rine** og **fine**, men ikke lenger **Line** osv.

```bash
echo 'Line Nine Tine Katrine' | grep '[^LNT]ine'
```

```output
Line Nine Tine Kat[rine]
```

Klassen `[a-z]` representerer alfabetintervallet av alle små (engelske) bokstaver fra **a** til **z**, mens `[A-Z]` representerer de tilsvarende store. Om man vil, kan man se på begrensede intervaller, som f.eks. `[J-V]` osv. Norske bokstaver godtas ikke i intervaller, selv om **æ**, **ø** og **å** er søkbare tegn i **regex** ellers.

Sifrene representeres av `[0-9]`, og man kan selvsagt velge sub-intervaller.

`[a-zA-Z]` representer både store og små bokstaver, mens `[a-zA-Z0-9]` representerer både små bokstaver, store bokstaver og sifre. Rekkefølgen av disse har ingenting å si i matching. La oss se på eksempler.

Under søkes det etter stor bokstav etter fulgt av liten, men ikke med forekomster for sent i alfabetet:

```bash
echo 'Anne Beate Jan Tore' | grep '[A-K][a-m]'
```

```output
Anne [Be]ate [Ja]n Tore
```

Det følgende søker etter alt som er bokstaver eller sifre. Og da matcher jo alt unntatt tegn som f.eks. pluss og minus:

```bash
➜  echo '+++45 AB C3 python---3' | grepm '[a-zA-Z0-9]'
```

```output
➜  echo '+++45 AB C3 python---3' | grepm '[a-zA-Z0-9]'
+++[4][5] [A][B] [C][3] [p][y][t][h][o][n]---[3]
```

Her derimot søkes det mer konkret etter en bokstav eller siffer etterfulgt av kolon:

```bash
echo '+: abc: 347: ---:' | grep '[a-zA-Z0-9]:'
```

```utput
+: ab[c:] 34[7:] ---:
```

Under søker vi konkret etter siffer etterfulgt av stor bokstav etterfulgt av liten bokstav:

```bash
echo 'AN3 Bn4 aX5 6vH 3Nr' | grep '[0-9][A-Z][a-z]'
```

```output
AN3 Bn4 aX5 6vH [3Nr]
```

Det er også mulig å legge inn flere tegn enn bokstaver å tall i klassen, f.eks. `[a-zA-Z0-9&_-]`. Dette inkluderer i tillegg til bokstaver og tall her ampersand, underscrore og minustegn.

Eksemplene våre er illustrerende, men lite nyttige. La oss prøve et litt mer realistisk eksempel, f.eks. å sjekke om en e-post-adresse har lovlig format. Det følgende er langt fra perfekt, `[.a-zA-Z0-9_-]+@[.a-zA-Z]+`, men matcher i det minste adresser som: **jan_roger2.home@gmail.co.uk**, og **jan.roger-home@gmail.com** etc. Uttrykket godtar riktignok også adresser som **.3---3...3___@.cm.**, så det er et stykke igjen her. Men det illustrerer vel en del av funksjonaliteten av **regex** like fullt. Uttrykket vårt godtar mer spesifikt én eller flere klynger av bokstaver, tall og våre tre spesialtegn, etterfulgt av @ og en eller flere klynger av bokstaver og punktum. F.eks

```bash
echo 'jan.roger-home@gmail.com' | grep -E '[.a-zA-Z0-9_-]+@[.a-zA-Z]+'
```

```output
[jan.roger-home@gmail.com]
```

Om ikke annet ville uttrykket ha stoppet en adresse som **jan.roger@gmail2-com**.

Men oppgaven var nok i vanskeligste laget, så la oss ta et annet. Her letes det fram produktnumre (kanskje) med et fast format og som slutter på **-333**. Det må være nøyaktig tre store bokstaver, bindestrek, tre sifre, bindestrek før 333.

```bash
echo 'NOX-901-333 FOX-875-334' | grepm -E '[A-Z]{3,3}-[0-9]{3,3}-3{3}'

```

```output
[NOX-901-333] FOX-875-334
```

## 🔍 rg

La oss se på den moderne varianten `rg`. For det første vil den fungere uten videre for alle **grep**-eksemplene vist i boken. F.eks. kunne vi erstattet:

```bash
echo 'set sunset sunsunset' | grep -E '(sun)+set'
```

med 

```bash
echo 'set sunset sunsunset' | rg '(sun)+set'
```

```output
set [sunset] [sunsunset]
```

osv. Men i tillegg til å være kjappere, har `rg` også noen brukervennlige tillegg, som søk i bestemte filtyper ved opsjonen `-t`, kortform for sifre (`\d`), alle mulige blanke (`\s`) mm. som er lette både å bruke og huske.

Følgende tabell oppsummerer metakarakterer i `rg` :

| Mønster      | Matcher
|-------------:|:------------------
| `.`	       | Ethvert tegn (unntatt ny linje)
| `*`          | Null eller flere av foregående tegn/gruppe
| `+`          | Én eller flere av foregående tegn/gruppe
| `?`          | Null eller ẽn av foregående tegn/gruppe
| `[abc]`      | Én av a, b, eller c
[`^abc`]       | Ethvert tegn unntatt a, b, eller c
| `(abc\|def)` | abc eler def
| `^`	       | Start på linje 
| `$`	       | Slutt på linje
| `\b`         | Ordgrense
| `\d`         | Siffer (0–9)
| `\w`         | Ordtegn (bokstav, siffer, underscore)
| `\s`         | Blank (mellomrom, tab, ny linje) 

Nå kan riktignok også `grep` utnytte `\b`, `\d` osv. ved `grep -P` (Perl mode), men for mindre erfarne brukere er det greit å ha slikt mer umiddelbart tilgjengelig.

| Opsjon  | Matcher
|--------:|:--------------------------------
| `-s`    | Case-sensitivt søk 
| `-s`    | Case-insensitivt søk 
| `-t`    | Begrenser søk til angitt filtype
| `-T`    | Eksluderer angitt filtype
| `-n`    | Inkludere linjenumre
| `-U`    | Multiline
| `-w`	  | Mønstre omgitt av ordskiller
| `-v`	  | Inverterer søkemønster
| `-x`	  | Matche hele linjer
| `-z`	  | Søk i zip-filer

