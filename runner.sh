#!/usr/bin/fish

pushd ~/Documents/doc/highlighting-doc

pandoc -f markdown -t asciidoc --wrap=none -o high-1.adoc high.md
cp high-1.adoc high-2.adoc
sd '❗' 'NOTE:' high-2.adoc
sd '\p{Extended_Pictographic}\uFE0F? ' '' high-2.adoc  # Fjerner emojis

asciidoctor config/html-master.adoc \
-a data-uri \
-o builds/index.html

echo "✅ index.html successfully built on builds/"

popd