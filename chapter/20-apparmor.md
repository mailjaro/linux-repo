# apparmor

**apparmor** er navnet **Debian-Linux** sin kjernebaserte
sikkerhetsløsning, som på mange måter tilsvarer hva **SELinux** er på
**Red Hat-Linux** (og dens slektninger). Begge tilbyr såkalt *Mandatory
Access Control* (**MAC**), som betegner det at en sikret entitet
(kjernen i dette tilfellet) begrenser prosessers/brukeres tilgang til
objekter (filer, kataloger, **TCP**-/**UDP**-porter, minne eller
**I/O**-enheter). Til forskjell for såkalt *Discretionary Access
Controll* (**DAC**, **Linux** sin vanlige **rwx**-aksess), der brukere
gis mulighet til å gjøre sikkerhetsmessige endringer (bevisst eller ved
feil), kan **MAC** (i prinsippet) ikke omgås. Når først bestemte
policy-valg er implementert, må selv **root** følge dem (til han evt.
går inn og endrer dem). **SELinux** og **apparmor** er svært forskjellig
implementert. Førstnevnte (som i sin tid ble utviklet av **NSA**)
regulerer nede på filnode-nivå, mens sistnevnte regulerer utfra filstier
(som vi skal se). Det vil aldri være aktuelt å kjøre begge
samtidig**apparmor** kommer preinnstallert under **Ubuntu** og skal være
aktivisert som standard. **apparmor** beskytter systemet ved å
**MAC**-begrense hva applikasjoner får lov til å gjøre. En applikasjon
kan f.eks. ha tillatelse til kun å lese bestemte filer, skrive til én
bestemt katalog, ikke benytte nettverk etc. Det aller viktigste i dette
er å begrense applikasjoner hackere kan få tilgang til. I førsterekke
gjelder dette nettjenester som **appache2** (vebbtjener), dvs.
nettjenester som lytter på bestemte porter og slipper trafikk initiert
utenfra inn. En hacker kan dermed kunne utnytte feil i programmet, få
kontroll over det og gradvis få utvidet privilegiene til han blir
**root** på systemet. Men om **appache2** er **apparmor**-beskyttet, vil
**MAC**-begrensingene stoppe ham i få utført mer en det **appache2** får
lov til å gjøre, selv med feil i programmet.

Ettersom vi ser bort i fra vebb-tjenere og den slags, er det kanskje
begrenset nyte av dette delkapittelet. Men det kommer litt an på hva man
ellers har installert Jeg har f.eks. installert **KDE Connect**, som
gjør det mulig å kommunisere med mobiltelefonen, få varsler, utveksle
filer mm. Og slike tjenester kunne ha godt av **apparmor**-beskyttelse.
(Brannmuren stopper imidlertid denne trafikken her per nå, når den er
aktiv.)

Jeg skal ta et enklere eksempel, slik at gangen i dette fremkommer.

**apparmore** skal være installert, men det kan være nødvendig å
installere **appmore_utils** (ved **sudo apt install appmore_utils**).
Den trengs for å lage såkalte profiler. Dessuten lar den oss få vite
hvilke applikasjoner som lytter som beskrevet over (altså prosesser med
**TCP**- /**UDP**-porter) uten **apparmor**-profil. Disse er gode
kandidater for **apparmor**-sikring:

aa-unconfined

Ellers aktiviserer eller deaktiviserer man **apparmor** med:

```bash
sudo systemctl restart apparmor\
sudo systemctl stop apparmor
```

Det neste man kan gjøre er å se en oversikt over hva som er beskyttet:

```bash
sudo apparmor_status
```

Output her gir en list over antall profiler som er i **enforce mode**,
**complain** **mode**, **prompt** **mode**, **kill mode** og
**unconstrained mode**. I tillegg listes hvilke prosesser som er i samme
*mode*, samt i **mixed mode**.

**Enforce mode**: Applikasjonen må følge og kan ikke omgå sin profils
begrensinger

**Complain mode**: Applikasjonen kan omgå sin profils begrensinger, men
hendelsene logges

**Kill mode**: Prosess vil bli drept ved strid mot profilbegrensninger

**Unconfined mode**: Applikasjoner uten **apparmor**-begrensninger og
**apparmor**-logging (kun vanlige **Linux**-begrensninger og -logging).

**Mixed mode** har jeg ikke funnet beskrivelser av.

Profilene er vanlige tekstfiler, ligger under **/etc/apparmor.d** og
følger en navnkonvensjon der **/** erstattes med punktum (unntatt
første). Profilen til f.eks. brukerprogrammet **/usr/bin/evince**
(**Evince Document Viewer**) heter da **usr.bin.evince** osv.

Anta så vi har et program eller skall-skript vi ønsker å sikre, f.eks.
**testProgram** på **/home/jan/bin**. Da utfører man

```bash
sudo aa-genprof /home/jan/bin/testProgram
```

fra en terminal. Terminalen havner da i et skanne-modus og forteller om
det på skjermen. Da skal man så i annen terminal kjøre programmet og
gjøre alt det normalt skal gjøre. For enkle programmer kan det være bare
å kjøre det. For større programmer og nettjenester kan det inkludere
både å starte og stoppe tjenesten, aksessere nettet mm. Nå man så går
tilbake til terminalen, trykker man **S** for skann, og **apparmor** vil
generere en profil med navnet **home.jan.bin.testProgram** i dialog med
oss. Den har merket seg alt hva programmet har forsøkt å
gjøre/akksessere, og man kan kort fortalt tillate det for profilen ved å
godta med **I** (for *inherit*) eller **A** (*accept*) avhengig av
svaralternativer. Det fins flere valg, men tanken er her at man skal
finne og godta alle normale operasjoner for programmet, slik at alt
annet siden vil være forbudt. Man må selvsagt gjøre dette i en trygg
omgivelse uten at uvedkommende kan påvirke prosessen.

Når man til slutt får tilbud om å lagre settingene, gjør man det og
aktiviserer profilen enten i *complain* eller *enforce mode*.
Førstnevnte er grei i en testfase, men gir ingen sikkerhet.

```bash
audo aa-complain /home/jan/bin/testProgram\
sudo aa-enforce /home/jan/bin/testProgram
```

Deretter kjører man programmet. Ofte hindrer **apparmor** det fordi noe
er satt for strengt. F.eks. har programmet fått lov til å lagre en fil
underveis, men det gjelder typisk bare et bestemt filnavn. Da må man inn
i profilen å endre filnavnet til \* etc. Det kan være vanskeligere å få
nettapplikasjoner til å virke (få **apparmor** til å la det kjøre) fordi
det er mye som kreves. Det kan være **DNS**-oppslag, port-aksess og
annet som må tilpasses. Men da har man i det minste et utgangspunkt og
kan søke hjelp på nettet osv.

Det er også andre måter å få laget/endret profiler på. Følgende kommando
ser gjennom loggen og gir konkrete spørsmål om ting den har funnet der:

```bash
sudo aa-logprof
```

Man kan også få laget et skjellett til profil ved kommandoen:

```bash
sudo apt install apparmor-easyprof\
sudo aa-easyprof \<sti til program\>
```

Og dessuten kan man få hjelp til å gjennomgå loggene ved:

```bash
sudo apt install apparmor-notify\
sudo aa-notify -s 1 -v
```

Forhåpentligvis gir dette litt bakgrunnsforståelse og kan være til hjelp
i en startfase.