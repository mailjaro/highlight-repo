
# Syntaksutheving

I mange sammenhenger ønsker man fargebasert syntaksutheving, for eksempel når man viser kodeeksempler i dokumentasjon. Dette kan gjelde kode i ulike programmeringsspråk eller kommandoer i forskjellige shell. Behovet oppstår både ved redigering og forhåndsvisning (for eksempel Markdown-forhåndsvisning i VS Code) og ved produksjon av ferdige dokumenter i formater som HTML, EPUB og PDF.

Til dette finnes det flere verktøy, blant annet **Rouge** og **Pygments**. Tidligere var også **Coderay** mye brukt, men dette prosjektet vedlikeholdes ikke lenger aktivt og er i praksis erstattet av **Rouge**.

I dette dokumentet viser vi hvordan syntaksutheving kan brukes på to viktige tekstplattformer: Markdown (MD) og Asciidoc (ADOC). Begge brukes ofte som utgangspunkt for å generere ferdige dokumenter i ulike formater, henholdsvis ved hjelp av **pandoc** og **asciidoctor**. I denne sammenhengen kan **Pygments** benyttes for syntaksutheving i førstnevnte tilfelle, mens **Rouge** brukes i sistnevnte.

Vi starter med en gjennomgang av **Rouge** og avslutter med **Pygments**.

## Rouge: Installering

**Rouge** er et **Ruby-gem**, så man trenger i praksis:

- Ruby
- RubyGems
- selve rouge-pakken

**Ubuntu:**

Her ser vi installasjonsstegene på Ubuntu:

```bash
% sudo apt update
% sudo apt install -y ruby ruby-dev build-essential
% sudo gem install --no-document rouge asciidoctor asciidoctor-pdf asciidoctor-epub3
```

**Fedora:**

Her er installasjonsstegene på Fedora:

```bash
% sudo dnf install -y ruby ruby-devel make gcc
% sudo gem install --no-document rouge asciidoctor asciidoctor-pdf asciidoctor-epub3
```

## Rouge: Programversjoner

Ikke alt er likt i ulike versjoner av programmene som benyttes. For ordensskyld opplyses det om at alt er testet og utført i/med:

- gem 3.6.9
- ruby runtime environment 3.4.8
- asciidoctor 2.0.26
- asciidoctor-epub 3-2.3.0
- asciidoctor-pdf 2.3.19

Disse kan evt. oppdateres ved:

```bash
% sudo gem update --system
% gem update asciidoctor
% gem update asciidoctor-epub3
% gem update asciidoctor-pdf
```


## Rouge: Bruk

Når dette er installert kan man ta i bruk uthevingen ved å inkludere det følgende på toppen (i *preamble*) til ADOC-filen, eller kanskje vel så vanlig, å inkludere det i premable på en masterfil (som gjerne er spesifikk for hvert output-format):

```yaml
:source-highlighter: rouge
:rouge-style: monokai
```

De tilgjengelige Rouge-stilene i siste linje kan ses fra

```bash
% rougify help style
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
% asciidoctor -a source-highlighter=rouge \
            -a rouge-style=monokai <fil.adoc> ...
```

Det nevnte er felles for HTML, EPUB og PDF. Den videre stilingen, om man ikke er fornøyd med default-valgene, er imidlertid forskjellig for de tre formatene. HTML benytter CSS, EPUB kan benytte både YAML og CSS, mens PDF kun benytter YAML. Formatene benytter dessuten hver sin kommando (hhv. **asciidoctor**, **asciidoctor-epub3** og **asciidoctor-pdf**) for konverteringen. 

## Videre stiling

Asciidoctor-programmene produserer fin layout. Særlig for teknisk dokumentasjon er default-stilene (supplert med denne syntaksuthevelsen) gjerne å foretrekke. Default-fil for stiling er:

- **asciidoctor.css** for `asciidoctor`  
- **asciidoctor-default.yml** for  `asciidoctor-pdf`
  
