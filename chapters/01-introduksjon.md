<img src="images/cover.png" class="centerpict">

# 📚 Introduksjon

For personlig hjemmebruk bør Linux være et svært godt alternativ til Windows og MacOS for mange, og til flere enn de som faktisk brukere det i dag. Ikke bare er det gratis, men det er også brukervennlig, stabilt, ser moderne og stilig ut, og kan kjøres på alle maskiner, også på PC-er som ellers etter hvert begynner å bli ukurante. Mulighetene for hjelp og støtte er veldig gode, og ikke minst har man frihet til å konfigurere eller få utført ting nøyaktig som man måtte ønske. Begrensingene er få. Linux kan installeres ved siden av Windows eller alene. Man kan bytte grafisk brukergrensesnitt når det måtte være, og bare man ikke har dataskrekk, bør Linux i dag være velegnet også for alminnelig bruk.

Tradisjonelt har Linux-brukere gjerne vært entusiastene med betydelige data- og programmeringskompetanse. Den slags folk tiltrekkes Linux fremdeles, men så eksklusivt trenger det ikke lenger å være. Moderne Linux-distribusjoner er ikke bare brukervennlige, med de har også god støtte for tekstbehandling, regneark, verktøy for presentasjoner, billedbehandling, internett, nettlesing, e-post, printing og det meste annet. Alt er gjerne gratis og står ikke tilbake i funksjonalitet for det man er vant til på andre plattformer. I tillegg har man alltid all slags støttverktøy tilgjengelig, det være seg de for backup, kryptering, versjonskontroll, huskelister, notater og det meste ellers.

Denne boken er for dem som ønsker å ta i bruk Linux på sin personlige hjemmemaskin. Den henvender seg ikke til drevne entusiaster. Disse klarer seg uten hjelp. Ei heller forsøker den å være startstedet for Linux-nybegynnere. Det fins mange gode introduksjoner man heller kan starte med. Denne boken er for relativt ferske Linux-brukere som ønsker å ta *det neste steget*. De som av nysgjerrighet eller behov, ønsker å ha mer oversikt, større utbytte, større glede og mer kontroll i sin Linux-hverdag.

Vi kommer derfor ikke til å snakke om de vanligste, mest grunnleggende kommandoene som `cd`, `pwd`, `cp`, `ls`, `mkdir`, `rm`, `mv`, `man`, `echo`, `cat`, `tail`, `head`, `more` og `less`. Selv viktige opsjoner til disse (som at  `rm -i` ber om bekreftelse før sletting og at  `rm -r` sletter rekursivt) lar vi ligge. De grunnleggende kommandoene lærer man seg fort uansett. Derimot skal vi si mer om viktige, men kanskje mer brysomme kommandoer som `find`, `sed`, `grep`, `awk`, `tar` og mange andre. Om du har vært borte i disse, skader det kanskje ikke med en oppfriskning. Dessuten kommer man da gjerne fort i kontakt med såkalte regulære uttrykk (**regex**), som ved første øyekast kan se litt avskrekkende ut, og som gjerne er vanskelige å huske. Første halvdel vies derfor viktige Linux-kommandoer.

Boken beskriver også nærmere funksjonalitet og muligheter som er nyttige, men som kanskje er mindre kjente, eksempelvis *extended file attributes* og *immutable file attributes* (to ulike utvidede filattributter). Vi skal videre se på skjellprogrammering og Makefiles (for mer sammensatte oppgaver), på **gpg** for kryptering og signering, på `at`, `cron`, `ufw` og mere til. Vi vil se også litt på praktiske administrative oppgaver, som logganalyse, nettverksinformasjon, systemvedlikehold og annet for vanlig, privat desktop-bruk. Systemadministrasjon av større systemer eller spesialiserte server-maskiner går utenfor denne boken. Litt vil bli nevnt om sikkerhet underveis, men boken kan ikke å behandle et så stort emne på en utfyllende måte.

## 🐧 Linux-distribusjoner

Det fins etter hvert tusenvis av Linux-distribusjoner. Tilgangen til åpen kildekode, mange entusiaster og ulike ønsker, gjør at flere setter samme distribusjoner med ulike karakteristika. Friheten i Linux er både til glede og frustrasjon. Hvilken man velger, avhenger både av PC-ens ressurser og brukerens preferanser.

