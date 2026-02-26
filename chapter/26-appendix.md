# Appendix

Filsystemet i Linux
En viss oversikt over hvilke kataloger som fins og hvilken hensikt de har, er nyttig. Det fins egentlig en egen standard, FHS, som konkretiserer og standardiserer katalogene Linux. Her ser vi en lang listing av toppkatalog /:

```output
bin -> usr/bin
bin.usr-is-merged
boot
cdrom
dev
etc
home
lib -> usr/lib
lib64 -> usr/lib64
lib.usr-is-merged
lost+found
media
mnt
opt
proc
root
run
sbin -> usr/sbin
sbin.usr-is-merged
snap
srv
sys
tmp
usr
var
```

### /usr/bin

usr står for User System Resourcees, og bin står for binaries. /usr/bin inneholder alle programmer og skallkommandoer for brukere. ls, cd, awk og alle ligger altså her. Tidligere lå disse programmene i /bin, så derfor er det nå en link derfra til /usr/bin.


### usr/

usr/lib inneholder systembiblioteker. (Biblioteker er kode som kan benyttes av flere programmer.) Tidligere lå dette i /lib, så det er tilsvarende nå satt opp en link der.

### /usr/sbin

/usr/sbin inneholder tileggsprogrammer og -kommandoer for administratorer. shutdown, ip og runlevel er eksempler på kommandoer som vil ligge her. Tidligere lå alt dette i /sbin.

### /usr/share

/usr/share inneholder dokumentasjon og felles ting for bibliotekene.

### /boot

/boot inneholder filer som trengs for å starte opp systemet. Filene til bl.a. GRUB og Linux-kjernen lagres dermed her. (Konfigurasjonsfilen for dette lagres imidlertid på /etc sammen med andre konfigurasjonsfiler.)

### /cdrom

/cdrom er ikke en del av FHS-standarden, men er fortsatt å finne på Ubuntu og visse andre distribusjoner. Den vil være midlertidig sted for en CD-ROM på systemet.

### /dev

dev står for devices. /dev-katalogen inneholder spesialfiler som representerer devices på systemet. Disse er strengt tatt ikke filer, men fremstår på mange måter som det. Disker, partisjoner, nettverksgrensesnitt og annet ligger her.

### /etc

/etc inneholder systembaserte konfigurasjonsfiler (ikke konfigurasjonfiler for brukere). Filene er typisk tekstfiler som kan editeres med en vanlig teksteditor.

### /home

/home inneholder brukernes hjemmekataloger, med alle dokumenter, bilder, filmer, musikkfiler osv, samt alle brukerspesifikke konfigurasjonsfiler som .bashrc og andre.

### /lost+found

Om filsystemet crasher, gjøres en sjekk av filsystemet ved neste oppstart. Om dette avdekker skadde filer, legges disse i /lost+found slik at man får mulighet til å gjenskape eller redde så mye som mulig senere. Kun root har tilgang til denne.

### /media

/media inneholder underkataloger for alle fjernbare media devices påkoblet systemet, altså USB-minnepenner, USB-disker og annet. På min installasjon er også en separat Linux Mint-partisjon å finne der, selv om den er permanent. Innholdet på alt dette fins altså tilgjengelig på kataloger under /media.

### /

/mnt er sted hvor systemadministrator midlertidig kan montere enheter

### /opt

opt står for optional packages og er reservert for programvare som ikke er del av det grunnleggende systemet. Eventuell programvare som ikke håndteres av det vanlige pakkesystemet, havner her.

### /proc

/proc inneholder spesialfiler (ikke egentlige filer) som representerer kjernens datastrukturer og alle prosesser i systemet. Hver eneste prosess har bl.a. sin underkatalog med navn tilsvarende PID-nummeret. proc-systemet settes opp ved oppstart og oppløses ved shutdown.

### /root

/root er hjemmekatalogen til root-bruker. roots ulike konfigureringsvalg lagres eksempelvis der.

### /run

/run er et sted hvor applikasjoner kan lagre unna data, om prosesser, sockets og mye annet. Dette kan ikke lagres på /tmp siden det der risikerer å bli slettet.

### /

/snap er ikke del av FHS og fins ikke nødvendigvis på andre distribusjoner. Men Ubuntu lagrer installerte snap-pakker og andre filer assosiert med snap der.
 
 ### /srv

/srv inneholder dato for tjenester systemet tilbyr, som vebbtjenester. De som kjører apache2 og har satt opp nettsted, lagrer typisk filene på en katalog under /srv.

