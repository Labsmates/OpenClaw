# 🎬 Workflow YouTube → Telegram Auto (n8n)

## 📋 Description

Workflow n8n qui surveille automatiquement 23 chaînes YouTube et envoie les nouvelles vidéos sur Telegram.

**Fonctionnalités :**
- ✅ Déclenché automatiquement à 12h et 20h (Paris)
- ✅ Surveille 23 chaînes YouTube via RSS
- ✅ Filtre les shorts (#shorts)
- ✅ Filtre les vidéos de plus de 3 jours
- ✅ Évite les doublons (state file)
- ✅ Envoie formaté sur Telegram

---

## 🚀 Installation

### 1. Importer le workflow

1. Ouvrir n8n : https://node8.connectika.fr
2. Cliquer sur **"Workflows"** → **"Import from File"**
3. Sélectionner : `/app/workspace/youtube-telegram-workflow.json`
4. Cliquer sur **"Import"**

### 2. Configuration requise

#### Variables d'environnement n8n

Ajouter dans les **Settings → Variables** de n8n :

```
TELEGRAM_BOT_TOKEN = <votre_token_bot>
```

*Remplacer par le token réel du bot Telegram.*

#### Fichiers requis

- **State file** : `/app/workspace/youtube-monitor-state.json` (déjà existant)
- **Liste des chaînes** : Déjà configurée dans le state file (23 chaînes)

---

## 🔧 Modifications possibles

### Changer l'heure de déclenchement

Dans le node **"Cron 12h & 20h"** :
- Modifier `triggerAtHour: 12` → autre heure
- Ajouter/supprimer des intervalles

### Changer le destinataire Telegram

Dans le node **"Send to Telegram"** :
- Modifier `chat_id: 8481398125` → autre ID

### Ajuster le filtre d'âge

Dans le node **"Parse & Filter Videos"** :
- Ligne `const maxAgeDays = 3;` → changer à 1, 7, etc.

---

## 📊 Fonctionnement

```
┌──────────────┐
│ Cron Trigger │  (12h & 20h Paris)
└──────┬───────┘
       │
       v
┌──────────────┐
│  Load State  │  (youtube-monitor-state.json)
└──────┬───────┘
       │
       v
┌──────────────┐
│ Parse State  │  (Extrait channels + sent_videos)
└──────┬───────┘
       │
       v
┌──────────────┐
│Loop Channels │  (Pour chaque chaîne)
└──────┬───────┘
       │
       v
┌──────────────┐
│ Fetch RSS    │  (YouTube RSS feed)
└──────┬───────┘
       │
       v
┌──────────────┐
│Parse & Filter│  (Filtre shorts, âge, doublons)
└──────┬───────┘
       │
       v
┌──────────────┐
│Format Message│  (Crée le message Telegram)
└──────┬───────┘
       │
       v
┌──────────────┐
│Send Telegram │  (Envoie via API Telegram)
└──────┬───────┘
       │
       v
┌──────────────┐
│ Update State │  (Ajoute IDs envoyés)
└──────┬───────┘
       │
       v
┌──────────────┐
│ Save State   │  (Sauvegarde JSON)
└──────────────┘
```

---

## 🧪 Test manuel

1. Ouvrir le workflow dans n8n
2. Cliquer sur **"Execute Workflow"** (bouton play)
3. Vérifier les résultats dans les logs
4. Vérifier Telegram pour les messages

---

## 🐛 Dépannage

### Aucune vidéo envoyée

- Vérifier que le state file contient bien les chaînes
- Vérifier que les vidéos ne sont pas déjà dans `sent_videos`
- Vérifier l'âge des vidéos (max 3 jours)

### Erreur Telegram

- Vérifier que `TELEGRAM_BOT_TOKEN` est configuré
- Vérifier que le `chat_id` est correct
- Vérifier que le bot a accès au chat

### Erreur RSS YouTube

- YouTube RSS peut être temporairement indisponible
- Timeout configuré à 10 secondes par chaîne

---

## 📝 Notes

- **Pas besoin d'OpenRouter/LLM** pour ce workflow (simple parsing XML/RSS)
- **Léger et rapide** : ~2-3 secondes par chaîne
- **State file partagé** avec le script Python actuel
- **Compatible** avec le système de heartbeat existant

---

## 🔄 Intégration avec HEARTBEAT.md

Ce workflow **remplace** les tâches YouTube du HEARTBEAT.md :
- ✅ Plus fiable (cron exact vs heartbeat ~30min)
- ✅ Plus performant (n8n dédié)
- ✅ Moins de charge sur l'agent principal

Vous pouvez **retirer** les sections YouTube de HEARTBEAT.md après avoir activé ce workflow.

---

**Créé le :** 20 février 2026  
**Version :** 1.0  
**Compatibilité :** n8n v1.0+
