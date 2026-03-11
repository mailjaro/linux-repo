#!/usr/bin/fish
pushd ~/Documents/doc/linux-doc

pushd chapters
# Convert MDs to ADOCs
for f in *.md
    pandoc "$f" -f markdown-smart -t asciidoc -o (string replace -r '\.md$' '.adoc' "$f")
end

# Remove emojis og make admonitions
sd '❗' 'NOTE:' *.adoc
sd '‼️' 'CAUTION:' *.adoc
sd '🚩' 'WARNING:' *.adoc
sd '\p{Extended_Pictographic}\uFE0F? ' '' *.adoc
sd ' [1-7]️⃣' '' *.adoc

cat ../configs/masterHTML.adoc > ADOCS
    ls -1 *.adoc > tmp
sd '^' 'include::./' tmp
sd 'adoc$' 'adoc[]' tmp
sd 'include::./$' '' tmp
cat tmp >> ADOCS 
popd
asciidoctor chapters/ADOCS -R . -a data.uri -o builds/linux.html
echo "✅ HTML format successfully produced"

rm chapters/*.adoc
popd
