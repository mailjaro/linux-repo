## Litt om administrasjon

Dette notatet har ikke ambisjoner om å gå i dybden på Linux-administrasjon. Systemet er generelt  stabilt og sikkert, og bør gi få bekymringer. Men man er ikke immun mot problemer, ei fra skadevare, hacking-forsøk og annet, og delsystemer kan jo svikte. God sikkerhet er alltid viktig, men vi rekker ikke å si mye om et så stort emne. (Søk gjerne opp nettressurser om emnet.) Det å beskytte seg mot avanserte hackere er uansett krevende. Disse kan langt mer enn de fleste, evner å skjule spor og aktivitet, og intet som sies i heftet stopper de mest avanserte. Det å ta hyppig sikkerhetskopi av brukerdokumenter og kryptere filer med sensitivt innhold, er vårt beste forsvar mot alt. For private bruker bør ikke en eventuell reinstallering av Linux være noen katastrofe.

Men det er likevel lurt å være sikkerhetsbevisst og unngå opplagte svakheter. Avanserte hackere er vanligere trussel for større institusjoner, og man kommer langt med vanlige, gode rutiner. Å sørge for trygge passord, at programmer, filer og kataloger har rett eierskap og minimale rettigheter, at man ikke roter til noe i systemkataloger, at man har en brannmur opp, at man oppdaterer jevnlig, at man ikke lagrer passord til nettbank og BankID utenfor eget hode, er et godt utgangspunkt. I tillegg er det lurt å gjøre seg kjent med systemet. Det er til hjelp både når feil oppstår og når PC-en gjør noe den ikke skal.

Det å kjøre administrative rapporteringsverktøy er vel og bra, men output kan si vanlig brukere lite. Et godt råd kan derfor være å gjøre seg kjent mens installasjonen er relativt ny. Ta kopi av /etc/passwd, se på/lagre output fra ps -ef og andre kommandoer, bli litt kjent med prosesser, deamons og andre tjenester som kjører, og når de kjører, google prosessnavn og systembrukere, se på logger, google feilmeldinger, ha formening om normal ytelse for CPU, minne osv. Kanskje kan man også studere systemet før og etter større installasjoner, slik at nye (normale) ting ikke tåkelegger oversiktsbildet man har opparbeidet.

Når det gjelder administrative oppgaver ellers, vil oppryddingsbehov etter hvert melde seg. Over tid vil det hope seg opp store logger, temporære filer, programrester og annet. Før eller siden kan det hende for mye er akkumulert opp og plassen begynner å bli trang. I det følgende skal vi se på administrative kommandoer, både for rydding og andre ting.

Her antas det at man ikke bruker Linux-maskinen som en nettverkstjener i noen form (f.eks. som en vebbtjener). Det vil sette andre krav både til sikkerhet og administrasjon.

### systemd: Start og stopp av tjenester

systemd er fundamental i Linux. Det er den første tjenesten som starter på systemet (og har derfor alltid PID 1) med bl.a. ansvaret for å starte alle andre. Ressurser den styrer kalles units, hvilket inkluderer tjenester, timere, mounts, automounts mm. Konfigurasjonsfilene for dette ligger tre steder:

```output
/etc/systemd/system
/run/systemd/system
/lib/systemd/system
```

Disse katalogene er angitt i prioritert rekkefølge, dvs. at det først søkes i /etc, dernest i /var og til slutt i /lib. Når man installerer tjenester som f.eks. appache2, legger den fra seg konfigurasjonsfiler på /lib. De kan oppfattes som de mest statiske, slik at kan man gjør mer dynamiske endring på /etc osv.

Ønsker man å se hvilke typer units systemd har, kan man gjøre:

```output
find /lib/systemd/system -type f | grep -oE '\.\w+$' | sort -u
.automount
.conf
.mount 	
.path
.service
.slice
.socket
.target
.timer
```

(Kommandoen finner bare alle filendelser på filer i /lib/systemd/system.)

Vi er her opptatt av services, og de tilhørende filene har alle endelse .service. Disse er tekstfiler med standardiserte overskrifter hvor man finner diverse innstillingsvalg.

For å se på status til hhv. alle units eller til en bestemt tjeneste, gjør:
systemctl status

```bash
systemctl status <navn på tjeneste>
```

Fra sistnevnte kan man få rapportert om tjenesten er aktiv eller inaktiv. I tillegg kan det bli rapportert om den er enabled eller disabled, hvilket sier om tjenesten startes automatisk eller ei etter systemstart.

Under ser vi hvordan man hhv. aktiverer en tjeneste (når den er inaktiv), reaktiverer en tjeneste (fra aktiv tilstand), relaster en tjeneste (leser inn konfigurasjonsinnstillingene på nytt, dersom utviklerne av tjenesten har programmert inn denne funksjonaliteten) eller stopper tjenesten.

```bash
sudo systemctl start <navn på tjeneste>
sudo systemctl restart <navn på tjeneste>
sudo systemctl reload <navn på tjeneste>
sudo systemctl stop <navn på tjeneste>
```

Her ser vi hvordan en tjeneste hhv. enables eller disables, altså hvorvidt den skal startes ifm. med systemstart eller ei.

```bash
sudo systemctl enable <navn på tjeneste>
sudo systemctl disable <navn på tjeneste>
```

## Skann etter sårbarheter og skadevare

Selv om en vanlig bruker sjelden vil oppleve problemer, skader det ikke å skanne etter sårbarheter og mulig skadevare på maskinen. Det finnes flere mye brukte og anbefalte gratisprogrammer. Hva som anbefales, vil variere over tid. For tiden er Lynis og ClamAV mye brukt.

