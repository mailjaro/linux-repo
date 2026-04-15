#!/usr/bin/fish
pushd ~/Documents/doc/linux-doc

pushd chapters
sd '```output' '```default' *.md
popd

if rg -q "dark_theme:.*true" configs/common.yaml
    set CSS "styles/dark.css"
else
    set CSS "styles/light.css"
end

cp styles/dark.css builds/styles
cp styles/light.css builds/styles

pandoc chapters/*.md --standalone \
    --highlight-style=espresso \
    --metadata-file=configs/common.yaml \
    --template=configs/template.html \
    --toc \
    -o builds/linux_pandoc.html -V css-path=$CSS \
    --embed-resources

pushd chapters
sd '```default' '```output' *.md
popd

echo "✅ Pandoc HTML version successfully generated"

popd
