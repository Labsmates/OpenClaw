# 🐉 Kali Linux Docker - Guide d'utilisation

## 📦 Déploiement réussi

**Container :** `kali-linux`  
**Image :** `kalilinux/kali-rolling:latest` (Kali 2025.4)  
**IP :** `172.80.0.7` (réseau proxy)  
**Hostname :** `kali.local`  
**Location :** `/opt/kali/`

---

## 🏗️ Architecture

```
/opt/kali/
├── docker-compose.yml     # Configuration Docker
├── data/                  # Données persistantes
└── workspace/             # Espace de travail
```

### Configuration Docker

**Réseau :**
- Réseau : `proxy` (externe)
- IP fixe : `172.80.0.7`
- Subnet : `172.80.0.0/24`

**Volumes persistants :**
- `/opt/kali/data` → `/data` (stockage données)
- `/opt/kali/workspace` → `/workspace` (projets)

**Capabilities :**
- `NET_ADMIN` - Administration réseau
- `NET_RAW` - Packets raw (scans, sniffing)
- `SYS_PTRACE` - Debugging, trace

**Timezone :** Europe/Paris

---

## 🔧 Utilisation

### Se connecter au container

```bash
# Via SSH au VPS puis Docker exec
ssh openclaw@54.37.157.8
docker exec -it kali-linux /bin/bash
```

### Commandes Docker de base

```bash
# Statut du container
docker ps | grep kali

# Logs du container
docker logs kali-linux

# Redémarrer
docker restart kali-linux

# Arrêter
docker stop kali-linux

# Démarrer
docker start kali-linux

# Stats ressources
docker stats kali-linux
```

### Exécuter des commandes

```bash
# Commande unique
docker exec kali-linux <commande>

# Exemples
docker exec kali-linux nmap --version
docker exec kali-linux python3 --version
docker exec kali-linux ls -la /workspace
```

---

## 🛠️ Outils installés

### Metapackage installé
**`kali-linux-headless`** - Outils essentiels sans GUI (~2.2 GB)

**Contient :**
- Nmap - Scan réseau
- Netcat - Swiss army knife réseau
- Metasploit Framework - Framework exploitation
- John the Ripper - Password cracking
- Hashcat - GPU password cracking
- Aircrack-ng - WiFi security
- SQLMap - SQL injection
- Burp Suite - Web application testing
- Wireshark (CLI) - Packet analysis
- Hydra - Brute force
- Gobuster - Directory/DNS busting
- Nikto - Web scanner
- Enum4linux - SMB enumeration
- Et 100+ autres outils...

### Outils système
- `net-tools` - ifconfig, netstat, route
- `iputils-ping` - ping, traceroute
- `curl`, `wget` - HTTP clients
- `git` - Version control
- `vim`, `nano` - Éditeurs texte
- `sudo` - Privilèges

---

## 🎯 Cas d'usage

### 1. Scan réseau

```bash
# Scan simple
docker exec kali-linux nmap -sn 172.80.0.0/24

# Scan de ports
docker exec kali-linux nmap -p- 172.80.0.10

# Scan avec détection OS
docker exec kali-linux nmap -O 172.80.0.21
```

### 2. Test d'intrusion web

```bash
# Nikto scan
docker exec kali-linux nikto -h http://target.com

# Gobuster directory brute force
docker exec kali-linux gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# SQLMap
docker exec kali-linux sqlmap -u "http://target.com/page?id=1" --dbs
```

### 3. Password cracking

```bash
# John the Ripper
docker exec kali-linux john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt

# Hashcat
docker exec kali-linux hashcat -m 0 -a 0 hash.txt wordlist.txt
```

### 4. Exploitation avec Metasploit

```bash
# Lancer msfconsole (interactif)
docker exec -it kali-linux msfconsole

# Rechercher exploits
docker exec kali-linux msfconsole -x "search apache; exit"
```

---

## 📂 Gestion des fichiers

### Copier des fichiers vers Kali

```bash
# Depuis le VPS vers Kali
docker cp /chemin/fichier kali-linux:/workspace/

# Depuis ta machine locale vers VPS puis Kali
scp fichier openclaw@54.37.157.8:/tmp/
ssh openclaw@54.37.157.8 "docker cp /tmp/fichier kali-linux:/workspace/"
```

### Récupérer des fichiers depuis Kali

```bash
# Depuis Kali vers VPS
docker cp kali-linux:/workspace/resultat.txt /tmp/

# Depuis VPS vers ta machine locale
scp openclaw@54.37.157.8:/tmp/resultat.txt ./
```

