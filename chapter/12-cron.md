# 🕛 cron

`cron` kan starte prosesser regelmessig. Når og hvilke styres **crontab**. (Muligens må man først installere ved hjelp av `sudo apt install cron`.) Brukeren kommer så igang ved å skrive:

```bash
crontab -e
```

Da åpnes en konfigureringsfil for `cron` tilknyttet brukeren. (Alle linjer i filen er i utgangspunktet kommentert ut med **#**.) Innledningsvis står et forklarende tekst, før man kommer til følgende to linjer nederst i filen.  Den første av disse er forklarende. Man kan så fjerne kommentarsymbolet **#** og fylle inn tidsangivelser og kommando etter ønske i siste linje.

```output
# m   h  dom mon dow   command
# *   *   *   *   *    *
```

Feltene der har følgende betydning:

```output
m = minutes	(0-59)
h = hours	(0-23)
dom = day of the month	(1-31)
mon = month of the year	(1-12)
dow = day of the week	(0-6)
```

Dermed kan man f.eks. enkelt sette igang en kommando eller skript på et bestemt klokkeslett med en bestemt frekvens. Eventuell output kan dirigeres til fil i kommandoangivelsen om ønskelig. Her kopieres eksempelvis en fil hver søndag kl 18.00:

```output
# m   h  	dom 	mon 	dow   command
  0	18	*	*	0	cp ~/Backup/arkiv.tar.gz /media/jan/Backup
```

Hva om man ønsker å utføre noen man ikke har privilegier til, f.eks. å foreta **shutdown** etter en bakup eller tilsvarende? Da må man starte med:

```bash
sudo crontab -u root -e
```

og man editerer ikke egen **crontab-fil**, med **root**s.  Under ser vi et eksempel der det kjøres et skript kalt **backUpSkript** kl. halv ett hver natt, og PC-en skrus av hver gang denne er ferdig.

```output
30 0 * * * cd /home/jan; /home/jan/bin/backUpSkript; shutdown -H +2 "User system backed up. System will halt in 2 minutes"
```

Her gir `shutdown` to minutters varsel. Husk at en `shutdown` kan kanselleres ved:

```bash
sudo shutdown -c
```

**cron** logger på **/var/log/syslog**, så man kan f.eks. følge litt med på aktiviteten ved:

```bash
cat /var/log/syslog | grep cron

```
eller mer spesifikt ved **journalctl**, som f.eks.

```bash
journalctl -u cron --since "1 hour ago"
```

Merk: **root** kjører en `cron`-jobb, kanskje hvert femte minutt, for å samle systemstatistikk. Skriptet for dette heter **debian-sa1**, og fyller opp mye av loggen for `cron`.

Verken `atv`- eller `cron`-jobber kjører hvis PC-en er av (eller de tilhørende demonene ikke kjører) ved angitte tidspunkter.