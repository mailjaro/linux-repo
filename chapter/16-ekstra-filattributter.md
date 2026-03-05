# Ekstra filattributter

Det fins to typer filattributter som kommer i tillegg til de vanlige. Vi
har *extended file attributes* (`xattrs`) og *immutable file
attributes*. Førstnevnt er metadata som kan tilknyttes filer og
kataloger, både for vanlige brukere til hjelp i filhåndtering og
sikkerhetrelatert data som primært kan utnyttes i
tilgangskontrollsystemer som **apparmor** (tilgjengelig på
Debian-distribusjoner, se senere kapittel) og SELinux
(tilgjengelig på Red Hat-beslektede distribusjoner). Sistnevnte
filattributter beskriver ett atrtributtsett som kan tillegges filer og
kataloger for en ekstrabeskyttelse, at de ikke kan slettes ved uhell
o.l. Vi skal si litt om begge.

## Extended file attributes: setfattr og getfattr

`xattrs` innfører altså på metadata, og disse grupperes i fire
hovedtyper:

-   **user**: Kan defineres fritt av bruker

-   **trusted**: Forbeholdt kjerne og administrativ bruk

-   **security**: For systemet, vanligvis for **ACL**
    > (aksesskontroll-lister)

-   **system**: Benyttes av sikkerhetstjenester som **apparmor** og
    > **SELinux**

Det er tre siste håndteres av **root** og går utover siktemålet for
heftet. Vi skal imidlertid se nærmere på metadata for brukere.

Metadata har størrelsesbegrensninger (navn må være under 255 tegn
verdiene under 64 kB). Navnene skal starte på **user.** slik at f.eks.
**user.author**, **user.project**, **user.checksum.md5sum**,
**usr.checksum.sha-256** alle er illustrerende eksempler på notasjon og
bruk.

De øvrige metanavnene har liknende navn, som f.eks. security.

Først installeres

Kan være deaktivert i noen distribusjoner

**setfattr** **-n** user.author **-v** \'Jan R Sandbakken\'
Book-no-1.odt

**setfattr** **-n** user.checksum.md5sum -**v**
dc2b210ad25b49abc52a805ff679b128 \\\
Book-no-1.odt

**setfattr** **-n** user.checksum.sha256sum **-v**\

6f3a5e7333d25d19036b55da59154c8f2bdbc7ce6a18b5d9417148156c4fb3b5 \\\
Book-no-1.odt

Slik lister vi verdiene av alle metanavn for en bestemt fil:

**getfattr** -d Book-no-1.odt

user.author=\"Jan R Sandbakken\"\
user.checksum.md5sum=\"dc2b210ad25b49abc52a805ff679b128\"\
user.checksum.sha256sum=\"6f3a5e7333d25d19036b55da59154c8f2bdbc7ce6a18b5d9417148156c4fb3b5\"

Slik sjekker vi verdien av et bestemt metanavn:

getfattr -n user.author Book-no-1.odt

\# file: Book-no-1.odt\
user.author=\"Jan R Sandbakken\"

For å fjerne et metanavn, benytt `-x`:

setfattr -x user.checksum.sha256sum Book-no-1.odt

Det er klart at vi kan legge inn metanavn som forfatter i dokumenter fra
flere applikasjoner, f.eks. i de fra **Libreoffice**. Men disse
metanavnene lar seg ikke søke på. I utvidede attributter er de
imidlertid søkbare. Som sagt, klarer ikke find-kommandoen dette i
utgangspunkt, men vi kan får det jo til likevel. Anta f.eks. vi har
bøker med ulike forfattere:

```bash
find . -name \'\*.odt\' -exec getfattr -d {} \";\"
```

```output
\# file: Book-no-2.odt\
user.author=\"Henrik Ibsen\"

\# file: Book-no-1.odt\
user.author=\"Jan R Sandbakken\"\
user.checksum.md5sum=\"dc2b210ad25b49abc52a805ff679b128\"**
```

Da kan vi søk etter bestemte metanavn, f.eks. etter bestemt forfatter:

```bash
find . -name \'\*.odt\' -exec getfattr -d {} \";\" \| grep -B1 \'Jan R\'
```

```output
\# file: Book-no-1.odt\
user.author=\"Jan R Sandbakken\"
```

## Immutable file attributes: chattr og lsattr

