# ☑️ Valg og forutsetninger

Før kan fokusere på Linux-kommandoene, må vi foreta noen valg og redegjøre for diverse betingelser. Det må velges skjell, editor og annet, og visse ting må sies før vi kan begynne. Det kan også være verdt på peke på enkelte ting man kan lese mer om for få en arbeidsflyt som man ønsker.

## 🐚 Valg av skjell

En terminal vil følge med distribusjonen og ved default kjøre ett av flere mulige skjell. Skjellene har forskjellige måter å effektivisere arbeidsflyten på. De har mye til felles, men også særtrekk som appellerer ulikt til ulike brukere. *Bourne again shell* (**bash**) er standard på mange distribusjoner, inklusive Ubuntu, Mint og Fedora, og benyttes gjerne i medfølgende skjellskript. Det er derfor naturlig å velg **bash** for våre skjellskript. Det er uansett enkelt å bytte skjell. **zsh** og **fish** er to populære valg, og for min måte å jobbe på, er det sistnevnte er mest effektivt. Også **zsh**, med sine mange *extensions*, har mange die-hard fans. Det er naturlig å eksperimentere litt.

Kommandoen

```bash
echo $SHELL
```

viser hvilket skjell man kjører.

### 🔧 Terminalemulatorer og konfigurering av skjell

Selv om det ikke er nødvendig, ønsker mange etter hvert å konfigurere terminalen sin. Vi har alle våre preferanser når det gjelder font, farger på bakgrunn, tekst, spesielle ord, opsjoner og annet. Noen liker mørke tema, andre lyse. Noen vil ha delvis gjennomsiktig bakgrunn, andre ikke. Noen ønsker seg et minimalistisk kommandoprompt som kanskje bare viser navnet på gjeldende katalog, mens andre vil ha ett med mye tilleggsinformasjon i bestemte farger, kanskje over en linje eller to osv. Dette er ikke bare jåleri, men bidrar også til effektivisering av arbeidet.

**`starship`** er nok det vanligste programmet for konfigurering av kommandoprompt. De har bl.a. ferdige *presets* man kan ta utgangspunkt i på hjemmesidene sine.

I tillegg ønsker man gjerne ha mulighet til å vise flere terminalvinduer på en effektiv måte. Man vil sikkert ønske seg flere faner, men også mulighet for å dele opp vinduet horisontalt og vertikalt på en effektiv måte. Terminal-multiplexing, som vi egentlig snakker om her, kan være innebygd i terminaler på enkelte distribusjoner (ingen av de vi ser på), men generelt må noe installeres for å få dette til. Tidligere gjorde man dette med en egen kommando, `screen` (med noen tilhørende tastatursnarveier som var vanskelig å huske). Nå er mulighetene flere. `tmux` er et populært valg for mange, særlig fordi det kan tilpasses en effektiv bruk ved hjelp via en fleksible konfigurering. 

Man har også såkalt terminalemulatorer, som er egne, selvstendige terminaler med multiplexing og andre utvidelser innebygd. Igjen er valgene mange. Alacritty, Kitty, Terminator og Waze er mye brukt, men i det senere har nyere konkurrenter som Ghostty og Warp fått mye oppmerksomhet. Førstnevnte er såkalt *cross plattform*, skal kjøre veldig raskt, har et bredt sett av temaer, gode, fleksible konfigureringsmuligher, og er godt tilrettelagt for videre interoperabilitet. Systemutviklere har lenge ventet på programmet, og det forventes en aktiv videreutvikling i tiden framover. Warp på sin side er ikke *open source*, men har innebygd AI og gode muligheter for arbeidsdeling. Det har raskt blitt et attraktivt og spennende valg for mange.

Arbeidsflyten kan effektivisere på enda flere måter også. Særlig vil programmer som `fzf` (Fuzzy Find), i kombinasjon med andre kommandoer, gjøre mange oppgaver (som søk etter filer og kataloger) til en lek.

Det er mer man kan si om alt dette, man nå bør man i det minste ha et utgangspunkt for videre søk og undersøkelser.

## 📝 Valg av editor

Man trenger en teksteditor for å lage tekstfiler man kan eksperimentere med. Flere DE-er inkluderer egne teksteditorer man kan bruke. Disse kan være alt fra enkle til funksjonsrike, men vil variere fra distribusjon til distribusjon.

