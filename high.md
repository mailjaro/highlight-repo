
# Syntaksutheving i Asciidoctor

I mange tilfeller ønsker man syntaksutheving, f.eks. når man viser kodeeksempler i ulike språk eller i ulike shell. Dette kan både være under skriving/forhåndsvisning (som f.eks. av Markdown i VS Code) eller ved produksjon av ulike dokumentformater (som EPUB, HTML og PDF). For dette har man løsninger som **Rouge** og **Pygments**. (Man har også **Coderay**, men dette vedlikeholdes ikke aktivt og er i praksis ersattet av **Rouge**.)

## Rouge: Installering

**Rouge** er et **Ruby-gem**, så man trenger i praksis:

- Ruby
- RubyGems
- selve rouge-pakken

**Ubuntu:**

Her ser vi installasjonsstegene på Ubuntu:

```bash
sudo apt update
sudo apt install -y ruby ruby-dev build-essential
sudo gem install --no-document rouge asciidoctor asciidoctor-pdf asciidoctor-epub3
```

**Fedora:**
Her er installasjonsstegene på Fedora:

```bash
sudo dnf install -y ruby ruby-devel make gcc
sudo gem install --no-document rouge asciidoctor asciidoctor-pdf asciidoctor-epub3
```

## Rouge: Relaterte versjoner

Ikke alt er likt i ulike versjoner av programmene som benyttes her. For ordensskyld opplyses det om at alt er testet og utført i/med:

- gem 3.6.9
- ruby runtime environment 3.4.8
- asciidoctor 2.0.26
- asciidoctor-epub 3-2.3.0
- asciidoctor-pdf 2.3.19

Disse kan oppdateres ved:

```bash
sudo gem update --system
gem update asciidoctor
gem update asciidoctor-epub3
gem update asciidoctor-pdf
```


## Rouge: Bruk

Når dette er installert kan man nyttiggjøre det ved å inkludere det følgende på toppen (i *preamble*) til ADOC-filen, eller kanskje vel så vanlig, å inkludere det i premable på en masterfil (som gjerne er spesifikk for hvert output-format):

```yaml
:source-highlighter: rouge
:rouge-style: monokai
```

De tilgjengelige Rouge-stilene i siste linje kan ses fra

```bash
rougify help style
```

og er i min versjon:

- base16
- base16.dark
- base16.light
- base16.monokai
- base16.monokai.dark
- base16.monokai.light
- base16.solarized
- base16.solarized.dark
- base16.solarized.light
- bw
- colorful
- github
- github.dark
- github.light
- gruvbox
- gruvbox.dark
- gruvbox.light
- igorpro
- magritte
- molokai
- monokai
- monokai.sublime
- pastie
- thankful_eyes
- tulip

Alternativt kan man styre det direkte fra kommandolinjen, som eksemplifisert her:

```bash
asciidoctor -a source-highlighter=rouge \
            -a rouge-style=monokai <fil.adoc> ...
```

Dette er felles for HTML, EPUB og PDF. Den videre stilingen, om man ikke er fornøyd med default-valgene, er forskjellig for de tre formatene. HTML benytter CSS, EPUB kan benytte både YAML og CSS, mens PDF kun benytter YAML. Formatene benytter dessuten hver sik kommando, hhv. **asciidoctor**, **asciidoctor-epub** og **asciidoctor-pdf**, for konverteringen. 

## Videre stiling

Asciidoctor.programmene produserer fin layout i våre formater. Særlig for tekniske dokumenter, dokumentasjon etc, er default-stilene, supplert med denne syntaksuthevelsen, gjerne å foretrekke. Default-fil for stiling er:

- **asciidoctor.css** for `asciidoctor`  
- **asciidoctor-default.yml** for  `asciidoctor-pdf`
  
`asciidoctor-epub3` bruker tre slike:

```text
epub3.css
epub3-css3-only.css
epub3-fonts.css
```

hvorav den første inneholder layout, typografi, kapittelstruktur osv. Den siste definerer font-innlasting mm.

Men om man likevel vil stile output-filene selv, har man anledning til det. Man *kan* da ta utgangspunkt i disse innebygde stilene, men det bør nevnes at disse er nokså kompakte og ikke enkle å jobbe med for ikke-speialister.