## Lynis
Man bør starte med å oppdatere og oppgradere systemet før installasjon av programvare som denne, så start gjerne med:

```bash
sudo apt update
sudo apt upgrade
```

Lynis kan deretter installeres med

```bash
sudo apt install lynis
```

selv om man med dette ikke får nyeste versjon (og Lynis kan klage over det i skann). Nyeste versjon kan evt. hentes på nettet og pakkes ut manuelt.
Når man er ferdig, kan man uansett sjekke versjon og gjennomføre et skann ved:

```bash
lynis --version
sudo lynis audit system
```

Output er lang, og det vil helt sikkert rapporteres om ting som bør forfølges eller styrkes. I slutten ser man bl.a. en oppsummerende hardening index, som som er en slags overordnet karakter på tingenes tilstand, slik Lynis ser det. Det angis et tall fra 0 (elendig) til 100 (perfekt), hvor tall mellom nok 50-70 er nokså vanlig.

Output viser mange ting, avhengig av hvilke tester som gjøres og hva man finner. Det gis bl.a. fargekoder som forenkler en gjennomgang. Grønt symboliserer OK, mens gult indikerer at noe mangler og rødt at noe må ses på.
Hos meg fikk jeg, kort fortalt, et par advarsler, samt 43 forbedringsforslag ved første skann. Forbedringsforslagene ble vist med én linjes forklaring sammen med en link. Her er ett eksempel på én disse:

> * Configure maximum password age in /etc/login.defs [AUTH-9286] https://cisofy.com/lynis/controls/AUTH-9286/
  

Ved å klikke på linken får man fram nærmere informasjon om problemet (selv om akkurat denne er selvforklarende). Her var anbefaling å kreve regelmessige passordskifter (og hvordan det gjøres, er forklart i neste kapittel).
De samme forbedringene kan også finnes i log-filene ved:
sudo less /var/log/lynis.log | grep Suggestion

På slutten av output fås også oppsummerende avsnitt om oppfølgingen videre:

```
Follow-up:
----------------------------
- Show details of a test (lynis show details TEST-ID)
- Check the logfile for all details (less /var/log/lynis.log)
- Read security controls texts (https://cisofy.com)
- Use --upload to upload data to central system (Lynis Enterprise users)
```

Man skal kunne få flere detaljer med lynis show details TEST-ID, står det, men det gir tomme output for meg for aktuelle TEST-ID-er.
Noe overordnet informasjon om en bestemt TEST-ID fås imidlertid ved lynis show tests <TEST_ID>, og en liste over alle tilgjengelige tester fås ved:

```bash
lynis show test
```

En konkret test kan gjennomføres ved

```output
lynis --tests <TEST_ID>

sudo lynis audit system --tests-from-group security
sudo lynis audit system --tests-from-group networking
sudo lynis audit system --test FW-100
```

```bash
lynis show commands	
lynis show settings
```

## ClamAV

ClamAV is an open-source antivirus engine for detecting malware, viruses, and other threats on Linux, Windows, and macOS. It is widely used on mail servers and file servers for scanning incoming files and preventing malware infections.  


### Key Features of ClamAV:  
Command-line virus scanner – Lightweight and efficient for Linux systems.  

Real-time scanning (optional) – Can be configured with ClamDaemon for automatic scanning. 

Database updates – Regular virus definition updates to detect new threats.

Multi-format scanning – Supports archives (ZIP, RAR, TAR, etc.), executables, and scripts. 

Mail server integration – Used with Postfix, Exim, and Sendmail to scan email attachments.  

Would you like help installing and using ClamAV on Linux?

```
sudo apt update && sudo apt install clamav clamav-daemon -y
sudo freshclam
clamscan -r /home
clamscan -r ~/Downloads
clamscan -r --remove /home
sudo systemctl start clamav-daemon
sudo systemctl enable clamav-daemon

-r: Recursive (scan subdirectories)

-i: Show infected files only

--bell: Alert sound on virus detection
Autentiseringspolicyer
PAM
/etc/pam.d/common-password
```

PAM (Pluggable Authentication Modules) is a flexible authentication framework used in Linux and Unix systems. It allows system administrators to configure authentication methods for users and services dynamically.
Key Features of PAM:

Modular Authentication – Supports different authentication methods (passwords, biometrics, smart cards, etc.).

Access Control – Restricts logins based on time, user groups, or system load.

Multi-Factor Authentication (MFA) – Can integrate with tools like Google Authenticator.

Account & Session Management – Controls password policies, session limits, and login restrictions.

Logging & Auditing – Monitors authentication attempts and logs failures.

PAM is essential for securing Linux systems by enforcing strong authentication rules. Would you like help configuring it?

PAM is included in most modern Linux distributions. Verify with:

```bash
ls /etc/pam.d/
```

```output
/etc/login.defs
```

## Loggesystemer

Det fins etter hvert en del grafisk verktøy for å visualisere og analysere logger. System Monitor følger eksempelvis med Ubuntu, og slike er fine å bruke. Andre kan også sammenfatte, filtrere, søke og tilby alarmer. I fortsettelsen skal vi dog fokusere på grunnleggende filer og kommandoer. Tradisjonelt baserer dette seg på logg-filer på /var/log, men disse blir i stigende grad erstattet med et nyere journal-system som aksesseres med kommandoen journalctl.

### var/log

