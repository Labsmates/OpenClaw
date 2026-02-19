# OpenClaw Configuration

Configuration publique pour **Axel**, assistant IA personnel construit avec [OpenClaw](https://openclaw.ai).

## 📋 À propos

Ce repository contient la configuration complète d'un assistant IA personnel :
- Personnalité et comportement (SOUL.md)
- Gestion de la mémoire et contexte (AGENTS.md)
- Automatisation quotidienne (HEARTBEAT.md)
- Documentation des outils configurés (TOOLS.md)

## 🔐 Sécurité

Cette configuration est **nettoyée de tous les secrets** :
- Pas de tokens API
- Pas d'emails personnels
- Pas de numéros de téléphone
- Pas d'identifiants Telegram

## 🚀 Utilisation

Pour utiliser cette configuration avec votre propre instance OpenClaw :

1. Clonez ce repo dans votre workspace OpenClaw
2. Adaptez les fichiers à votre situation :
   - `USER.md` - Informations sur vous
   - `IDENTITY.md` - Personnalité de votre assistant
   - `TOOLS.md` - Vos outils et credentials (gardez-les privés !)
3. Configurez vos propres tokens et API keys

## 📁 Structure

```
.
├── AGENTS.md       # Guide de fonctionnement de l'assistant
├── SOUL.md         # Personnalité et philosophie
├── IDENTITY.md     # Identité de l'assistant
├── USER.md         # Profil utilisateur (générique)
├── HEARTBEAT.md    # Jobs automatiques quotidiens
├── TOOLS.md        # Documentation des outils (secrets retirés)
└── MEMORY.md       # Système de mémoire long-terme
```

## 🛠️ Outils configurés

- **Gmail** (via Himalaya CLI)
- **ElevenLabs TTS** (voix : Roger, Sarah, Charlie, George)
- **GitHub** (via gh CLI)
- **Philips Hue** (via openhue)

## 📚 Ressources

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [Discord Community](https://discord.com/invite/clawd)
- [Skills Hub](https://clawhub.com)

## 📝 License

MIT - Adaptez et utilisez librement !

---

**Mise à jour automatique** : Ce repo est synchronisé automatiquement avec la configuration active.