### /tmp

Applikasjoner lagrer temporære data på /tmp. Disse filen slettes normalt ved restart og kan i prinsippet bli slettet av systemet når som helst.

### /var

Systemet skriver data til /var under kjøring. Data for cache, logging, e-post og skriverkø er eksempler på ting som havner i /var.

## Vanlige systembrukere

Det kan også være greit å ha en viss oversikt over vanlige system-brukere på maskinen. Disse er der for å kjøre bestemte oppgaver med tilpassede og ikke for utvidede rettigheter. Hvilke som er tilstede, vil avhenge en god del av distribusjon og installasjon. Her vises for to ulike installasjoner: Ubuntu (vist i grønt) og Mint (vist i rødt). Det som er felles for dem er vist i sort. Beskrivelsene er ikke utfyllende på noen måte og flere kunne sikkert vært mer presise. Men det er et utgangspunkt til andre, bedre oversikter er å finne.

Bruker
Beskrivelse
_apt
apt-daemon for installering og håndtering av snaps 
avahi
For kringkasting og oppdagelse av tjenester på lokalnettet
avahi-autopid
IPv4LL network address configuration daemon 
backup
Sikkerhetskopi-relatert
bin
Brukt av applikasjoner tidligere. Brukes ikke av nye applikasjoner
colord
Knyttet til bruk av farger og fargeprofiler
cups-browsed
Gjør ikke-lokale CUPS printere tilgjengelig lokalt
cups-pk-helper
Relatert til CUPS
daemon
Brukt av daemons tidligere. Brukes ikke av nyere deamons
dhcpcd
Klient for å kommunisere med DHCP-tjenere for å få IP-adresse mm.
_flatpak
For flatpak-programsystemet (et universalt pakkesystem)
dnsmasq
Sørger for DNS på småskala nettverk
fwupd-refresh
Knyttet til oppdatering av firmware
games
Spillrelatert
gdm
Gnome (GNU Network Object Model Environment)  display manager
geoclue
Gir støtte for geo-lokalitet i applikasjoner 
gnats
 For lagring og rapportering av bugs (GNATS bug tracking system)
gnome-initial-setup
Runs first time you log in to the GNOME desktop and lets you configure your language, keyboard layout, online accounts integration, and more. 
gnome-remote-desktop
GNOME Remote Desktop allows users to share their desktop and control it remotely using various protocols,
hplip
Sørger for Hewlett Packard HPLIP-printerstøtte
irc
Knyttet til IRC (Internet Relay Chat)-tjenesten
jan
Vanlig bruker
kernoops
Samler og formilder crash-informasjon fra kjernen
lightdm
Lightweight display cross-desktop display manager
list
 Umulig å google informasjon om denne
lp

mail

man

messagebus
A message bus daemon responsible for managing communication between different processes in a Linux architecture
news

nm-openvpn
NetworkManager is a program for providing detection and configuration for systems to automatically connect to networks. OpenVPN is a virtual private network (VPN) system that implements techniques to create secure point-to-point or site-to-site connections in routed or bridged configurations and remote access facilities. It implements both client and server applications. 
nobody
A placeholder reserved for NFS only
polkitd
Autentiseringsmekanisme daemons kan tilby upriveligerte programmer
proxy
The proxy system user in Ubuntu is a non-login user account meant to run proxy services securely. It helps in traffic management, caching, and security by ensuring that proxy services operate in an isolated and restricted environment.
puls
For Puls Audio general purpose sound middleware
root

rtkit
The rtkit system user in Ubuntu exists to run RealtimeKit (rtkit-daemon), which allows safe and controlled real-time scheduling for applications like PulseAudio and PipeWire. It helps improve audio performance while ensuring system stability and security.
saned
 Gjør at ikke-lokal klienter skal kunne etterspørre lokale bilder
speech-dispatcher
 Daemon som støtter programmer som vil utføre talefunksjoner
sssd
 Knyttet til System Security Services, autentisering og ikke-lokal akksess
sync

sys

syslog

systemd-network

systemd-oom
 Monitorer og hindrer OOM (userspace Out Of Memory)
systemd-resolve

systemd-timesync

tcpdump

tss

usbmux
 USB multiplexing daemon, kontrollerer forbindelser over USB til iOS
