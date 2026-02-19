# 🔄 Auto-Synchronisation GitHub

Ce repository est **automatiquement synchronisé** avec la configuration active d'OpenClaw.

## Comment ça fonctionne

1. **Modifications détectées** : Lorsque des fichiers de configuration sont modifiés (AGENTS.md, SOUL.md, TOOLS.md, etc.)
2. **Nettoyage automatique** : Tous les secrets sont retirés avant publication :
   - Tokens API (ElevenLabs, GitHub, etc.)
   - Emails personnels
   - Numéros de téléphone
   - Identifiants Telegram
3. **Push automatique** : Les fichiers nettoyés sont poussés sur GitHub

## Fichiers synchronisés

✅ **Publiés (nettoyés) :**
- AGENTS.md
- SOUL.md
- TOOLS.md
- USER.md
- IDENTITY.md
- HEARTBEAT.md
- MEMORY.md
- README.md

❌ **Exclus (privés) :**
- `*-state.json` (état des jobs)
- `memory/` (notes quotidiennes)
- `*.pdf` (rapports générés)
- Scripts contenant des credentials
- Fichiers de configuration bruts

## Script de synchronisation

Le script `/tmp/openclaw-repo/sync-config.sh` :
1. Copie les fichiers depuis `/app/workspace`
2. Nettoie tous les secrets avec `sed`
3. Commit les changements
4. Push vers GitHub

## Sécurité

**Aucun secret n'est jamais publié** grâce à :
- Nettoyage automatique par regex
- `.gitignore` robuste
- Revue manuelle possible avant chaque push

## Utilisation manuelle

Si vous voulez forcer une synchronisation :

```bash
/app/workspace/sync-to-github.sh
```

---

**Dernière mise à jour :** 2026-02-19
