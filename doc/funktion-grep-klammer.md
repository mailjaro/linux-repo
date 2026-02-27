# Grep-funksjon for klammer

Følgende fish-funksjon lager en justert `grep`-kommando som klammemarker matchende mønstre (istedenfor fargenarkeringen som gis):

```bash
function grepm
    grep --color=always $argv \
    | perl -pe '
        s/\e\[[0-9;]*m/\x00/g;
        s/\x00([^\x00]*)\x00/[$1]/g;
    '
end
```

Her er et par eksempler på bruk:

```bash
echo 'foo bar baz' | grepm 'ba'
```

```output
foo [ba]r [ba]z
```

```bash
echo 'foo bar baz' | grepm 'ba.'
```

```output
foo [bar] [baz]
```
