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
Ubuntu er en sebian-basert linux-variant.
Windows har ikke samme rikdom av kommandoer.
```

Kommandoen

```bash
grep linux testfil.txt
```

returnerer da følgende to linjer til skjermen:

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">Linux</span> er et Unix-basert operativsystem basert på åpen kildekodee.
Ubuntu er en Debian-basert <span class="ansi1 ansi31">Linux</span>-variant.
</pre>
:::

Opsjon `-i` sørger for man ikke skiller på små og store bokstaver, mens `-n` sørger for at linjenumre inkluderes i resultatet.

```bash
grep -in 'rt linux' testfil.txt
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi32">2</span><span class="ansi36">:</span>Ubuntu er en Debian-base<span class="ansi1 ansi31">rt Linux</span>-variant.
</pre>
:::

Opsjonen `-v` gir komplementet og `-w` angir at mønstret må være et helt ord.

```bash
grep -ivw "en" testfil.txt
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi32">2</span><span class="ansi36">:</span>Ubuntu er en Debian-base<span class="ansi1 ansi31">rt Linux</span>-variant.
</pre>
:::

Man kan søke flere filer ved ganske enkelt å inkludere flere filer i søket, som f.eks.

```bash
grep -c linux testfil-1.txt testfil-2.txt *.c *.py
```

Her indikerer `-c` at man bare vil ha antallet linjer som matcher i (hver av) filene. Ønsker man å fortsette søk i alle underkataloger, kan man benytte `-r`. Den følger ikke symbolske linker (i motsetning til `-R`). Disse fungerer kanskje best med `*` eller `.` som filangivelse. Prøver man f.eks. ting som `*.py`, og ingen slike fins i gjeldende katalog, vil ikke `grep` gå ned i underkataloger ved bruk av `-r`.

Ønsker man bare å liste filene, kan man benytte `-l`. Følgende kommando lister navnet til alle filer i filtreet under gjeldende katalog som inneholder ordet **while**, med små eller store bokstaver.

```bash
grep -riwl 'while' *
```

Ønsker vi å søke etter flere ordmønstre, benyttes `-E` (som også gir flere muligheter, se neste underkapittel). Bruken fremgår av følgende eksempel (som også ber om linjenumre og ikke-case-sensitivt søk):

```bash
grep -Ein 'linux|windows' testfil.txt
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi32">1</span><span class="ansi36">:</span><span class="ansi1 ansi31">Linux</span> er et Unix-basert operativsystem basert på åpen kildekodee.
<span class="ansi32">2</span><span class="ansi36">:</span>Ubuntu er en Debian-basert <span class="ansi1 ansi31">Linux</span>-variant.
<span class="ansi32">3</span><span class="ansi36">:</span><span class="ansi1 ansi31">Windows</span> mangler særlig samme rikdom av skallkommandoer.
</pre>
:::

Ønsker man å printe bare det som matcher, ikke hele linjen, kan man bruke opsjon `-o`.

For strengt formaterte filer ønsker man kanskje å søke etter match for hele linjer. Da benyttes `-x`, som i:

```bash
grep -x '20-Jan--06 15:24:35' system.log
```

Ønsker man mer kontekst rundt fillinjene man finner, kan man benytte `-A`,`-B` og `-C`. Eksempelvis sier `-A3` at man i tillegg vil printe ut 3 linjer etter (after), `-B2` at man vil printe ut 2 linjer før (before) og `-C5` at man vil printe ut 5 linjer både før og etter. De følgende to kommandoene har altså samme viste effekt.

```bash
grep -in -A1 -B1 'debian' testfil.txt
grep -in -C1 'debian' testfil.txt
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi32">1</span><span class="ansi36">-</span>Linux er et Unix-basert operativsystem basert på åpen kildekodee.
<span class="ansi32">2</span><span class="ansi36">:</span>Ubuntu er en <span class="ansi1 ansi31">Debian</span>-basert Linux-variant.
<span class="ansi32">3</span><span class="ansi36">-</span>Windows mangler særlig samme rikdom av skallkommandoer.
</pre>
:::

Søker vi spesielt etter noe på starten av en linje, benyttes tegnet `^`. Tilsvarende symbol for noe på slutten av en linje er `$`.

```bash
grep -i '^linux' testfil.txt
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">Linux</span> er et Unix-basert operativsystem basert på åpen kildekodee.
</pre>
:::

