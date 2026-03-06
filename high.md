
# Highligting i Asciidoctor

I mange tilfeller ønsker man syntaks-higlighting, f.eks. når man viser kodeeksempler i ulike språk eller i ulike shell. Dette kan både være under skriving/forhåndsvisning (som f.eks. av Markdown i VS Code) eller ved produksjon av ulike dokumentformater (som EPUB, HTML og PDF). For dette har man løsninger som **Rouge** og **Pygments**. (Man har også **Coderay**, men dette vedlikhodes ikke aktivt og er i praksis ersattet av **Rouge**.)

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

## Rouge: Bruk

Når dette er installert kan utnytte dette ved å inkludere det følgende på toppen (i *preamble*) til ADOC-filen, eller kanskje vel så vanlig, å inkludere det i premable på en masterfil (som gjerne er spesifikk for hvert output-format):

```yaml
:source-highlighter: rouge
:rouge-style: monokai
```

De tilgjengelige Rouge-stilene i sisste linje kan ses fra

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

Man kan alternativt styre det fra kommandolinjen som eksemplifisert her:

```bash
asciidoctor -a source-highlighter=rouge \
            -a rouge-style=monokai <fil.adoc> ...
```

Dette er felles for HTML, EPUB og PDF. Ellers skiller de seg ved at HTML og EPUB videre baserer stiling på CSS, mens PDF-settingene er YAML-basert. Og de benytter hhv. kommandoene **asciidoctor**, **asciidoctor-epub** og **asciidoctor-pdf** for konvertering. 

Man kan enten kombinere highlightingen med inkludert CSS eller YAML (med veldig flott resultat), eller med en egenskrevet versjon. For CCS kan man da konkret produsere og ta utgangspunkt i de nevnte fargekombinasjonene ved kommandoer som disse:

```bash
rougify style github > github.css
rougify style monokai > monokai.css
```

Inkluderer man det følgende

```yaml
:linkcss:
```

i preamble (i toppen av dokument eller masterfil) blir disse også produsert sammen med output-filen ved produksjon.

Men man må uansett være forberedt på å skrive mye mer CSS for en fullverdig formatering av hele dokumentet.

Default fil for stiling for

- `asciidoctor` er **asciidoctor.css** (som også spyttes ut ved bruk av `:linkcss:`) 
-  `asciidoctor-pdf` er **asciidoctor-default.yml**
  
`asciidoctor-epub3` bruker tre slike:

```text
epub3.css
epub3-css3-only.css
epub3-fonts.css
```

hvorav den inneholder layout, typografi, kapittelstruktur osv. Den siste definerer font-innlasting mm.

For å få inkludert egne stiler kan man inkludere for:

**HTML:**

```yaml
:stylesheet: my-style.css
```

i preamble eller direkte fra kommandolinja inkludere

```bash
asciidoctor -a stylesheet=my-style.css ...
```

**EPUB:**

```yaml
:stylesheet: my-style.css
:ebook-theme: my-style.yml
```

i preamble eller direkte fra kommandolinja inkludere

```bash
asciidoctor-epub3 -a stylesheet=my-style.css ...
asciidoctor-epub3 -a ebook-theme=my-style.yml ...
```

**PDF:**

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

La oss se i detalj på hvordan man kan produsere disse formatene, med en *real life*-katalogstruktur mm.

### ROUGE: HTML output

Vi forutsetter her at man samler preamble i en egen html-masterfil **html-master.adoc**. Den kan se noe slik ut:

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

Videre antar vi at:

- hovedfilen heter **sample.adoc**
- bilder ligger på **images/**
- stiler ligger på **styles/**
- og output skal til **builds/**:

Ønsker man higlighting, er det enklest å inkludere `:source-highlighter: rouge` og f.eks. `:rouge-style: monokai` i et preamble.

Om ikke annet spesifiseres i preamble, benyttes default CSS for Ascidoctor.

Ofte ønsker man å sende output til en egen katalog, f.eks, **bulid/**, og kanskje med eg bestemt filnavn, f.eks. **test.html**, hvilket enten kan gjøres ved

```bash
asciidoctor config/html-master.adoc -B <hjemmekatalog> \
            -D builds -o <navn>.html
```

### ROUGE: EPUB output

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

### Rouge: PDF output

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

❗ Ved bruk av opsjonen `-B` **finner asciidoctro-pdf** korrekt fram til alle filene her. Det fungerer ikke for **asciidoctor** og **asciidoctror-pdf**.