Det er mange loggfiler /var/log. Vi skal bare nevne de viktigste. Men man kan starte med å liste katalogen og se på datoer for siste endring. Det er mulig å følge litt med, se på innhold, og oppdage om spesielle ting har hendt. 
Nå er det klart at enkelte av disse filene fort blir veldig store. Linux logger mye, og f.eks. syslog fyller seg fort opp til noen hundre tusen linjer på noen dager eller uker, avhengig av aktivitet. Selv meldinger med prioritet Warning, kan det bli noen tusen av. Man kan ikke finlese store logger. Ikke skjønner man så mye av innholdet heller. Men, merker man unormal aktivitet, tregere maskin, minneproblematikk og liknende, kan man brette opp ermene og fordype seg. 
Det følgende lister de viktigste log-filene på vanlige Ubuntu-installasjoner. (Flere kan være aktuelle avhengig av hva man har installert.)

### Log-filer på /var/log

- syslog:

 Generelle eventer fra hele systemet

- kern.log

 Kjernespesifikke meldinger

 - boot.log

Logg relatert til boot-prosessen

- dmesg

Kjerneinformasjon rundt maskinvare og drivere

- auth.log

 Alle utentiseringshendelser fra system og brukere

- faillog

Holder telling med påloggingsfeil og grensene for hver konto

- btmp
- 
Holder oversikt over feilede pålogginsgforsøk (binærfil)

- wtmp
- 
Holder historikken over alle inn- ut utlogginger (binærfil)

Noen av disse, som auth, kern, syslog og dmesg, vokser fort, og det lages gz-serier av loggene. Det kan være ønskelig å rydde opp i disse etter hvert, hvilket i tilfelle må gjøres med forsiktighet. (Mer om det i underkapittelet om opprydding.) De fleste log-filene er tekstbaserte og kan leses med cat, less, tail og andre, gjerne i kombinasjon med grep for spesifikke søk. Andre er binære, og kan leses med last -f. Noen logger, som boot, krever root-privilegier. (Generelt forteller logger mye som angripere kan ha glede av, så hemmelighold er viktig.) Loggene har interesse ikke bare med tanke på sikkerhet, men også for optimalisering, diagnostisering, feilsøking og debugging.

auth.log er mulig å titte i regelmessig. Her ser man (bl.a.) all sudo-aktivitet. Denne kommandoen

```bash
grep -w sudo auth.log
```

bør dermed ikke inneholde overraskelser. De utførte kommandoene vises i høyre kolonne.

Merk: For alle kommandoer rundt logging her, forutsettes det at bruker har utført cd til /var/log.

Også følgende kan være nyttig:

```bash
grep 'authentication failure' auth.log
```

som får fram mislykkede påloggingsforsøk.
Binærefilene utmp (tom for meg) og wtmp kan leses med last:

```bash
last -f wtmp
```

(Opsjonen -f trengs egentlig ikke for standardfil wtmp.) Her har normalt bare bruker og reboot oppføringer (ses i første kolonne), slik at det følgende lister hhv. alle restarter, og evt. oppføringer fra andre/noe annet:

```bash
last -f wtmp  | awk '/reboot/ {print}'
last -f wtmp  | awk '!/reboot/ && !/jan/ {print}'
```

Når det gjelder den store syslog, kan man for det første se nye oppføringer i sanntid ved:

```bash
tail -f syslog
```

Ellers kan man søke etter spesifikk oppføringer med grep. Maskinvareproblematikk, som disk- eller USB-trøbbel, mus som ikke virker og den slags, kan være ting det søkes etter. I så fall er det også verdt å søke i dmesg, som har delvis overlappende oppføringer, men også annen informasjon. Det fins en kommando for å lese denne, også kalt dmesg, som formater informasjonen pen og i farger. Et eksempel på bruk her er da:

```bash
sudo dmesg | grep USB
```

Men tradisjonelle syslog-søk blir i stadig sterkere grad erstattet av søk i såkalte journaler. I disse logges det samme. Og mere til.


## journalctl

I tillegg til /var/log-systemet har man altså journalene til systemd (system journal demon for system and service management i Linux), som også samler data fra hendelser i systemet, fra kjerne til brukere. Disse lagrer ikke i filer på /var/log, men som sentrale binærfiler for effektive søk og oppslag. Kommandoen for å søke i dette er journalctl.

F.eks., for å vise oppføringer fra journalene i sanntid (fra hele systemet) kan man utføre:

```bash
journalctl -f
```

Også her er selvsagt den totale mengden overveldene. Det meste forteller neppe heller vanlig brukere mye. Network manager, cron, kjerne, rtkit-deamon og wifi-kommunikasjon vil ha flere oppføringer der, bl.a., særlig ved nettaktivitet. Men alt kan googles om PC-en skulle begynne å underprestere, og man kan selvsagt spørre mer spesifikt.

En vanlig anvendelse er å søke på oppføringer fra deamons1. For å fram dette brukes opsjonen -u, som f.eks.

```bash
journalctl -u snapd
journalctl -u cusp
journalctl -u atd
```

som viser ting i journalene om hhv. tjenester som håndterer snap-programvaresystemet, utskrift og at-funksjonen.

Ønsker man å se tjenester som er aktive i øyeblikket, kan man utføre:

```bash
systemctl --type=service --state=running
```

```output
UNIT                          LOAD   ACTIVE SUB     DESCRIPTION
accounts-daemon.service       loaded active running Accounts Service
atd.service                   loaded active running Deferred execution scheduler
avahi-daemon.service          loaded active running Avahi mDNS/DNS-SD Stack
bluetooth.service             loaded active running Bluetooth service
...
wpa_supplicant.service        loaded active running WPA supplicant

Legend: LOAD   → Reflects whether the unit definition was properly loaded.
 	 ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
 	 SUB    → The low-level unit activation state, values depend on unit type.

33 loaded units listed.
```

(En forkortet output er vist). To beslektede kommandoer er

