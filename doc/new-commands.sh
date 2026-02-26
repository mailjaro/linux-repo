#!/usr/bin/bash

grep --color=always -ivw "en" testfil.txt | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-1.txt
grep --color=always -Ein 'linux|windows' testfil.txt | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-2.txt
grep --color=always -i '^linux' testfil.txt | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-2-5.txt
grep --color=always  -in -A1 -B1 'debian' testfil.txt | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-3.txt
echo  'ascot cat cut cute cutter c-t c:t dog car ct' | grep --color=always 'c.t' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-4.txt
echo  'err error' | grep --color=always '^e' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-5.txt
echo  'err error' | grep --color=always 'r$' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-6.txt
echo  'h oh ooh o oo' | grep --color=always 'o*h' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-7.txt
echo  'dg dog doog' | grep --color=always -E 'do+g' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-8.txt
echo  '911 9111 91111 911111 111' | grep --color=always -E '91{2}' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-9.txt
echo  '911 9111 91111 911111 111' | grep --color=always -E '91{2,}' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-10.txt
echo  '911 9111 91111 911111 111' | grep --color=always -E '91{2,3}' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-11.txt
echo  'color colour coloor' | grep --color=always -E 'colou?r' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-12.txt
echo  'cat cats dog dogs ctdg' | grep --color=always -E 'cat|dog' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-13.txt
echo  'set sunset sunsunset' | grep --color=always -E '(sun)+set' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-14.txt
echo  'Line Nine Tine Katrine' | grep --color=always '[LNT]ine' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-15.txt
echo  'Line Nine Tine Katrine' | grep --color=always '[^LNT]ine' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-16.txt
echo  'Anne Beate Jan Tare' | grep --color=always '[A-K][a-m]' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-17.txt
echo  '+45 AB C3 python-3' | grep --color=always '[a-zA-Z0-9]' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-18.txt
echo  '+: abc: 347: ---:' | grep --color=always '[a-zA-Z0-9]:' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-19.txt
echo  'AN3 Bn4 aX5 6vH 3Nr' | grep --color=always '[0-9][A-Z][a-z]' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-20.txt
echo  'jan.roger-home@gmail.com' | grep --color=always -E '[.a-zA-Z0-9_-]+@[.a-zA-Z]+' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-21.txt
echo  'NOX-901-333 FOX-875-334' | grep --color=always -E '[A-Z]{3,3}\-[0-9]{3,3}\-3{3}' | ansi2html | awk '/<pre class="ansi2html-content">/,/<\/pre>/' > output-22.txt

