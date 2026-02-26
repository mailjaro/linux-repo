# 🔒 gpg

## Installasjon

**gpg** inneholder et større sett av funksjonalitet for å kryptere, signere, tidsstemple, dekryptere og verifisere filer mm. Både asymmetriske og symmetriske teknikker støttes. Man kan generere, importere eller eksportere offentlige nøkler/sertifikater, og man kan eksportere eller verifisere slike.

For evt. å installere **gpg**, utfør `sudo apt install gpg`.

**gpg** er ideelt å bruke når man skal utveksle filer sikkert. Men det er også bra kun for kryptering av egne filer. Det fins flere alternativer for det sistnevnte, men **gpg** har fordelen av å være så velkjent og mye brukt at gjennombrudd i kryptoanlayse eller avdekking av svakheter fort vil bli spredd og kompensert for.

For å kryptere en fil med en passordfrase kan man bare gjøre

```bash
gpg -c farlig.txt
```

Dette lager en ny fil **farlig.txt.gpg**, og originalen kan slettes. For
å dekryptere kan man bare skrive

```bash
gpg farlig.txt.gpg
```

Et alternativ til **gpg** for kryptering med passordfrase er f.eks. **ccrypt** (i form av kommandoene **ccencrypt** og **ccdecrypt**).

De som ikke har har flere behov enn dette, kan hoppe til neste kapittel.

Vi andre skal se nærmere på vanlig bruk av **gpg** med normalt behov for hemmelighold. For mer avanserte behov kan det nemlig være innstillinger, opsjoner og valg som bør velges og diskuteres mer kritisk.

## Symmetrisk kryptering

Som sagt, for å kryptere en sensitiv fil **farlig.txt**. med passordfrase, kan man utføre `gpg -c farlig.txt`. Man blir da bedt om å velge seg et passord. Resultatet blir filen **farlig.txt .gpg**, og originalen kan trygt slettes/flyttes. Man kan også vurdere å bruk **shred** istedenfor **rm** for tryggere sletting, f.eks.

```bash
shred -uzv farlig.txt
```

Merk også at hvis man benytter opsjonen **-a **i** gpg**, får resultatfilen en ASCII-koding (istedenfor en egen binær **gpg**-koding), og filen får endelsen **.asc**.

For å lese innholdet til skjerm, angi:

```bash
gpg -d farlig.txt.gpg
```

For å gjenskape den leselige filen, utfør

```bash
gpg farlig.txt.gpg
```

```output
gpg: WARNING: no command supplied. Trying to guess what you mean ...
gpg: AES256.CFB encrypted data
gpg: encrypted with 1 passphrase
```

Her gjetter **gpg** korrekt og gir den opprinnelige åpne filen **farlig.txt** tilbake (om man angir rett passord underveis). Ønsker man å styre navnet på den dekryptere filen, bruk:

```bash
gpg -d -o farlig.txt farlig.txt.gpg
```

Merk at man selvsagt kan dra sammen flere opsjoner, som **-d -o** til **-do** osv., men dette unngås her for synliggjøring.

Merk også at **gpg** mellomlagrer passord for sesjoner, slik at man en stund ikke trenger å angi passord på nytt. Man kan droppe denne mellomlagringen ved opsjonen **\--no-symkey-cache**:'

```bash
gpg --no-symkey-cache -c farlig.txt
```

Man kan videre velge ulike symmetriske krypteringsalgoritmer ved hjelp
av opsjonen **--cipher-algo**. Tilgjengelige alternativer kan ses fra:

```bash
gpg --version
```

```output
Supported algorithms:Pubkey: RSA, ELG, DSA, ECDH, ECDSA, EDDSA
Cipher: IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH, CAMELLIA128, CAMELLIA192, CAMELLIA256
Hash: SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
Compression: Uncompressed, ZIP, ZLIB, BZIP2
```

(Kun det sentrale i outputen er vist.) Vi ser først støttede asymmetriske algoritmer (*Pubkey*) før de symmetriske (*Cipher*). Symmetrisk standard er AES256 i CFB-modus. Til slutt ser vi tilgjengelige hash-algoritmer og kompresjonsvalg.

