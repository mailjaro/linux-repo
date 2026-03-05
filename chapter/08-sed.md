# ✂️ sed og sd

## ✂️ sed

`sed`, kort for *stream editor*, erstatter tekstmønstre i filer eller kommandostrømmer. Den er mye brukt.
 
I det første eksempelet erstattes (`s` for *substitute*) første forekomst av **linux** med **LINUX** i hver linje i en tekstfil:

```bash
sed 's/linux/LINUX/' tekstfil.txt
```

Resultatet sendes til skjermen, og selve tekstfilen blir uforandret. Man kan endre originalfilen ved opsjon `-i`:

```bash
sed -i 's|linux|LINUX|' tekstfil.txt
```

Eksempelet viser også at vi ikke trenger å bruke `/` som skilletegn, men også `|` eller punktum går like bra. Det kan være nyttig hvis man f.eks. skal slette/bytte ut forekomster av skråstrek.

Ønsker man dessuten å lage en backup før filendringen, kan man etterfølge `-i` med en ønsket filendelse, f.eks. **.bak**:

```bash
sed -i.bak 's/linux/LINUX/' tekstfil.txt
```

Da får man en fil **tekstfil.txt.bak**, med innhold altså lik det **tekstfil.txt** hadde før endringen.

Bare første forekomst i hver linje erstattes i disse eksemplene. Ønsker man å erstatte alle forekomster i en linje, kan man ende mønsteret med `g`. Det følgende erstatter eksempelvis alle blanke med bindestrek:

```bash
sed 's/ /-/g' tekstfil.txt
```

Om man har en fil med tabulatorer og ønsker å bytte ut dem med mellomrom, kan man tilsvarende gjøre:

```bash
sed 's/\t/ /g' tekstfil.txt
```

Start av linje symboliseres i mønstre av `/^` og slutten med `$/`. Om innholdet av en **testfil.txt** er:

```output
bin
Desktop
Documents
Downloads
tiger.JPG
lion.JPG
```

vil

```bash
sed -i 's/^D/d/' testfil.txt
sed -i 's/.JPG$/.jpg/' testfil.txt
```

gi

```output
bin
desktop
documents
downloads
tiger.jpg
lion.jpg
```

Følgende sletter dermed alle tomme linjer:

```bash
sed '/^$/d' testfil.txt 
```

De siste er eksempler med regulære uttrykk, og vi skal si mer om det straks.

Men før det, må vi se på flere aksjoner/instruksjoner.

Man kan slette linjer som inneholder et bestemt mønster ved `d` (*delete*). Følgende linje sletter alle linjer dermed som inneholder teksten tiger:

```bash
sed '/tiger/d' testfil.txt
```

Man kan reversere **mønsteret** ved `!`, sånn at f.eks. det følgende sletter alle linjer som ikke inneholder mønsteret **tiger**:

```bash
sed '/tiger/!d' testfil.txt
```

Man kan også slette spesifikke linjer, f.eks. linje 2, ved

```bash
sed '2d' testfil.txt
```
eller linjene 2 til 4 ved

```bash
sed '2,4d' testfil.txt
```

Isteden for å slette eller erstatte mønstre, kan man printe dem ved opsjonen `-n` og instruksjonen `p`. Det er nyttig i en testfase. Det følgende eksemplifiserer:

```bash
sed -n ’/tiger/p’ testfil.txt
sed -n '2,4p' testfil.txt
```

Ønsker man å legge inn nye linjer, kan man benytte instruksjonen `i` (for *insert*). Følgende legger inn en ny linje før linjer med mønsteret **tiger**:

```bash
sed '/tiger/i Ny linje' testfil.txt
```

```output
bin
desktop
documents
Ny linje
downloads
tiger.jpg
lion.jpg
```

Man kan også legge inn ny linje før et bestemt linjenummer, f.eks. linje 5, med:

```bash
sed '5i fox.png' testfil.txt
```

Ønsker man å legge inn linjer etter isteden for før, bytter man bare ut `i` med `a` (*append*):

```bash
sed '/tiger/a Ny linje' testfil.txt
sed '5a fox.png' testfil.txt
```