`asciidoctor-epub3` bruker på sin side tre slike:

```text
epub3.css
epub3-css3-only.css
epub3-fonts.css
```

hvorav den første inneholder layout, typografi, kapittelstruktur osv. Den siste definerer font-innlasting mm.

Men om man likevel ikke er fornøyd med default og vil stile output-filene selv, har man anledning til det. Man *kan* da ta utgangspunkt i disse innebygde stilene, men det bør nevnes at disse er nokså kompakte og ikke enkle å jobbe med for ikke-speialister.

Men for syntaksuthevelsen kan det være greit å vite at man kan ta utgangspunkt i de nevnte Rouge-kombinasjonene ved å produsere CCS-er ved kommandoer som

```bash
% rougify style github > github.css
% rougify style monokai > monokai.css
```

Inkluderer man det følgende

```yaml
:linkcss:
```

i preamble (i toppen av dokument eller masterfil) blir disse også produsert sammen med output-filen ved HTML- og EPUB-produksjon (for korrekt lesing av filene).

Men selv med dette som utgangspunkt,  må man være forberedt på en større utvidelse av CSS-ene for en fullverdig formatering av hele dokumentet. Disse tar kun av seg syntaksuthevelsene.

For å få benyttet egne stiler kan man inkludere dem på ulike måter, avhengig av output-format:

### HTML-stiling

Legg inn 

```yaml
:stylesheet: my-style.css
```

i preamble, eller utfør direkte fra kommandolinja

```bash
% asciidoctor -a stylesheet=my-style.css ...
```

### EPUB-stiling

Legg in

```yaml
:ebook-theme: my-style.yml
```

i preamble, eller utfør det følgende direkte fra kommandolinja

```bash
% asciidoctor-epub3 -a ebook-theme=my-style.yml ...
```

På grunn av bakoverkompabilitet støtter EPUB fortsatt følgende CCS-baserte varianter:

```yaml
:stylesheet: my-style.css
```

i preamble og 
```bash
% asciidoctor-epub3 -a stylesheet=my-style.css ...
```

fra kommandolinja.

### PDF-stiling

Legg inn

```yaml
:pdf-theme: styles/my-style.yml
```

i preamble eller utfør følgende dirkete fra kommandolinja

```bash
% asciidoctor-pdf -a pdf-theme=my-theme.yml ...
```

Når alt er tilrettelagt for syntaksytheving på disse måtene, trenger man bare å lage kodeblokker av formen `[source,<språk>]` i ADOC-filene, så blir de syntaksuthvet ut fra språk og Rouge-stilvalg.

❗ **pandoc** mapper forøvrig *fence blocks* til slike kodeblokker når den konverterer MD til ADOC. Dermed kan man også gjerne starte med MD og konvertere til sluttformater med ADOC som mellommann.

## Rouge: Produksjon

Vi skal nå i detalj se på hvordan output-formatene våre kan produseres i en praktisk situasjon, med en *real life*-katalogstruktur mm. Vi forutsetter da at vi jobber med et prosjekt organisert som følger:

- hovedfilen heter **sample.adoc**
- bilder ligger på **images/**
- stiler ligger på **styles/**
- konfigurasjon og masterfiler ligger på **config/**
- og output skal til **builds/**:

Vi forutsetter videre at man samler preamble i en egen formatspesifikk ADOC masterfil.

La oss starte med HTML og se på hvordan outout-formater produseres i disse omgivelsene.

### HTML-output

Masterfilen kan se noe slik ut:

```yaml
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
```

I etterkant av preamble vil man så typisk inkludere filen(e) som inneholder selve ADOC-teksten, altså f.eks. `include::sample.adoc[]`.

Ønsker man higlighting, er det enklest, som gjort her, å inkludere `:source-highlighter: rouge` og f.eks. `:rouge-style: monokai` i preamble.

Ofte ønsker man å sende output til en egen katalog, f.eks, **bulid/**, og kanskje med et bestemt filnavn, f.eks. **test.html**. Dermed ender vi opp med å gjøre:

```bash
% asciidoctor config/html-master.adoc -B <hjemmekatalog> \
             -D builds -o <navn>.html
```

❗ **asciidoctor** har fått masterfilen som input-fil. Denne ligger i underkatalogen **config/**, hvilket påvirker referansene til andre kataloger i treet. Opsjonen `-B` setter hjemmekatalogen, og filer i **config/** og **stiler/** finnes dermed korrekt uten prefiks `../`. **images/** trenger likevel dette prefikset (uvisst av hvilken grunn).  

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
:ebook-stylesheet: my-style.css
```

etterfulgt av en include av ADOC-tkestfilene (se eksempel vist over). Produksjonen kan gjøres ved:

```bash
% asciidoctor-epub3 config/epub-master.adoc -D builds -o <navn>.epub
```

Igjen er **rouge** og **rouge-style monokai** satt i masterfilen.

❗ Opsjonen `-B` for **asciidoctor-apub3** virker ikke etter hensikten, så prefiks `../` er benyttet for referanser til kataloger i masterfilen (se diskusjon over).

### PDF-output

Vi antar igjen samme hovedfil og katalogstruktur. En pdf-master kan f.eks. se slik ut:

```yaml
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
```

etterfulgt av en include av ADOC-tkestfilene (se eksempel vist over). Produksjonen kan gjøres ved:

```bash
% asciidoctor-pdf -B <arbeidskatalog> -D builds -o <navn>.pdf
```

Igjen velges **rouge** og **rouge-style** fra masterfilen

❗ Opsjonen `-B` fungerer fint for **asciidoctro-pdf**, slik at kataloger i masterfilen kan angis uten prefiks `../` (se diskusjon over).

## pandoc-installering

Hvordan pandoc installeres på Ubuntu og Fedora er vist under. For PDF-produksjon trenger man også en moderne LaTeX-motor, og installasjon av en slik er også vist.

### Ubuntu

```bash
% sudo apt install pandoc
% sudo apt install texlive-xetex texlive-latex-recommended \
      texlive-latex-extra texlive-fonts-recommended
```

### Fedora

```bash
% sudo dnf install pandoc
% sudo dnf install texlive-xetex texlive-collection-latexrecommended \
      texlive-collection-fontsrecommended
```

## Pygments: Installering

La oss forlate **Rouge** og ADOCs, og isteden tar for oss **Pygments** og MD.

**Pygments** er et Python-basert system for syntaksuthevelse. Det fins gjerne ferdige pakker man kan installere, f.eks. under **dnf** og **snap**, men det kan være bedre å installere via **pip3** direkte:

```bash
% pip3 install pygments
```

Pygments kan da siden oppgraderes ved:

```bash
% pip install --upgrade pygments
```

Ønsker man pakkene, så kan disse installeres ved for hhv. Ubuntu og Fedora ved:

```bash
% sudo apt install python3-pygments
```

```bash
% sudo dnf install python3-pygments
```

## Pygments: Relaterte versjoner

Vi har valgt pip-varianten her, og versjonene vi benytterfremkommer av

```bash
% pandoc --version
% pygmentize -V
```

I dette heftet er følgende lagt i grunn:

- Pandoc versjon 3.6.4
- Pygments version 2.19.2

## Pygments: Generelt

Om man vil se en liste over støttede språk og formater, kan man gjøre:
Vi skal benytte Pygments til å få
```bash
% pygmentize -L lexers
```

Ønsker man å se de inkluderte temaene, kan man gjøre:

```bash
% pygmentize -L styles
```

For **pandoc** har man disse ferdige syntaksuthevelsene:

```bash
% pandoc --list-highlight-styles
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

## Pygments: Bruk

Man utnytter disse syntaksstilene i våre tre formater ved kommandoer som: 

```bash
% pandoc test.md --highlight-style=pygments -s -o builds/test.html
```

```bash
% pandoc test.md --highlight-style=breezedark -o builds/test.epub
```

```bash
% pandoc test.md --highlight-style=zenburn --pdf-engine=xelatex \
       -o builds/test.pdf
```

Man vil typisk også inkludere en felles metafil med tittel, forfatter, versjon mm, samt én spesifikk for hvert format. Disse må inkluderes ved opsjonen `--defaults` til **pandoc**:


```bash
--defaults=common.yml
```

```bash
--defaults=html.yml
--defaults=epub.yml
--defaults=pdf.yml
```

Her ser vi videre et eksempel på en **commom.yml**:

```yaml
title: "En tittel"
author: "Ola Nordmann"
version: "1,0"
date: "Mars 2026"
language: "no"
```

Og under ser vi eksempler på formatspesifikke YAML-filer:

**html.yml:**

```yaml
standalone: true
metadata-files: config/common.yml
css: styles/html.css
```

**epub.yml:**

```yaml
standalone: true
metadata-files: config/common.yml
css: styles/epub.css
epub-cover-image: images/cover.png
```

**pdf.yml:**

```yaml
standalone: true
pdf-engine: xelatex
include-in-header: styles/pdf.tex
metadata-files: config/common.yaml

variables:
  mainfont: "Liberation Serif"
  monofont: "Liberation Mono"
  fontsize: 11pt
  geometry: margin=2.5cm
```

❗ Merk at pandoc ikke har noen cover-image-metadata for HTML og PDF. Der sette isteden et bilde inn på egen side i MD-dokumentet ved:

```text
![Cover](images/cover.png)
```

Eksemplene viser også hvordan man kan stile hvert av formatene, ved CSS- og TEX-filer for HTML/EPUB og PDF.

### "Pygments" i VS Code

Når vi først er igang, kan vi jo nevne at om man benytter utvidelsen **Markdown Preview Enhanced** for forhåndsvisningen av MD i VS Code, kan man velge blant en rekke Pygmentaktige fargevalg. Man går da inn i Settings-GUI (`Ctr+,`) og søker opp:

```text
Markdown-preview-enhanced: Code Block Theme
```
Her kan man i en rullemeny velge f.eks. **github-dark.css**, **twighlight.css** og et tyvetalls andre.

## Fordeler og ulemper: Rouge vs Pygments

La oss avslutte med en liten sammenlikning av

- pandoc med **Pygments** fra MD
- asciidoctor med **Rouge** fra Asciidoc

Det er det klart at begge bidrar med fin syntaksutheving i sluttproduktet.

➕ Fordelen med det førstnevnte ligger i fleksibiliteten. Man må riktignok skrive egne CCS-er eller TEX-filer, som kan være alt fra enkle til utfordrende, men disse lar seg enklere sy sammen med det øvrige og med **Pygments**.

➖ Ulempen er at fomatene blir nokså nakne uten egeninnsats.

➕ Fordelen med det sistnevnte er at **asciidoctor** produserer veldig flotte ferdige formater og kan utnytte Asciidocs rikere muligheter med *admonitions*, *callouts*, bedre tabellhådntereing, matematikk og annet.

➖ Ulempen er at default-settingene vanskelig lar seg sette til side. Selv mindre tilpasninger slipper ikke til og vil kunne kreve skriving av helt nye og fullverdige stilingsdokumenter.

## Andre hefter i serien

📘 Litt om Linux

📘 [Litt om Gitt](https://mailjaro.github.io/git-repo/)

📘 [Litt om VS Code](https://mailjaro.github.io/vscode-repo/)

📘 [Litt om GPG](https://mailjaro.github.io/gpg-repo/)

📘 [Litt om CSS](https://mailjaro.github.io/css-repo/)