For å velge spesifikk, symmetrisk algoritme, gjør (der vi også har inkludert **-v** for mer informasjon):

```bash
gpg --cipher-algo TWOFISH -c -v farlig.txt
```

```output
gpg: enabled compatibility flags:
gpg: pinentry launched (13804 gnome3 1.2.1 /dev/pts/0 xterm-256color :0 20620/1000/5 1000/1000 -)
gpg: using cipher TWOFISH.CFB
gpg: writing to 'farlig.txt.gpg'
```

**Merk**: Det er *mulig* å velge algoritmer som **TWOFISH** som standard via **\~/.gnupg/gpg.conf**. (Mer om den filen senere.) Det går bra for symmetrisk (privat) kryptering, men angitt som standard, vil den også benyttes som en del av asymmetrisk kryptering. Det er ikke sikkert mottaker støtter dette, og det anbefales generelt ikke å velge utenfor **gpg**-standarden som default.

## Asymmetrisk kryptering

Bruken her er også enkel. Man vil typisk ønske å sende noe kryptert til en person (hvis data ligger nøkkelringen)*,* eller man ønsker å signere noe (hvilket krever ens personlige passord/passordfrase). Mottar man noe tilsvarende, vil **gpg** tolke den beskyttede meldingen og si hva som evt. må gjøres videre. Dette antas som relativt vel kjent. I fortsettelsen skal vi først vise vanlig, enkel bruk før vi ser nærmere på utvidede valg.

### Nøkkelgenerering

Dersom brukeren trenger å lage seg et nytt offentlige/hemmelig
nøkkelpar, utføres:

```bash
gpg --gen-key
```

Denne spør om fullt navn og e-postadresse, samt om et beskyttende passord/passordfrase. Dette havner da på det lokale **gpg**-systemets nøkkelring (*keychain*), og dermed er alt ferdig og klart til bruk, Om man vil, kan man hoppe til neste underkapittel.

Om man isteden ønsker å styre alle valg selv - og ikke bare godta standardverdier, gjør man isteden

```bash
gpg --full-generate-key
```

For disse brukerne kommer nå 4-5 sider med forklaringer andre kan hoppe over.

Etter man har angitt ovennevnte kommando, får man mulighet til også velge algoritmer, nøkkellengder og varighet. Første spørsmålet gjelder ønsket signerings- og krypteringsalgoritme.

```output
    Gpg (GnuPG) 2.4.4; Copyright (C) 2024 g10 Code GmbH
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    Please select what kind of key you want:

    (1) RSA and RSA
    (2) DSA and Elgamal
    (3) DSA (sign only)
    (4) RSA (sign only)
    (9) ECC (sign and encrypt) *default*
    (10) ECC (sign only)
    (14) Existing key from card

    Your selection?
```

For oss er kun 1, 2 og 9 aktuelle. Med 1 benyttes **RSA** både for signering `[S]` og kryptering (nøkkelutveksling) `[E]`. For 2 benyttes **DSA** for `[S]` og **Elgamal** for `[E]` (begge har sin rot i **Diffie**-**Hellman**-systemet), mens for 3 (standard per nå) benyttes elliptiske kurver både for `[S]` og `[E]`.

La oss se nærmere på disse muligheten. (Standardvalg er merket eller vist i parentes.)

**1 RSA/RSA**

Da får man opp følgende muligheter:

```output
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (3072)
```

Nøkkellengden gjelder for både `[S]` og `[E]`. Før ble 2024 bits ansett som tilstrekkelig, og det holder sikkert fortsatt. Nå er det ikke uvanlig å velge 4096.

**2 DSA/Elgamal**
Da får man fram:

```output
DSA keys may be between 1024 and 3072 bits long.
What keysize do you want? (2048)
```

Valget setter nøkkellengde både for **DSA** `[S]` og **Elgamal** `[E]`.

**9 ECC/ECC**

