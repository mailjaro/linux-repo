# 📚 git

**`git`** (som også er laget av Linux-skaper Linus Torvalds) er en praktisk og mye brukt løsning for versjonskontroll av større programmerings- og skriveprosjekter. For å initiere dette (valgene blir globale på maskinen etter det), gjør noe som likner:

```bash
git config --global user.name 'Ola Nordmann'
git config --global user.email 'ola.nordmann@gmail.com'
```

Deretter lager man en katalog for hvert prosjekt. På prosjektets hjemmekatalog setter man systemet opp ved kanskje først å lage en **.gitignore**-fil, som er en vanlig tekstfil hvor man på hver linje skriver navn på filer og kataloger som git skal ignoreres (deriblant kanskje **.gitignore** selv). Typisk arbeider man så fram noen viktige filer som skal utgjøre prosjektet, la oss si **fil-1.odt** og **fil-2.odt**.

Deretter gjør man:

```bash
git init
```

og etter behov

```bash
git add fil-1.odt
git add fil-2.odt
```

samt

```bash
git commit -m 'beskrivende tekst for hvor i prosessen man er'
```

Videre gir

```bash
git status
git log
```

hhv. en status på hva som ligger i *workspace* og en logg over aktiviteten.

Man kan også vise info kun om siste commit ved **`git log -1`**, den før der igjen ved **`git log -2`** osv.

For å gjenskap en bestemt versjon:

IKKE FERDIG