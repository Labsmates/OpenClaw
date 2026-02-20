# 🚀 Guide d'Installation : Workflows YouTube → Telegram

## ✅ Prérequis

Avant de commencer, assure-toi d'avoir :

### 1. Token Telegram Bot
- [ ] Tu as le token de ton bot Telegram
- [ ] Format : `1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`

### 2. Clé API OpenRouter (pour version IA)
- [ ] Créer un compte : https://openrouter.ai/auth?sign_up=true
- [ ] Aller dans **Keys** → **Create Key**
- [ ] Ajouter $5 de crédits minimum
- [ ] Copier la clé : `sk_or_v1_...`

---

## 📦 Configuration Hybride (Recommandée)

Tu vas installer 2 workflows :
1. **Workflow Simple** → 23 chaînes (gratuit)
2. **Workflow IA** → 5 chaînes VIP (avec résumés intelligents)

**Coût total : ~$0.50/mois**

---

## 🔧 Étape 1 : Configuration des Variables n8n

1. Va sur : https://node8.connectika.fr
2. Connecte-toi
3. Clique sur **Settings** (⚙️) en haut à droite
4. Clique sur **Variables** dans le menu
5. Ajoute ces 2 variables :

### Variable 1 : TELEGRAM_BOT_TOKEN
```
Name: TELEGRAM_BOT_TOKEN
Value: [TON_TOKEN_TELEGRAM]
```
*Remplace `[TON_TOKEN_TELEGRAM]` par ton vrai token*

### Variable 2 : OPENROUTER_API_KEY
```
Name: OPENROUTER_API_KEY
Value: [TA_CLE_OPENROUTER]
```
*Remplace `[TA_CLE_OPENROUTER]` par ta vraie clé (sk_or_v1_...)*

6. Clique sur **Save** pour chaque variable

---

## 📥 Étape 2 : Importer le Workflow Simple

1. Dans n8n, clique sur **Workflows** (en haut à gauche)
2. Clique sur **Add Workflow** → **Import from File**
3. Dans la fenêtre qui s'ouvre, colle ce chemin :
   ```
   /app/workspace/youtube-telegram-workflow.json
   ```
4. OU clique sur **Browse** et navigue vers ce fichier
5. Clique sur **Import**
6. Le workflow apparaît avec 14 nodes

### Configuration du Workflow Simple

1. Vérifie le node **"Cron 12h & 20h"** (premier node)
   - Il doit être configuré sur `triggerAtHour: 12` et `20`
   - Timezone : UTC (Paris = UTC+1, donc 12h Paris = 11h UTC)
   
2. Vérifie le node **"Send to Telegram"**
   - `chat_id` doit être `8481398125`

3. **Active le workflow** : Toggle en haut à droite (OFF → ON)

4. **Teste-le** : Clique sur **Execute Workflow** (▶️)

5. Vérifie ton Telegram → Tu devrais recevoir les nouvelles vidéos !

---

## 📥 Étape 3 : Importer le Workflow IA (VIP)

1. Dans n8n, clique sur **Workflows** → **Add Workflow** → **Import from File**
2. Colle ce chemin :
   ```
   /app/workspace/youtube-telegram-ai-workflow.json
   ```
3. Clique sur **Import**
4. Le workflow apparaît avec 14 nodes (version IA)

### Configuration du Workflow IA

1. Vérifie le node **"Load VIP State File"**
   - `filePath` doit être `/app/workspace/youtube-monitor-vip-state.json`

2. Vérifie le node **"AI Analysis (Claude)"**
   - URL : `https://openrouter.ai/api/v1/chat/completions`
   - Header : `Authorization: Bearer {{ $vars.OPENROUTER_API_KEY }}`
   - Modèle : `anthropic/claude-3.5-sonnet`

3. Vérifie le node **"Send to Telegram"**
   - `chat_id` doit être `8481398125`

4. **Active le workflow** : Toggle en haut à droite (OFF → ON)

5. **Teste-le** : Clique sur **Execute Workflow** (▶️)

6. Vérifie ton Telegram → Les vidéos VIP doivent avoir des résumés IA ! 🤖

---

## 🎯 Chaînes surveillées

### Workflow Simple (23 chaînes)
Toutes les chaînes dans `youtube-monitor-state.json`

### Workflow IA VIP (5 chaînes)
- Vision IA (UCyc03X3uRuxM9n7fyRH_gIw)
- Dr. Firas (UCriIQI8uaoEro5FEnOpeidQ)
- Renaud Dékode (UCOWu-2h4IpoEjhsRlTuesFg)
- Et 2 autres chaînes tech/IA importantes

---

## 🕐 Planning d'exécution

