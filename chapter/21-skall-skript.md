## Skall-skript

Det er mye å si om skallskript. De har ulike datatyper, variable, arrayer, if-setninger, løkker, funksjoner, strengoperajsoner og annet. Det vil gå for langt å omtale alt i detalj. Det fins flere online-ressurser tilgjengelig, f.eks. Linux Handbook. Men vi må starte med å si litt om strenger.

### Litt om strenger i skall

Det meste vi håndterer når vi jobber i skall eller lager skallskript, er strenger. Kommandoer, opsjoner, stier og ulike argumenter er strenger. Vi har dessuten spesialtegn som har egen betydning og trenger egen behandling.
For det første er det verdt å merke seg at strenger konkateneres når de legges rett etter hverandre (altså uten space mellom). Konstruksjonen "Ole Robert""Nordmann" gir følgelig singelstrengen "Ola RobertNordmann".

Videre kan strenges omsluttes av både enkle og doble quotes, altså både som ’Ola Nordmann’ og "Ola Nordmann". Forskjellen er at singel quotes gir den faktiske karakteren for alle karakterer mellom paret. En singel quote kan derfor aldri skytes inn mellom disse, selv om man prøver å  prefikse den med \ eller noe. Doble quotes tolker noen spesialtegn, inklusive \, `, $, * og @, spesielt. Førstnevnte benyttes som prefiks for seg og de øvrige, for å få fram disse spesialtegnene (at \\ blir \, at \$ blir $ osv. mellom doble quotes). Betydningen av * i full generalitet mellom doble quotes er sammensatt, men den spiller rolle når filnavnangivelser skal bli ekspandert. Når og om en ekspansjon skjer, er også sammensatt.

Noen problemstillinger illustreres under. I det første eksempelet ekspanderes versjonen med dobbel quotes, men ikke den med single.

```output
STI="Testkatalog"; X="$STI/*.jpg"; Y='$STI/*.jpg'; echo $X; echo $Y
Testkatalog/photo-1.jpg Testkatalog/photo-2.jpg
Testkatalog’/*.jpg’

Om ls lister de to variantene, får vi:

```ouput
STI="Testkatalog"; X="$STI/*.jpg"; Y='$STI/*.jpg'; ls $X; ls $Y
Testkatalog/photo-1.jpg  Testkatalog/photo-2.jpg
ls: cannot access '$STI/*.jpg': No such file or directory
```

Dette var kanskje som forventet, men la oss se på flere eksempler. I det neste tilfellet ekspanderes  begge:

```ouput
X=$STI"/*.jpg"; Y=$STI'/*.jpg'; echo $X; echo $Y
Testkatalog/photo-1.jpg Testkatalog/photo-2.jpg
Testkatalog/photo-1.jpg Testkatalog/photo-2.jpg
```

Det fins regler som spesifiserer detaljene for alle skall, men disse er omfattende. Kanskje det beste i en startfase er å teste ut ulike notasjonsvalg for å se hvilke som fungerer etter intensjonene.
For det er også mulig å angi strenger, stier og filnavn uten quotes. Det følgende fungerer f.eks. helt utmerket. En ny fil Testkatalog/photo-3.jpg opprettes:

```output
STI=Testkatalog; NYTT=photo-3.jpg; touch $STI/$NYTT
```

Men prøver vi

```output
STI=Testkatalog; X=*.jpg; Y=$STI/$X; echo $X; echo $Y
wrong-photo-1.jpg wrong-photo-2.jpg
```

Testkatalog/photo-1.jpg Testkatalog/photo-2.jpg Testkatalog/photo-3.jpg
ser vi at det er fullt mulig å bli forvirret. Her lå det tydeligvis to jpg-filer på gjeldende katalog (wrong-1.jpg og wrong-2.jpg), og *.jpg ble ekspandert til disse i eksempelet over.

Med `Y="$STI/$X"` over, får vi samme resultat, men med `Y=’$STI/$X’` over, ville nederste linje i output bare blitt strengen $STI/$X. Vi må altså skille på innhold i strenger og hva de blir når de evt. blir forsøkt ekspandert ut.
Moralen er: Grundig testing kan være nødvendig i sammensatte skript.
Regulære uttrykk, regex og skall

### Grunnleggende ting og eksempler

Det er nyttig å vite hvilket skall man bruker, det være seg bash, ksh, zsh eller tcsh. Her er tre varianter som finner ut det:

```output
echo $shell
echo $0
ps -p $$
```

For å se hvilke som er tilgjengelige, utfør:

```output
cat /etc/shells
\# /etc/shells: valid login shells
/bin/sh
/usr/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash						# Restricted bash
/usr/bin/rbash
/usr/bin/dash					# Lighter bash
```

For å lese om historikken og karakteristika til ulike skall, se f.eks. link on howtogeek.

For å installere et nytt skall, f.eks. zsh, som er ganske populært, gjør:

```bash
sudo apt install zsh
```

For å kjøre:

```bash
zsh
```

og exit igjen for å gå ut og tilbake til forrige skall (eller avslutte siste). 

Når man lager skallskript trenger man i det minste variable, if-setninger og løkker. Bruk av det første eksemplifiseres her:

```output
#!/bin/bash
readonly PI=3.1415926
ALDER=22
echo $PI
ALDER=$(($ALDER+1))
echo $ALDER
bokstav='J'
streng='JAN'
DATO=$(date)
DATO=date`
```

Ingen blanke godtas rundt =. Variable kan lagre heltall, strenger og tegn. Prefikset readonly gir endringsbeskyttelse. Resultater fra kommandoer $(cmnd) eller `cmnd` (gammel notasjon) kan legges i variable som vist. Oppdatering av variabel er også vist.

If-setningen har følgende notasjon:

```output
#!/bin/bash
VAR='eple'

if [ $VAR == 'banan' ]; then
   echo 'Jeg liker banan'
elif [ $VAR == 'eple' ]; then
   echo 'Jeg liker eple'
else
   echo 'Jeg liker ikke frukt'
fi
```

elif- og else-gren kan droppes

Vi har tre løkker i bash: for, while og .
For-løkken fins både i en C- og en Python-variant:

```output
#!/bin/bash
for ((i = 1 ; i <= 10 ; i++)); do
 echo "i ="
 echo $i
done

#!/bin/bash
for i in {1..10}; do
    echo 'i ='
    echo $i
done

#!/bin/bash
i=0
while [ $i -lt 10 ]; do
    echo 'i er:'
    i=$(($i+1))
    echo $i
done
```

Vi har eq, lt, le, gt og ge som relasjonsalternativer f.eks. for while.

```output
#!/bin/bash
i=0
until [ $i -ge 10 ]; do
 echo 'i er:'
 i=$(($i+1))
 echo $i
done
```

Løkkene har mulighet for break og continue for å hoppe helt eller delvis ut av løkker. I tillegg vil exit hoppe ut av hele skriptet.

Skallskript kalles ofte med argumenter. I skriptet betegner $1 første argument, $2 andre argument osv. $@ betegner alle argumentene og $0 selve skriptnavnet. Dette er én av flere måter å behandle brukerangitte argumenter i skriptet.
En annen baserer seg på argumentflagg, som f.eks. -i <filnavn>, og bruken fremgår av eksempelet under (i et skript kalt test.sh):

```output
#!/bin/bash
while getopts ":i:o:" opt; do
 case $opt in
  i)
   echo "Input fil: $OPTARG"
   ;;
  o)
   echo "Output fil $OPTARG"
   ;;
 esac
done
```

Her er det to mulige flagg definert, -i og -o, og et par eksempler på bruk er vist under:

```output
./test.sh -i input.txt -o output.txt
Input fil: input.txt
Output fil output.txt
./test.sh -i input-1.txt -i inputfil-2.txt -o output.txt
Input fil: input-1.txt
Input fil: input-2.txt
Output fil output.tx
```

Angivelse av andre flagg blir i eksemplet bare ignorert.

Under vises et eksempel på et tar backup-skript som tar sikkerhetskopi av de viktigste brukerkatalogene. Det skal hovedsakelig kjøres fra hjemmekatalog, der mange konfigurasjons- og systemrelaterte kataloger blir ekskludert. Backup-arkivet får navn etter dagens dato med prefiks ubuntu- og filendelse .tar.gz.

```output
#!/bin/bash
DATO=$(date +%d-%b-%g)
FIL=ubuntu-backup
ARKIV=$FIL-$DATO.tar.gz

tar --exclude='./snap'        \
    --exclude='./Downloads'   \
    --exclude='./Templates'   \
    --exclude='./.cache'      \
    --exclude='./.dotnet'     \
    --exclude='./.java'       \
    --exclude='./.local'      \
    --exclude='./.profile'    \
    --exclude='./.ssh'        \
    --exclude='./.vscode'     \
    --exclude='./.Public'     \
    --exclude='./.config'     \
-vczf $ARKIV .
```

Resultatet blir en fil med navn på formen buntu-backup-14-Feb-25.tar.gz:

La oss se på et annet eksempel der det skjer litt mer. Det viser alle skallskript på ~/bin sammen med en forklaring av hva de gjør.

```output
#!/usr/bin/bash

# lists all skall script commands on $HOME/bin along with a description

pushd /home/jan/bin > /dev/null
echo "skall script files on $(pwd):"
ls -l *.sh | awk '{print "\033[0m" $1, "\033[92m" $NF "\033[0m "}' > left.txt
awk 'FNR == 2 { print; nextfile }' *.sh | cut -c 2- > right.txt
paste -d '-' left.txt right.txt
rm -f left.txt right.txt
popd > /dev/null
```

Dette gir per nå følgende utskrift, der skriptet selv kommer korrekt med:

Her er forutsetningene at alle skallskript (og bare de) har endelse .sh, og at andre linje alltid inneholder en kommentar med kommandobeskrivelse.
Skriptet pusher inn i ~/bin helt i starten og popper tilbake til kallkatalogen rett før slutt. Mellom dette skrives en overskrift, før to awk- og en paste-kommando gjør selve jobben.
Den første awk-en henter ut første og siste kollonne i en lang listing av sh-filer (og føyer på hhv. standard og grønn tekstfarge). Output legges i en midlertidig fil left.txt.

Neste awk-kommando skriver ut andre linje i hver sh-fil (den forklarende kommentaren). Resultatet omdirigeres så til cut, som sørger for å fjerne de to første tegnene (# ) og sende output til den midlertidige filen right.txt.
Dermed trenger man bare å spleise sammen disse filene linje for linje, hvilket er hva paste gjør (her med bindestrek istedenfor standardverdi tabulator mellom).

Her er enda et skript. Dette foretar inkrementell backup fra $SOURCE til $TARGET. Det sjekkes at $TARGET eksisterer/er montert og at det fins en veldefinert nivå 0-backup å bygge videre på.(Hvis denne ikke finnes, opprettes den.). Løpenumre er implementert, og man søker opp sist brukte løpenummer mm.

```output
#!/usr/bin/bash
\# creates incremental user file backups on BACKUPDISK
TARGET=/media/jan/BACKUPDISK/Ink-Ubuntu
SOURCE=/home/jan/Testkatalog
EXDIR="--exclude=$SOURCE/Tullekatalog\
       --exclude=$SOURCE/GammelKatalog"
if [ -d $TARGET ]; then
 echo "Partition is mounted."
 if ! [ -f $TARGET/ink-arkiv.snar.gz ] || ! [ -f $TARGET/ink-arkiv-0.tar.gz ]; then
 echo "Correct snar file or correct level 0 backup not on target."
 echo "Creating initial backup:"
 tar $EXDIR -Pczf $TARGET/ink-arkiv-0.tar.gz -g $TARGET/ink-arkiv.snar.gz $SOURCE
 echo "Initial level 0 backup successfully created:"
 \# tar -tvzg /dev/null -zf $TARGET/ink-arkiv-0.tar.gz
 exit
 else
 echo "Level 0 backup and snar file on target."
 pushd $TARGET > /dev/null
 NYESTEFIL=$(ls -1t ink-arkiv-*.tar.gz | awk 'NR==1 {print}')
 NUMSTR=$(echo $NYESTEFIL | grep -o '[0-9]')
 NUM=$(echo $NUMSTR | sed -e 's: ::g')
 echo "Most recent incremental backup is backup number" $NUM"."
 NUM=$(($NUM+1))
 NYFIL=ink-arkiv-$NUM.tar.gz
 echo 'Creating incremental backup' $NYFIL':'
 tar $EXDIR -Pczf $TARGET/$NYFIL -g $TARGET/ink-arkiv.snar.gz $SOURCE
 echo 'Incremental backup' $NYFIL 'successfully created:'
 \# tar -tzg /dev/null -zvf $TARGET/$NYFIL
 popd > /dev/null
 fi
else
 echo 'Partition is not mounted.'
fi
```

De viktige, utførende backup-setningene er vist i gult. Setningene som kunne ha listet innholdet i backupene til slutt, er kommentert ut, ettersom output fort kan bli lang.