# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## 📧 Gmail (Himalaya)

**Installé:** ✅ v1.1.0 (Linux x86_64)  
**Location:** `/usr/local/bin/himalaya`  
**Compte:** [VOTRE_EMAIL]  
**Configuration:** `/root/.config/himalaya/config.toml`

**Script simplifié:** `/app/workspace/gmail.sh`

**Utilisation rapide:**
```bash
# Lister les derniers emails
./gmail.sh list 10

# Lire un email
./gmail.sh read 10

# Envoyer un email
./gmail.sh send "dest@example.com" "Sujet" "Message"

# Rechercher
./gmail.sh search "from:google"
```

**Commandes Himalaya avancées:**
```bash
# Lister tous les dossiers
himalaya folder list

# Lister emails dans un dossier spécifique
himalaya envelope list --folder "[Gmail]/Sent Mail"

# Recherche avancée
himalaya envelope list from:example@gmail.com subject:urgent

# Créer un brouillon (ouvre éditeur)
himalaya message write

# Répondre à un email
himalaya message reply 10

# Déplacer vers un dossier
himalaya message move 10 "[Gmail]/Trash"
```

**Notes:**
- App Password configuré (stocké dans config)
- IMAP: imap.gmail.com:993 (TLS)
- SMTP: smtp.gmail.com:587 (STARTTLS)

---

## 🗣️ ElevenLabs TTS (sag)

**Installed:** ✅ v0.2.2 (Linux x86_64)  
**API Key:** Configured in OpenClaw config (`talk.apiKey`)  
**Location:** `/usr/local/bin/sag`

**Voix disponibles:**
- **Roger** (CwhRBWXzGAHq8TQ4Fs17) - Laid-Back, Casual, Resonant
- **Sarah** (EXAVITQu4vr4xnSDxMaL) - Mature, Reassuring, Confident
- **Charlie** (IKne3meq5aSn9XLyUdCD) - Deep, Confident, Energetic
- **George** (JBFqnCBsd6RMkjVDRZzb) - Warm, Captivating Storyteller

**Utilisation:**
```bash
export ELEVENLABS_API_KEY="YOUR_API_KEY_HERE"
sag -v Roger "Ton texte ici"
sag -v Roger -o /tmp/audio.mp3 "Message vocal"
sag voices --limit 20  # Liste toutes les voix
```

**Notes:**
- Modèle par défaut : `eleven_v3` (expressif)
- Tags audio v3 : `[whispers]`, `[shouts]`, `[laughs]`, `[excited]`, etc.
- Pour les pauses : `[pause]`, `[short pause]`, `[long pause]`

---

## 💡 Philips Hue (openhue)

**Installed:** ✅ v0.23 (Linux x86_64)  
**Location:** `/usr/local/bin/openhue`  
**Configuration:** Nécessite setup avec le bridge Hue

**Setup:**
1. Appuyer sur le bouton du bridge Hue
2. Lancer : `openhue setup`
3. Découvrir les bridges : `openhue discover`

**Utilisation:**
```bash
# Lister les lumières
openhue get light --json

# Allumer/éteindre
openhue set light "Bureau" --on
openhue set light "Salon" --off

# Luminosité (0-100)
openhue set light "Chambre" --on --brightness 50

# Couleur
openhue set light "LED Strip" --on --rgb #FF00FF

# Activer une scène
openhue set scene <scene-id>
```

---

## 🐙 GitHub (gh CLI)

**Installé:** ✅  
**Location:** `/usr/bin/gh`  
**Configuration:** `/root/.config/gh/hosts.yml`

**Utilisation rapide:**
```bash
# Statut de l'authentification
gh auth status

# Lister les repos
gh repo list

# Créer un repo
gh repo create mon-projet --public

# Cloner un repo
gh repo clone owner/repo

# Issues
gh issue list
gh issue create --title "Titre" --body "Description"

# Pull Requests
gh pr list
gh pr create --title "Titre" --body "Description"

# Workflows CI/CD
gh run list
gh run view <run-id>

# API GitHub
gh api user
gh api repos/owner/repo/issues
```

**Notes:**
- Token configuré et actif
- Protocole Git : HTTPS

---

Add whatever helps you do your job. This is your cheat sheet.
