# Lokale kommandoer

## Pandoc: MD til ADOC

Hovefilen er skrvet i MD og konverteres før HTML-prooduksjon først til ADOC:

```bash
pandoc -f markdown -t asciidoc --wrap=none -o high.adoc high.md
```

Pandoc/ADOC har problemer med `incude`-setninger, selv om de er i *literal blocks*. Disse må derfor prefikses med backslash:

```bash
sed -i 's/^\(.*\)include::/\\\1include::/' high.adoc
```

## HTML-produksjon

Her er en produksjonskommando for HTML:

```bash
asciidoctor config/html-master.adoc -B ~/Documents/doc/highlighting-doc -o builds/index.html
```

Ved eksport til **GitHub pages** må man eksportere denne fra Git-gren **gh-pages**. Man switcher typisk til denne grenen og kopierer **index.html** fra **builds/** til WD for den pushes etc.