```bash
grep -i 'e.$' testfil.txt
```

:::ansiout
<pre class="ansi2html-content">
Linux er et Unix-basert operativsystem basert på åpen kildekode<span class="ansi1 ansi31">e.</span>
</pre>
:::

Dette er egentlig begge eksempler på såkalte regulære uttrykk (**`regex`**). Det er mye å si om dette, så vi skal se nærmere på dette i følgene underkapittel.

`grep`-eksemplene vår har vært knyttet til søk i filer, men det er også vanlige å finne spesielle ting i output kommando fra kommandoer, f.eks.

```bash
ps -ef | grep -i bluetooth
```

## Regulære uttrykk, regex og egrep

Til å begynne med, klarer man seg kanskje med eksemplene som er gitt. Men for å ta søkene til neste nivå, trenges **regex**.

Det fins for det første flere standarder her, både POSIX- og Perl-baserte. For førstnevnte, som er av størst interesse for oss, fins det både BRE (*Basic Regular Expressions*) og ERE (*Extended Regular Expressions*). BRE er standard/inkludert i kommandoer som `grep`, `sed` og andre (hvilket vi kommer tilbake til), mens ERE inkluderes først ved bruk av opsjonen `-E`. Og siden datafolk ikke er glad i unødvendig skriving, er dette for grep tatt opp i kommandoen `egrep`. (Dvs. `egrep` er det samme som `grep -E`.) `egrep` er imidlertid utgående, og det anbefales å benytte `grep -E` med tanke på fremtidig kompatibilitet.

Forskjellen mellom vanlig og utvidet **regex** går i hovedsak på at man ofte slipper escape av metakarakterer i det utvidede tilfellet, hvilket kan være en fordel (se mer om dette lenger ned). Tegn som `?`, `+`, `{`, `}`, `|`, `(` og `)` brukes nemlig mye når man kombinerer mønstre, og disse behandles der som spesielle tegn. I vanlig **regex** må man ha benyttet mange escapes får å få til det samme, og koden blir vanskeligere å lese.

Det fins også en tilsvarende variant av `grep -F`, `fgrep`, som også er utgående. Men `fgrep -F` er nyttig i enkelte sammenhenger der man skal søke gjennom filer med mange metakarakter. Kommandoen ser på teksten som en fiksert samling linjer med tegn som det kan søkes i.

Regulære uttrykk baser seg uansett på følgende fem byggestener:

* Bokstavelighet: for søk etter tekst som matcher eksakt, bokstav for bokstav.
  
