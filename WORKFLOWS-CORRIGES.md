# ✅ Workflows YouTube Corrigés (avec OpenRouter & connexions)

## 🎯 Ce qui a été corrigé

### Problèmes des workflows originaux
❌ Utilisation de simples HTTP requests au lieu d'un agent IA  
❌ Connexions entre nodes incomplètes ou incorrectes  
❌ Pas de validation des paramètres  
❌ Nodes Telegram mal configurés (credentials manquantes)  
❌ Nodes File read/write incorrects  

### Solutions appliquées (selon N8N.md)
✅ **Agent IA OpenRouter** : Utilisation du node `@n8n/n8n-nodes-langchain.lmChatOpenAi`  
✅ **Connexions complètes** : Tous les nodes connectés dans le bon ordre  
✅ **Paramètres explicites** : TOUS les paramètres définis (never trust defaults)  
✅ **Nodes Telegram** : Utilisation du node natif `n8n-nodes-base.telegram`  
✅ **File operations** : `readBinaryFiles` et `writeFile` correctement configurés  
✅ **Code nodes** : Parsing correct avec gestion des erreurs  

---

## 📦 Fichiers créés

### 1. Workflow Simple (gratuit, rapide)
**Fichier :** `youtube-telegram-simple-correct.json`  
**Nodes :** 11 nodes  
**Type :** Sans IA, messages template fixe  
**State file :** `/app/workspace/youtube-monitor-state.json` (23 chaînes)  

### 2. Workflow IA (avec OpenRouter)
**Fichier :** `youtube-telegram-ai-correct.json`  
**Nodes :** 12 nodes  
**Type :** Avec agent IA OpenRouter pour résumés intelligents  
**State file :** `/app/workspace/youtube-monitor-vip-state.json` (5 chaînes VIP)  

---

## 🏗️ Architecture des workflows corrigés

### Workflow Simple
```
Schedule Every 12h (scheduleTrigger)
  ↓
Load State File (readBinaryFiles)
  ↓
Parse State (code) - Extrait channels + sent_videos
  ↓
Loop Channels (splitInBatches)
  ↓
Fetch YouTube RSS (httpRequest)
  ↓
Parse & Filter Videos (code) - Filtre shorts, âge, doublons
  ↓
Format Telegram Message (code) - Template fixe
  ↓
Send to Telegram (telegram) - Node natif Telegram
  ↓
Check if Sent (if)
  ↓
Update State (code) - Merge sent_videos
  ↓
Save State File (writeFile)
```

### Workflow IA (OpenRouter)
```
Schedule Every 12h (scheduleTrigger)
  ↓
Load VIP State (readBinaryFiles)
  ↓
Parse State (code)
  ↓
Loop Channels (splitInBatches)
  ↓
Fetch YouTube RSS (httpRequest)
  ↓
Parse & Filter Videos (code) - Avec description extraite
  ↓
AI Analyze (OpenRouter) - Agent IA @n8n/n8n-nodes-langchain.lmChatOpenAi
  ↓
Format Enhanced Message (code) - Combine résumé IA + metadata
  ↓
Send to Telegram (telegram)
  ↓
Check if Sent (if)
  ↓
Update State (code)
  ↓
Save VIP State (writeFile)
```

---

## 🔧 Configuration requise

### Credentials n8n à créer

#### 1. Telegram Bot API
**Type :** `telegramApi`  
**Name :** `Telegram Bot`  
**Access Token :** Ton token bot Telegram

#### 2. OpenRouter API (pour workflow IA)
**Type :** `httpHeaderAuth`  
**Name :** `OpenRouter API`  
**Header Name :** `Authorization`  
**Header Value :** `Bearer sk_or_v1_...` (ta clé OpenRouter)

#### 3. Variables n8n (optionnelles)
- `TELEGRAM_BOT_TOKEN` - Token bot (si tu veux utiliser variables)
- `OPENROUTER_API_KEY` - Clé OpenRouter

---

## 📥 Import manuel dans n8n

### Étape 1 : Prépare les credentials

1. Va sur https://node8.connectika.fr
2. **Settings** → **Credentials**
3. **New Credential** → **Telegram API**
   - Name : `Telegram Bot`
   - Access Token : [TON_TOKEN]
   - Save
4. **New Credential** → **HTTP Header Auth**
   - Name : `OpenRouter API`
   - Name : `Authorization`
   - Value : `Bearer [TA_CLE_OPENROUTER]`
   - Save

### Étape 2 : Import Workflow Simple

1. **Workflows** → **Add Workflow**
2. Clique sur **⋮** (3 points) → **Import from File**
3. Sélectionne `/app/workspace/youtube-telegram-simple-correct.json`
4. **Import**
5. Le workflow apparaît avec 11 nodes
6. Vérifie le node **"Send to Telegram"** :
   - Credential : Sélectionne `Telegram Bot`
7. **Save**

### Étape 3 : Import Workflow IA