En distribusjon kan gjør ulike valg av kjerne (kort fortalt det som sørger for forbindelse mellom maskinvare og prosesser), pakkesystem, grafisk grensesnitt, underliggende tjenester, brukerapplikasjoner mm. Noen distribusjoner er velegnet for nybegynnere, andre for profesjonelle. Noen er store med mye brukerfunksjonalitet. Andre er små og effektive, og overlater flere valg til brukeren. Noen har et brukergrensesnitt som likner Windows, andre ikke.

Distribusjonene kan grupperes i tre hovedvarianter (med mange undergrupperinger) ut fra innebygd pakkesystem. Hovedvariantene er vist under, og noen av de vanligste distribusjonene fra hver er angitt i parentes:

- Debian-baserte (inklusive Ubuntu, Mint, Pop!_OS, Elementary OS, MX og Zorin OS)
- Pacman-baserte (inklusive Arch, Manjaro og EndeavourOS)
- RPM-baserte (inklusive Fedora og Red Hat)

Entusiaster og drevne brukere har gjerne sine egne favoritter. For nybegynnere er valgene færre, selv om man også her har flere alternativer. Ubuntu og Mint er ofte de som anbefales nybegynnere (men på ingen måte bare de). Jeg benytter begge, og har også eksperimentert en del med Fedora. Sistnevnte er kjent for å ligge i front på ny funksjonalitet, men må gjerne gjennom mer initiell konfigurering før oppsettet blir slik man ønsker.

Ubuntu er kanskje så nærme man kommer en de facto-standard for vanlige brukere i dag. Den er utbredt, svært stabil og har et stort brukersamfunn hvor man enkelt kan finne hjelp. Det medfølgende brukergrensesnittet (GNOME) ser vakkert ut og har veldig god brukervennlighet. Noen misliker at snap-programvarepakkene deres (mer om dem etter hvert) har store overhead og kan være mindre kjappe ved oppstart. Det kan være merkbart for store applikasjoner. Men man er uansett ikke låst til dette. Man står fritt til å installere andre pakkesystemer som Flatpak eller andre.

Linux Mint er også et godt og populært valg. Det er like stabilt, har et flott medfølgende brukergrensesnitt (Cinnamon) som for noen har fordelen av å likne mye på Windows.

Ferske brukere bør styre unna enkelte distribusjoner (som Arch og Kali m.fl.). Allerede ved installasjonen vil man her måtte ta stilling til spørsmål man kanskje ikke har forhold til. Men det er også det å si at fordi konfigureringsmulighetene i Linux er så store, og fordi brukergrensesnittet godt kan byttes ut, er forskjellene i brukeropplevelse, utseende og funksjonalitet ikke alltid så merkbare. Men det vil uansett være noen forskjeller igjen her og der, i første rekke rundt installasjon og oppdateringer av programpakker. Det følgende viser f.eks. hvordan man installerer pakken **systat** på tre distribusjoner fra kommandolinjen:

```bash
sudo apt install sysstat    # Ubuntu og Mint
sudo dnf install sysstat    # Fedora
sudo pacman -S sysstat      # Arch
```

En viktig ting å ta stilling er oppdateringssyklusen som er lagt til grunn i distribusjonen. Noen av dem liker å ligge i front og tilbyr hurtige oppdateringer og nyeste versjoner (som dermed fort kan ha feil), mens andre fokuserer mer på stabilitet og en mer forsiktig i sin strategi. Ubuntu og Mint er av dem som prioriterer stabilitet, hvilket er nok et argument for å anbefale dem for vår bruk.

Ellers er det klart at Linux kanskje i enda større grad enn andre opereativsystemer, er i konstant utvikling. Mye av grunnstrukturen og kommandoene består, men stadige nye muligheter, som inkludering og bruk av AI, gjør at flere verktøy stadig endres. Dette bør ikke oppfattes negativt. Dynamikken gjør fagfelt spennende, og gjør at man alltid kan lære seg noe nytt.

## 🔧 Installasjon