Da får man fram:

```output
Please select which elliptic curve you want:

(1) Curve 25519 *default*
(4) NIST P-384
(6) Brainpool P-256

Your selection?
```

Valgene gjelder både `[S]` og `[E]`, og skiller seg på hvilken konkret elliptisk kurve som legges til grunn. Enda flere valg her fås fram ved å velge ekspertmodus i genereringen (som generelt ikke er å anbefale):

```bash
gpg --expert --full-generate-key
```

Da ville man fått fram alle disse valgene under alternativ 9:

```output
Please select which elliptic curve you want:

(1) Curve 25519 *default*
(2) Curve 448
(3) NIST P-256
(4) NIST P-384
(5) NIST P-521
(6) Brainpool P-256
(7) Brainpool P-384
(8) Brainpool P-512
(9) secp256k1

Your selection?
```

Videre, etter man har landet alt dette, får man spørsmål om varighet. Normalt ønskes verken for kort eller altfor lang varighet. For kort varighet er upraktisk, men kan alltids utvides (se senere beskrivelse). Skulle man få frastjålet PC med nøkler og oppsett, kan en nøkkel som timer ut være å foretrekke. Men selvsagt risikerer man å ikke kunne dekryptere noe viktig fordi nøkler har gått ut også. Bruken avgjør hva man velger.

```output
Please specify how long the key should be valid.

0 = key does not expire
<n> = key expires in n days
<n>w = key expires in n weeks
<n>m = key expires in n months
<n>y = key expires in n years

Key is valid for? (0)
```

**gpg** viser deretter valgt utløpsdato og ber om bekreftelse på at den er korrekt. Deretter bes det om fullt navn, epost og en kommentar. (Alt blir også bedt om bekreftelse på.)

**Merk**: Kommentaren blir en del av nøkkelsettet og kan ikke endres. Velg også denne med en viss omhu.

```
GnuPG needs to construct a user ID to identify your key.

Real name:
Email address:
Comment:
```

Til slutt genereres nøkkelparet. (Det anbefales å ha en del tilfeldig aktivitet gående på PC-en her for å sikre mest mulig tilfeldighet i genereringen.)

Under ser vi et eksempel på sluttresultat (som også kan fås fram ved **gpg -k**):

```output
pgpg: revocation certificate stored as
'/home/ola/.gnupg/openpgp-revocs.dD2AF134F36B2EC2E654EEABC56C8D1EE935C2180.rev'
public and secret key created and signed.
pub dsa1024 2025-02-12 [SC] [expires: 2026-02-12] D2AF134F36B2EC2E654EEABC56C8D1EE935C2180
uid Ola Nordmann (Kun for testformål) <ola.nordmann@gmail.com>
sub elg1024 2025-02-12 [E] [expires: 2026-02-12]
```

Merk at man får laget *to* nøkkelpar: *master *(*primary*) og *sub* (*secondary*). Hensikten med *sub*-nøkkelen (som er bundet til *master*) er at den kan oppbevares og annulleres uavhengig av *master*. Det er egentlig offentlig *sub*-nøkkel som blir eksportert og benyttet i andres kryptering til deg. *Master*-paret kan tryggere begrenses til intern håndtering av signering, sertifisering, nøkkelring etc.

