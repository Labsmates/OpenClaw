# ✅ Checklist Installation Workflows YouTube

## 📋 Avant de commencer

- [ ] J'ai mon token Telegram Bot
- [ ] J'ai créé un compte OpenRouter
- [ ] J'ai ajouté $5 de crédits sur OpenRouter
- [ ] J'ai copié ma clé API OpenRouter (sk_or_v1_...)
- [ ] J'ai accès à n8n : https://node8.connectika.fr

---

## 🔧 Configuration n8n (5 min)

### Variables à créer

Dans n8n → **Settings** → **Variables** :

- [ ] Variable 1 créée : `TELEGRAM_BOT_TOKEN`
- [ ] Variable 2 créée : `OPENROUTER_API_KEY`
- [ ] Les 2 variables sont **sauvegardées**

---

## 📥 Import Workflow Simple (2 min)

- [ ] **Workflows** → **Import from File**
- [ ] Fichier : `/app/workspace/youtube-telegram-workflow.json`
- [ ] Workflow importé (14 nodes visibles)
- [ ] Node "Cron 12h & 20h" vérifié
- [ ] Node "Send to Telegram" vérifié (chat_id = 8481398125)
- [ ] Workflow **activé** (toggle ON)
- [ ] **Test manuel** : Execute Workflow ▶️
- [ ] ✅ Messages reçus sur Telegram

---

## 📥 Import Workflow IA VIP (3 min)

- [ ] **Workflows** → **Import from File**
- [ ] Fichier : `/app/workspace/youtube-telegram-ai-workflow.json`
- [ ] Workflow importé (14 nodes visibles)
- [ ] Node "Load VIP State File" vérifie (vip-state.json)
- [ ] Node "AI Analysis" vérifié (OpenRouter configuré)
- [ ] Node "Send to Telegram" vérifié (chat_id = 8481398125)
- [ ] Workflow **activé** (toggle ON)
- [ ] **Test manuel** : Execute Workflow ▶️
- [ ] ✅ Messages avec résumés IA reçus sur Telegram

---

## 🎯 Vérification finale (2 min)

- [ ] Les 2 workflows sont **actifs** (toggle ON)
- [ ] Horaires configurés : 12h & 20h
- [ ] State files existent :
  - `/app/workspace/youtube-monitor-state.json` (23 chaînes)
  - `/app/workspace/youtube-monitor-vip-state.json` (5 chaînes)
- [ ] Logs n8n : pas d'erreurs
- [ ] Telegram : messages bien reçus

---

## 📊 Monitoring (optionnel)

- [ ] OpenRouter activity : https://openrouter.ai/activity
- [ ] n8n Executions : historique visible
- [ ] Coût estimé après 24h : ~$0.02

---

## ✨ Prochaines étapes

- [ ] Laisser tourner 2-3 jours
- [ ] Surveiller les coûts OpenRouter
- [ ] Ajuster si besoin (chaînes, horaires, modèle)
- [ ] (Optionnel) Désactiver YouTube dans HEARTBEAT.md

---

## 🚨 Si problème

1. Check **Settings → Variables** (tokens présents ?)
2. Check **Executions** (erreurs dans les logs ?)
3. Check OpenRouter (crédits restants ?)
4. Demande-moi ! 😊

---

**Total temps d'installation : ~15 minutes**  
**Difficulté : ⭐⭐☆☆☆ (facile)**