```bash
journalctl _PID=<PID NR>
```

for søk etter bestemt prosesser, og (f.eks.)

```bash
journalctl /usr/bin/Python3	
```

for søk om et bestemt program.

Istedenfor å sende output til grep for mønstersøk, kan vi benytte opsjonen -g,

```bash
journalctl -g usb
```

Denne opsjonen er viktig, og poenget er at den kan selvsagt kombineres med andre valg for enda mer spesifikke søk.

Ønsker man å vise oppføringer ut fra tid, kan man ta utgangspunkt i følgende mal:

```output
journalctl --since "YYYY-MM-DD HH:MM:SS" --until "YYYY-MM-DD HH:MM:SS"
```
Eksempelvis kan vi vise alle oppføringer om natten mellom 27. og 28. februar, eller alle oppføringer de siste 10 minuttene fra cron-deamon, med de nyeste først (pga. -r):

```output
journalctl --since "2024-02-27 23:00:00" --until "2024-02-28 07:00:00"
journalctl -r -u cron.service --since "18:45:00" --until "18:55:00
```

Videre kan man vise oppføringer basert på prioritetsnivå (emerg, alert, crit, err, warning, notice, info, or debug), som f.eks.

```bash
journalctl -p warning
```

Man bør ikke ha mange av de tre første, og det er verdt å se nærmere på hva disse eventuelt sier.

En liste over seneste boots fås fram med:

```bash
journalctl --list-boots
```

```output
IDX BOOT ID                          FIRST ENTRY                 LAST ENTRY                 
 -4 f1b97eb16fd647469564f5153794b02c Wed 2025-02-19 23:31:55 CET Sat 2025-02-22 16:51:27 CET
 -3 ca128a822d1d47f58abc002f37529483 Sat 2025-02-22 16:51:44 CET Fri 2025-02-28 17:32:15 CET
 -2 747db458296e480288f9658b1571c206 Fri 2025-02-28 17:32:37 CET Sun 2025-03-02 20:02:44 CET
 -1 ff70d491f90141348d1c893bd7d281a1 Sun 2025-03-02 20:16:12 CET Tue 2025-03-04 11:00:38 CET
  0 ea512e6d4bf94246b200bdd5f94c6a8a Tue 2025-03-04 11:00:47 CET Tue 2025-03-04 19:55:53 CET

```
hvor man så kan be om mer informasjon om én av dem, f.eks. dem med indeks -3:

```bash
journalctl -b -3
```

Output her er teknisk, men kan være et utgangspunkt for videre forfølging ved oppstartsproblemer.

Vi kan også nevne denne, som viser meldinger fra kjernen (også teknisk):

```bash
journalctl -k
```

og man kan velge ulike output-formater med -o, f.eks.

```bash
journalctl -o cat -g usb
journalctl -o json -g usb
```

der man hhv. ønsker en knappere output eller en for viderebehandling i et JSON-system, bare for å illustrere litt av mulighetene.

Flere kommandoer, deriblant journalctl sender output via more eller less for roligere gjennomgang. Ønskes ikke dette , kan man inkludere opsjonen --no-pager.

## Opprydding

Over tid vil det akkumuleres en del filer som tar opp unødig plass. Før eller siden vil man ønske å rydde. Programmer man avinstallerer kan legge igjen både konfigurasjonsfiler og støtteprogrammer. Ulike applikasjoner kan legge igjen alt fra bilder, ikoner, biblioteker, mellomlager, logger og temporære filer av ulike slag.

La oss starte med å se på rydding i program-delen. Vi må både se på programmer installert ved apt og på såkalte snaps installert via App Center.

### apt-relatert

apt (Advanced Package Tool) er et nyere system for håndtere, installere, oppdatere og avinstallere  programpakker på Ubuntu. I sin nyeste form benyttes det ved kommandoer som sudo apt install, mens sudo apt-get install-utgaven, som man også ser i eksempler på nettet, er en noe eldre slektning. Disse kan brukes om hverandre, men det anbefales å benytte nyeste. En grundigere gjennomgang er å finne på Ubunto.com.

Begge er brukervennlige utvidelser av det underliggende mer lavnivå-pakkesystemet dpkg (Debian Package). Følgende to kommandoene lister hva som installert:

```bash
dpkg --list
apt list --installed
```

(Begge returnerer for meg i overkant av 1900 programmer, men ikke helt identiske tall.) Det anbefales dog ikke å bruke dpkg i håndtering av programpakker for vanlige bruker.

For å fjerne støtteprogrammer som kan bli liggende igjen etter er avinstallasjon, utfør:

```bash
sudo apt autoremove
```

Men man må også lete blant kjørende programmer for å se om man har noe man ikke ønsker/trenger. Installerte programmer kan installere og satt igang av andre som kan bli værende igjen selv etter autoremove. apache2 er et slikt eksempel. Enkelte administrasjonsverktøy installeres og starter apache2, hvilket er vebbtjener-programvaren under Ubuntu (kalt httpd andre steder). Med mindre man ønsker å sette opp PC-en som en vebbtjener, trenger man virkelig ikke denne. I så fall bør den avinstalleres med sudo apt remove apache2.

For å fjerne gjenglemte konfigurasjonsfiler, gjør:

```bash
sudo apt autoclean
```

Nedlastede pakker mellomlagres for fremtidig bruk. For å renske mellomlageret, utfør:

```bash
sudo apt clean
```

Såkalte orphaned pakker (foreldreløse, ubrukte biblioteker) kan også akkumulere. For å finne disse, kan man utføre:

```bash
deborphan
```