uucp
For Unix-to-Unix copy, et eldre tjenestesett for filoverføring mm.
uuidd
Daemon som sørger for unike identifikatorverider for objekter
whoopsie
Rapporterer feil, f.eks. når noe crasher 
www-data
apache2-daemon. (Ubuntu legger den til selv uten apache2)


Fra ChatGTP:
Tabell: Vanlige systembrukere på vanlige Linux-distribusjoner

System Users
Ubuntu
Fedora
Arch Linux
CentOS
Description
apache
No
Yes
Yes
Yes
A user associated with the Apache web server (may also be http or httpd depending on the distro).
bin
Yes
Yes
Yes
Yes
A user associated with essential system binaries.
cups
Yes
Yes
Yes
Yes
A user for CUPS (Common Unix Printing System) services.
daemon
Yes
Yes
Yes
Yes
A system user for background services (daemons).
dbus
Yes
Yes
Yes
Yes
A user for the D-Bus inter-process communication system.
docker
No
Yes
Yes
Yes
A user for Docker container management.
games
Yes
Yes
Yes
Yes
A user related to games and game resources.
git
Yes
Yes
Yes
Yes
A user for Git-related processes.
gnome
Yes
Yes
Yes
Yes
A user for GNOME desktop environment processes.
http
No
Yes
Yes
Yes
Web server user, associated with httpd (Apache or Nginx).
lp
Yes
Yes
Yes
Yes
A user for printing services.
mail
Yes
Yes
Yes
Yes
A user for mail services.
man
Yes
Yes
Yes
Yes
A user for system manual page utilities.
messagebus
Yes
Yes
Yes
Yes
A user for D-Bus message bus system.
named
No
No
No
Yes
A user for the DNS service (BIND), typically found in CentOS.
news
Yes
Yes
Yes
Yes
A user for Usenet news services.
nobody
Yes
Yes
Yes
Yes
A user often used for processes that don't require a specific identity.
ntp
Yes
Yes
Yes
Yes
A user for network time protocol (NTP) services.
pkg
No
No
Yes
No
A user for package management (in some distros).
postfix
No
Yes
Yes
Yes
A user associated with the Postfix mail transfer agent.
root
Yes
Yes
Yes
Yes
The superuser with full administrative privileges.
saslauth
No
Yes
Yes
Yes
A user for SASL (Simple Authentication and Security Layer) for email authentication.
snapd
Yes
No
Yes
No
A user associated with Snap package management and service.
sync
Yes
Yes
Yes
Yes
A user for synchronizing file systems.
sys
Yes
Yes
Yes
Yes
A user for system-level processes.
systemd-coredump
No
Yes
Yes
Yes
A user for systemd's core dump functionality, handling process crashes and dumps.
systemd-journal
Yes
Yes
Yes
Yes
A user for systemd's journal service, managing system logs.
systemd-timesync
Yes
Yes
Yes
Yes
A user for time synchronization services under systemd.
tss
Yes
Yes
Yes
Yes
Trusted Computing Service (used for TPM-Trusted Platform Module).
ubiquity
No
No
No
No
A user related to the Ubiquity installer 
www-data
Yes
Yes
Yes
Yes
A user typically used by web servers (Apache, Nginx, etc.).

Denne tabellen er ikke helt korrekt. Oppfølgingene er i tabellen er rettet opp for Ubuntu
Key Notes:
    • Common System Users: Users like root, daemon, bin, sys, and sync are common across all major distributions because they are part of basic UNIX system utilities.
    • Distribution-Specific Users: Some users, such as named for DNS services or snapd for Snap package management, are specific to certain distributions. snapd is mostly found in Ubuntu and some derivatives.
    • System Services and Daemons: Many of these system users are associated with specific services, such as www-data (web servers), apache (Apache HTTP Server), ntp (time synchronization), and messagebus (D-Bus message system).
Conclusion:
This table includes most system users that are common across the five popular Linux distributions, as well as a few specific ones for each distribution. The actual list of users may vary slightly depending on the version and any additional packages installed. However, this provides a solid overview of the system users most commonly found in Linux distributions like Ubuntu, Fedora, Debian, Arch Linux, and CentOS.

## vmstat-detaljer
vmstat gir output i form av kolonner som trenger en litt plasskrevende forklaring, så den er gitt her i appendix. Tabellen under gir en oversikt med korte forklaringer.

procs
r: Antall såkalte runnable processes, prosesser som er startet, og enten kjører eller venter på ledig CPU-tid
b: Antall prosesser i uninterruptible sleep, prosesser som ikke kan avbrytes før de er ferdig med sin pågående aksjon. Prosessene er ofte drivere som venter på at ressurser blir frigjort

