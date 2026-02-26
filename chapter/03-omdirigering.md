# 🔧 Piper og omdirigering

Før vi kan fokusere helhjertet på kommandoer, må vi se på hvordan de kan kombineres -- med hverandre og med omgivelsene, ved såkalt omdirigering.

Den kanskje viktigste er `|` (pipe) som tar output fra en kommando som input til ny kommando. Et enkelt eksempel er å pipe til `less` ved lang output (output vises da en skjerm ad gangen), f.eks:

```bash
ps -ef | less
```

Man kan sende output fra en kommando til ny fil med `>`, til standard error ved `>2` og til standard output og standard error ved `>&`. Man kan tilføye til fil ved `>>`, som f.eks:

```bash
tail /var/log/syslog | grep dbus-daemon >> log.txt
```

Her leter man (ved `grep`) opp forekomster av ordet dbus-daemon på slutten av **`sylslog`**-filen (pga. `tail`) og legger tilhørende linjer ut til fil.

Videre kan innholdet av en fil kan sendes til en kommando ved `cmd<fil`. F.eks:

```bash
cat < input.txt > output.txt
```

I tillegg har man kommandoen `tee`, som splitter output fra en kommando både til stdout og til fil.  Under ser vi et eksempel. Det ser ut til man kjører et skript kalt **runBackup** (som kanskje tar lang tid), og omdirigeringen gjør at brukeren også kan studere output senere:

```bash
runBackup | tee BACKUP-LOG.txt
```

En funksjonalitet vi også kan nevne i denne sammenheng, er kommandoen `xargs`. Den leser fra **stdin** (typisk en output fra en kommando som går over flere linjer) og konstruerer en liste av argumenter fra dette til bruk for andre kommandoer. Flere kommandoer er avhengige av `xargs` som mellommann når output fra andre skal være input.

Et eksempel er:

```bash
find . -name "*.tmp" | xargs rm
```

Denne finner alle filer med endelse **tmp** under gjeldende katalog, og fjerner dem. Konkret finner `find` filene og returnerer navnene under hverandre på hver sin linje (en vertikal liste):

```output
doc/fil-1.tmp
./fil-2.tmp
```

`rm`-kommandoen vil imidlertid ikke kunne håndtere dette som input. Men `xargs` lager en argumentliste fra dette (en horisontal liste), og sørger for at det følgende utføres

```bash
rm doc/fil-1.tmp ./fil-2.tmp
```

hvilket fungerer fint.

Opsjonen `-n <antall>` til `xargs` kan være viktig å kjenne til. Den kontrollerer antall argumenter som videreføres til sluttkommandoen om gangen. Noen kommandoer, som `mkdir`, `rmdir` aksepterer bare ett argument, så om de ønsker å utnytte `xargs` tilsvarende, må man inkludere `-n 1`, som f.eks. her:

```bash
find . -type d -name "tmp" | xargs -n 1 rmdir
```

Kataloger med navn **tmp** slettes der i tur og orden.
