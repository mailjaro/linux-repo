## Tips og triks

Her samles diverse tips og triks. Disse er ikke nødvendigvis gruppert på noen spesiell måte, og alt er sikkert ikke like nyttig.

```bash
cd -				# Går tilbake til forrige katalog
```

```bah
ctr+l
```

tømmer terminalvinduet som clear, mens følgende resetter (uten å slette history):

```bash
reset				# Restarter terminal
```

pushd og popd pusher og poper katalogangivelser på/av en stakk (en first in, last-out-kø). Den fungerer som forventet. Ved å pushe en katalog til stakken, havner vi der. Og når vi siden popper, sendes vi tilbake til opprinnelig katalog. Pusher vi flere ganger, vil hvert pop sendes oss et steg tilbake i serien osv. Popper vi en gang får mye, får vi bare en melding om at stakken er tom (og blir stående). Dette kommandoparet er ikke minst nyttige i skallskript, ved at man pusher inn i ønsket katalog ved start, og popper tilbake ved avslutning. (Dermed blir sjansene mindre for at man endre uønskede filer, samt at man ikke endrer katalog for brukeren som utførte skriptet.)

Kommandoer som kjører i bakgrunn, startet ved cmd &, fås oversikt over ved jobs -l.

Uttrykket !! står for forrige kommando. Den kan settes sammen som del av ny kommando.

ctrl+r fører skallet over i historikk-søkemodus. Ved å taste én eller flere bokstaver, vises den nyeste som passer eller inneholder disse. Taster man ctrl+r på nytt, vises forrige osv. Trykk enter for å kjøre funnet kommando på nytt.
history gir en nummerert liste over alle siste kommandoer, !nr kjører kommando med dette nummeret på nytt.
Om man f.eks. kjører sensitive kommandoer, kan man starte kommandoen med space for å hindre at den legges til historikken. Evt. kan man rediger .bash_history etter eget ønske.

ctrl + og ctrl – øker og minker fontstørrelse.

ctrl+u tømmer påbegynt kommandolinje.

ctrl+a og ctrl+e sender markøren til hhv. start eller slutt av kommandolinjen.

ctrl+shift pil opp og ned blar opp og ned i terminalvinduet.

Et par kommandoer kan kjøres etter hverandre fra samme linje med ; eller && mellom. I sistnevnte kjøres ikke kommando 2 ved feil i den første. Benytter man || mellom, kjøres bare andre om første feiler. F.eks. kan man da installere en kommando om den ikke finnes etc.
htop || sudo apt install htop && htop

Den tidligere nevnte kommandoen

```bash
ps -eo comm,pcpu --sort -pcpu | head -5; ps -eo comm,pmem --sort -pmem | head -5
```

som viser de 5 mest CPU-intensive og de 5 mest minneintense prosessene som kjører, er vanskelig å huske. Men vi kan legge den inn som et alias, f.eks. som p5 ved:

```bash
alias p5="ps -eo comm,pcpu --sort -pcpu |
    head -5; ps -eo comm,pmem --sort -pmem | head -5"
```
Den  kan legges til i .bashrc på hjemmekatalogen, men kanskje enda bedre er det å legge egenlagde aliaser i ~/.bash_aliases.

For visse kommandoer med uryddig output, kan column gruppere det pent i kolonner.

```bash
mount | column -t
```

rsync benyttes om man skal kopiere (eller synkronisere filer), typisk mellom maskiner, eller over nett mer generelt, etv. lokalt. En morsom ting er at den underveis viser en fremdriftsindikator. Ved store kopieringsjobber er den derfor et morsomt alternativ til cp. (Merk dog at kopiering kan I/O-mellomlagres, slik at ikke alt tar merkbar tid for rsync.)

pv er en kommando med flere muligheter, men som også kan vise en fremdriftsindikator. Her er et eksempel som teller antall filer på et tar.gz-arkiv med pv-fremdriftsindikator:

```bash
pv arkiv.tar.gz | (tar -tz | wc -l)
```

Her er et annet:

```bash
tar -czf - ./Documents/ | (pv -p --timer --rate --bytes > backup.tgz)
```

Litt om systemet:

```bash
uname -a
```

For å legge inn linjenumre i en output, kan benytte nl, som f.eks.

```bash
snap list --all | nl | less
```

For å se tidsinnstillingene som gjelder:

```bash
timedatectl 
```

```output
Local time: Thu 2025-03-27 13:11:15 CET
Universal time: Thu 2025-03-27 12:11:15 UTC
RTC time: Thu 2025-03-27 12:11:15				# Innebygd klokke
Time zone: Europe/Oslo (CET, +0100)
System clock synchronized: yes
NTP service: active
RTC in local TZ: no
Eller bare tidssonen:
cat /etc/timezone
Europe/Oslo
```

Følgende anvendt på en fil, viser mer info en ls -l fil:

```bash
stat fil
```