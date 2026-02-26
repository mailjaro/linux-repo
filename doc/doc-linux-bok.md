# 📚 Dokumentasjon: Produksjon av Linux-bok

## 🎨 Fra MD til CSS ved Pandoc

### 📒 Overskrifter

Overskrifter i MD som
> `# Intro`

og

> `## Kapittel 2`

overføres ved **pandoc** til HTML-overskriftene:

```html
<h1 id="intro">Intro</h1>
```
  
```html
<h2 id="kapittel-2">Kapittel 2</h2>
```

Disse kan dermed CSS-formateres vha.

```css
h1 {}
h2 {}
```

osv.


### 📔 Vanlig tekst

Vanlig tekst transformeres til

```html
<p>Vanlig tekst.</p>
```

Man kan dermed CSS-formatere disse med `p {}`. Ellers er det vanlig å gjøre globale valg også i `body {}`, så man har to muligheter her. Konkurrerende valg i førstnevnte overskriver de sistnevnte.

### 📘 Egenfinerte avsnittsstiler

Egne avsnittsstiler som

>:::poem
Havet er blått.
:::

transformeres til:

```html
<div class="poem">
```

Disse kan derfor stiles ved:

```css
.poem {}
```

### ▶️ Blockquotes

Blockquotes som f.eks.

> `> Innrykk`

transformeres til:

```html
<blockquote>
<p>Et innrykk</p>
</blockquote>
```

Disse kan dermed CSS-formateres ved

```css
blockquote {}
```

### 💻 Kodeblokker

#### 🧾 Known named fenced codeblocks

Velkjente named fenced codeblocks, som f.eks.

> \```bash  
> ls -l testfil  
> \```

transformeres til en mer sammensatt HTML-kode:

```html
<div class="sourceCode" id="cb1">
    <pre class="sourceCode bash">
        <code class="sourceCode bash">
            <span id="cb1-1">
            <a href="#cb1-1" aria-hidden="true" tabindex="-1"><a>
            <span class="fu">ls</span> <span class="at">-l</span>
            tesfil</span>
        </code>
    </pre>
</div>
```

❗**Merk**:

- **sourceCode** anvendes her både på `<div>`, `<pre>` og `<code>`.

- **bash** anvendes på `<pre>` og `<code>`

- **pandoc** forsøker å farglegge kodeord etc. i HTML-`spans` via klasser som `fu` , `at` og andre

Det sistnevnte påvirkes av **pandocs syntax highlights** (som **pygments** og **breezedark**) via kommandoer som:

```bash
pandoc --print-highlight-style=STYLE
```

Her ser vi en oversikt over **pandocs** `span`-klasser:

 Klasse | Betydning 
:-----|:-------
fu    | Kommando (som **ls**)
at	| Opsjon (som **-l**)
kw	| Nøkkelord (som **if**)
st	| Streng
co	| Kommentar
dt	| Datatype
va	| Variabel

Disse kan f.eks. (og mest spesifikt) kustomiseres i CSS ved:

```css
pre.sourceCode.bash .fu {}
pre.sourceCode.bash .at {}
```

osv.

Her ser vi valgalternativene for highlight styles:

- pygments

- tango

- espresso

- zenburn

- kate

- monochrome

- breezedark

- haddock

Mht. til mer overordnet formatering, kan vi se nærmere på en forkortet utgave av HTML-koden vår:

```html
<div class="sourceCode" id="cb1">
    <pre class="sourceCode bash">
        <code>class="sourceCode bash"></code>
    </pre>
</div>
```

Vi ser her en nestet struktur av klasser.

- Klassene gjøre at vi kan formatere i egne beholdere (som **sourceCode** og **bash**) uten å endre format i generelle beholdere de er definert fra (som **div** eller **pre**).
  
-  Den nestede strukturen virker hierarkisk. De mest generelle formateringene kan gjøres på øverste nivå (**div**), de mest spesifikke på nederste nivå (**code**). (Formateringsnotasjonene er vist lenger ned.)

Vi minner også om at:

- `<div>` er en generell blokkbeholder (til forskjell fra inline-beholdere).

- `<pre>` er en generell beholder for preformatted text som:

  - benytter monofont

  - som tolker alt bokstavelig og beholder uforandret ulike blanke tegn og linjeskift

- `<code>` er en generell beholder ment for kode, ofte inline eller inni en`<pre>`.

Når man ønsker å formatere **bash**-eksempler, har man derfor flere valg.

```css
.bash {}
```

er mest generell og vil formatere alle beholdere som inneholder `"class="bash">`.

Den neste

```css
code.bash {}
```

matcher `<code class="bash">`, mens f.eks.

```css
code.sourceCode.bash {}
```

matcher `<code class="sourceCode bash">`

osv. (I disse eksemplene kan man tenke på punktum som **AND**.)

Mellomrom benyttes for nestede strukturer. F.eks. matcher

```css
pre.bash code.bash {}
```

følgende HTML:

```html
<pre class="sourceCode bash">
    <code>class="sourceCode bash"></code>
</pre>
```

Før vi fastslår hvordan man bør CCS-formaterer