I eksempelet er begge 1014-bits **DSA**/**Elgemal**-nøkler med én og samme utløpsdato. *Primary* er merket `[SC]`, og *secondary* er merket `[E]`. Dette betegner bruksegenskapene hhv. **S**ign og **C**ertify, og **E**ncryption (nøkkelutveksling) i tråd med det ovennevnte.

Nå benyttes altså ikke en asymetrisk `[E]` nøkkel til kryptering av selve *meldingen*. Den vil alltid være symmetrisk kryptert standardalgoritme er AES256, men nøkkelen benyttes i en *key exchange*, kort sagt i en protokoll (det være seg **RSA**, **Diffie-Hellmann** eller annen) med offentlige og hemmelige nøkler.

Man kan også legge til flere *sub keys* (av `[S]` eller `[E]` type). Man starter dette ved `gpg--edit-key 'Ola Nordmann'`, hvor man så kommer inn i et **gpg**-skall. Der skriver man **addkey**, velger algoritme og nøkkellengde, og avslutter med **save**.

I **gpg**-skallet kan man også slette nøkler. Da velger man først nøkkel ved **key nr** (*sub*-nr. regnet fra 0), som så blir stjernemerket. Hvis den er korrekt, sletter man med **delkey** og **save**.

På liknende vis kan man også forlenge en nøkkel. Siden dette kan være ekstra viktig, viser vi et eksempel i sin helhet. Det Ola skriver er vist i parentes. Han ender her opp med å forlenge nøkkelen med 10 år (regnet fra hans daværende dato).

```bash
gpg --edit-key 'Ola Nordmann'
```

```output
gpg (GnuPG) 2.4.4; Copyright (C) 2024 g10 Code GmbHThis is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Secret key is available.
sec dsa1024/56C8D1EE935C2180
created: 2025-02-12 expires: 2026-02-12 usage: SC
trust: ultimate validity: ultimate
ssb elg1024/F86A3BAE0672409B
created: 2025-02-12 expires: 2026-02-12 usage: E
ssb rsa1024/5A7E7DF499677EC8
created: 2025-02-12 expires: 2025-08-11 usage: S
ssb brainpoolP256r1/6595A87AA3F68C76
created: 2025-02-13 expires: 2025-10-11 usage: S
[ultimate] (1). Ola Nordmann (Kun for testformål)
<ola.nordmann@gmail.com>
```

```bash
gpg> (key 2)        # Legg merke til stjernen som dukker opp under
```

```output
sec dsa1024/56C8D1EE935C2180
created: 2025-02-12 expires: 2026-02-12 usage: SC
trust: ultimate validity: ultimate
ssb elg1024/F86A3BAE0672409B
created: 2025-02-12 expires: 2026-02-12 usage: E
ssb\* rsa1024/5A7E7DF499677EC8
created: 2025-02-12 expires: 2025-08-11 usage: S
ssb brainpoolP256r1/6595A87AA3F68C76
created: 2025-02-13 expires: 2025-10-11 usage: S
[ultimate] (1). Ola Nordmann (Kun for testformål)
<ola.nordmann@gmail.com>
```

```bash
gpg> (expire)
```

```output
Changing expiration time for a subkey.
Please specify how long the key should be valid.
0 = key does not expire
\<n\> = key expires in n days
\<n\>w = key expires in n weeks
\<n\>m = key expires in n months    
\<n\>y = key expires in n years
```

```bash
Key is valid for? (0) (10y)
```

```output
Key expires at Sun 11 Feb 2035 08:02:13 PM CET
```

```bash
Is this correct? (y/N) (y)
```

```output
sec dsa1024/56C8D1EE935C2180
created: 2025-02-12 expires: 2026-02-12 usage: SC
trust: ultimate validity: ultimate
ssb elg1024/F86A3BAE0672409B
created: 2025-02-12 expires: 2026-02-12 usage: E
ssb\* rsa1024/5A7E7DF499677EC8\
created: 2025-02-12 expires: 2035-02-11 usage: S
ssb brainpoolP256r1/6595A87AA3F68C76\
created: 2025-02-13 expires: 2025-10-11 usage: S

[ultimate] (1). Ola Nordmann (Kun for testformål)
<ola.nordmann@gmail.com>
```

```bash
gpg> (save)
```

Om det gir mening å forlenge en *pub*-nøkkel mer enn *primarys* levetid, er en annen sak, men *primary* kan endres tilsvarende. *Primary* har **key** 0. Den velges også om man bare skriver **key**. (Ingen stjerne betyr at *master* er valgt.)

Videre, i utskriften fra **gpg -k**, ser man fingeravtrykket til den offentlige *master*-nøkkelen:

```output
D2AF 134F 36B2 EC2E 654E EABC 56C8 D1EE 935C 2180
```

Den er på 160 bit (40 heksadesimale sifre). Den benyttes for kontroll for nøkkelens ekthet, og utgjør også dens id. To kortversjoner av fingeravtrykk (*long* og *short*) kan også benyttes som id. Disse er hhv. de siste 64 bit (16 hex-sifre) eller siste 32 bit (8 hex-sifre) av fingeravtrykk.

```v
D2AF 134F 36B2 EC2E 654E EABC 56C8 D1EE 935C 2180
56C8 D1EE 935C 2180
935C 2180
```

Kommandoene for å få fram disse er:

```bash
gpg --keyid-format long --list-keys ola.nordmann@gmail.com
```

```output
pub dsa1024/**56C8D1EE935C2180** 2025-02-12 [SC] [expires: 2026-02-12]
D2AF134F36B2EC2E654EEABC56C8D1EE935C2180
uid [ultimate] Ola Nordmann (Kun for testformål)
<ola.nordmann@gmail.com>
sub elg1024 F86A3BAE0672409B 2025-02-12 [E][expires: 2026-02-12]
```

```bash
gpg --keyid-format short --list-keys ola.nordmann@gmail.com
```

```output
pub dsa1024/935C2180  2025-02-12 [SC][expires: 2026-02-12]
D2AF134F36B2EC2E654EEABC56C8D1EE935C2180
uid [ultimate] Ola Nordmann (Kun for testformål)
<ola.nordmann@gmail.com>
sub elg1024/0672409B 2025-02-12 [E] [expires: 2026-02-12]
```

I begge tilfeller er kort eller langt fingeravtrykk vist i gult, både for *primary* og *sub*.

### Brukersertifisering av nøkler

Om man vil kommunisere med flere, vil det kunne bli behov for å signere andres nøkler. Helst bør offentlige nøkler/sertifikater bli kontrollert og sertifisert av en betrodd instans (**CA**), men for småskala kommunikasjon, er det vanligere at person A sertifiserer B, B sertifiserer C, slik at A også har mulighet til å stole på nøklene til person C osv.

Anta Ola Nordmann og Kari Nordmann skal signere hverandres nøkler. Kari starter prosessen ved å eksportere ut sin offentlige nøkkel fra sin nøkkelring ved:

```bash
gpg -a --export > Kari.Nordmann.asc
```

Opsjonen **-a** (*armour*) gir ASCII-kodet fil.

Når Ola Nordmann får denne, og er trygg på at den virkelig er Karis, importere den inn i sin nøkkelring. Han må bl.a. sjekke fingeravtrykk, som i eksemplene våre for Kari er:

```output
684C DE04 83D6 BD0A A634 3497 81B8 B69C 2ADB 88CC
```

```bash
gpg --import Kari.Nordmann.asc
```

Ola er dermed klar til å signere nøkkelen hennes ved f.eks.

```bash
gpg --sign-key 2ADB88CC
```

Karis fingeravtrykk (f.eks, i kort format) ble her benyttet som referanse til nøkkel man vil signere. Evt. kan man benytte langt format (81B8B69C2ADB88CC), navn eller e-postadresse isteden, altså f.eks:

```bash
gpg --sign-key 81B8B69C2ADB88CC
gpg --sign-key 'Kari Nordmann\'
gpg --sign-key kari.nordmann@gmail.com
```

Det *går* an å benytte deler av navn som *Kari* isteden for hele, når det er entydig og ikke kan forveksles. Det anbefales selvsagt ikke i veldig sensitive situasjoner eller når antall brukerne er mange.

Nå kan Ola også eksportere sin nøkkel og få den signert av Kari. Han vil da eksporterer sin offentlige nøkkel (*sub*), signere den og krypterer den med Karis offentlige nøkkel:

```bash
gpg -a --export ola.nordmann@gmail.com | gpg -s -e -r kari.nordmann@gmail.com > ola.nordmann.asc.gpg
```

**Merk**: Dersom Ola var av dem med flere egne nøkkelsett i nøkkelringen, måtte han f.eks. lagt til `--local-user ola.nordmann@gmail.com` før **--sign-key** (ved nøkkelsigneringen) eller før opsjonen **-s** (ved meldingssigneringen) for å klargjøre hvilken han ville signere med (fingeravtrykk, navn eller e-post som vist). Mer om dette straks.

Sluttfilen **ola.nordmann.asc.gpg** kan trygt sendes Kari på e-post, og hun kan dekryptere og signatursjekke (ved `gpg ola.nordmann.asc.gpg`) og importere Olas nøkkel tilsvarende (`gpg --import Ola.Nordmann.asc`). Ola og Kari kan nå kommunisere trygt og effektivt, og man vil også kunne utvide det til å stole på nøkler den andre har godtatt.

### Kryptering og signering

Slik kan Ola nå kryptere en fil bare Kari kan åpne og lese (vist i fire varianter)

```bash
gpg -e -r kari.nordmann@gmail.com farlig.txt
gpg -e -r 'Kari Nordmann' farlig.txt
gpg -e -r 2ADB88CC farlig.txt
gpg -e -r 81B8B69C2ADB88CC farlig.txt
```

De to siste fingeravtrykkbaserte kan være sikrere, men vi benytter gjerne den første for større oversiktlighet. Bruk av kun fornavn i andre
linje ville som sagt gått bra når det er entydig, selv om det generelt er mer risikofylt i større organisasjoner.

La oss se på signering. I tillegg til offentlige nøkler til venner og bekjente, inneholder nøkkelringen ofte bare ett *eget* nøkkelsett*. Kommandoen

```bash
gpg -s farlig.txt
```

er da alt man trenger for å lage en signert fil **farlig.txt.gpg**.

**Merk**: I tillegg til at filen signeres, får den også et tidstempel (*timestamp*). I noen anvendelser er slikt like viktig.

Og skal Ola både kryptere og sende en fil til Kari, kan han gjøre

```bash
gpg -e -s -r kari.nordmann@gmail.com farlig.txt
```

Når Kari mottar disse, er alt hun trenger å gjøre:

```bash
gpg farlig.txt.gpg
```

Det vil fremgå av **gpg**-output til skjerm hvilken nøkkel som er benyttet i kryptering, tidstempelet, samt hvem som har signert outputfilen **farlig.txt**. Hvis **GOOD signature from Ola ...** (for riktig Ola) printes til skjem, er alt i orden. Hvis man får **BAD signature** eller **GOOD signature from** noen andre, må hele meldingen/filen selvsagt forkastes.

Her kommer igjen flere detaljer for de som ønsker å styre valgene selv.

For det første er det flere måter å signere på. Om Ola gjør nevnte

```bash
gpg -s dokument.txt
```

produseres altså en (zippet) signert versjon av dokumentet, **dokument.txt.gpg**. Tanken er at Kari får denne tilsendt og kan både gjenskape **dokument.txt** og få verifisert at Ola har signert den.

Ola har imidlertid to andre muligheter. Kanskje de utveksler e-poster i klartekst og Ola bare vil signere bestemt tekst der. Da kan han benytte
såkalt **clearsign signature**, som produserer noe alà:

```output
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Jeg innrømmer at det var jeg som spiste opp kakene.
-----BEGIN PGP SIGNATURE-----

iI0EARMIADUWIQRblQ+PvWJxfU433Dhllah6o/aMdgUCZ9GUHxccb2xhLm5vcmRt
YW5uQGdtYWlsLmNvbQAKCRBllah6o/aMdtzsAQCjJcwObJyEfEYHs5xVV7eSFhtr
3+ZzRfvXnzmDDF1uFAD/ccvzjWAdxfOKLRelN7RFHb1zAa4g0TuXhL4pk+sXhQs=
=/Hxo
-----END PGP SIGNATURE-----
```

Her vil Kari se hva Ola har skrevet (at han innrømmer å ha spist opp kakene) og har lagt ved en signatur av dette som Kari kan kontrollere.
Enten har Kari fått tilsendt en tekstfil med ovennevnte innhold, eller hun kan kopiere dette ut i en tekstfil selv, la oss si til **melding.txt.asc**. Kari kan da si:

```bash
gpg melding.txt.asc
```

Og hun får dermed både en melding til skjerm om gyldighet av signatur, hvem som i tilfelle har signert, samt (hvis gyldig signatur) en fil
**melding.txt** som inneholder det den signerende (forhåpentligvis Ola) faktisk har signert.

En tredje signeringsmulighet er en såkalt i Her er tanken at Ola har et dokument og et signert dokument, og begge oversendes Kari for å bli kontrollert som et par.

Ola gjør:

```bash
gpg --detach-sig kontrakt.pdf
```

hvilket produserer **kontrakt.pdf.sig**. Kari mottar begge disse filene og utfører:

```bash
gpg --verify kontrakt.pdf.sig kontrakt.pdf
```

Igjen kontrolleres det om signaturen er gyldig (at signert dokument samsvarer med kontrakten) og angis hvem som har signert det (forhåpentligvis Ola).

De som har valgt å ikke hoppe over noe, vet at Ola kan legge til flere, ekstra signeringsnøkler. Dessuten kan han ha eldre nøkkelsett på nøkkelringen. Så hvordan skal Ola gå fram da for å velge rett signeringsnøkkel da?

For det første kan han sette hva som er standard `[S]`-nøkkel i filen **\~/.gnupg/gpg.conf**. Et eksempel på dette er vist til slutt i kapittelet. Men hvis han isteden vil spesifisere fra gang til gang, kan man gjøre som forklart i fortsettelsen. La oss se på dette med ekstra signeringsnøkler først.

Dersom Ola bare legger til én ekstra `[S]`-nøkkel, viser det seg at **gpg** alltid velger *den* for signering, selv om han i kommandoer forsøker å angi den opprinnelige neringsnøkkelen. Så for å få demonstrert valg av signeringsnøkler, legger vi til to stk. Det er allerede gjort under. Her har Ola har to *sub* `[S]`-nøkler (hhv. én **RSA**- og én **ECC**-basert nøkkel), foruten én sub `[E]`-nøkkel (**Elgamal**-basert).

```bash
gpg --keyid-format short --list-keys ola.nordmann@gmail.com
```

```output
pub   dsa1024/935C2180 2025-02-12 [SC] [expires: 2026-02-12]
      D2AF134F36B2EC2E654EEABC56C8D1EE935C2180
uid         [ultimate] Ola Nordmann (Kun for testformål)
<ola.nordmann@gmail.com>
sub   elg1024/0672409B 2025-02-12 [E] [expires: 2026-02-12]
sub   rsa1024/99677EC8 2025-02-12 [S] [expires: 2025-08-11]
sub   brainpoolP256r1/A3F68C76 2025-02-13 [S] [expires: 2025-10-11]
```

Om Ola f.eks. ønsker å signere med sin `[S]`-nøkkel (den **ECC**/**BrainpoolP256R1**-baserte), kan han utføre:

```bash
gpg -v -s \--default-key A3F68C76 farlig.txt
```

```output
gpg: enabled compatibility flags:
gpg: using pgp trust model
gpg: using "A3F68C76" as default secret key for signing
gpg: using subkey 6595A87AA3F68C76 instead of primary key 56C8D1EE935C2180
gpg: writing to 'farlig.txt.gpg'
gpg: ECDSA/SHA256 signature from: "6595A87AA3F68C76 Ola Nordmann (Kun for testformål) <ola.nordmann@gmail.com>"
```

Om noen siden ønsker å sjekke signaturen, kan de som før bare skrive:

```bash
gpg -v farlig.txt.gpg
```

```output
ppg: enabled compatibility flags:
gpg: WARNING: no command supplied.  Trying to guess what you mean ...
gpg: original file name='farlig.txt'
gpg: Signature made Thu 13 Feb 2025 07:23:12 PM CET
gpg:                using ECDSA key 5B950F8FBD62717D4E37DC386595A87AA3F68C76
gpg: using subkey 6595A87AA3F68C76 instead of primary key 56C8D1EE935C2180
gpg: using subkey 6595A87AA3F68C76 instead of primary key 56C8D1EE935C2180
gpg: using pgp trust model
gpg: Good signature from "Ola Nordmann (Kun for testformål) <ola.nordmann@gmail.com>" [ultimate]
gpg: binary signature, digest algorithm SHA256, key algorithm brainpoolP256r1
```