For å fjerne dem, bruk:
sudo apt remove --purge $(deborphan)
Alt dette fungerer ikke nødvendigvis perfekt. Alt fjernes ikke alltid, og det kan også fjernes for mye. Man kan oppleve at programmer slutter å virke etter rydding. Disse kan imidlertid reinstalleres, og i sum vil man få slanket systemet.

Hos meg har ved to oppryddinger innstillingsprogrammet GNOME Control Center forsvunnet slik at den måtte reinstalleres og startes på nytt ved:

```bash
sudo apt install gnome-control-center
gnome-control-center'
```

Man kan også vurdere å installere aptitude for å se flere detaljer om programmer og avhengigheter.


### snap-relatert

snap er et system for pakking og dsitribusjon av programvare for Linux, beslektet med App Store for IOS. Programmene utviklet her kalles derfor snaps isteden for apps. Utviklere kan på den måten enklere både lage snaps, typisk med fint GUI, og få dem distribuert ut via App Center. Firefox og Spotify er velkjente snaps. Programmene er «selvforsynte» pakker som har med seg alt de trenger for å kommunisere med og kjøre på Linux. De er ofte store med plasskrevende overhead.

snapd håndterer snap-systemet på Linux. Brukere forholder seg for det meste til App Center, både for å installerer, oppdaterer eller avinstallerer snaps. Men for å rydde trengs kommandolinje.
For å liste alle installerte snap-pakker, bruk:

```bash
snap list
```

Om man vil, kan man avinstallere også fra terminal ved
sudo snap remove <snap_name>
eller sjekke for oppdateringer ved
apt list --upgradable
Dessuten kan man få fram mer informasjon om snaps (som f.eks. vlc) ved
snap info vlc

Videre kan snapd beholde tidligere versjoner av snaps ved en oppdatering. Den vil merke dem som deaktivert (disabled), med de opptar likevel plass.

Lister man hva som er installert ved

```bash
snap list --all
```

får man en lang liste som inkluderer disse. Et lite eksempelutdrag er vist her. Vi ser at man har to versjoner av Spotify, hvorav den eldste er deaktivert.

```output
Name		Version			Rev	Tracking		Publisher	Notes
spotify	1.2.52.442.g01893f92	82	latest/stable	spotify✓	disabled
spotify	1.2.53.440.g7b2f582a	83	atest/stable	spotify✓	-

```
Det er mulig å fjerne slike ved å angi navn og revisjonsnummer vha. malen:

```bash
sudo snap remove <name> --revision=<rev>
```

Altså ut fra outputen over gjøre:

```bash
sudo snap remove 'spotify' --revision=82
```

Ønsker man å liste (navn og revisjonsnummer) over alle slike deaktiviserte kandidater, gjør man:

```bash
snap list --all | awk '/disabled/{print $1, $3}'
```

Man frigjør plass ved å slette slike, men mister muligheten til å rulle tilbake til tidligere versjoner.

Billedfiler er ofte store og kan også oppta mye plass. På

```output
~/snap/snap-store/common/.cache/snap-store/images
```

ligger det et større antall bilder. Mange er bare ikoner til bruk for App Center, men det vil også være reklamebilder for ulike snaps der, spill og annet. Det skader ikke å slette dem, selv om flere vil dukke opp igjen ved ny bruk av App Center.
På andre distribusjoner vil det være annerledes, så det anbefales å gjøre et billedsøk, som f.eks.

```bash
find . -type f -iname "*.jpg" -or -iname "*.png 
```

På Linux Mint ligger f.eks. tilsvarende bilder under cinnamon/spices/applet og hypnotix/providers.

### Miniatyrbilder

Miniatyrbilder (thumbnails) er småversjoner av bilder som File Manager og fotoapper lager + oppbevarer for å øke hastigheten i oversiktsvisninger av bilder. Disse kan slettes for å frigjøre plass eller av andre hensyn.

File Manager lagrer sine på ~/.cache/thumbnails (i underkataloger), så man kan f.eks. slette ved:

```bash
find ~/.cache/thumbnails-type f -iname "*.jpg" -or -iname "*.png" -delete
```

Ønsker man bare å se plassbruk, gjør:

```bash
du -sh ~/.cache/thumbnails/
```

Photoapper vil lagre sine på andre steder. Shotwell, én av disse, lagrer eksempelvis miniatyrbilder på ~/.cache/shotwell/thumbs. Man bør enkelt kunne finne tilsvarende sted for andre billed-snaps.


### Diverse filer

Systemet lagrer i hovedsak temporære filer på /tmp, og disse skal slettes ifm. restart. Flere av disse trengs imidlertid hele tiden av systemet, og mye av strukturen dukker raskt opp igjen. Normalt kan man stole på at systemet sletter og begrenser størrelsen av /tmp. 

snaps og andre programmer kan også ha temporære filer som kan slettes. Men hva, hvor og hvordan vil variere fra tilfelle til tilfelle. Det er eksempelvis sikkert kjent hvordan man kan tømme søkehistorikk og mellomlager i nettlesere som Firefox.

Når det gjelder logg-filer på /var/log, bør man være litt forsiktig med å fjerne filer. Prosesser kan bli hengende om en fil de forventer å finne, plutselig er borte. Logg-filer skal i utgangspunktet ikke slettes. Man risikerer også å slette spor man kan trenge i undersøkelser om noe skulle skje. Systemet rydder der før eller siden. Men så lenge alt er normalt og plassen begynner å bli trang, skader det nok ikke å krympe loggene litt. Det er tryggest er i så fall å begrense seg til .gz-filene og bruke truncate for å nulle ut blant dem, som eksempelvis her:

```bash
sudo truncate -s 0 syslog.4.gz
```