Når det gjelder selve installasjonen, fins det gode veiledninger på nettet for alle vanlige distribusjoner. Tanken er at de fleste lesere allerede har gjort det. Kort fortalt er det enkelt. Det vanligste for vanlige brukere er kanskje å installere det parallelt med Windows. (Det kan jo være nødvendig for å sikre støtte for noe hardware man har eller liknende.) Ønsker man dette, må man bl.a. inn i BIOS og endre et par innstillinger, samt repartisjonere disken. Man ender opp med en (GRUB-) meny som dukker opp ved oppstart, der man kan velge start av Windows, vanlig Linux eller Linux i såkalt *Advanced Boot Option* (i tilfelle problemer skulle oppstå). 

## 🎁 Pakkesystemer

Man har to hovedmåter å installere programmer på under Linux. Man kan installere distrospesifikt via kommandolinjen, som eksemplifisert over for Debian-, Pacman- og RPM-varianter, eller man kan installere fra universelle pakkesystemer fra en form for AppStore via et grafisk brukergrensesnitt.

(Det fins også flere mer uavhengige, direkte måter å installere programmer på (f.eks. fra steder som GitHub for all slags programmer eller Rust-programmer via Cargo-systemet), men disse skal vi la ligge. Man vil ikke treffe ofte på disse i oppstarten.)

Distrospesifikke programmer tilbys av de som utgir og vedlikeholder distribusjonen. Disse består av vanlige binærfiler, biblioteker og konfigurasjonsfiler. De får en vanlig plass i systemet (på **/usr/bin** og liknende) og vil inngå i systemets pakkadatabase hvor avhengigheter, konflikter og versjoner kontrolleres. Programmene benytter systemets øvrige biblioteker, hvilket gjør dem raske, lette og effektive.

De universelle programpakken er ment å kjøre på flere (helst alle) distribusjoner og er selvforsynte programpakker som inneholder alt det de måtte trenge av biblioteker og støtteprogrammer. De kjører typisk i et begrenset og kontrollert miljø (*sandboxing*) for økt sikkerhet og for å isolerer dem mest mulig fra systemet. De installeres gjerne til egne kataloger (som **/var/lib/flatpak** eller **/snap**). Slike generelle pakker kan være tilgjengelig i nyere versjoner, ettersom veien til utviklerne er kortere, men kan være noe tregere pga. nevnte overhead. Snaps tilbys f.eks. default via App Center, og flatpak-programmer tilbys via Flathub. Førstnevnte system er default på Ubuntu og Mint, mens sistnevnte er default på f.eks. Fedora.

Det fins også flere slike universelle pakkesystemer, som Homebrew, Appimage, Nix/Nixpkgs og andre, men igjen er dette sjelden noe nye brukere trenger å fokuserer særlig på. Men *om* f.eks. en Ubuntu-brukere ønsker å installere flatpak fra Flathub, kan dette gjøres ved:

```bash
sudo apt install flatpak
```

Det grafiske brukergrensesnittet installeres ved:

```bash
sudo apt install gnome-software-plugin-flatpak
```

Liknende kommandoer gjøres ved installasjon av andre universelle pakkesystemer på andre distribusjoner. 

Vi her altså man på Ubuntu og Mint installerer fra kommandolinjen ved:

```bash
sudo apt remove <program>
```

Det anbefales gjerne å gjøre

```bash
sudo apt update
```

i forkant av installeringer for å oppdatere pakkeindeksen (kort fortalt for å sørge for at pakkeoversikten er oppdatert og frisk).

Noen ganger vil man også sørge for at settet av installerte pakker er oppdatert, hvilket man kan sørge for med:

```bash
sudo apt upgrade
```

## 📺 Vindussystemer

Et godt og tilpasset brukergrensesnitt/vindussystem følger alltid med en Linux-distribusjon. Bruken er gjerne selvforklarende for alle med litt erfaring fra Windows eller MacOS, og vi skal derfor ikke bruke tid på dette. Det fins gode veiledninger, tips og triks etc. på nettet.

Men det er også mulig å bytte grensesnittet for å få best mulige tilpasning til eget behov/smak. Noen, som KDE Plasma, har svært mange settinger å velge i. Andre, som Xfce, er slankere og bedre tilpasset eldre, ressurssvakere maskiner. GNOME, som altså følger med Ubuntu og Fedora, har et brukervennlig, moderne utseende. Mens Cinnamon som følger med Mint, også har mye til felles med Windows. 