Når det gjelder tekstuthevelse kan det være greit å vite at man kan ta utgangspunkt i de nevnte fargekombinasjonene ved å produsere CCS-er ved kommandoer som

```bash
rougify style github > github.css
rougify style monokai > monokai.css
```

Inkluderer man det følgende

```yaml
:linkcss:
```

i preamble (i toppen av dokument eller masterfil) blir disse også produsert sammen med output-filen ved HTML- og EPUB-produksjon (for korrekt lesing av filene).

Men man må da være forberedt på en større utvidelse av CSS-ene for en fullverdig formatering av hele dokumentet. Disse tar kun for seg syntaksuthevelsene.

For å få inkludert egne stiler kan man inkludere for:

### HTML-stiling

```yaml
:stylesheet: my-style.css
```

i preamble eller direkte fra kommandolinja inkludere

```bash
asciidoctor -a stylesheet=my-style.css ...
```

### EPUB-stiling

```yaml
:ebook-theme: my-style.yml
```

i preamble, eller direkte fra kommandolinja inkludere

```bash
asciidoctor-epub3 -a ebook-theme=my-style.yml ...
```

På grunn av bakoverkompabilitet støttes fortsatt de CCS-baserte variantene

```yaml
:stylesheet: my-style.css
```

i preamble og 
```bash
asciidoctor-epub3 -a stylesheet=my-style.css ...
```

fra kommandolinja.

### PDF-stiling

```yaml
:pdf-theme: styles/my-style.yml
```

i preamble eller direkte fra kommandolinja inkludere

```bash
asciidoctor-pdf -a pdf-theme=my-theme.yml ...
```

For å highlighte et bestemt kodeeksempel i gjenkjente "språk", som f.eks. **python**, bruker man ADOC blokker som:

```text
[source,python]
----
def hello():
    print("hi")
----
```

(Og Markdown *fence blocks* mappes også til slike ved **pandoc**.)

## ROUGE: Produksjon

Vi skal nå i detalj på hvordan output-formatene våre kan produseres i en praktisk situasjon, med en *real life*-katalogstruktur mm. Vi forutseter da at vi jobber med et prosjekt organisert som følger:

- hovedfilen heter **sample.adoc**
- bilder ligger på **images/**
- stiler ligger på **styles/**
- konfigurasjon og masterfiler ligger på **config/**
- og output skal til **builds/**:

Vi forutsetter videre at man samler preamble i en egen html-masterfil **html-master.adoc**. Den kan se noe slik ut:

### HTML-output

```text
= Tittel
Ola Nordmann <ola.nordmann@gmail.com>
v1.0 2026-02-12
:description: En beskrivelse
:doctype: book
:icons: font
:toc: left
:toc-title: Innholdsfortegnelse
:toclevels: 3
:sectanchors:
:stylesheet: styles/asciidoctor.css
:source-highlighter: rouge
:rouge-style: monokai
image::../images/cover.png[role=cover,align=center]

include::sample.adoc[]
```

Ønsker man higlighting, er det enklest å inkludere `:source-highlighter: rouge` og f.eks. `:rouge-style: monokai` i et preamble.

Om ikke annet spesifiseres i preamble, benyttes default CSS for Ascidoctor.

Ofte ønsker man å sende output til en egen katalog, f.eks, **bulid/**, og kanskje med eg bestemt filnavn, f.eks. **test.html**, hvilket enten kan gjøres ved

```bash
asciidoctor config/html-master.adoc -B <hjemmekatalog> \
            -D builds -o <navn>.html
```

❗ **asciidoctor** velger masterfilen som input-fil. Denne liger i underkatalogen **config/**, hvilket påvirker referansene til andre kataloger i treet. Opsjonen `-B` setter hjemmekatalogen, og filer i **config/** og **stiler/** finnes dermed uten prefiks `../`. **images/** trenger likevel dette prefikset (uvisst av hvilken grunn).  

### EPUB-output

Vi antar samme katalogstruktur og hoveddfil. En EPUB-masterfil kan se slik ut:

```yaml
= Teskstutheving i AsciiDoc
Jan R Sandbakken <mailjaro@gmail.com>
v1.0 2026-02-19
:doctype: book
:front-cover-image: image:../images/cover.png[]
:description: Et hefte om syntaksutheving via AsciiDoc
:icons: font
:sectanchors:
:source-highlighter: rouge
:rouge-style: base16.solarized.light
:ebook-stylesdir: ../styles
// :ebook-stylesheet: my-style.css

include::../sample.adoc[]
```

```bash
asciidoctor-epub3 config/epub-master.adoc -D builds -o <navn>.epub
```

I preamble er brukerstilen kommentert ut, og default formatering blir gjeldende.

Igjen er **rouge** og **rouge-style monokai** satt i masterfilen.

❗ Opsjonen `-B` for **asciidoctor-apub3** virker ikke etter hensikten, så prefiks `../` er benyttet for referanser til kataloger i masterfilen (se diskusjon over).

### PDF-output

Vi antar igjen samme hovedfil og katalogstruktur. En pdf-master kan f.eks. se slik ut:

```txt
= Tittel
Ola Nordmann <ola.nordmann@gmail.com>
v1.0 2026-02-12
:description: En beskrivelse
:doctype: book
:front-cover-image: image:images/cover.png[]
:title-page:
:icons: font
:toc: left
:toc-title: Innholdsfortegnelse
:toclevels: 3
:sectanchors:
:pdf-theme: styles/my-style.yml
:source-highlighter: rouge
:rouge-style: base16.dark

include::sample.adoc[]
```

og produskjonen kan ved

```bash
asciidoctor-pdf -B <arbeidskatalog> -D builds -o <navn>.pdf
```

Igjen velges **rouge** og **rouge-style** fra masterfilen

❗ Opsjonen `-B` fungerer fint for **asciidoctro-pdf**, slik at kataloger i masterfilen kan angis uten prefiks `../` (se diskusjon over).

## pandoc-installering

Hvodan pandoc installeres på Ubuntu og Fedora er vist under. For PDF-produksjon trenger man også en moderne LaTeX-motor, ohg installasjon av en slik er også vist.

### Ubuntu

```bash
sudo apt install pandoc
sudo apt install texlive-xetex texlive-latex-recommended \
     texlive-latex-extra texlive-fonts-recommended
```

### Fedora

```bash
sudo dnf install pandoc
sudo dnf install texlive-xetex texlive-collection-latexrecommended \
     texlive-collection-fontsrecommended
```

## Pygments: Installering

**Pygments** er et Python-basert system for syntaksuthevelse. Det fins gjerne ferdige pakker man kan installere, f.eks. under **dnf** eller **snap**, men det kan være bedre å installere via **pip3** direkte:

```bash
pip3 install pygments
```

Pygments kan siden oppgraderes ved:

```bash
pip install --upgrade pygments
```

Ønsker man pakkene, så kan disse installeres ved for hhv. Ubuntu og Fedora ved:

```bash
sudo apt install python3-pygments
```

```bash
sudo dnf install python3-pygments
```

## Pygments: Relaterte versjoner

Vi har valgt pip-varianten her, og versjonene vi benytterfremkommer av

```bash
pandoc --version
pygmentize -V
```

I dette heftet er dermed følgende lagt i grunn:

- Pandoc versjon 3.6.4
- Pygments version 2.19.2

## Pygments: Generelt

Vi skal benytte Pygments til å få
Om man vil se en liste over støttede språk og formater:

```bash
pygmentize -L lexers
```

Ønsker man å se de inkluderte temaene:

```bash
pygmentize -L styles
```

For pandoc har man disse ferdige syntaksuthevelsene:

```bash
pandoc --list-highlight-styles
```

```text
pygments
tango
espresso
zenburn
kate
monochrome
breezedark
haddock
```

## Pygments; Bruk


```bash
pandoc test.md --highlight-style=monokai -s -o test.html
```

```bash
pandoc test.md --highlight-style=pygments -o builds/test.epub
```

```bash
pandoc test.md \
    --pdf-engine=xelatex \
    --highlight-style=pygments \
    -o builds/test.pdf
```