* Metakarakterer: spesielle symboler som punktum (`.`), hatt (`^`), dollartegn (`$`), stjerne (`*`), pluss (`+`), spørsmålstegn (`?`), pipe (`|`), parenteser `( )` , krøllparenteser `{}` og backslash (`\`).
  
* Gruppering og gjenbruk: bruk av parenteser for organisering av tekstbiter til tekstenheter, evt. med lagring av det som matcher for senere bruk. Og gjerne i kombinasjon med eller- operatoren `|`.

* Karakterklasser: for søk etter grupper av karakterer, som `[abc]`, `[^abc]`, `[a-z]`, `[A-Z]`, `[a-zA-Z]`, `[0-9]` og `[a-zA-Z0-9]`

* Escaping: bruk av `\` for at spesialtegn skal tolkes kun som tegnet, som f.eks. at spesialtegnet `.` (som matcher alle tegn) ved `\.` bare representerer punktum.

La oss starte med metakarakterene.

Punktum representerer altså alle karakterer, slik at f.eks. c.t matcher både **cat**, **cut** og **c-t**, men ikke **ct**. Dette bekreftes av:

```bash
echo 'ascot cat cut cute cutter c-t c:t dog car ct' | grep 'c.t'
```

:::ansiout
<pre class="ansi2html-content">
as<span class="ansi1 ansi31">cot</span> <span class="ansi1 ansi31">cat</span> <span class="ansi1 ansi31">cut</span> <span class="ansi1 ansi31">cut</span>e <span class="ansi1 ansi31">cut</span>ter <span class="ansi1 ansi31">c-t</span> <span class="ansi1 ansi31">c:t</span> dog car ct
</pre>
:::

`^mønster` representernoe på starten og `mønster$` noe på slutten av en linje:

```bash
echo 'err error' | grep '^e'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">e</span>rr error
</pre>
:::

```bash
echo 'err error' | grep 'r$'
```

:::ansiout
<pre class="ansi2html-content">
err erro<span class="ansi1 ansi31">r</span>
</pre>
:::

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
kari.txt
ola.txt
```

Her måtte vi bruke backslash foran punktum for å få med **.txt**, men ikke **-txt**.

Stjerne (`*`) står for ingen eller flere av foregående tegn, slik at `o*h` matcher **h**, **oh**, **ooh**, **oooh** osv, men ikke **o** eller **oo** f.eks.

```bash
echo 'h oh ooh o oo' | grep 'o*h'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">h</span> <span class="ansi1 ansi31">oh</span> <span class="ansi1 ansi31">ooh</span> o oo
</pre>
:::

Pluss (`+`) står for én eller flere forekomster av foregående tegn, slik at `do+g` matcher **dog** og **doog** osv, men ikke **dg**. Men for at det skal fungere, må man enten ta escape av plusstegnet eller bruke utvidet **`regex`**. For kontroll kan gjøre én av følgende (men for fremtiden, altså helst ikke den siste):

```bash
echo 'dg dog doog' | grep 'do\+g'
echo 'dg dog doog' | grep -E 'do+g'
echo 'dg dog doog' | egrep 'do+g'
```

:::ansiout
<pre class="ansi2html-content">
dg <span class="ansi1 ansi31">dog</span> <span class="ansi1 ansi31">doog</span>
</pre>
:::

Vi ser at itvidede regulære uttrykk (ERE) er mer lesbar og å foretrekke.

**Merk**: I eksempelet med filendelse **.txt** lenger opp, må man benytte escape for punktum også med `grep -E`. Punktum behandles spesielt også i det utvidede tilfellet.

`{n}` står for `n` repetisjoner av foregående tegn, `{n,}` står for minst n repetisjoner, mens {n,m} står for minst **n** og høyst **m** repetisjoner av foregående tegn. Dvs at `91{2}` matcher **911**, og `91{2,}` matcher **911**, **9111**, **91111**, ..., mens `91{2,3}` matcher **911** og **9111**, men ikke **91111**. Krøllparentes må espapes i vanlige uttrykk, så her er det greit på benytte den utvidede varianten:

```bash
echo '911 9111 91111 911111 111' | grep -E '91{2}'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">911</span> <span class="ansi1 ansi31">911</span>1 <span class="ansi1 ansi31">911</span>11 <span class="ansi1 ansi31">911</span>111 111
</pre>
:::

```bash
echo '911 9111 91111 911111 111' | grep -E '91{2,}'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">911</span> <span class="ansi1 ansi31">9111</span> <span class="ansi1 ansi31">91111</span> <span class="ansi1 ansi31">911111</span> 111
</pre>
:::

```bash
echo '911 9111 91111 911111 111' | grep -E '91{2,3}'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">911</span> <span class="ansi1 ansi31">9111</span> <span class="ansi1 ansi31">9111</span>1 <span class="ansi1 ansi31">9111</span>11 111
</pre>
:::

Her ser vi bruk av `\b`:

```bash
echo cat bobcat | grep '\bcat'
```

```bash
echo cat catalog | grep '\bcat\b'
```

Her ser vi bruk av både `\b`:

```bash
echo 'err error' | grep -E '\b\w{3}\b'
```

Spørsmålstegn (`?`) betyr at tegnet foran er opsjonelt, slik at f.eks. `colou?r` matcher både det amerikanske **color** og det britiske **colour**.

```bash
echo 'color colour coloor' | grep 'colou\?r'
echo 'color colour coloor' | grep -E 'colou?r'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">color</span> <span class="ansi1 ansi31">colour</span> coloor
</pre>
:::

Pipe (`|`) benyttes for flere mønstre, som en eller-operator:

```bash
echo 'cat cats dog dogs ctdg' | grep 'cat\|dog'
echo 'cat cats dog dogs ctdg' | grep -E 'cat|dog'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">cat</span> <span class="ansi1 ansi31">cat</span>s <span class="ansi1 ansi31">dog</span> <span class="ansi1 ansi31">dog</span>s ctdg
</pre>
:::

Vi ser at utvidede uttrykk normalt er å foretrekke. (Og vi ser nå også hva som egentlig foregikk i det tidligere `linux|windows`-eksempelet vårt.)

Parenteser benyttes for gruppering. Her finne vi f.eks. alle forekomster av **set** prefikset med én eller flere **sun**:

```bash
echo 'set sunset sunsunset' | grep -E '(sun)+set'
```

:::ansiout
<pre class="ansi2html-content">
set <span class="ansi1 ansi31">sunset</span> <span class="ansi1 ansi31">sunsunset</span>
</pre>
:::

Klassen `[abc]` representerer **a** eller **b** eller **c**, slik at `[LNT]ine` matcher både **Line**, **Nine** og **Tine**, men ikke **Katrine**.

```bash
echo 'Line Nine Tine Katrine' | grep '[LNT]ine'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">Line</span> <span class="ansi1 ansi31">Nine</span> <span class="ansi1 ansi31">Tine</span> Katrine
</pre>
:::

`[^abc]` representerer det omvendte av `[abc]`, slik at `[^LNT]ine` matcher både **mine**, **sine**, **rine** og **fine**, men ikke lenger **Line** osv.

```bash
echo 'Line Nine Tine Katrine' | grep '[^LNT]ine'
```

:::ansiout
<pre class="ansi2html-content">
Line Nine Tine Kat<span class="ansi1 ansi31">rine</span>
</pre>
:::

Klassen `[a-z]` representerer alfabetintervallet av alle små (engelske) bokstaver fra **a** til **z**, mens `[A-Z]` representerer de tilsvarende store. Om man vil, kan man se på begrensede intervaller, som f.eks. `[J-V]` osv. Norske bokstaver godtas ikke i intervaller, selv om **æ**, **ø** og **å** er søkbare tegn i **regex** ellers.

Sifrene representeres av `[0-9]`, og man kan selvsagt velge sub-intervaller.

`[a-zA-Z]` representer både store og små bokstaver, mens `[a-zA-Z0-9]` representerer både små bokstaver, store bokstaver og sifre. Rekkefølgen av disse har ingenting å si i matching. La oss se på eksempler.

Under søkes det etter stor bokstav etter fulgt av liten, men ikke med forekomster for sent i alfabetet:

```bash
echo 'Anne Beate Jan Tore' | grep '[A-K][a-m]'
```

:::ansiout
<pre class="ansi2html-content">
Anne <span class="ansi1 ansi31">Be</span>ate <span class="ansi1 ansi31">Ja</span>n Tore
</pre>
:::

Det følgende søker etter alt som er bokstaver eller sifre. Og da matcher jo alt unntatt tegn som f.eks. pluss og minus:

```bash
echo '+45 AB C3 python-3' | grep '[a-zA-Z0-9]'
```

:::ansiout
<pre class="ansi2html-content">
+<span class="ansi1 ansi31">4</span><span class="ansi1 ansi31">5</span> <span class="ansi1 ansi31">A</span><span class="ansi1 ansi31">B</span> <span class="ansi1 ansi31">C</span><span class="ansi1 ansi31">3</span> <span class="ansi1 ansi31">p</span><span class="ansi1 ansi31">y</span><span class="ansi1 ansi31">t</span><span class="ansi1 ansi31">h</span><span class="ansi1 ansi31">o</span><span class="ansi1 ansi31">n</span>-<span class="ansi1 ansi31">3</span>
</pre>
:::

Her derimot søkes det mer konkret etter en bokstav eller siffer etterfulgt av kolon:

```bash
echo '+: abc: 347: ---:' | grep '[a-zA-Z0-9]:'
```

:::ansiout
<pre class="ansi2html-content">
+: ab<span class="ansi1 ansi31">c:</span> 34<span class="ansi1 ansi31">7:</span> ---:
</pre>
:::

Under søker vi konkret etter siffer etterfulgt av stor bokstav etterfulgt av liten bokstav:

```bash
echo 'AN3 Bn4 aX5 6vH 3Nr' | grep '[0-9][A-Z][a-z]'
```

:::ansiout
<pre class="ansi2html-content">
AN3 Bn4 aX5 6vH <span class="ansi1 ansi31">3Nr</span>
</pre>
:::

Det er også mulig å legge inn flere tegn enn bokstaver å tall i klassen, f.eks. `[a-zA-Z0-9&_-]`. Dette inkluderer i tillegg til bokstaver og tall her ampersand, underscrore og minustegn.

Eksemplene våre er illustrerende, men lite nyttige. La oss prøve et mer realistisk eksempel, f.eks. å sjekke om en e-post-adresse har lovlig format. Det følgende er langt fra perfekt, `[.a-zA-Z0-9_-]+@[.a-zA-Z]+`, men matcher i det minste adresser som: **jan_roger2.home@gmail.co.uk**, og **jan.roger-home@gmail.com** etc. Uttrykket godtar riktignok også adresser som **`.3---3...3___@.cm.`**, så det er et stykke igjen her. Men det illustrerer vel en del av funksjonaliteten av **regex** like fullt. Uttrykket vårt godtar mer spesifikt én eller flere klynger av bokstaver, tall og våre tre spesialtegn, etterfulgt av @ og en eller flere klynger av bokstaver og punktum. F.eks

```bash
echo 'jan.roger-home@gmail.com' | grep -E '[.a-zA-Z0-9_-]+@[.a-zA-Z]+'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">jan.roger-home@gmail.com</span>
</pre>
:::

Om ikke annet ville uttrykket ha stoppet en adresse som **jan.roger@gmail2-com**.

Men oppgaven var nok i vanskeligste laget, så la oss ta et annet. Her letes det fram produktnumre (kanskje) med et fast format og som slutter på **-333**. Det må være nøyaktig tre store bokstaver, bindestrek, tre sifre, bindestrek før 333.

```bash
echo 'NOX-901-333 FOX-875-334' | grep -E '[A-Z]{3,3}\-[0-9]{3,3}\-3{3}'
```

:::ansiout
<pre class="ansi2html-content">
<span class="ansi1 ansi31">NOX-901-333</span> FOX-875-334
</pre>
:::

Bindestrekene her trenger backslash foran seg selv ved bruk av `-E`.


## 🔍 rg

La oss se på den moderne varianten `rg`. For det første vil den fungere uten videre for alle **grep**-eksemplene vist i boken. F.eks. kunne vi erstattet:

```bash
echo 'set sunset sunsunset' | grep -E '(sun)+set'
```

med 

```bash
echo 'set sunset sunsunset' | rg '(sun)+set'
```

:::ansiout
<pre class="ansi2html-content">
set <span class="ansi1 ansi31">sunset</span> <span class="ansi1 ansi31">sunsunset</span>
</pre>
:::

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

Regulære uttrykk benyttes også med andre kommandoer, særlig i `sed`, og skallskript, så vi kommer mer tilbake til dette.