Man kan også gjøre erstatninger på bare på et bestemt linjenummer, f.eks. linje 2, med:

```bash
sed '2s/desk/hard/' testfil.txt
```

```output
bin
hardtop
documents
downloads
tiger.jpg
lion.jpg
```

Ønsker man å utføre flere ting i samme kommando, f.eks. både en erstatning og en sletting, kan man benytte `-e` som følger:

```bash
sed -e 's/d/D/g' -e '/jpg/d' testfil.txt
```

```output
bin
Desktop
Documents
DownloaDs
```

Her slettet vi alle linjer som inneholdt **jpg** og erstattet alle `d` med `D`.

La oss se nå nærmere på regulære uttrykk. Som `grep`, har også sed en opsjon `-E` for utvidede regulære uttrykk. Se beskrivelser om **regex** i **grep**-kapittelet.

Betydningen av punktum og stjerne er som beskrevet der. Det følgende erstatter dermed alt etter **ig** med **og** i testfilen vår:

```bash
sed -E 's/ig.*/og/' testfil.txt
```

```output
bin
desktop
documents
downloads
tog
lion.jpg
```

Eller-funksjon fungerer også. Her erstattes alle mønster som passer **tiger** eller **lion** med **animal**:

```bash
sed -E 's/tiger|lion/animal/g' testfil.txt
```

```output
bin
desktop
documents
downloads
animal.jpg
animal.jpg
```

Karakterklasser kan også anvendes som omtalt tidligere. Her fjernes f.eks. alle ikkenumeriske tegn:

```bash
echo '+47-914N' | sed -E 's/[^0-9]//g'
```

```output
47914
```

Her vises bruk av repetisjoner (2 eller flere `t` byttes ut med `T`):

```bash
echo hot hetttte hattte  | sed -E 's/t{2,}/T/g'
```

```output
hot heTe haTe
```

Grupperinger kan også brukes. Her søker det etter tre bokstavgrupper, og rekkefølgen av disse byttes om (med kolon imellom). Merk at første ordgruppe i slike grupperinger kan refereres med \
`\1`, andre med `\2` osv.

```bash
echo 'Jan Roger Sandbakken' | sed -E 's/([A-Za-z]+) ([A-Za-z]+) ([A-Za-z]+)/\3:\1:\2/'
```

```output
Sandbakken:Jan:Roger
```

La oss avslutte med eksempel som viser styrken og fleksibiliteten med regulære uttrykk i `sed`. Dette gjør om tall som f.eks. 84500000 til 84,500,000:

```bash
echo 84500000 | sed -E ':a;s/([0-9])([0-9]{3})(,|$)/\1,\2\3/;ta'
```
output
```
84,500,000
```

Om man ønsker annen separator her, f.eks. hhv. kolon eller mellomrom, kan man gjøre

```bash
echo 84500000 | sed -E ':a;s/([0-9])([0-9]{3})(:|$)/\1:\2\3/;ta'
```

```output
84:500:000
```

```bash
echo 84500000 | sed -E ':a;s/([0-9])([0-9]{3})( |$)/\1 \2\3/;ta'
```

```output
84 500 000
```

Det er mye som foregår her. Starten `:a;` og slutten `;ta` sørger både navngir søket/erstatningen som **a**, og det itereres så lenge det kan gjøres erstatninger. Det søkes etter single tall før gruppe med tre sifre etterfulgt enten av komma eller slutt på linje. Deretter settes det inn et komma mellom det single tallet og gruppen av tre sifre. Dermed blir kommaer satt korrekt inn iterativt fra høyre til venstre.

La oss koste på oss en ekstra forklaring her. Første iterasjon blir:

```bash
echo 84500000 | sed -E 's/([0-9])([0-9]{3})(:|$)/\1:\2\3/'
```

```output
84500:000
```

I starttallet 84500000 blir `\3` slutt på linje, `\2` den avsluttende siffergruppen 000, mens `\1` blir sifferet før denne gruppen. Det legges inn et kolon mellom `\1` og `\2`, og vi får outputen over

