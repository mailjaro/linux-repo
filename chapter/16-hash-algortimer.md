# 🔑 Hash-algortimer

Også kalt kryptografisk sjekksum.

## crypt

## Sha256sum

```bash
sha256sum --version
```

## md5sum

```bash
md5sum \--version
```

## Verifisering av Ubuntu-distribusjon

https://ubuntu.com/tutorials/how-to-verify-ubuntu#1-overview

```bash
gpg \--keyid-format long \--keyserver hkp://keyserver.ubuntu.com
\--recv-keys
```

```output
0x46181433FBB75451 0xD94AA3F0EFE21092
```

```bash
gpg -k
```

```bash
cat SHA256SUMS
```

```output
d7fe3d6a0419667d2f8eff12796996328daa2d4f90cd9f87aa9371b362f987bf
\*ubuntu-24.04.2-desktop-amd64.iso
```

```output
d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d
\*ubuntu-24.04.2-live-server-amd64.iso
```

```output
5d1eea52103166f1c460dc012ed325c6eb31d2ce16ef6a00ffdfda8e99e12f43
\*ubuntu-24.04.2-wsl-amd64.wsl
```

```bash
gpg \--keyid-format long \--verify SHA256SUMS.gpg SHA256SUMS
```