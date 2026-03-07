# 📚 Syntaksutheving

Dette prosjektet demonstrerer fargebasert syntaksutheving for kodeeksempler i dokumentasjon. Det dekker bruk av **Rouge** for AsciiDoc og **Pygments** for Markdown, med støtte for produksjon av HTML, EPUB og PDF.

## 🚀 Bruk

Bygg HTML-filen fra `high.md`:

```bash
make html
```

Åpne den genererte filen i Firefox:

```bash
make read
```

Alternativt, kjør `runner.sh` for samme funksjonalitet.

## 📋 Krav

- **pandoc** for MD-posesserig
- **asciidoctor** for AsciiDoc-prosessering
- **rouge** for syntaksutheving i **pandoc**-output
- **Pygments** for syntaksutheving for **asciidoctor**-ouput

## 📖 Innhold

Prosjektet inkluderer veiledninger for installasjon og bruk av Rouge og Pygments, samt eksempler på styling for ulike output-formater.

---

*Se `high.md` for full dokumentasjon.*