# 🤖 Workflow YouTube → Telegram AI Enhanced (n8n + OpenRouter)

## 📋 Description

Version **améliorée par IA** du workflow YouTube qui utilise **Claude 3.5 Sonnet** (via OpenRouter) pour générer des résumés intelligents et engageants.

---

## 🆚 Comparaison : Version Simple vs Version IA

| Critère | Version Simple | Version IA Enhanced |
|---------|---------------|---------------------|
| **Vitesse** | ⚡ Très rapide (~2s/chaîne) | 🐢 Plus lent (~5-8s/chaîne) |
| **Coût** | 💰 Gratuit | 💸 ~0.003$/vidéo (Claude) |
| **Message** | 📝 Template fixe | 🎨 Résumé personnalisé IA |
| **Qualité** | ✅ Fiable | ✨ Plus engageant |
| **Emojis** | 🎬 Fixes | 😊 Contextuels |
| **Résumé** | ❌ Aucun | ✅ Analyse du contenu |
| **Rate limit** | ✅ Aucun | ⚠️ OpenRouter limits |

---

## 🎯 Exemple de sortie

### Version Simple
```
🎬 **Le Chef de la Sécurité d'Anthropic DÉMISSIONNE et Part Écrire de la Poésie**
👤 Vision IA • 📅 Il y a aujourd'hui
https://www.youtube.com/watch?v=oK2vU_Ws8Y0
```

### Version IA Enhanced
```
🚨 Le responsable de la sécurité d'Anthropic quitte l'entreprise pour se consacrer à la poésie — un départ surprenant qui soulève des questions sur la stratégie de l'entreprise en matière d'IA.

👤 Vision IA • 📅 aujourd'hui
🔗 https://www.youtube.com/watch?v=oK2vU_Ws8Y0
```

---

## 🚀 Installation

### 1. Prérequis

#### Variables d'environnement n8n

Ajouter dans **Settings → Variables** :

```
OPENROUTER_API_KEY = sk_or_v1_...
TELEGRAM_BOT_TOKEN = <votre_token>
```

**Obtenir une clé OpenRouter :**
1. Créer un compte sur https://openrouter.ai
2. Aller dans **Keys** → **Create Key**
3. Copier la clé (commence par `sk_or_v1_`)
4. Ajouter des crédits (minimum $5)

### 2. Importer le workflow

1. Ouvrir n8n : https://node8.connectika.fr
2. **Workflows** → **Import from File**
3. Sélectionner : `/app/workspace/youtube-telegram-ai-workflow.json`
4. **Import**

### 3. Vérifier la configuration

Dans le node **"AI Analysis (Claude)"** :
- Vérifier que `OPENROUTER_API_KEY` est bien référencée
- Modèle utilisé : `anthropic/claude-3.5-sonnet`
- Temperature : `0.7` (créatif mais cohérent)
- Max tokens : `150` (résumé court)

---

## 🧠 Prompt IA utilisé

```
Analyse cette vidéo YouTube et génère un message Telegram engageant.

Titre: [titre]
Chaîne: [chaîne]
Description: [description]

Génère un message court (2-3 lignes max) qui:
- Résume le contenu principal
- Utilise 1-2 emojis pertinents
- Donne envie de cliquer
- Reste naturel et concis

Format attendu:
[emoji] [Résumé en 1-2 phrases courtes]

Réponds UNIQUEMENT avec le message, sans explication.
```

---

## 📊 Architecture du workflow

**Différences avec la version simple :**

```
...
Parse & Filter Videos
       │
       v
┌──────────────────────┐
│ AI Analysis (Claude) │  ← NOUVEAU : Analyse IA
└──────────┬───────────┘
           │
           v
┌──────────────────────┐
│Format Enhanced Msg   │  ← Combine IA + métadonnées
└──────────┬───────────┘
           │
           v
    Send to Telegram
    ...
```

**Node ajouté :**
- **AI Analysis (Claude)** : Appel HTTP POST vers OpenRouter
  - Envoie titre + description
  - Reçoit résumé personnalisé
  - Timeout : 30 secondes

---

## 💰 Estimation des coûts

**Modèle :** Claude 3.5 Sonnet  
**Tarif OpenRouter :**
- Input : $3/1M tokens (~$0.000003/token)
- Output : $15/1M tokens (~$0.000015/token)

**Estimation par vidéo :**
- Input : ~200 tokens (titre + description + prompt)
- Output : ~50 tokens (résumé)
- **Coût total : ~$0.0015/vidéo**

