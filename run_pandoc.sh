#!/usr/bin/fish
pushd ~/Documents/doc/linux-doc

pushd chapters
sd '```output' '```default' *.md
popd

pandoc chapters/*.md --standalone \
    --highlight-style=espresso \
    --css=styles/linux_pandoc.css \
    --metadata-file=configs/common.yaml \
    -o builds/linux_pandoc.html

pushd chapters
sd '```default' '```output' *.md
popd

echo "✅ Pandoc HTML version successfully generated"

popd