og vi ser at signeringsvalget framgår tydelig.

På samme måte kan Ola skille mellom signeringsnøkler på ulike *nøkkelsett*. En id er tilstrekkelig også her. Alternativt kan han benytte opsjonen \--**local-user** og angi navn eller e-post, noe som skiller på nøkkelsett - om han godtar standardvalg av signeringsnøkkel.

**Merk**: Man kan *ikke* velge bestemte `[E]`-nøkler på samme måte. **gpg** vil selv håndtere nøkkelutveksling ut fra nøkkelmulighetene til begge brukerne.

Som sagt, om skal Ola både kryptere og signere en fil til Kari, kan han skrive:

```bash
gpg -e -s -r kari.nordmann\@gmail.com farlig.txt
```

Her velges igjen standard signeringsnøkkel. Skulle Ola ha flere signeringsnøkler, kan man styre det med id som over, altså f.eks. skrive:

```bash
gpg -e -s --default-key A3F68C76 -r kari.nordmann\@gmail.com farlig.txt
```

Når Kari mottar filen **farlig.txt.gpg**, kan hun som før dekryptere og sjekke signatur ved

```bash
gpg farlig.txt.gpg
```

```output
gpg: WARNING: no command supplied.  Trying to guess what you mean ...
gpg: encrypted with brainpoolP256r1 key, ID 6F30870F8880F2A1, created 2025-02-13
      "Kari Nordmann (Kun for testing) <kari.nordmann@gmail.com>"
gpg: Signature made Thu 13 Feb 2025 07:35:53 PM CET
gpg:                using ECDSA key 5B950F8FBD62717D4E37DC386595A87AA3F68C76
gpg: Good signature from "Ola Nordmann (Kun for testformål) <ola.nordmann@gmail.com>" [ultimate]
```