> \```bash  
> ls -l testfil  
> \```

er det lurt å se hva øvrige kodeblokker transformeres til.

#### 🧾 Unknown named fenced codeblocks

Ukjente named fenced codeblocks, som f.eks.

> \```output  
> test.md  
> \```

transformeres til:

```html
<pre class="output"><code>test.md</code></pre>
```

og vi kan formatere denne ved:

```css
output {}
```
eller

```css
pre.output {}
```

#### 🧾 Unnamed fence codeblocks

Unavnede kodeblokker

> \```  
> rwx  
> \```

transformeres til

```html
<pre><code>rwx</code></pre>
```

Denne kan f.eks. formateres ved

```css
pre.code {}
```
men det kan synes bedre å unngå denne og heller navngi dem med **output** etc. Dette muliggjør mer spesifikk formatering.

#### ➡️ ansi2html-output

Visse Linux-kommandoer som **grep** kan fargelegge mønstre i output. Et eksempel er output fra

```bash
echo 'error' | grep 'r'
```

som fargelegger r-ene i egen farge. Disse blir borte om man kopierer teksten over i MD. En løsning for å beholde fargekodinger er å benytte programmet **ansi2html**.

- **ansi2html** er å finne på GitHub, og krever egen installering på Ubuntu og Mint. Kort fortalt installeres det ved **pip3** til `/usr/share/bin`.

Sender man output til **ansi2html**, returneres et ferdig HTML-dokument, men hvor essensen er det følgende:

```html
<pre class="ansi2html-content">
    e<span class="ansi1 ansi31">r</span>
    <span class="ansi1 ansi31">r</span>
    o<span class="ansi1 ansi31">r</span>
</pre>
```

Denne blokken kan filtreres ut ved en **awk**-kommando:

```bash
awk '/<pre class="ansi2html-content">/,/<\/pre>/'
```

Ettersom kodeblokker tolker tekst bokstavelig, bør denne kopieres inn i en egendefinert brukerstil som f.eks.

>:::ansiout  
\<pre class="ansi2html-content">  
\</pre>  
:::

Denne transformeres da til:

```html
<div class="ansiout">
    <pre class="ansi2html-content">
    </pre>
</div>

```

Strukturen gjør at vi kan formatere disse på flere måter:

```css
.ansi2html-content {}
```

```css
pre.ansi2html-content {}
```

```css
.ansiout.ansi2html-content {}
```

osv. Men ettersom **ansi2html** kun benyttes på ẽn måte, er førstnevnte tilstrekkelig for oss.

### 🎨 Oppsummering MD til CSS

For vanlig tekst, blockquotes og overskrifter er situasjonen enkel. Disse formateres hhv. med `body {}` eller `p {}`, `blockquote`, `h1 {}` og `h2 {}` osv.

For kode fins det flere valg. Vi ønsker å illustrere både input og output. Sistnevnte sogar i to utgaver (**ansiout** og **output**). Disse skal ha mye felles, men må skille seg på bakgrunnsfarge.

I vårt tilfelle, hvor formateringen kan skje uten tanke på beslektede stiler, synes det enklest å:

- sette felles formater vha.

```css
.bash, .output, .ansiout {
    ont-family: "Ubuntu Mono", "Liberation Mono", monospace;
    font-size: 1rem;
    margin: 6px, 2px, 6px, 2px;
    padding: 2px
}
```

- og mer spesifikke formater ved:

```css
.output, .ansiout {
    background-color: #eef;
}
```

```css
.bash {
    background-color: #eef;
}
```

Ellers bør man være forberedt å gjøre spesifiseringer for innebygde beholdere som `code {}` og `span {}` etc. Disse kan introdusere marger og annet som gjør at brukerstiler oppfører seg ulikt.

## 🎨 Fra MD til laTeX ved Pandoc

### 📒 Overskrifter

### 📔 Vanlig tekst

### 📘 Egenfinerte avsnittsstiler

### ▶️ Blockquotes

### 💻 Kodeblokker 

#### 🧾 Known named fenced codeblocks

#### 🧾 Unknown named fenced codeblocks

#### 🧾 Unnamed fence codeblocks

# 📎 Appendix

## ➡️ Installasjon av ansi2html

### På Ubuntu og mint

⚠️ Prøver man med

```bash
sudo apt install
```

får man

```output  
E: Unable to locate package ansi2html  
```

⚠️ På [pypi.org](https://pypi.org/project/ansi2html/) står at man må installere ved:

```bash
pip3 install ansi2html
```

men på Ubunto og Mint får man da

```output
error: 
externally-managed-environment
```

👍 Man må derfor først opprette et environment:

```bash
python3 -m venv venv
```

Så aktivisere det:

```bash
source venv/bin/activate
```

Om alt fungerer, skal man ha fått opprettet en katalogstruktur, og terminalen indikerer et aktivt environment med noe som likner:

```output
(venv) jan@host:~/Document/project$
```
Deretter kan man installere `ansi2html` ved:

```bash
pip3 install ansi2html
```

Venv environment kan deaktiviseres

```bash
deactivate
```

og programmet kan flyttes

```bash
sudo mv venv/bin/ansi2html /usr/local/bin/
```

Man kan utøre en liten test

```
ansi2html --help
```

og om alt fungerer, kan hele katalogstrukturen i venv avslutningsvis slettes:

```bash
rm -rf venv
```

## På Fedora

Her er det enklere. Alt man trenger å gjøre er

```bash
sudo dnf install python3-ansi2html
```