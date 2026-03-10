#!/usr/bin/fish
pushd ~/Documents/doc/linux-doc
mkdir -p drafts

pandoc linux.md  \
   --metadata-file=config/common.yaml \
   --css=styles/epub-dark.css -o \
   drafts/linux-dark.epub

pandoc linux.md  \
   --metadata-file=config/common.yaml \
   --css=styles/epub-light.css -o \
   drafts/linux-light.epub

pandoc linux.md --metadata-file=./config/common.yaml \
                 --wrap=none -f markdown-smart -o linux-1.adoc

asciidoctor -a stylesheet=../styles/asciidoctor-default.css \
            -a data-uri \
            config/masterHTML-1.adoc -o drafts/linux-1.html

cp linux-1.adoc linux-2.adoc
sd '\[source,text\]' '[%unbreakable]\n[source,text]' linux-2.adoc
sd '\[source,json\]' '[%unbreakable]\n[source,json]' linux-2.adoc
sd '\p{Extended_Pictographic}\uFE0F? ' '' linux-2.adoc  # Fjerner emojis
sd ' 1️⃣' '' linux-2.adoc
sd ' 2️⃣' '' linux-2.adoc
sd ' 3️⃣' '' linux-2.adoc
sd ' 4️⃣' '' linux-2.adoc
sd ' 5️⃣' '' linux-2.adoc
sd ' 6️⃣' '' linux-2.adoc
sd ' 7️⃣' '' linux-2.adoc


asciidoctor -a stylesheet=../styles/asciidoctor-default.css \
            -a data-uri \
            config/masterHTML-2.adoc -o drafts/linux-2.html

cp linux-2.adoc linux-3.adoc

asciidoctor-pdf config/masterPDF.adoc --theme=styles/asciidoctor-default.yml \
                -o drafts/linux.pdf

popd