og få produsert åpen fil **farlig.txt**.

Ola kan selvsagt også kryptere (evt. signere eller kryptere *og* signere) til seg selv ved å angi recipient **-r Ola**, `r -ola.nordmann@gmail.com` eller tilsvarende). Hvis han da ikke heller vil bruke den symmetriske varianten med **-c** i dette tilfellet.

### Annet

Det er som antydet underveis, mulig å sette en del standardverdier i filen **~/.gnupg/gpg.conf**. Her ser vi et par eksempler:

```output
# Standardvalg for gpg. Se man gpg for muligheter
# Benytt fulle opsjonsnavn, ikke forkortelser, og ingen bindestreker:
verbose
armor
# Følgende KAN gjøres, men er det anbefales ikke å velge ikke-gpg-standarder:
cipher-algo TWOFISH
# Bestemmelse av standard signeringsnøkkel:
default-key 5B950F8FBD62717D4E37DC386595A87AA3F68C76
```

For nederste linje, spesifisering av standard `[S]`-nøkkel, anbefales det å benytte fingeravtrykk som id (i det minste i langt format).

Følgende kommandoer kan ellers være nyttige for å holde litt oversikt over trestruktur og nøkler:

```bash
tree ~/.gnupg
gpg --with-colons --list-keys --with-fingerprint
```

Dersom du ønsker å gjøre gpp-nøklene dine tilgjengelig for andre, vurder steder som **keys.openpgp.org**. Dette er ingen CA (de signerer/sertifiserer ikke nøkler), men de gjør nøkler søkbare for andre basert på tilhørende e-post-adresse. De kontrollerer at avsender eier e-postadressen, men er ingen CA, og kan ikke verifisere at personen er den vedkommende gir seg t for å være.