For journal-loggene fins det egne kall for krymping. For å se hvor mye plass arkiverte og aktive journaler tar opp, gjør:

```bash
journalctl --disk-usage
```

500 MB fikk jeg som svar ved forrige forsøk, men følgende kommandoer krymper vekk eldre deler ved hhv. å fjerne oppføringer eldre enn 7 dager eller til størrelsen er under 100 MB. (Kanskje den siste er greiest.)

```bash
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=100M
```

Dette er ryddigere enn en tilsvarende reduksjon av tekstfillogger på /var/log.

Noe annet som opptar plass, er tidligere benyttede Linux-kjerner. Når man oppdater kjerne, beholdes eldre versjon. Det er gode grunner til det. Om noe skulle slutte å virke eller låse seg i ny versjon, har man mulighet til å rulle tilbake til gammel kjerne. Man velger da bare Advanced Boot Option fra GRUB-menyen ved oppstart, velger gammel kjerne og starter opp med den. Da skulle alt være i orden igjen, og man kan gjerne avinstallere kjernen som skapte problemer

Man kan sjekke versjon av nåværende kjerne ved:

```bash
uname -r
```

```
6.8.0-52-generic
```


En liste over alle som er lagret, vises ved én av disse kommandoene:

```bash
sudo dpkg --list | grep 'linux-image'
apt list --installed | grep 'linux-image'
```

```output
ii  linux-image-6.8.0-51-generic	6.8.0-51.52	amd64	Signed kernel image generic
ii  linux-image-6.8.0-52-generic	6.8.0-52.53	amd64	Signed kernel image generic
ii  linux-image-generic-hwe-24.04	6.8.0-52.53	amd64	Generic Linux kernel image
```

Her er output for den første vist. Dersom man har testet den nye kjernen en stund og er sikker på at alt virker, kan man godt fjerne eldre versjon, altså 6.8.0-51-generic her, hvilket kan gjøres ved kommandoen:

```bash
sudo apt --purge remove 
```

```output
linux-image-6.8.0-51-generic
```

Alternativt vil tidligere nevnte kommando (men med opsjon --purge)

```bash
sudo apt autoremove --purge
```

fjerne både ubrukte programmer og ubrukte kjerner. 1 GB sånn ca. kan bli frigjort på denne måten for meg.

Videre er det sikkert filer på ~/Downloads å slette, og Rubbish Bin bør også slettes ved jevne mellomrom.

## Prosesser, minne og ytelse

Det er mange verktøy tilgjengelig til å monitorere ytelsene av Linux-maskiner. Noen følger med vanlige distribusjoner, andre må installeres, noen gjøre spesifikke oppgaver, andre en hel rekke. Medfølgende System Monitor kan f.eks. bidra.

Vi skal ta for oss et utvalg verktøy. Vi vil gjerne ha oversikt over prosesser som kjører, CPU-belasting, minnebruk, I/O, diskbruk og åpne filer, og etterhvert også detaljer om nettverkstrafikk og ressurser. Vi er ikke profesjonelle systemadministratorer og skal ikke drifte et nettverk av maskiner. Vi forventer ikke å forstå all output, men ønsker likevel mulighet for detaljer (i tillegg til sammenfattende oversikter), slik at vi med internettet i ryggen kan søke nærmere ved behov.

Om vi starter med å se på hva som kjører, er prosessoversikten i System Monitor veldig fin og oversiktlig. Output organiseres i en trestruktur. Man kan sortere etter kolonneoverskriftene, slik at man kjapt kan se hvilke brukere og systembrukere som kjører, CPU- og minneforbruk for de ulike prosessene og hvilke som skriver til disk mm. Man kan også høyreklikke på prosesser og få opp mer informasjon + enkelte handlinger, deriblant kill.

Ellers har vi jo velkjente ps. Den har mange opsjoner og muligheter. F.eks.

```bash
ps -ef | less				# Viser alt
ps -ef | grep avahi-daemon		# 
```

Viser linjer som inneholder bestemt ord

```ouput
UID          PID    PPID  C STIME TTY          TIME CMD
avahi       1066       1  0 Mar04 ?        00:00:06 avahi-daemon: running [JanAsus.local]
avahi       1148    1066  0 Mar04 ?        00:00:00 avahi-daemon: chroot helper
jan        62290   55874  0 10:20 pts/1    00:00:00 grep --color=auto avahi-daemon
ps -ejH					# Viser som prosesstre
ps -eLf					# Viser info om tråder
ps -C firefox				# Viser informasjon om bestemt prosess
ps -ef | head -1; ps -ef | grep gnome-skall	# Inkluderer overskrift i søket
```

m.fl. Vanlige brukere vet neppe hva hærskaren av systemprosesser gjør, så det skader ikke å ha filkopier av ps -ef-output fra tidligere som et sammenlikningsgrunnlag. Og om en prosess skulle henge, bør vi i det minste kunne finne rett PID og drepe den med:

```bash
kill -9 <PID>
```

Her ser vi to ps-baserte kommandoer som viser de 5 mest CPU-intensive og de 5 mest minneintense prosessene som kjører nå, og som kanskje må følges nærmere:

```bash
ps -eo comm,pcpu --sort -pcpu | head -5;
ps -eo comm,pmem --sort -pmem | head -5
```

En annen kommando som viser det kjørende systemet er top (Table of Process), evt. htop, som er en populær en tredjeparts utvidelse av denne. Den viser en real-time-oversikt (oppdatering hvert 5. sekund). Man starter den ved

```bash
top
```

og så kan man hoppe mellom ulike visninger med bokstavkommandoer (trykk h når programmet kjører for å se hvilke). Sammenfattende informasjon (om prosesser, CPU, minne og SWAP) vises øverst, og listen av prosesser under.

