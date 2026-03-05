# ➰ curl og wget

`curl` er et verktøy for å overføre filer fra eller til en tjener ved hjelp av URL-er. wget er kun for å hente filer fra URL-er.

Et nyttig sted i den sammenheng er **Bashupload** (https://bashupload.com/). Ikke bare får vi demonstrert `curl`- og `wget`-kommandoene, man man kan også laste opp filer for typisk å laste dem ned et annet sted, hvilket man ofte kan trenge. Begrensningene er at størrelsen må være under 50 GB (så store filer tar uansett svært lang tid for å laste opp), de lagres i tre dager og at filene bare kan lastes ned én gang. Det kan være lurt å kryptere filer man laster opp. Kommandoen for å laste opp en fil **lokal-fil.asc**, blir uansett som eksemplifisert her:

```bash
curl https://bashupload.com/ -T lokal-fil.asc
```

Opsjon `-T` tilsier at man vil bruke **FTP**-protokollen for overføring.

Man får instruksjoner om hvordan man kan laste ned igjen filen i retur (ved hjelp av `wget`), ved noe som likner:

```output
wget https://bashupload.com/v8fYh/y9Jsf.asc
```

Filnavnet på **Bashupload** blir noen ganger tilfeldig, som her, men andre ganger beholdes filnavnet (over en tilfeldig katalog) som vist i eksempler lenger ned. Det ser ut som systemet gjenkjenner noen filendelser, som **.jpg** etc., og prøver å behold dem, men f.eks. ikke for **.odt**  fra LibreOffice.


Outputen fra `curl`-kommandoen, som sendes til skjerm, inneholder både det opprinnelige filnavnet og det viktige nedlastingsnavnet. Det er derfor naturlig å sende `curl`-outputen til en fil man tar vare på. Derfor er kanskje følgende opplastingskommando bedre å gi:

```bash
curl https://bashupload.com/ -T lokal-fil.asc | tee -a howToGet.txt
```

Denne splitter output, som havner både til skjerm og tilføyes filen **howToGet.txt**. Legger man i tillegg til dato og klokkeslett til outputen, bør alt ligge til rette for vellykket nedlasting senere.

`curl` støtter såkalt *globbing*, slik at flere filer kan lastes opp samlet ved én kommando. Under ser vi flere eksempler, der også tilhørende linjer fra output med nedlastingsinstruksjon er vist:

```bash
curl -T 'jan-[1-99].jpg.asc' https://bashupload.com/
```

```output
wget https://bashupload.com/FriwY/jan_1.jpg.asc
wget https://bashupload.com/Nr8XN/jan_2.jpg.asc
```

Her overlevde både filnavn og endelser.

Eller man kan utføre (ingen space mellom filene):

```bash
curl -T '{jan-1.jpg.asc,janRapport.odt.asc}' https://bashupload.com/
```

```output
wget https://bashupload.com/q3p3c/jan_1.jpg.asc
wget https://bashupload.com/eY8oB/fzMRe.asc
```

eller

```bash
curl -T '{jan.jpg,marianne.jpg}.asc' https://bashupload.com/
```

```output
wget https://bashupload.com/tQzjN/jan.jpg.asc
wget https://bashupload.com/Cftd7/2V5J0.asc
```

`wget` er en gratis program for nedlasting av filer fra vebb. Den er inkludert i Ubuntu. Outputene over viser enkeltkommandoer for vanlig nedlasting fra Bashupload**. Ønskes det at jobber skjer i bakgrunn (nedlastingstidene kan variere), bruk opsjon -b. Output havner da i filen **wget-log**. Vil man følge med i den, utfør f.eks. `tail -f wget-log`.

Har man flere filer å laste ned, kan man legge URL-ene (og kun dem) på separate linjer i en tekstfil, f.eks. **my-urls.txt**, og isteden uføre:

```bash
wget -i my-urls.txt
```

Skal man laste opp mange filer, er det kanskje greiest å tar-zippe til én fil (og helst kryptere denne).

**Merk**: Man kan enkelt laste opp filer (f.eks. bilder) fra mobil, nettbrett eller noe annet uten kommandolinje, bare ved å gå til **bashupload.com**.

**Merk**: Alt om `gpg`-kryptering er i et etterfølgende kapittel, men kort fortalt er `gpg -ac fil` alt som trengs å kryptere fil med et passord man må velge i en dialog. Resultatet blir en kryptert fil **fil.asc** som kan lastes opp ved `curl`.