Det er tre begreper her: *Desktop Environment* (DE), *Window Manager* (WM) og underliggende grafisk protokoller.

- DE er en samling av programmer og applikasjoner som får Linux til å fungere grafisk. Startmeny, oppgavelinje, filutforsker, widgets, påloggingsskjerm, system for å velge innstillinger, temaer, farger og utseende, terminal og mye mer inngår her. Ulike DE-er tilbyr forskjeller både i utseende og programløsninger. 

- Et WM har ansvaret for opprettelsen og plasseringer av vinduer på skjermen. Den kontroller hvordan de stabler og organiserer seg, gir hvert applikasjonsvindu en tittelbar, en ramme med muligheter for størrelsesendring, flytting, minimalisering og liknende. DE og WM distribueres gjerne samlet som et par, men det kan følge med visse valg om man foretar et bytte. Og avanserte brukere vil sikkert kunne utnytte et enda større mulighetsrom.

- Underliggende sett av grafiske protokoller vil i praksis si enten X11 eller Wayland. Førstnevnt har vært med oss siden 1980-tallet og er, etter utallige tilpasninger, fremdeles levende og i utstrakt bruk. Av effektivitetshensyn, sikkerhetsutfordringer og annet, har man lenge ønsket å erstatte X11, og Wayland er ment å være etterfølgeren. Det er imidlertid mye, på mange nivåer, som på skrives om, og en full overgang til Wayland vil ta tid. Per nå fins det både X11- og Wayland-baserte DE/WM-løsninger, som GNOME og Cinnamon. Det forventes en fortsatt gradvis og stadig overgang til Wayland generelt.

Det fins egne kommandoer for å se hvilket DE og WD man faktisk kjører. Men kanskje er det greiere å installere kommandolinjeprogrammet **fastfetch** (en moderne utgave av tidligere **neofetch**) som skriver ut viktig informasjon om maskin og system,, deriblant denne. Her ser man f.eks. det relevante utdraget for min Ubuntu-installasjon:

```output
DE: GNOME 46.0
WM: Mutter (Wayland)
```

For de som ønsker å eksperimentere, fins det rundt 20 DE-er å velge mellom. Hver av disse har en konkret installeringskommando som man må finne om man vil bytte. Sist jeg sjekket gjaldt følgende for fire vanlige DE-valg på Ubuntu/Mint:

```bash
sudo apt install gnome-session			        # GNOME
sudo apt install cinnamon-desktop-environment	# Cinnamon
sudo apt install kde-standard			    	# KDE Plasma
sudo apt install xfce4 xfce4-goodies	    	# Xfce
```

(Detaljene vil kunne endre seg, så det er alltid lurt å se hva som gjelder for nyeste versjoner.)

Når man så har installert én (eller flere) av disse, trenger man bare å logge seg av. Når man logger seg på igjen, kan man velge ønsket DE i en nedtrekksmeny. Den er typisk plassert i nedre høyre hjørne på påloggingsskjermen, gjerne under et tannhjulikon. Ofte må man klikke seg inn i passordfeltet før det dukker opp (og det kan være variasjoner i plassering i ulike DE-er).

Men for de fleste vil medfølge setup fungere lenge og vel. GNOME og Cinnamon er begge veldig stilfulle og gode. Og de kan dessuten konfigureres enda mer enn det som i utgangspunktet er tilrettelagt for ved hjelp av *extensions*. Det er bare å søke opp nærmere informasjon om dette.

Én grunn til at enkelte bytter WM, er at de ønsker en såkalt *tiling* av vinduer. Normalt legger vinduer seg delvis oppå hverandre og overlater til brukeren å aktivere/organisere vinduer. Ved *tiling* legger vinduene ved siden av hverandre som rektangulære fliser, slik at alle blir synlige. Mange finner dette mer effektivt f.eks. ved koding og andre arbeidsintense oppgaver. Dette er likevel noe man også kan få til ved *extensions*, så kanskje bør man eksperimentere litt og se hva man trives med.