Trykker man gjentatte ganger på t, får man ulike CPU-fokuserte visninger, slik at man raskt kan se totalbelastning og de mest CPU-intensive prosessene
.
Trykker man gjentatte ganger på m, får man ulike minnevisninger, slik at man raskt kan se totalforbruk og de mest minneintensive prosessene.
Med htop kan man velge det tilsvarende med museklikk.

Minnet i Linux kan vi overordnet si består av vanlig (raskt, men begrenset) RAM-minne, samt et reservert område på disken (tregt, men stort) kalt SWAP-minne (swapped out eller paged out memory). Kommandoen

```bash
free -h
```

(evt. bare free) gir et øyeblikksbilde av minnebruken. Ønsker man en mer dynamisk oversikt, kan man be om gjentatte øyeblikksbilder, f.eks. hvert tredje sekund ved:

```bash
free -s 3
```

Kommandoen leser egentlig av filen /proc/meminfo.

Buffere og cache (mellomlager) vil også lagres i minnet. Buffere er typisk implementert i RAM og inneholder originalkopier av data for å kompensere for hastighetsforskjeller mellom utvekslende prosesser, typisk ifm. I/O. Bufferne bidrar til økt effektivitet, reduserte antall I/O-operasjoner og mindre datatap. Cache lagrer hyppige brukte data og instruksjoner for å redusere tiden det tar å hente data, og på den måten øke hastigheten av hele systemet. Cache-funksjoner implementeres både i RAM og på disk.

For å få mer detaljert informasjon, også om dette siste, kan man benytte vmstat (Virtual Memory Statistic Reporter):

```bash
vmstat
```

```output
procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
 2  1    512 880084 104672 3673460    0    0    31   107  783    3  3  1 96  0  0  0
 ```
Forklaring av hver kolonne krever litt plass, så det er lagt til appendix.

De to siste fremstår sikkert nokså kryptiske, men er relatert til kjøring av såkalte Virtuals machines. Det er noe man kan installere for (typisk) å kjøre et annet operativsystem (eller annen distribusjon) i noe som fremstår som en egen maskin i programvare på maskinen, altså en virtuell maskin. Det fins gratisverktøy for dette, og drevne bruker benytter hyppig slike i eksperimentering, læring og annet. Men det må åpnes for i BIOS, og begge kolonnene bør derfor alltid vise 0 for oss.

Også top rapporterer for øvrig st.

vmstat gir også et øyeblikksbilde, men kan gjentas f.eks. hvert femte sekund ved

```bash
vmstat 5
```

Disk-relvant informasjon får ved

```bash
vmstat -d
vmstat -D
```

og informasjon rundt minne ved:

```bash
sudo vmstat -m | less
```

iostat er en annen kommando som ofte også nevnes. Den har mye til felles med vmstat, men informerer mer på enkeltpartisjoner.

Trenger man å se spesielt på I/O-aktivitet, kan man se på iotop.

For å få innsikt i åpne filer på systemet, kan man benytte lsof (List Open Files).  Her er noen eksempler med forklaringer:

```bash
lsof -c firefox		   # Filer åpnet av en gitt prosess
sudo lsof /var/log/syslog  # Prosesser som har åpnet gitt fil
sudo lsof +D /var/log/	   # 
```
Prosesser som har åpnet gitt katalog

```bash
sudo lsof -u jan		   # Filer åpnet av bestemt bruker
sudo -i			   # Filer åpnet av nettverkstjenester
sudo -i :22			   # Filer åpnet av nettverkstjenester over port 22 
sudo lsof -i tcp		   # Filer åpnet TCP-protokollen
```


Når det gjelder diskbruk er snappen Disk Analyser, som er preinstallert på Ubuntu, en fint verktøy som viser hva som tar opp mest plass.  Ellers kan kommandoen df -h vise ledig plass på alle partisjonene. Videre kan du -h vise opptatt plass av filer og kataloger.

Et greit eksempel med det siste er

```bash
du -h -BK --max-depth=1 . | sort -r -n
```

som viser diskbruken til gjeldende katalog alle alle dens underkataloger ett nivå nedenfor, sortert etter størrelse.

## Nettverk

Det er mange verktøy tilgjengelig, både for å få oversikt over nettverket rundt seg og for å monitorere trafikk. Ettersom vi ikke skal administrere noe nettverk med flere brukere, bare holde litt oversikt over et vanlig hjemmenettverk, som trolig høyst består av en PC eller to, noen mobiltelefoner og nettbrett, en TV, kanskje en netthøyttaler, en printer og den slags, er behovet vårt i hverdagen nokså beskjedent. Normalt er behovet for rekonfigureringer og komplisert samhandling lite. Men det er alltid morsomt å ha en viss oversikt over hjemmenettverket.

Jeg vil tro alle har en trådløs ruter som gir enhetene interne IP-adresser til hjemmeenhetene og sørger for kommunikasjon ut via et grensesnitt. Kommandoen ip kan benyttes til å få en oversikt. (Dessuten tilbyr mange internettleverandører en nettbasert administrasjon av ruteren med gode oversikter av dens hjemmenett.) Hvis denne og flere andre senere kommandoer ikke allerede er installert, installer dem felles med:

```bash
sudo apt update && sudo apt install net-tools
```

Deretter kan man kjøre:

```bash
ip -c a					# For detaljert info
ip -c -brief a				# For kun overordnet info
```

som gir en oversikt (i farger) bl.a. av PC-ens IP- og MAC-addresse. Under ser vi (for et enkelt hjemmenettverk) det samme for grensesnittet på ruteren:

```bash
ip -c n
```

ip erstatter den tidligere i iconfig.

For info om DNS og DNS-tjenere, har vi kommandoene dig og resolvectl. F.eks.

```bash
dig www.vg.no +short
```

```output
195.88.55.16
195.88.54.16
```

Evt. for flere detaljer kan man gjøre

```bash
dig www.vg.no +nocomments
```

Følgende inkluderer litt statistikk:
dig www.vg.no +noall +answer +stats
Her er et par varianter med 

```bash
resolvectl:
resolvectl status
```

Et oppslag på et bestemt nettsted:

```bash
resolvectl query www.vg.no
```

```output
www.vg.no: 195.88.55.16                        -- link: wlo1
           195.88.54.16                        -- link: wlo1
           2001:67c:21e0::16                   -- link: wlo1
-- Information acquired via protocol DNS in 10.2ms.
-- Data is authenticated: no; Data was acquired via local or encrypted transport: no
-- Data from: network
```

Her tømmes DNS-mellomlageret, hvilket er greit for fjerning av utdaterte resultater:
resolvectl flush-caches

Hva med å liste opp hele ruten til et nettsted?

```bash
sudo apt install 
```

```
inetutils-traceroute
inetutils-traceroute www.wolfram.com
traceroute to www.wolfram.com (140.177.9.134), 64 hops max
 1   172.16.10.1  1.466ms  1.396ms  1.375ms
 2   82.146.71.1  4.261ms  3.626ms  2.979ms 
 3   213.239.106.13  11.587ms  4.570ms  2.736ms
 4   193.90.113.101  4.540ms  3.776ms  58.095ms
 5   195.0.244.91  5.762ms  4.158ms  4.213ms 
 ...
 27   72.251.165.138  205.039ms  *  131.309ms
 28   140.177.9.134  129.105ms  129.917ms  128.366ms
```

En annen kommando er ss, som erstatter den tidligere kommandoen netstat. ss viser info om TCP, UDP og sockets. Output kan ofte bli lang. Kommandoen

```bash
ss -l
```

lister lyttende sockets.
De følgende to lister lyttende TCP- og UDP-sockets:

```bash
ss -tul
ss -tur state listening
```

Det følgende lister etablerte TCP- og UDP-forbindelser (hvor man også ved -r prøver å vise nettverksadresser ved navn og porter ved protokoller):

```bash
ss -tur state established
```

Her er sockets med etablerte HTTPS-forbindelser:

```bash
ss -a state established '( dport = :https or sport = :https )'
```

Her ser vi alle (-a)  sockets assosiert med SSH, hhv. via navn og portnummer:

```bash
ss -a '( dport = :ssh or sport = :ssh )'
ss -a '( dport = :22 or sport = :22 )'
```

For å se hvilke prosesser som bruker gitte sockets, kan man inkludere -p:

```bash
sudo ss -tup
```

En annen kommando som har erstattet netstat, er nstat. Den overvåker nettverket og kan utnyttes ved feilsøk, f.eks. ved ineffektivt nett. Høye verdier fra de to første  kommandoene under tyder på feilkonfigurering i nettverket. Høye verdier fra de to siste tyder på flaskehalser eller dårlig nett.

```bash
watch nstat IpInDiscards			# number of discarded IP packets
watch nstat TcpExtTCPAbortOnData		# connections reset due to unexpected data
watch nstat TcpExtTCPSynRetrans		# retransmitted SYN packets
watch nstat TcpExtTCPSlowStartRetrans	# retransmissions due to slow start 
```

Tcpdump er er det mest benyttede verktøyet for å analysere og monitorere nettrafikk. La oss se på noen eksempler.
Det følgende lister hvilke nettverksgrensesnitt som er tilgjengelig:

```bash
tcpdump -D
```

```output
1.wlo1 [Up, Running, Wireless, Associated]
2.any (Pseudo-device that captures on all interfaces) [Up, Running]
3.lo [Up, Running, Loopback]
4.bluetooth0 (Bluetooth adapter number 0) [Wireless, Association status unknown]
5.bluetooth-monitor (Bluetooth Linux Monitor) [Wireless]
6.nflog (Linux netfilter log (NFLOG) interface) [none]
7.nfqueue (Linux netfilter queue (NFQUEUE) interface) [none]
8.dbus-system (D-Bus system bus) [none]
9.dbus-session (D-Bus session bus) [none]
```

Her kan vi dermed monitorere trafikk hhv. over wifi-grensesnittet eller over blåtann:

```bash
sudo tcpdump -i wlo1
sudo tcpdump -i bluetooth0
```

Under monitoreres hhv. all TCP-, UDP eller ICM-trafikk:

```bash
sudo tcpdump tcp
sudo tcpdump udp
sudo tcpdump icmp
```

Ønsker vi å følge trafikk til en bestemt IP-adresse eller port, kan man gjøre:

```bash
sudo tcpdump host <IP-adresse>
sudo tcpdump port <Portnummer>
```

Man kan også benytte src og dst for source og destination, samt logiske operatorer som or, and og not, som i dette eksempelet:

```bash
sudo tcpdump src host 192.168.1.100 and \( port 80 or port 443 \)
```

For å se trafikk på et bestemt nett:
sudo tcpdump net 192.168.1.0/24
For å se trafikk over bestemte portintervall:

```bash
sudo tcpdump 'tcp[0:2] > 1023 and tcp[0:2] < 65536'		# Kilde portintervall
sudo tcpdump 'tcp[2:2] > 1023 and tcp[2:2] < 65536'		# Ende portintervall
```

Dette kan i hvert fall være et utgangspunkt.