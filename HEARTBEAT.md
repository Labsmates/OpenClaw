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

2. **Récupère la date et l'heure** (timezone configurée) :
   ```bash
   TZ=YOUR_TIMEZONE date +"%Y-%m-%d %H:%M"
   ```

3. **Vérifie si les jobs doivent être lancés** :

   - **Veille Cybersécurité (9h00-9h30)** :
     - Si l'heure est entre 09:00 et 09:30
     - ET que `veille_cyber_done` n'a pas déjà été lancé aujourd'hui
     - ALORS lance `sessions_spawn` avec la tâche de veille cyber
     - Marque comme fait dans le state file

   - **Veille IA (10h00-10h30)** :
     - Si l'heure est entre 10:00 et 10:30
     - ET que `veille_ia_done` n'a pas déjà été lancé aujourd'hui
     - ALORS lance `sessions_spawn` avec la tâche de veille IA
     - Marque comme fait dans le state file

   - **Check-in vocal (12h00-12h30)** :
     - Si l'heure est entre 12:00 et 12:30
     - ET que `checkin_vocal_done` n'a pas déjà été lancé aujourd'hui
     - ALORS lance `sessions_spawn` avec la tâche de check-in vocal
     - Marque comme fait dans le state file

   - **Surveillance YouTube (12h00-12h30 et 20h00-20h30)** :
     - Vérifie les nouvelles vidéos des chaînes suivies
     - Filtre les shorts (titre contient #shorts)
     - Envoie chaque vidéo nouvelle
     - Marque les vidéos comme envoyées

4. **Envoie automatique des PDFs** :
   - Après génération des veilles, envoie les PDFs générés
   - Marque comme envoyés dans le state file

5. **Réinitialise l'état chaque nouveau jour** :
   - Si la date dans le state file != date actuelle
   - Réinitialise tous les flags à `false`

6. **Si aucun job à lancer** :
   - Réponds `HEARTBEAT_OK`

---

## Format du state file (`daily-jobs-state.json`)

```json
{
  "date": "2026-02-19",
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
Mission quotidienne de veille cybersécurité : recherche les dernières actualités (max 24h), sélectionne 5-6 articles pertinents, génère des résumés détaillés, crée un PDF professionnel, et envoie par email.

### Veille IA
Mission quotidienne de veille IA : recherche les avancées récentes (OpenAI, Anthropic, Google Gemini, DeepSeek, etc.), sélectionne 5-6 articles/annonces, génère des résumés techniques détaillés, crée un PDF professionnel, et envoie par email.

### Check-in vocal
Check-in quotidien avec voix naturelle pour demander comment se passe la journée.

---

**Important :** Ce système se base sur les heartbeats (toutes les ~30 minutes). Les jobs peuvent donc se déclencher avec jusqu'à 30 minutes de retard par rapport à l'heure cible.
