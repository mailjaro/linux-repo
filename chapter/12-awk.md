# 📄 awk

**`awk`** (navnet kommer fra etternavnene til opphavsmennene, bl.a. velkjente Kernighan) benyttes for å søke fram mønstre og ord i filer og kommado-otput, og utføre spesifiserte aksjoner. Den fokuserer på felter (dvs. karakterer omgitt av blanke tegn). En hel linje omtales som **`\$0`**, første felt som **`\$1`** osv. og antall felt (dvs. siste felt) som **`$NF`**. Disse kan benyttes som variable i kall.

**`awk`** scanner en fil linje for linje, splitter hver linje i felter, sammenlikner linje eller felter med mønsteret før den utfører aksjonene på de utvalgte linjene.

Syntaksen er som følger:

```bash
awk options 'selection criteria {action}' input-file > output-file
```

Input-filen kan selvsagt være output fra annen kommando ved omdirigering, mens output uten omdirigering havner til skjerm.

Om vi ser på output fra følgende **`ls`**-kommando (der totalen i første linje gjerne ikke trengs):

```bash
ls -l
```

```output
total 196
-rw-rw-r-- 1 jan jan  14788 Mar 28 16:05 Book-no-1.odt
-rw-rw-r-- 1 jan jan 172647 Mar 28 16:07 Book-no-2.odt
-rw-rw-r-- 1 jan jan     27 Apr  1 20:51 testfil.txt
```

kan **awk** f.eks. printe ut valgte kolonner, her femte (filstørrelse):

```bash
ls -l | awk 'NR>1 {print $5}'
```

```output
14788
172647
27
```

Her velger man ut rettighetene og filnavnet:

```bash
ls -l | awk 'NR>1 {print $1, $9}'
```

```output
-rw-rw-r-- Book-no-1.odt
-rw-rw-r-- Book-no-2.odt
-rw-rw-r-- testfil.txt
```

Siste felt (det niende i eksempelet) benevnes **`$NF`**. Legg ellers merke til at **`awk`** skriver ut et mellomrom mellom feltene. Det kan vi endre med **`OFS`**. Under har vi også lagt inn en **`BEGIN`**-regel.

```bash
ls -l | awk 'BEGIN {print " PERM        CLOCK   NAME:"} NR>1, OFS=" | " \
  {print $1, $8, $NF}'
```

```output
 PERM        CLOCK   NAME:
-rw-rw-r-- | 16:05 | Book-no-1.odt
-rw-rw-r-- | 16:07 | Book-no-2.odt
-rw-rw-r-- | 20:51 | testfil.txt
```

I alle disse eksemplene inkluderte vi **`NR>1`** for å ekskludere totalen i første linje i **`ls -l`**.

Man kan også angi mønstre for feltene ved **`/mønster/`**. Eksempelet under viser linjer i **syslog** som inneholder feltet **kernel**. Felt felt 3 og 4 i disse, samt linjenummeret (vha. variabelen **`NR`**) printes.

```bash
tail -50 /var/log/syslog | awk '/kernel/ {print NR, $3, $4}'
```

```output
34 kernel: rtw_8821ce
47 kernel: message
48 kernel: kauditd_printk_skb:
49 kernel: audit:
50 kernel: audit:
```

Ønsker man motsatt alt annet enn **`/mønster/`**, skriver man **`/!mønster/`**. Man kan også legge inn kriterier. Under vises alle PDF-filer i filtreet hvis størrelse (i 7. kolonne) er over 200 000 byte. Størrelsen og filstien (i 10. kolonne) printes til stdout.

```bash
find . -name *.pdf -ls | awk '$7 > 200000 {print $7, $11}'
```

```output
1514291 ./Esperanto/Kellerman-Kolor.pdf 
203616 ./FIRMA-AS/Politiattest.pdf
286497 ./FIRMA-AS/Stiftelse.pdf
```

Den neste finner alle linjer f.o.m. 25 tom. 27 i en filliste. Linjenummer og hele linjene for disse printes.

```bash
find . -name *.pdf -ls | awk 'NR==25, NR==27 {print NR, $0}'
```

Her finner vi alle PDF-filer med stinavn under 35 tegn:

```bash
find . -name *.pdf -ls | awk 'length($11) < 35'
```

I enkelte filer benyttes f.eks. kolon (**:**) istedenfor mellomrom for å skille mellom ord/felter (som i **/etc/passwd**). Vi kan benytte opsjon **-F** og spesielt angi **-`F:`** for kolon. Her er en kommando som viser definerte brukere (og systembrukere) og deres tilhørende hjemmekatalog, sortert alfabetisk og pent vist i to kolonner:

```bash
awk -F: '{print $1, $6}' /etc/passwd | sort -k 1 | column -t
```

**`awk`** kan gjøre mye mer. Den har **`if`**-tester, løkkestrukturer, kan utføre ulike beregninger (også matematiske), og den har flere måter å å angi mønstergjentakelser på, for å nevne noe.

Her summerer vi noen tall i andre kolonne i en **testfil.txt** med følgende innhold:

```output
Jan   10
Alice  8
Bob    7
```
```bash
awk '{sum += $2} END {print sum}' testfil.txt
```

```output
25
```

Her ser vi en liten **`if`**-setning. Her sendes output fra **`df -h`** (oversikt over diskpartisjoner) inn til awk som sørger for å skrive ut første linje (overskriften), samt alle hovedpartisjoner (**nvme** står for *non-volatile memory express*):

```bash
df -h | awk '{if (NR==1) {print $0}} /nvme/ {print $0}'
```

```output
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme0n1p7  260G   27G  220G  11% /
/dev/nvme0n1p1  256M   50M  207M  20% /boot/efi
/dev/nvme0n1p6   65G   28G   35G  45% /media/jan/3364c0f4-4d82-474d-bad7-71d44eb0418b
```

Partisjonene svarer til de tre operativsystemene som for tiden er installert hos meg, hhv. Ubuntu Linux, Windows og Mint Linux.

Her ser vi strukturen til **`if`**, **`if-else`** og **`if-else-if-else`**:

```bash
awk '{ if () {} }'
awk '{ if () {} else {} }'
awk '{ if () {} else if () {} else {} }'
```

La oss f.eks. si vi er interessert i opplysninger om **`gpg`**-bruker Ola Nordmann i **`gpg`**-nøkkelringen og ønsker å trekke ut både hans fingeravtrykk, navn og e-postadresse. Opplysingene kommer ut av **`gpg -k`**, men vi må benytte **`awk`** til å finne nøyaktig det vi leter etter på visse steder i linje 2 og 3:

```bash
gpg -k Ola | awk '{ if (NR==2) {print $1} else if (NR==3) {print $3, $4, $NF} else {} }'
```

```output
D2AF134F36B2EC2E654EEABC56C8D1EE935C2180
Ola Nordmann <ola.nordmann@gmail.com>
```