I neste iterasjon går man løs på tallet 84500:000. Her blir `\3` de avsluttende tre sifrene 000, mens `\2` blir gruppe 500 og \1 sifferet foran det igjen. Det dyttes inn et kolon mellom de to sistnevnte, og vi får output som vist:

I neste iterasjon går man løs på tallet 84500:000. Her blir `\3` de avsluttende tre sifrene 000, mens `\2` blir gruppe 500 og `\1` sifferet foran det igjen. Det dyttes inn et kolon mellom de to sistnevnte, og vi får output som vist:

```bash
echo 84500:000 | sed -E 's/([0-9])([0-9]{3})(:|$)/\1:\2\3/'
```

```output
84:500:000
```

Deretter får man ikke gjort flere erstatninger og iterasjonen stopper.

## ✂️ sd

Den moderne rust-utgaven av `sed` heter `sd`, som er enklere både til grunnleggende bruk og til mer avansert bruk med regulære uttrykk. La oss starte med det grunnleggende.

Hvis man f eks skal bytte ut alle forekomster av ordet *windows* med ordet *linux* i sett av filer, kan man gjøre:

```bash
sd 'windows' 'linux' *.txt
```

❗**Merk:** `sd` bytter ut alle forekomster i filen, ikke bare første forekomst i hver linje som `sed` (med mindre **g**-endelsen inkluderes).

Ønsker man bare å se sluttresultatet uten å endre filene, kan man benytte preview-opsjonen `-p`:

```bash
sd  -p 'windows' 'linux' *.txt
```

Den ferdige erstattede outputen printes til skjermen og fargekoder de nye mønstrene fint og oversiktlig.

Opsjonen `-n` kan benyttes til å begrense antall substitusjoner. Andre opsjoner inkluderes som flag (**REGEX**-flagg). Dette inkluderer

* c - det skilles mellom store og små bokstaver (default)
          
* e - match over flere linjer ikke mulig
          
* i - det skilles *ikke* mellom små og store bokstaver
          
* m - match over flere linjer mulig
          
* s - gjør at `.` matcher *newline*
          
* w - match bare av hele ord
Disse må etterfølge flaggopsjonen `-f`. Eksempelvis, for å ikke skille mellom små og store bokstaver (`-i`), samt bare matche hele ord (`-w`), kan man gjøre:

```bash
sd -p -fiw 'windows' 'linux' *.txt
```

(her også i preview-mode pga `-p`)

❗**Merk:** Eventuelle store bokstaver fra mønster nr. 1 blir her gjort om til små (siden mønster nr. 2 kun inneholder små bokstaver).

Det følgende erstatter blanke med tabulator:

```bash
sd -p ' ' '\t' testfil.txt
```

og denne punktum og dobbelblanke med punktum og singelblank:

```bash
sd -p '\.  ' '. '
```

❗**Merk:** Vi må benytte `\t` også i mønster 2 for å angi en tabulator i eksempel 1, men bare punktum for punktum i mønster 2 i det siste eksempelet.

Mye av den grunnleggende bruken er dekket med disse eksemplene. La oss se mer på bruk av regulære uttrykk. `sd` følger samme konvensjon som `rg`, forklart i kapittelet om **grep/rg**. 

Det følgende erstatter eventuelt dermed all forekomster av **at** og **AT** med **@** (**|** representerer **eller**):

```bash
echo 'meatdisney.com youATdisney.com' | sd 'at|AT' '@'
```

```output
me@disney.com you@disney.com
```

```bash
echo 'a1c23e456' | sd '\d' ':'
```

```output
a:c::e:::
```

```bash
echo 'Line Nine Tine Katrine' | sd '[LNT]' 'Kl'
```

```output
Kline Kline Kline Katrine
```

Anta vi har følgende tekstblokk i en fil **test.md**, og ønsker å erstatte innmaten (de tre linjene) ut kun ut fra kriteriet at de ligger mellom et hode **start** og en hale **end**.

```output
start
  Tekst linje 1
  Tekst linje 2
  Tekst linje 3
end
```

Vi kan da gjøre

```bash
sd '(?s)(start)().*?)(end)' '$1
  Ny første linje
  Ny andre linje
  Ny tredjelinje
$3' test.txt
```

som nettopp produserer:

```output
start
  Ny første linje
  Ny andre linje
  Ny tredjelinje
end
```

Kommandoen utnytter flagget `(?s)`, som søker over flere linjer (dvs. *newline* ignoreres) fra ordet **start** (`$1`) via innmaten (`$2`) til ordet **end** (`$3`).

**Merk**: Hadde vi droppet paranteser rundt det midtre mønsteret (innmaten) `.*?`, som vi kunne gjort, ville **end** blitt lageret som `$2`.

Anta omvendt at man ønsker å bytte ut hodet **start** og halen **end** til denne tekstblokken. Da kan man gjøre

```bash
sd '(?s)(start)(.*?)(end)' 'HODE${2}HALE' test.txt
```

og filen

```output
HODE
  Ny første linje
  Ny andre linje
  Ny tredjelinje
HALE
```

**Merk**: Hadde man skrevet `HODE $2 HALE` med mellomrom, hadde man introduert uønskede blanke tegn i filen. Og hadde man skrevet `HODE$2HALE` uten noe form for skille, ville man fått en feilmeling om flertydighet i input. Syntaksen  `HODE${2}HALE` er derfor korrekt i tilfeller som dette.

Det siste eksempelet er nyttig når man f.eks. ønsker å konvertere mellom ulike avsnittsstiler i et MD-dokument. I MD har man både kodeblokker og egedefinerte avsnittstiler som er tekst omsluttet av hode og hale som i eksemplene. De førstnevnte blokkene ser slik ut (men hvor backticks er erstattet av enkle anførselstegn for ikke å forvirre MD-editoren min):

```bash
'''output
Noe tekst
'''
```

De sistnevnte blokkene er på formen:

```bash
:::poem
Noe tekst
:::
```

Anta vi ønsker å konvertere en output-kodeblokk til en ny egendefinert output-stil for større kontroll. Ettersom man kan ha flere typer kodeblokker, kan man ikke uten videre ersatte forkomster av tre backticks. Kun riktige blokker skal editeres.

Følgende kommando fungerer:

```bash
sd '(?s)(```output)(.*?)(```)' ':::nyoutput${2}:::' test.md
```
Den ser på input som tre ordgrupper (hode-innmat-hale, `$1-$2-$3`) og sørger for rett substituering.

Output fra **ansi2html** er på formen (delvis forkortet av hensyn til lesbarhet):

```output
<!DOCTYPE ...>
<html>
<head>
<meta ...">
<title></title>
<style type="text/css"> ...</style>
</head>
<body class="...>
<pre class="ansi2html-content">
<span id="line-0">e<span class="ansi1 ansi31">r</span>
<span class="ansi1 ansi31">r</span>o
<span class="ansi1 ansi31">r</span></span>
<span id="line-1"></span>
</pre>
</body>
</html>
```

hvor man ønsker å beholde:

```output
<pre class="ansi2html-content"> 
    e<span class="ansi1 ansi31">r</span>                                      
    <span class="ansi1 ansi31">r</span>                                       
    o<span class="ansi1 ansi31">r</span>                                      
</pre>      
```

Igjen kan man se på input bestående av ordrupper som går over flere linjer:

```output
"[ NOE ] - [ <preclass ] - [ NOE ] -
 [ </pre> ] - [ NOE ] - [ </HTML> ]"
```

Her består den av seks ord, og man ønsker å beholde det andre, tredje og fjerde (`$2 $3 $4`). Om input er lagret i filen **test.html**, gir dermed følgende kommando ønsket output

```bash
sd '(?s)(.*?)(<pre class)(.*?)(</pre>)(.*?)(</html>)' '$2$3$4' test.html
```

Eller om man vil gjøre alt i én kommando:

```bash
 echo error | grep --color=always r  | ansi2html \
 | sd '(?s)(.*?)(<pre class)(.*?)(</pre>)(.*?)(</html>)' '$2$3$4'
```

og alt får endelig ønskede, fargekodene utseende:

```output
:::ansiout
<pre class="ansi2html-content">
e<span class="ansi1 ansi31">r</span><span class="ansi1 ansi31">r</span>o<span class="ansi1 ansi31">r</span>
</pre>
:::
```