---

## 🔒 Sécurité

### Bonnes pratiques

1. **Isolation réseau**
   - Kali est sur le réseau `proxy` avec les autres services
   - Utilise avec précaution (scans, attaques)

2. **Capabilities limitées**
   - Seulement NET_ADMIN, NET_RAW, SYS_PTRACE
   - Pas de privilèges root complets sur l'hôte

3. **Données persistantes**
   - Stocke tes résultats dans `/workspace` ou `/data`
   - Survit aux redémarrages du container

4. **Ne jamais scanner sans autorisation**
   - Usage légal uniquement
   - Tests sur tes propres systèmes ou avec autorisation écrite

---

## 🚀 Mise à jour

### Mettre à jour l'image Kali

```bash
# Sur le VPS
cd /opt/kali
docker compose pull
docker compose up -d --force-recreate
```

### Installer des outils supplémentaires

```bash
# Se connecter
docker exec -it kali-linux /bin/bash

# Chercher un outil
apt search <nom_outil>

# Installer
apt update
apt install -y <nom_outil>

# Exemples
apt install -y kali-linux-large  # Plus d'outils (~9 GB)
apt install -y exploitdb          # Exploit Database
apt install -y zaproxy            # OWASP ZAP
```

---

## 📊 Monitoring

### Ressources utilisées

```bash
# CPU, RAM, I/O
docker stats kali-linux

# Espace disque
docker exec kali-linux df -h

# Processus actifs
docker exec kali-linux ps aux
```

### Logs

```bash
# Logs en temps réel
docker logs -f kali-linux

# Dernières 100 lignes
docker logs --tail 100 kali-linux

# Logs avec timestamps
docker logs -t kali-linux
```

---

## 🐛 Troubleshooting

### Container ne démarre pas

```bash
# Vérifier les logs
docker logs kali-linux

# Vérifier l'état
docker ps -a | grep kali

# Redémarrer
docker restart kali-linux
```

### Problème de réseau

```bash
# Vérifier l'IP
docker exec kali-linux ip addr show

# Tester la connectivité
docker exec kali-linux ping -c 3 8.8.8.8

# Vérifier DNS
docker exec kali-linux nslookup google.com
```

### Manque d'espace disque

```bash
# Nettoyer les images inutilisées
docker system prune -a

# Vérifier l'espace
df -h /opt/kali
```

---

## 🔧 Configuration avancée

### Ajouter un utilisateur non-root

```bash
docker exec -it kali-linux /bin/bash

# Dans le container
useradd -m -s /bin/bash kaliuser
passwd kaliuser
usermod -aG sudo kaliuser

# Se connecter avec cet user
docker exec -it -u kaliuser kali-linux /bin/bash
```

### Exposer un port (ex: Metasploit web UI)

Ajouter dans `docker-compose.yml` :
```yaml
ports:
  - "4444:4444"  # Metasploit listener
  - "8080:8080"  # Web UI
```

Redémarrer :
```bash
docker compose up -d
```

---

## 📝 Notes importantes

### Limitations

- **Pas de systemd** - Services doivent être lancés manuellement
- **Pas de GUI** - Version headless uniquement
- **Root par défaut** - Le container tourne en root (isolation Docker)

### Performance

- **Image size :** ~2.5 GB (kali-rolling + headless)
- **RAM recommandée :** 2 GB minimum
- **CPU :** 2 cores minimum pour Metasploit/Hashcat

### Légalité

⚠️ **IMPORTANT :** Kali Linux contient des outils de hacking.

**Usage autorisé :**
- ✅ Tests sur tes propres systèmes
- ✅ Pentests avec contrat/autorisation écrite
- ✅ Labs/environnements de test
- ✅ Formation/éducation

**Usage interdit :**
- ❌ Scans non autorisés
- ❌ Attaques sur systèmes tiers
- ❌ Hacking illégal

**Responsabilité :** Tu es responsable de l'usage que tu fais de ces outils.

---

## 🔗 Ressources

**Documentation officielle Kali :**
- https://www.kali.org/docs/
- https://www.kali.org/docs/containers/
- https://www.kali.org/tools/

**Docker Hub :**
- https://hub.docker.com/r/kalilinux/kali-rolling

**Formation :**
- Offensive Security (créateurs de Kali)
- HackTheBox, TryHackMe (labs de pratique)

---

**Déployé le :** 20 février 2026  
**Version Kali :** 2025.4 Rolling  
**Localisation :** `/opt/kali/` (VPS 54.37.157.8)
