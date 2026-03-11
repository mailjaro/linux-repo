# 💾 tar og gzip

`tar` pakker essensielt et fitre sammen til én fil, mens `gzip` komprimerer (zipper) filer ned til minimal størrelse. Disse kombineres mange ganger i én og samme kommando. Dette kan utnyttes ved filoverføring, sikkerhetskopiering og annet.

Vanlig bruk tilsvarer såkalt full arkivering, og det beskrives først. Men det er også mulig å ta inkrementell og differsensiell arkivering/backup, der kun endrede filer arkiveres. Vi skal se på det etterpå.

## Full arkivering

Slik kan man skape en komprimert **tar**-fil (arkivfil):

```bash
tar -czf arkiv.tar.gz fil*.tmp
```

Her lager vi (`-c`) en arkivfil (`-f`) med navnet **arkiv.tar.gz** fra alle filer som passer navnmønster **fil\*.tmp**. Arkivfilen komprimeres så med `gzip` (pga. opsjonen `-z`). (Alternativ komprimeringsalgotitme kan velges ved opsjoner.) Ved konvensjon bør alle slike `gzip`-komprimerte arkivfiler ende på **.tar.gz** (evt. **.tgz**).

Ønsker man å liste filene i arkivet, gjøres det ved opsjonen `-t` (evt. supplert med `-v` for mer informasjon):

```bash
tar -tvzf arkiv.tar.gz
```

(`z`-opsjonen kan strengt tatt droppes her.) For å pakke ut arkivfiler benyttes `-x`, gjerne supplert med `-v` for å se filnavn som pakkes ut underveis:

```bash
tar -xvzf arkiv.tar.gz
```

Denne pakker ut alt til gjeldende katalog. Ønsker man å pakke ut til en annen, bestemt katalog, benytt opsjonen `-C` og angivelse av sted, som f.eks.

```bash
tar -xvzf arkiv.tar.gz -C /media/jan/USB-disk
```

**Merk**: Når man har benyttet konvensjonell filendelse, slipper man å spesifisere komprimeringsalgortime.

Ønsker man bare å pakke ut enkeltfiler fra arkivet, kan dette gjøres ved å supplere kommandoen over med de filene man ønsker, som f.eks.

```bash
tar -xvf arkiv.tar.gz fil-1.tmp
```

Dersom man ønsker å ekskludere bestemt kataloger (eller filer) fra å havne i arkivet, benytte opsjonen -`-exclude='katalog'` rett i etterkant av tar før øvrige opsjoner. Man kan ha en hel serie av slike for å ekskludere flere kataloger/filer. Eksempler er vist i skallskript-kapittelet.

Dersom man ønsker å fjerne zippingen av arkivet, kan man utføre:

```bash
gzip -d arkiv.tar.gz
```

Da ender man opp med et ukomprimert arkiv med navn **arkiv.tar**.

En annen mye brukt pakkealgoritme er `zip` (som produserer arkivfiler med navn som **arkiv.zip**).  Disse pakkes ut med `unzip arkiv.zip`.

Fra det ukomprimert arkivet kan man f.eks. hente ut enkeltfiler, slette dem i arkivet, for så å legge til nye versjoner av filene og komprimere alt på nytt. Stegene er eksemplifisert ved følgende fem kommandoer, der man kan tenke seg at man har endret den aktuelle filen før den legges på plass igjen i linje tre:

```bash
tar -xvf arkiv.tar fil-1.tmp		 # Henter ut angitt fil fra arkiv
tar --delete -f arkiv.tar fil-1.tmp	 # Sletter angitt fil i arkiv
tar --append -f arkiv.tar fil-1.tmp	 # Filen legges tilbake i arkiv
gzip arkiv.tar						 # Arkivet zippes på nytt
rm fil-1.tmp						 # Fjerner nylig arkivert fil
```

Man kan også ønske å kryptere arkivfilen. I så fall må man huske å slette arkivfilen.

## Inkrementell og differensiell arkivering

Både inkrementell og differensiell arkivering (backup) baserer seg på en initiell full backup, også kalt nivå 0-backup. Mens en full backup alltid lager et nytt arkiv av filene den har ansvar for, forsøker de to andre kun å ta sikkerhetskopi av endrede filer. Måten de måler endring på, skiller dem. En inkrementell backup ser på foregående inkrementelle backup som basis, mens en differensiell backup ser på initielle nivå 0-backup som basis. For å gjenskape filer fra en inkrementell backup, trengs nivå 0 og hele serien av inkrementelle backuper etter den. Vi kan da bare gjenskape filene fram til og med siste feilfrie inkrementelle backup. Alt etter det er tapt. For å gjenskape en differensiell backup, trengs nivå 0 og den differensielle backupen for akkurat den aktuelle dagen (hvis sikkerhetskopifrekvensen er dag).

La oss se på eksempler.

### Inkrementell backup

Vi skal her få laget oss både en **tar**-fil (arkivet) og en snapshot-fil (med metadata) som ved konvensjon har filendelse **.snar**. Anta i fortsettelsen at disse skal legges på et sted refereres `$TARGET`. Dette vil være en stivariabel man kan sette tidlig i skallet eller skriptet, f.eks. slik:

```bash
TARGET=/home/jan/Backup
```

Vi trenger også å bestemme navn på **tar**- og **snar**-filene. Nå er det sånn at i det inkrementelle tilfellet må **tar**-filnavnet endres hver gang, mens snar-filen overskives og bør ha samme navn. Det er derfor naturlig å inkludere et løpenummer på **tar**-filen, og velge løpenummer 0 på første. (Alternativt kunne man basert seg på dato.) Vi velger derfor å starte med **ink-arkiv-0.tar.gz** og **ink-arkiv.snar.gz** for arkiv og metafil. Og de neste **tar**-filene bør bli **ink-arkiv-1.tar.gz**, **ink-arkiv-2.tar.gz** osv. Anta videre at vi skal ta sikkerhetskopi av en katalog (og dens undertre) vi kan referere som `$SOURCE`, f.eks:

```bash
SOURCE=/home/jan/Testkatalog
```

Da blir kommandoen for første nivå 0-backup:

```bash
tar -vczf $TARGET/ink-arkiv-0.tar.gz -g $TARGET/ink-arkiv.snar.gz $SOURCE
```

**Merk**: Kommandoen er som for full backup, med unntak av `-g`-delen.

**Merk**: Systemet merker at arkivet er nytt, altså at det er en nivå 0-backup (med tilhørende metadata).

**Merk**: Meldingen om fjerning av ledende **/** i navn, som dukker opp, er ingen feilmelding, men en opplysning. Det skal visstnok kunne undertrykkes ved å inkluder opsjonen `-P` i første opsjonsklynge.


Når vi skal foreta neste (andre) inkrementelle backup, utføres samme kommando som første, bare at man bytter ut **ink-arkiv-0.tar.gz** med **ink-arkiv-1.tar.gz**. Navnet på snar-filen beholdes.

```bash
tar -vczf $TARGET/ink-arkiv-1.tar.gz -g $TARGET/ink-arkiv.snar.gz $SOURCE
```
Neste (tredje) der igjen blir

```bash
tar -vczf $TARGET/ink-arkiv-2.tar.gz -g $TARGET/ink-arkiv.snar.gz $SOURCE
```

osv. Slik fortsetter man med å ta nye inkrementelle backuper etter behov (bare man husker å endre løpenummeret). Det er sikkert best å legge kommandoen inn i et skript med en løpenummervariabel som kan avleses og inkrementeres.

For å se innholdet av arkivet for et bestemt løpenummer, f.eks. den tilhørende **ink-arkiv-2.tar.gz**, utføres følgende:

```bash
tar -tvzg /dev/null -vzf $TARGET/ink-arkiv-2.tar.gz
```

Hvordan gjenskapes filene fra dette systemet? Man starter med å gjenskape nivå 0, deretter nivå 1, før nivå 2 osv. I eksempelet under vises dette, og det ønskes å gjenskape filene på sted referert med `$NYTARGET`. Det kan være samme sted som filene kom fra (altså `$SOURCE` over), gjeldende katalog eller et annet sted. Filer med samme navn som de gjenskapte på katalogen, blir uansett (naturlig nok) slettet underveis.

Her velges det å gjenskape filene på opprinnelig sted, slik at det er satt:

```bash
NYTARGET=$SOURCE
```

Da utfører man først:

```bash
tar --directory=$NYTARGET -xvzf $TARGET/ink-arkiv-0.tar.gz -g /dev/null
```

Her blir først de initielle situasjonen gjenskapt. Og videre utfører man i tur og orden:

```bash
tar --directory=$NYTARGET -xvzf $TARGET/ink-arkiv-1.tar.gz -g /dev/null
tar --directory=$NYTARGET -xvzf $TARGET/ink-arkiv-2.tar.gz -g /dev/null
tar --directory=$NYTARGET -xvzf $TARGET/ink-arkiv-3.tar.gz -g /dev/null
```

Hele filtreet (slik situasjonen var da backup nr. 4 med løpenummer 3 ble foretatt) blir da korrekt gjenskapt.

### Differensiell backup

Kommandoene i dette tilfellet er nokså like, men man må unngå å overskrive snapshot-filen til nivå 0. Vi skal igjen lage oss en serie backuper, la oss si **dif-arkiv-0.tar.gz**, **dif-arkiv-1.tar-gz**, **dif-arkiv-2.tar.gz**, osv. Den første inkrementelle metafilen kan vi nå kalle **dif-arkiv-0.snar.gz**. Hvis vi så kopierer denne til **dif-arkiv-1.snar.gz** til bruk med **dif-arkiv-1.tar.gz**, kopierer den til **dif-arkiv-2.snar.gz** til bruk med **dif-arkiv-2.tar.gz** osv., får vi en serie med slike **tar**/snar-par. Sammen utgjør de en differensiell backup, og som par kan de alene gjenskape filsituasjonen (fram til da).

```bash
tar -czf $TARGET/diff-arkiv-0.tar.gz -g $TARGET/diff-arkiv-0.snar.gz $SOURC
cp $TARGET/dif-arkiv-0.snar.gz $TARGET/dif-arkiv-1.snar.gz
tar -czf $TARGET/diff-arkiv-1.tar.gz -g $TARGET/diff-arkiv-1.snar.gz $SOURCE
```

```bash
cp $TARGET/dif-arkiv-0.snar.gz $TARGET/dif-arkiv-2.snar.gz
tar -czf $TARGET/diff-arkiv-2.tar.gz -g $TARGET/diff-arkiv-2.snar.gz $SOURCE
```

```bash
cp $TARGET/dif-arkiv-0.snar.gz $TARGET/dif-arkiv-3.snar.gz
tar -czf $TARGET/diff-arkiv-3.tar.gz -g $TARGET/diff-arkiv-3.snar.gz $SOURCE
```

osv. Merk at det altså den initielle snar-filen vi tar kopi av hver gang.

For å gjenskape f.eks. backup med løpenummer hhv. 0 eller 3 (med samme katalogantakelser som under inkrement-eksempelet), utfør hhv:

```bash
tar --directory=. -xvf $TARGET/diff-arkiv-0.tar.gz -g /dev/null
```

eller

```bash
tar --directory=. -xvf $TARGET/diff-arkiv-3.tar.gz -g /dev/null
```