Les deux workflows se déclenchent automatiquement :
- **12h00** (Paris) → Surveillance + envoi nouvelles vidéos
- **20h00** (Paris) → Surveillance + envoi nouvelles vidéos

**Note :** Les horaires sont en UTC dans n8n. Si besoin d'ajuster :
- Paris (UTC+1) : 12h Paris = 11h UTC
- Modifier dans le node **"Cron 12h & 20h"**

---

## ✅ Vérification

### Test Workflow Simple
1. Execute Workflow (▶️)
2. Regarde les logs de chaque node (clic sur le node)
3. Vérifie **"Parse & Filter Videos"** → combien de vidéos trouvées ?
4. Vérifie **"Send to Telegram"** → status `ok: true` ?
5. Check Telegram → Messages reçus ?

### Test Workflow IA
1. Execute Workflow (▶️)
2. Vérifie **"AI Analysis (Claude)"** → Réponse IA reçue ?
3. Vérifie **"Format Enhanced Message"** → Message formaté correctement ?
4. Vérifie **"Send to Telegram"** → status `ok: true` ?
5. Check Telegram → Messages avec résumés IA reçus ?

---

## 🐛 Dépannage

### Erreur : "Variable TELEGRAM_BOT_TOKEN not found"
→ Tu n'as pas créé la variable dans **Settings → Variables**

### Erreur : "Variable OPENROUTER_API_KEY not found"
→ Tu n'as pas créé la variable OpenRouter

### Erreur : "Unauthorized" (OpenRouter)
→ Clé API invalide ou pas de crédits

### Erreur : "File not found" (youtube-monitor-state.json)
→ Le fichier state n'existe pas. Vérifie le chemin :
```bash
ls -la /app/workspace/youtube-monitor*.json
```

### Aucune vidéo envoyée
→ Toutes les vidéos sont peut-être déjà dans `sent_videos`
→ Vide le tableau `sent_videos` dans le state file pour retester

### Vidéos envoyées en double
→ Les deux workflows utilisent des state files séparés :
- Simple : `youtube-monitor-state.json`
- IA VIP : `youtube-monitor-vip-state.json`
→ Normal si une même vidéo apparaît dans les deux (différents formats)

---

## 📊 Monitoring

### Voir l'historique des exécutions
1. Dans n8n, clique sur **Executions** (menu gauche)
2. Voir toutes les exécutions passées
3. Cliquer sur une exécution pour voir les détails

### Surveiller les coûts OpenRouter
1. Va sur https://openrouter.ai/activity
2. Voir l'utilisation par modèle
3. Budget restant affiché en haut

---

## 🎨 Personnalisation

### Ajouter/Retirer des chaînes

**Workflow Simple (toutes les chaînes) :**
1. Édite `/app/workspace/youtube-monitor-state.json`
2. Ajoute/retire des IDs dans `"channels": [...]`
3. Redémarre le workflow

**Workflow IA (chaînes VIP) :**
1. Édite `/app/workspace/youtube-monitor-vip-state.json`
2. Ajoute/retire des IDs dans `"channels": [...]`
3. Redémarre le workflow

### Changer les horaires
1. Ouvre le workflow dans n8n
2. Clique sur le node **"Cron 12h & 20h"**
3. Modifie `triggerAtHour` : 12, 20 → autres heures
4. Save

### Changer le modèle IA (économiser)
1. Ouvre le workflow IA
2. Node **"AI Analysis (Claude)"**
3. Remplace :
   ```json
   "model": "anthropic/claude-3-haiku"
   ```
   **Économie : ~90%** | Qualité : légèrement inférieure

---

## ✨ Prochaines étapes

Une fois les workflows actifs :
1. **Laisse tourner 2-3 jours** pour tester
2. **Surveille les coûts** OpenRouter (devrait être <$1)
3. **Ajuste** si besoin (chaînes, horaires, modèle)
4. **Désactive HEARTBEAT.md YouTube** (optionnel)
   - Les workflows n8n sont plus fiables que les heartbeats

---

## 📞 Besoin d'aide ?

Si un workflow ne fonctionne pas :
1. **Check les logs** dans n8n (Executions)
2. **Vérifie les variables** (Settings → Variables)
3. **Teste manuellement** (Execute Workflow)
4. **Demande-moi** si bloqué 😊

---

**Installation créée le :** 20 février 2026  
**Version :** 1.0 Hybride  
**Fichiers utilisés :**
- `youtube-telegram-workflow.json` (Simple)
- `youtube-telegram-ai-workflow.json` (IA VIP)
- `youtube-monitor-state.json` (23 chaînes)
- `youtube-monitor-vip-state.json` (5 chaînes VIP)
