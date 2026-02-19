# HEARTBEAT.md - Automatisation Quotidienne

## État des jobs quotidiens

Vérifie l'heure actuelle et lance les jobs quotidiens si nécessaire.

**Système de tracking :** `/app/workspace/daily-jobs-state.json`

---

## Instructions pour chaque heartbeat

1. **Lis l'état actuel** :
   ```bash
   cat /app/workspace/daily-jobs-state.json 2>/dev/null || echo '{}'
   ```

2. **Récupère la date et l'heure** (timezone Europe/[VOTRE_VILLE]) :
   ```bash
   TZ=Europe/[VOTRE_VILLE] date +"%Y-%m-%d %H:%M"
   ```

3. **Vérifie si les jobs doivent être lancés** :

   - **Veille Cybersécurité (9h00-9h30)** :
     - Si l'heure est entre 09:00 et 09:30
     - ET que `veille_cyber_done` n'a pas déjà été lancé aujourd'hui
     - ALORS lance `sessions_spawn` avec la tâche de veille cyber
     - Marque comme fait dans le state file (`veille_cyber_done: true`)

   - **Veille IA (10h00-10h30)** :
     - Si l'heure est entre 10:00 et 10:30
     - ET que `veille_ia_done` n'a pas déjà été lancé aujourd'hui
     - ALORS lance `sessions_spawn` avec la tâche de veille IA
     - Marque comme fait dans le state file (`veille_ia_done: true`)

   - **Check-in vocal (12h00-12h30)** :
     - Si l'heure est entre 12:00 et 12:30
     - ET que `checkin_vocal_done` n'a pas déjà été lancé aujourd'hui
     - ALORS lance `sessions_spawn` avec la tâche de check-in vocal
     - Marque comme fait dans le state file (`checkin_vocal_done: true`)

   - **Surveillance YouTube (12h00-12h30 et 20h00-20h30)** :
     - Si l'heure est entre 12:00 et 12:30 OU entre 20:00 et 20:30
     - ET que le check YouTube n'a pas été fait dans cette plage horaire aujourd'hui
     - ALORS :
       1. Lance `python3 /app/workspace/youtube-check.py` pour récupérer les nouvelles vidéos
       2. Filtre les shorts (titre contient #shorts)
       3. Envoie chaque vidéo sur Telegram avec format :
          ```
          🎬 **[Titre]**
          👤 [Chaîne] • 📅 Il y a [X] jour(s)
          [URL]
          ```
       4. Marque les vidéos comme envoyées dans le state file
     - Utilise `/app/workspace/youtube-monitor-state.json` pour tracker les vidéos déjà envoyées
     - Filtre : max 3 jours, pas de shorts (#shorts dans le titre)

4. **Envoie automatique des PDFs sur Telegram** :
   - Si `veille_cyber_done: true` ET `veille_cyber_sent: false` ET fichier existe :
     - Vérifie si `/app/workspace/veille-cyber-YYYY-MM-DD_pro.pdf` existe
     - Envoie sur Telegram avec message récapitulatif
     - Marque `veille_cyber_sent: true`
   
   - Si `veille_ia_done: true` ET `veille_ia_sent: false` ET fichier existe :
     - Vérifie si `/app/workspace/veille_ia_YYYY-MM-DD_pro.pdf` existe
     - Envoie sur Telegram avec message récapitulatif
     - Marque `veille_ia_sent: true`

5. **Réinitialise l'état chaque nouveau jour** :
   - Si la date dans le state file != date actuelle
   - Réinitialise tous les flags à `false`

6. **Si aucun job à lancer** :
   - Réponds `HEARTBEAT_OK`

---

## Format du state file (`daily-jobs-state.json`)

```json
{
  "date": "2026-02-07",
  "veille_cyber_done": false,
  "veille_cyber_sent": false,
  "veille_ia_done": false,
  "veille_ia_sent": false,
  "checkin_vocal_done": false,
  "youtube_12h_done": false,
  "youtube_20h_done": false
}
```

---

## Tâches complètes (pour sessions_spawn)

### Veille Cybersécurité
```
Mission quotidienne de veille cybersécurité pour [YOUR_NAME] :

1. Recherche les dernières actualités cybersécurité et hacking (max 24h)
2. Sélectionne 5-6 articles pertinents et récents
3. Pour chaque article : résumé DÉTAILLÉ en français (6-8 phrases) incluant :
   - Contexte et enjeux
   - Détails techniques importants
   - Impact potentiel
   - Recommandations si applicable
   - Lien source, date

4. Génère un PDF PROFESSIONNEL avec template amélioré :
   - Utilise le template de /app/workspace/veille-cyber-2026-02-15_pro.html comme référence
   - Nom fichier : veille-cyber-YYYY-MM-DD_pro.pdf
   - Inclus : Page de garde, Résumé exécutif, Métriques visuelles, Points clés, Impact, Recommandations
   - Design rouge/orange pour alertes de sécurité

5. Envoie le PDF par email à [VOTRE_EMAIL] avec sujet 'Veille Cyber - [Date]'

6. NE PAS envoyer sur Telegram (l'agent principal le fera automatiquement)

Sois EXHAUSTIF, pertinent, et professionnel. Focus sur : vulnérabilités, attaques récentes, outils de sécurité, tendances hacking.
```

### Veille IA
```
Mission quotidienne de veille IA pour [YOUR_NAME] :

1. Recherche les dernières avancées et actualités IA (max 24h) concernant :
   - OpenAI (GPT, ChatGPT, nouveautés)
   - Anthropic Claude (nouvelles versions, capacités)
   - Google Gemini (mises à jour, performances)
   - DeepSeek (modèles chinois)
   - Kimi AI
   - IA chinoises (Baidu, Alibaba, etc.)
   - Mistral AI (modèles européens)
   - Autres avancées majeures (LLaMA, etc.)

2. Sélectionne 5-6 articles/annonces pertinents et récents

3. Pour chaque article : résumé DÉTAILLÉ en français (6-8 phrases) incluant :
   - Contexte et enjeux
   - Détails techniques (paramètres, capacités, benchmarks)
   - Impact sur le marché/industrie
   - Comparaison avec concurrents si pertinent
   - Lien source, date

4. Génère un PDF PROFESSIONNEL avec template amélioré :
   - Utilise le template de /app/workspace/veille_ia_2026-02-15_pro.html comme référence
   - Nom fichier : veille_ia_YYYY-MM-DD_pro.pdf
   - Inclus : Page de garde, Résumé exécutif, Métriques visuelles, Points clés, Impact stratégique
   - Design bleu/violet moderne

5. Envoie le PDF par email à [VOTRE_EMAIL] avec sujet 'Veille IA - [Date]'

6. NE PAS envoyer sur Telegram (l'agent principal le fera automatiquement)

Sois EXHAUSTIF, technique quand nécessaire, et professionnel. Focus sur : nouveaux modèles, capacités innovantes, benchmarks, compétition entre labos, tendances du marché.
```

### Check-in vocal
```
C'est l'heure du check-in quotidien avec [YOUR_NAME]. Génère un message audio chaleureux et naturel pour lui demander comment se passe sa journée. Utilise la voix Roger d'ElevenLabs (décontracté et chaleureux). Garde le message court (30-45 secondes max). Envoie l'audio sur Telegram à [VOTRE_TELEGRAM_USERNAME]. Puis reste disponible pour continuer la conversation s'il répond (audio ou texte).
```

---

**Important :** Ce système se base sur les heartbeats (toutes les ~30 minutes). Les jobs peuvent donc se déclencher avec jusqu'à 30 minutes de retard par rapport à l'heure cible.