**Coût mensuel estimé (60 vidéos/jour) :**
- 60 vidéos × 30 jours = 1800 vidéos/mois
- **~$2.70/mois**

**Alternative économique :**
- Utiliser `anthropic/claude-3-haiku` : ~10× moins cher
- Modifier le workflow : `"model": "anthropic/claude-3-haiku"`

---

## 🔧 Optimisations possibles

### 1. Utiliser Claude Haiku (économique)

Dans le node **"AI Analysis"**, remplacer :
```json
"model": "anthropic/claude-3-haiku"
```
**Économie : ~90%** | Qualité : légèrement inférieure

### 2. Batch processing (réduire les appels API)

Au lieu d'analyser vidéo par vidéo, grouper par 3-5 vidéos :
- Modifier le node **"Loop Channels"** : `batchSize: 5`
- Adapter le prompt pour analyser plusieurs vidéos

### 3. Cache des résumés

Stocker les résumés générés dans un fichier JSON :
- Évite de ré-analyser la même vidéo
- Utile si le workflow crash et redémarre

---

## 🧪 Test manuel

1. Ouvrir le workflow dans n8n
2. **Execute Workflow** (play button)
3. Vérifier les logs :
   - Node **"AI Analysis"** : voir la réponse Claude
   - Node **"Format Enhanced Message"** : message final
4. Vérifier Telegram

**Exemple de log attendu :**
```json
{
  "choices": [{
    "message": {
      "content": "🚨 Le responsable de la sécurité d'Anthropic..."
    }
  }]
}
```

---

## 🐛 Dépannage

### Erreur OpenRouter 401 (Unauthorized)

- Vérifier que `OPENROUTER_API_KEY` est bien configurée
- Vérifier que la clé commence par `sk_or_v1_`
- Vérifier que le compte a des crédits

### Erreur OpenRouter 429 (Rate Limit)

- Trop de requêtes simultanées
- Solution : Réduire `batchSize` dans le loop
- Ou ajouter un délai entre les appels (node **Wait**)

### Résumés IA incohérents

- Vérifier que la description YouTube n'est pas vide
- Ajuster `temperature` (0.5 = plus déterministe)
- Améliorer le prompt avec des exemples

### Timeout (30s dépassé)

- OpenRouter peut être lent aux heures de pointe
- Augmenter timeout : `"timeout": 60000` (60s)

---

## 📈 Monitoring

### Vérifier les coûts OpenRouter

1. Aller sur https://openrouter.ai/activity
2. Voir l'utilisation par modèle
3. Surveiller le budget restant

### Logs n8n

- Chaque exécution est loggée
- Voir **Executions** → **Details** pour les erreurs
- Temps d'exécution total affiché

---

## 🔄 Quelle version choisir ?

### Utilise la **version simple** si :
- ✅ Tu veux un système fiable et rapide
- ✅ Tu surveilles beaucoup de chaînes (>50)
- ✅ Les messages basiques te suffisent
- ✅ Tu veux 0 coût

### Utilise la **version IA** si :
- ✅ Tu veux des messages engageants
- ✅ Tu surveilles <30 chaînes
- ✅ Tu as un budget OpenRouter (~$3/mois)
- ✅ Tu veux des résumés intelligents

### Hybride (recommandé) :
- Version simple en production (12h & 20h)
- Version IA pour des chaînes VIP sélectionnées
- Créer un 2e workflow IA pour 3-5 chaînes prioritaires

---

## 🎨 Personnalisation du prompt

Le prompt actuel génère des résumés **neutres et informatifs**.

### Pour des messages plus **punchy** :
```
Génère un message viral pour cette vidéo YouTube.
Utilise un ton excitant, 2-3 emojis, et une phrase choc.
```

### Pour des messages plus **techniques** :
```
Résume cette vidéo YouTube pour un public technique.
Mets en avant les concepts clés, technologies, et innovations.
```

### Pour des messages **humoristiques** :
```
Résume cette vidéo avec un ton léger et une touche d'humour.
Reste concis mais amusant.
```

Modifier dans le node **"AI Analysis (Claude)"** → `jsonBody` → `content`

---

## 📝 Notes

- **Modèle recommandé** : Claude 3.5 Sonnet (meilleur ratio qualité/prix)
- **Alternative gratuite** : Pas d'OpenRouter = utiliser version simple
- **Fallback** : Si OpenRouter down, logger l'erreur et utiliser template fixe

---

**Créé le :** 20 février 2026  
**Version :** 1.0 AI Enhanced  
**Compatibilité :** n8n v1.0+ | OpenRouter API v1