1. **Workflows** → **Add Workflow**
2. **Import from File**
3. Sélectionne `/app/workspace/youtube-telegram-ai-correct.json`
4. **Import**
5. Le workflow apparaît avec 12 nodes
6. Configure 2 nodes :
   - **"AI Analyze (OpenRouter)"** :
     - Credential : Sélectionne `OpenRouter API`
     - Model : `anthropic/claude-3.5-sonnet`
     - Base URL : `https://openrouter.ai/api/v1`
   - **"Send to Telegram"** :
     - Credential : Sélectionne `Telegram Bot`
7. **Save**

---

## ✅ Validation après import

### Test Workflow Simple
1. Ouvre le workflow
2. Clique **Execute Workflow** (▶️)
3. Vérifie chaque node :
   - ✅ **Parse State** : Channels et sent_videos chargés
   - ✅ **Loop Channels** : 23 items (ou 5 pour VIP)
   - ✅ **Fetch YouTube RSS** : XML reçu
   - ✅ **Parse & Filter Videos** : Vidéos extraites
   - ✅ **Send to Telegram** : Messages envoyés
4. Check Telegram → Messages reçus ?

### Test Workflow IA
1. Ouvre le workflow IA
2. **Execute Workflow** (▶️)
3. Vérifie nodes supplémentaires :
   - ✅ **AI Analyze** : Résumé IA généré
   - ✅ **Format Enhanced Message** : Message avec résumé
4. Check Telegram → Messages avec résumés IA reçus ?

---

## 🎯 Différences clés vs anciens workflows

| Aspect | Ancien (incorrect) | Nouveau (corrigé) |
|--------|-------------------|------------------|
| **IA** | HTTP POST basique | Node LangChain Chat OpenAI |
| **Telegram** | HTTP POST manual | Node Telegram natif |
| **Connexions** | Incomplètes | Toutes définies |
| **File read** | readBinaryFile | readBinaryFiles (correct) |
| **Paramètres** | Defaults utilisés | TOUS explicites |
| **Validation** | Aucune | Multi-niveaux |
| **Credentials** | Hardcodées | Credentials n8n |

---

## 🚀 Activation des workflows

Une fois importés et testés :

1. Ouvre chaque workflow
2. Toggle **Active** (OFF → ON) en haut à droite
3. **Save**
4. Les workflows se déclenchent automatiquement toutes les 12h

**Horaires :** 
- Workflow lancé toutes les 12h (à partir du moment d'activation)
- Pour définir des horaires précis (12h00, 20h00), change le trigger :
  - Ouvre le node **"Schedule Every 12h"**
  - Change de `hoursInterval: 12` à `triggerAtHour: 12` et `triggerAtHour: 20`

---

## 📊 Monitoring

### Voir les exécutions
1. **Executions** (menu gauche)
2. Voir toutes les exécutions passées
3. Cliquer sur une exécution pour détails

### Logs
Chaque node montre :
- Input data
- Output data
- Execution time
- Erreurs éventuelles

---

## 🐛 Troubleshooting

### Erreur "Credential not found"
→ Tu n'as pas créé les credentials Telegram/OpenRouter

### Erreur "File not found"
→ Les state files n'existent pas. Crée-les :
```bash
# Sur le VPS ou localement
echo '{"channels": [], "sent_videos": []}' > /app/workspace/youtube-monitor-state.json
echo '{"channels": [], "sent_videos": []}' > /app/workspace/youtube-monitor-vip-state.json
```

### Aucune vidéo envoyée
→ Toutes déjà dans `sent_videos`. Vide le tableau pour retester :
```json
{
  "channels": [...],
  "sent_videos": []
}
```

### Erreur OpenRouter "Unauthorized"
→ Clé API invalide ou pas de crédits

### Node Telegram échoue
→ Vérifie que le bot a accès au chat (envoie `/start` au bot d'abord)

---

## 💡 Optimisations futures

### Réduire les coûts IA
Remplace le modèle dans le node **"AI Analyze"** :
```
anthropic/claude-3-haiku
```
**Économie : ~90%** | Qualité : légèrement inférieure

### Changer les horaires
Node **"Schedule Every 12h"** :
```json
"rule": {
  "interval": [
    {"triggerAtHour": 9},
    {"triggerAtHour": 21}
  ]
}
```

### Ajouter/retirer des chaînes
Édite les state files :
- `youtube-monitor-state.json` (23 chaînes - workflow simple)
- `youtube-monitor-vip-state.json` (5 chaînes - workflow IA)

---

## 📝 Notes

- Les workflows corrigés respectent toutes les bonnes pratiques de **N8N.md**
- Tous les paramètres sont explicitement définis (never trust defaults)
- Connexions entre nodes validées et complètes
- Utilisation de nodes natifs n8n (Telegram, LangChain)
- Credentials séparées (sécurité)
- Code nodes optimisés et commentés

---

**Créé le :** 20 février 2026  
**Version :** 2.0 (corrigé avec N8N.md)  
**Basé sur :** n8n-skills + n8n-mcp best practices
