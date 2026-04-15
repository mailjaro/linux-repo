# 🧱 ufw (brannmur)

`ufw` står for *Uncomplicated Firewall* og gir en brannmur som kan startes, stoppes og modifiseres fra kommandolinjen. Den medfølger Ubuntu, og man kan sjekke om den kjører eller ei ved:

```bash
sudo ufw status
```

Den er ikke-aktiv etter installasjon av Ubuntu, men kan aktiviseres og deaktiveres ved hhv.

```bash
sudo ufw enable
sudo ufw disable
```

Når den er aktiv kan vi sjekke status og hovedregler ved:

```bash
sudo ufw status verbose
```

```output
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip
```

Output her viser settinger som er godt egnet for privat bruk. Bare utgående trafikk tillates (dvs. trafikk initiert fra innsiden), mens forespørsler utenfra blokkeres. For de som setter opp vebbtjenere og annet, må mer åpnes opp, og konfigureringen kompliseres.

De fleste rutere for hjemmenettverk har en brannmur med samme policy, så man kan vurdere å skru av `ufw` når man er hjemme.

For å sjekke loggene kan vi gjøre

```bash
sudo less /var/log/ufw.log 
```

eller 

```bash
grep -i ufw /var/log/syslog
grep -i ufw /var/log/kern.log
```

Under ser vi et lite loggeksempel. Akkurat denne er ikke spesielt spennende. Den har å gjøre med at rutere jevnlig multicaster ut for å høre om det er noe nytt. Men for å se nærmere på formatet til loggen, får denne duge. Øverst ser vi dato og om hendelsen var en ufw-blokkering eller en tillatelse. Etter det ser vi felter som er forklart på høyre side. (Enda flere felter er definert.)

```output
2025-03-06T16:05:35.835450+01:00 JanAsus kernel: [UFW BLOCK]
IN=wlo1								# Ingoing interface
OUT=								# Outgoing interface
MAC=2c:3b:70:2d:39:9f:e8:37:7a:c4:ec:af:08:00 # Src and dst MAC
SRC=10.0.0.138					    # Source IP
DST=224.0.0.1						# Destination IP
LEN=36								# Length of the packet
TOS=0x00							# Type og service
PREC=0xC0							# 
TTL=1								# Time to live
ID=0								#
DF									# Don’t fragment bit 
PROTO=2								# Protocol (TCP, UDP)
```

Det er to MAC-adresser angitt her, delt på midten. Den venstre halvdelen er til det trådløse grensesnittet på PC-en, og den til høyre er hjemmeruteren i dette tilfellet.

Som kontroll, for å finne MAC-adressen på PC-en, kan man f.eks. gå fram som følger:

Navnet på wifi-grensesnittet på PC-en er f.eks. å finne i **/proc/net/wireless**:

```bash
cat /proc/net/wireless
```

```output
Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
face  | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
wlo1: 0000   68.  -42.  -256        0      0      0      0     12        0
```

(eventuelt ser vi den ved **ip address**) slik at man i dette tilfellet kan si:

```bash
ip link show wlo1
```

```output
2: wlo1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DORMANT group default qlen 1000
    link/ether 2c:3b:70:2d:39:9f brd ff:ff:ff:ff:ff:ff
    altname wlp1s0
```

og der står den (gulmarkert for tydeliggjøring).

MAC-adressen til ruteren står gjerne fysisk på boksen.

`ufw` støtter følgende nivåer på loggingen:

- **off**: Ingen logging.
- **low**: Logger blokkerte pakker (anbefalt i normale situasjoner).
- **medium**: Inkluderer ugyldige pakker, nye forbindelser og såkalt rate limited logging.
- **high**: Logger pakker med og uten rate limiting.
- **full**: Som high, men uten rate limiting.

*Rate limiting* i denne sammenheng en begrensing på antall forsøk som beskyttelse mot *denial of service*-angrep.
	
For å sette ønsket loggenivå, gjør f.eks:

```bash
sudo ufw logging medium
```

Man kan dessuten velge å åpne for en spesiell tjeneste eller port ved:

```bash
sudo ufw allow log ssh
sudo ufw allow log 22/tcp			# TCP-port 22 er for SSH
```
evt å blokkere ved:

```bash
sudo ufw deny log ssh
sudo ufw deny log 22/tcp			# TCP-port 22 er for SSH
```

HEFTET ER IKKE FERDIGSKREVET

## 📚 Andre hefter i serien

📘 [Litt om CSS](https://mailjaro.github.io/css-repo/)

📘 [Litt om Git](https://mailjaro.github.io/git-repo/)

📘 [Litt om VS Code](https://mailjaro.github.io/vscode-repo/)

📘 [Litt om GPG](https://mailjaro.github.io/gpg-repo/)

📘 [Litt om syntaksutheving](https://mailjaro.github.io/highlight-repo/)

📘 [Litt om Makefile](https://mailjaro.github.io/makefile-repo/)

📘 [Moderne AI: Virkemåte](https://mailjaro.github.io/ai-repo/)