I tillegg fins det universelt tilgjengelige standardeditorer som **vi**,**vim**, **neovim** og **nano**. Den første, som har vært med siden starten, er veldig minimalistisk og lite intuitiv i bruk. Få hjemmebrukere vil starte med den. **vim** er også en gammel traver, men har fortsatt sine entusiastiske tilhengere. Om de da ikke har godt over til den moderen utgaven **neovim**, som både er mer fleksibel, konfigurerbar og utvidbar. Begge disse er også lite intuitive i bruk, men kan styres effektivt med tastatursnarveier, når man bare har fått alt til å sitte i fingrene. Læringskurven er bratt, men om man programmerer eller skriver mye, kan dette være gode alternativer.

**nano** er langt enklere. Man trenger ingen innføring. Det er bare å opprette fil, skrive, editere, lagre (`ctrl+s`) og avslutte (`ctrl+x`) i vei. Men det kan være verdt å se på noen av snarveiene, ikke minst fordi tastekombinasjonene er så annerledes enn vanlig.

```output
Alt+U		Undo
Alt+E		Redo
Ctrl+K	    Cut
Alt+6		Copy
Ctrl+U	    Paste
Ctrl+Y	    One page up
Ctrl+V	    One page down
Ctrl+O	    Save as
Ctrl+W	    Search for a string or a regular expression
Alt+R		Replace a string or a regular expression
Ctrl+R	    Insert another file into the current
Ctrl+T   	Execute and paste output from command
Alt+N		Turn line numbers on/off
Alt+G		Go to line number, column number
Alt+D		Report number of lines, words and characters
```

m.fl. Når man inkluderer `#!/bin/bash` (evt. et annet skall) i starten, blir dessuten filen oversiktlig fargelagt og formatert. Den er kjapp og grei for enkle skript.

Til mer sammensatte skript og lengre tekst, er Visual Code Studio (VSCode) å anbefale. Det er egentlig et (svært utbredt) IDE for programmeringen, men kan også benyttes til generell skriving. Selv skriver jeg mye i Markdown og Asciidoc (to tekstnære formater egnet for alt fra korte informasjonsskriv til dokumentasjon, artikler og hele bøker), og benytter VSCode her. Det er langt mer avansert og har rike muligheter for editering, tilpasning og formatering (for skjellskript når man inkluderer `#!/bin/bash` eller tilsvarende i starten også der).

## ⭐ Kommandoer i nyere utgaver

Linux-samfunnet er stort, levende og preget av stadig innovasjon. I de senere år har man sett en trend der utviklermiljøene har jobbet fram moderne utgaver av tradisjonelle Linux-kommandoer. Disse nye variantene er typisk skrevet i Rust (et nyere, populært programmeringsspråk velegnet for slik bruk) og er gjerne kjappere, mer brukervennlige, mer intuitive, har enklere syntaks og smartere default-verdier mm. De tradisjonelle kommandoene, utviklet kanskje på 70-tallet, var ment for profesjonelle, og syntaksdetaljene kan være vanskelig å huske for de som ikke bruker dem daglig. Fargelegging og pen strukturering av output var også noe som var mindre aktuelt den gang, men som er inkludert i nyere versjoner.

Eksempler på slike nye og gamle kommandoer er:

- `fd` for `find`
-`rg` for `grep`
- `sd` for `sed`
- `eza` for `ls`
- `bat` for `cat`
- `procs` for `ps`
- `delta` for `diff`
- `xh` for `curl`
- `bottom` for `top`
- `ncdu` for `du`
- `duf` for `df`
  
og flere til. (En moderne Rust-utgave for `awk` mangler for øvrig ennå.)

Vi skal ta for både gamle og moderne utgaver (der de finnes) for kommandoer vi fokuserer på. Jeg bruker alltid de nyere i min hverdag, men det er greit med kjennskap til de eldre variantene, ettersom mange skript fortsatt benytter dem.

## Opsjonssyntaks

Kommandoer har opsjoner som kan brukes både i kort (UNIX-stil) og langt format (GNU-stil). Vi vil gjennomgående benytte de korte (der de finnes). Altså vil vi gjennomgående skrive f.eks.

```bash
tar -tvf bigArchive.tar
```

og ikke 

```bash
tar --list --verbose --file=bigArchive.tar
```

Fordelen med de korte er selvsagt at de medfører mindre skriving, men har ulempen at de er vanskeligere å huske.

Det fins også en BSD-stil for opsjoner (hvor man. bl.a ikke benytter `-`), men den ignoreres.