memory
swpd: mengde virtuelt minne brukt, altså minnemengde som er swapped/paged ut
free: mengde ledig minne
buff: mengde minne benyttet som buffere
cache: mengde minne benyttet som mellomlagres

swap
si: Mengde minne hentet inn fra SWAP-området på disk
so: Mengde minne flyttet ut til SWAP-området på disk

io
bi: Antall datablokker mottat fra et block device
bo: Antall datablokker sendt til et block device

system
in: Antall interrupts per sekund
cs: Antall kontekst-switcher (systemmodus-brukermodus) per sekund

cpu (alle tall i prosent av toal CPU-tid)
 us: Tid brukt på kjøring av ikke-kjernekode
 sy: Tid bruk på kjøring av kjernekode
 id: Tid tilbragt som ikke-aktiv
wa: Tid brukt på venting på I/O 
st: Tid stjålet fra Virtual machine
 gu: Tid brukt på kjøring av KVM (Kernel-based Virtual Machine) guest code

## Terminologi: Processes, damoens og services

I Linux har processes, daemons og services presise, beslektede, men ulike betydninger. Sistnevnte har dessuten to definisjoner, så det er nødvendig å klargjøre.

Selv på engelsk er det lett å bli upresis når man snakker om ting som skjer på en PC. Problemet er at ordene over også er helt vanlige, beskrivende ord (med unntak av daemon) som man tyr til også når behovet for presisjon ikke er til stede. Enda verre blir det når dette oversettes til norsk. De tre siste blir gjerne til prosesser og tjenester, og disse er generelle, overlappende og fine beskrivende ord man også må få bruke mer upresist. Program er også et eksempel på noe som kan ha både en presis og en generell betydning.
Med program i presis forstand, mener vi selve koden til programmet, gjerne som en kjørbar binærfil, men også som kildekoden til f.eks. et C- eller Python-program. En applikasjon er i denne sammenheng bare et brukerprogram, altså et program som skal gjøre noe for brukeren (som regel direkte), ikke primært for systemet.

En prosess (process) er et aktivt program som kjøres av operativsystemet. Den har dedikerte ressurser som minne o.l, et unikt prosessnummer (PID), en gitt prioritet og kan være i en av flere tilstander (som f.eks. i Running state eller i Interruptable sleep state ventende på ledige ressurser).

Videre skiller vi på prosesser som kjører i forgrunn og de som kjører i bakgrunn. Forgrunnsprosesser er tilknyttet en terminal og vil ofte (men ikke alltid) kommunisere med brukeren underveis. Bakgrunnsprosesser er ikke tilknyttet noen terminal og vil kjøre stille uten brukerinteraksjon. Daemons og services er begge ikke-interaktive prosesser som kjører i bakgrunn. Ordene daemeon (som er et UNIX-begrep og ikke er i universell bruk) og services oversettes gjerne begge til tjeneste, hvis da man ikke bare kaller dem prosesser (som de også er).

Damons starter typisk når systemet starter og stoppes først ved shutdown. De er satt til å gjøre en bestemt jobb, og noen kjører i kernel mode, andre i user mode. Prosessen med PID 1, systemd, som (bl.a.) sørger for at alle andre prosesser starter, kjører hele tiden i bakgrunn og er dermed et eksempel på et daemon.

Vi har sett (i kapittelet om start og stopp av tjenester) at systemd kaller sine daemons (de den selv håndterer) for services. Vi finner en liste av dem under /lib/systemd/system. Dette er én av betydningene av services under Linux. Den andre er som en prosess som svarer på forespørsler fra andre prosesser, som regel over et nettverk. Ut fra dette er services altså hva en tjener tilbyr.

Så, kort fortalt: Både processes, daemons og services er prosesser. services og daemons er  prosesser som kjører i bakgrunn. services er spesielle damoens (håndtert av systemd, etv. tjeneste tilbydt av en tjenerfunksjon).

For å liste hhv. aktive og inaktive (men lastet i minne) tjenester, gjør:

```bash
sudo systemctl --type=service --state=active
sudo systemctl --type=service --state=inactive
```

De aktive kan være running eller exited, så ønsker man bare de første av disse, gjør:

```bash
sudo systemctl --type=service --state=running
```

Tilstanden til en daemon kan også være failed, slik at man etv. kan søke om det er noe slike (normalt ingen):

```bash
systemctl --type=service --state=failed
```