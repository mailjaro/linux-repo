# 📚 git

**`git`** (som også er laget av Linux-skaper Linus Torvalds) er en praktisk og mye brukt løsning for versjonskontroll av større programmerings- og skriveprosjekter. Jeg har skrevet et eget hefte om det, [Litt om Git](https://mailjaro.github.io/git-repo/), som inkluderer oppsett mot GitHub og jobbing fra flere PC-er. Derfor nevner vi bare det aller viktigste her.

For å initiere Git (valgene blir globale på maskinen etter det), gjør man:

```bash
git config --global user.name 'Ola Nordmann'
git config --global user.email 'ola.nordmann@gmail.com'
```

På prosjektets hjemmekatalog setter man systemet opp ved kanskje først å lage en **.gitignore**-fil, som er en vanlig tekstfil hvor man på hver linje skriver navn på filer og kataloger som git skal ignoreres. Deretter gjør setter man opp prosjektet som et Git-prosjekt ved å gjøre.:

```bash
git init
```

Typisk arbeider man på noen filer som skal utgjøre prosjektet, la oss si **kapittel-1.md** og **kapittel-2.md**.

Etter en redigering gjør man

```bash
git add kapittel-1.md
git add kapittel-2.md
```

samt en lagring av dette ved:

```bash
git commit -m 'beskrivende tekst for hvor i prosessen man er'
```

Videre gir

```bash
git status
git log
```

hhv. en status på hva som evt. ligger i den såkalte INDEKSEN, klar for neste *commit*, og en logg over de siste *committene*.
