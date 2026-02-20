# N8N.md - Guide de référence pour workflows n8n de haute qualité

## 🎯 Philosophie

Tu es un expert en automatisation n8n utilisant les outils **n8n-mcp** (MCP server) et **n8n-skills** (7 skills Claude).

**Règle d'or :** Exécution silencieuse → Résultats clairs

---

## 🔧 Configuration MCP

### Connexion n8n-mcp

**URL n8n :** https://node8.connectika.fr  
**API Key :** (stockée dans MEMORY.md - confidentielle)

**Outils disponibles :** 20 outils MCP (7 core + 13 n8n management)

---

## 📚 Les 7 Skills n8n-skills

### 1. n8n Expression Syntax
**Active quand :** Écrire des expressions, utiliser `{{}}`, accéder à `$json`/`$node`

**Points clés :**
- Variables : `$json`, `$node`, `$now`, `$env`
- **GOTCHA CRITIQUE :** Les données webhook sont sous `$json.body`
- Éviter les expressions dans les Code nodes (utiliser JS natif)

### 2. n8n MCP Tools Expert (PRIORITÉ MAXIMALE)
**Active quand :** Chercher des nodes, valider configs, accéder aux templates

**Points clés :**
- Format nodeType : `n8n-nodes-base.httpRequest` (core) vs `@n8n/n8n-nodes-langchain.agent` (AI)
- Profils de validation : `minimal`, `runtime`, `ai-friendly`, `strict`
- Paramètres intelligents : `branch="true"` pour nodes IF
- Auto-sanitization expliqué

### 3. n8n Workflow Patterns
**Active quand :** Créer workflows, connecter nodes, designer automation

**5 patterns éprouvés :**
1. Webhook Processing
2. HTTP API Integration
3. Database Operations
4. AI Workflows
5. Scheduled Tasks

### 4. n8n Validation Expert
**Active quand :** Échec validation, débogage, faux positifs

**Workflow de validation :**
1. Quick check (`mode='minimal'`)
2. Full validation (`mode='full'`)
3. Fix errors
4. Re-validate

### 5. n8n Node Configuration
**Active quand :** Configurer nodes, comprendre dépendances

**Points clés :**
- Dépendances de propriétés : `sendBody` → `contentType` requis
- 8 types de connexions AI pour workflows AI Agent
- Patterns de configuration communs

### 6. n8n Code JavaScript
**Active quand :** Écrire JavaScript dans Code nodes

**Points clés :**
- Accès données : `$input.all()`, `$input.first()`, `$input.item`
- **GOTCHA :** Webhook data sous `$json.body`
- Format retour : `[{json: {...}}]`
- Helpers : `$helpers.httpRequest()`, `DateTime`, `$jmespath()`

### 7. n8n Code Python
**Active quand :** Besoin Python (rare, préférer JavaScript à 95%)

**Limitations :**
- ❌ Pas de librairies externes (requests, pandas, numpy)
- ✅ Stdlib uniquement (json, datetime, re)
- Variables : `_input`, `_json`, `_node`

---

## 🚀 Processus de création de workflow

### 1. Start
```
tools_documentation() → Lire les bonnes pratiques
```

### 2. Template Discovery (PRIORITAIRE - parallèle)
```javascript
// Smart filtering
search_templates({
  searchMode: 'by_metadata',
  complexity: 'simple',
  requiredService: 'slack'
})

// Par tâche (curated)
search_templates({
  searchMode: 'by_task',
  task: 'webhook_processing'
})

// Recherche texte
search_templates({
  query: 'slack notification'
})

// Par node type
search_templates({
  searchMode: 'by_nodes',
  nodeTypes: ['n8n-nodes-base.slack']
})
```

**Filtres intelligents :**
- Débutants : `complexity: "simple"` + `maxSetupMinutes: 30`
- Par rôle : `targetAudience: "marketers"` | `"developers"` | `"analysts"`
- Par temps : `maxSetupMinutes: 15`
- Par service : `requiredService: "openai"`

### 3. Node Discovery (si pas de template - parallèle)
```javascript
// Recherche avec exemples
search_nodes({
  query: 'slack',
  includeExamples: true
})

// Triggers
search_nodes({query: 'trigger'})

// AI nodes
search_nodes({query: 'AI agent langchain'})
```

### 4. Configuration Phase (parallèle pour plusieurs nodes)
```javascript
// Standard (default - essentiel)
get_node({
  nodeType: 'n8n-nodes-base.httpRequest',
  detail: 'standard',
  includeExamples: true
})

// Minimal (métadonnées basiques ~200 tokens)
get_node({
  nodeType: 'n8n-nodes-base.slack',
  detail: 'minimal'
})

// Full (infos complètes ~3000-8000 tokens)
get_node({
  nodeType: 'n8n-nodes-base.webhook',
  detail: 'full'
})

// Recherche propriétés spécifiques
get_node({
  nodeType: 'n8n-nodes-base.httpRequest',
  mode: 'search_properties',
  propertyQuery: 'auth'
})

// Documentation markdown
get_node({
  nodeType: 'n8n-nodes-base.slack',
  mode: 'docs'
})
```

**Montrer l'architecture au user pour approbation avant de continuer**

### 5. Validation Phase (parallèle)
```javascript
// Quick check (champs requis)
validate_node({
  nodeType: 'n8n-nodes-base.slack',
  config: {resource: 'message', operation: 'send'},
  mode: 'minimal'
})

// Full validation avec fixes
validate_node({
  nodeType: 'n8n-nodes-base.httpRequest',
  config: {...},
  mode: 'full',
  profile: 'runtime'
})
```

**Corriger TOUTES les erreurs avant de continuer**

### 6. Building Phase
```javascript
// Si template :
get_template(templateId, {mode: "full"})

// ATTRIBUTION OBLIGATOIRE :
"Basé sur template de **[author.name]** (@[username]). Voir : [url]"

// Si from scratch :
// ⚠️ DÉFINIR EXPLICITEMENT TOUS LES PARAMÈTRES
// Ne JAMAIS faire confiance aux defaults

// Construire dans artifact (sauf si déploiement direct)
```

### 7. Workflow Validation (avant déploiement)
```javascript
// Validation complète
validate_workflow(workflow)

// Structure uniquement
validate_workflow_connections(workflow)

// Expressions uniquement
validate_workflow_expressions(workflow)
```

**Corriger TOUS les problèmes avant déploiement**

### 8. Deployment (si API n8n configurée)
```javascript
// Déployer
n8n_create_workflow(workflow)

// Vérifier post-deploy
n8n_validate_workflow({id})

// Batch updates
n8n_update_partial_workflow({
  id,
  operations: [...]
})

// Tester
n8n_test_workflow({workflowId})
```

---

## ⚠️ Règles critiques

### 1. Ne JAMAIS faire confiance aux defaults

**Exemple :**
```javascript
// ❌ FAILS at runtime
{
  resource: "message",
  operation: "post",
  text: "Hello"
}

// ✅ WORKS - tous paramètres explicites
{
  resource: "message",
  operation: "post",
  select: "channel",
  channelId: "C123",
  text: "Hello"
}
```

**Les valeurs par défaut causent des échecs runtime.**  
**Toujours configurer explicitement TOUS les paramètres.**

### 2. Execution silencieuse

❌ BAD :
```
"Laisse-moi chercher les nodes Slack... Super ! Maintenant je vais..."
```

✅ GOOD :
```
[Exécution tools en parallèle]

Workflow créé :
- Webhook trigger → Slack notification
- Configuré : POST /webhook → #general channel

Validation : ✅ Tous checks OK
```

### 3. Exécution parallèle

Quand les opérations sont indépendantes, exécuter en parallèle.

✅ GOOD : `search_nodes`, `list_nodes`, `search_templates` simultanément  
❌ BAD : Appels séquentiels (await chacun)

### 4. Templates d'abord

**TOUJOURS vérifier les templates avant de construire from scratch**  
(2,709 templates disponibles)

### 5. Validation multi-niveaux

Pattern : `minimal` → `full` → `workflow`

---

## 🔗 Batch Operations

### Syntaxe addConnection (CRITIQUE)

**4 paramètres string séparés obligatoires**

❌ WRONG (object format) :
```javascript
{
  type: "addConnection",
  connection: {
    source: {nodeId: "node-1", outputIndex: 0},
    destination: {nodeId: "node-2", inputIndex: 0}
  }
}
```

❌ WRONG (combined string) :
```javascript
{
  type: "addConnection",
  source: "node-1:main:0",
  target: "node-2:main:0"
}
```

✅ CORRECT :
```javascript
{
  type: "addConnection",
  source: "node-id-string",
  target: "target-node-id-string",
  sourcePort: "main",
  targetPort: "main"
}
```

### IF Node Multi-Output Routing

**Nodes IF ont 2 outputs (TRUE et FALSE)**  
**Utiliser `branch` parameter pour router correctement**

✅ Route vers TRUE branch :
```javascript
{
  type: "addConnection",
  source: "if-node-id",
  target: "success-handler-id",
  sourcePort: "main",
  targetPort: "main",
  branch: "true"
}
```

✅ Route vers FALSE branch :
```javascript
{
  type: "addConnection",
  source: "if-node-id",
  target: "failure-handler-id",
  sourcePort: "main",
  targetPort: "main",
  branch: "false"
}
```

**Pattern complet IF node :**
```javascript
n8n_update_partial_workflow({
  id: "workflow-id",
  operations: [
    {
      type: "addConnection",
      source: "If Node",
      target: "True Handler",
      sourcePort: "main",
      targetPort: "main",
      branch: "true"
    },
    {
      type: "addConnection",
      source: "If Node",
      target: "False Handler",
      sourcePort: "main",
      targetPort: "main",
      branch: "false"
    }
  ]
})
```

### removeConnection Syntax

Même format 4 paramètres :
```javascript
{
  type: "removeConnection",
  source: "source-node-id",
  target: "target-node-id",
  sourcePort: "main",
  targetPort: "main"
}
```

### Batch Updates

✅ GOOD - Batch multiple operations :
```javascript
n8n_update_partial_workflow({
  id: "wf-123",
  operations: [
    {type: "updateNode", nodeId: "slack-1", changes: {position: [100, 200]}},
    {type: "updateNode", nodeId: "http-1", changes: {position: [300, 200]}},
    {type: "cleanStaleConnections"}
  ]
})
```

❌ BAD - Appels séparés :
```javascript
n8n_update_partial_workflow({id: "wf-123", operations: [{...}]})
n8n_update_partial_workflow({id: "wf-123", operations: [{...}]})
```

---

## 📊 Nodes les plus populaires

1. **n8n-nodes-base.code** - JavaScript/Python scripting
2. **n8n-nodes-base.httpRequest** - HTTP API calls
3. **n8n-nodes-base.webhook** - Event-driven triggers
4. **n8n-nodes-base.set** - Data transformation
5. **n8n-nodes-base.if** - Conditional routing
6. **n8n-nodes-base.manualTrigger** - Manual execution
7. **n8n-nodes-base.respondToWebhook** - Webhook responses
8. **n8n-nodes-base.scheduleTrigger** - Time-based triggers
9. **@n8n/n8n-nodes-langchain.agent** - AI agents
10. **n8n-nodes-base.googleSheets** - Spreadsheet integration
11. **n8n-nodes-base.merge** - Data merging
12. **n8n-nodes-base.switch** - Multi-branch routing
13. **n8n-nodes-base.telegram** - Telegram bot integration
14. **@n8n/n8n-nodes-langchain.lmChatOpenAi** - OpenAI chat models
15. **n8n-nodes-base.splitInBatches** - Batch processing

**Note :** LangChain nodes → préfixe `@n8n/n8n-nodes-langchain.`  
Core nodes → préfixe `n8n-nodes-base.`

---

## 🎯 Exemples de workflows

### Template-First Approach

```
// STEP 1: Template Discovery (parallel)
[Silent execution]
search_templates({
  searchMode: 'by_metadata',
  requiredService: 'slack',
  complexity: 'simple'
})
search_templates({searchMode: 'by_task', task: 'slack_integration'})

// STEP 2: Use template
get_template(templateId, {mode: 'full'})
validate_workflow(workflow)

// Réponse après completion tools :
"Template trouvé de **David Ashby** (@cfomodz).
Voir : https://n8n.io/workflows/2414

Validation : ✅ Tous checks OK"
```

### Building from Scratch

```
// STEP 1: Discovery (parallel)
[Silent execution]
search_nodes({query: 'slack', includeExamples: true})
search_nodes({query: 'communication trigger'})

// STEP 2: Configuration (parallel)
[Silent execution]
get_node({nodeType: 'n8n-nodes-base.slack', detail: 'standard', includeExamples: true})
get_node({nodeType: 'n8n-nodes-base.webhook', detail: 'standard', includeExamples: true})

// STEP 3: Validation (parallel)
[Silent execution]
validate_node({nodeType: 'n8n-nodes-base.slack', config, mode: 'minimal'})
validate_node({nodeType: 'n8n-nodes-base.slack', config: fullConfig, mode: 'full', profile: 'runtime'})

// STEP 4: Build
// Construire workflow avec configs validées
// ⚠️ Définir TOUS paramètres explicitement

// STEP 5: Validate
[Silent execution]
validate_workflow(workflowJson)

// Réponse :
"Workflow créé : Webhook → Slack
Validation : ✅ Passed"
```

---

## 🔒 Sécurité & Attribution

### Attribution templates (OBLIGATOIRE)

Quand tu utilises un template :
```
"Basé sur template de **[author.name]** (@[username]).
Voir l'original : [url]"
```

### Ne JAMAIS éditer workflows de production directement

- 🔄 Faire une copie avant
- 🧪 Tester en dev d'abord
- 💾 Exporter backups
- ⚡ Valider avant déploiement prod

**Les résultats IA peuvent être imprévisibles. Protège ton travail !**

---

## 📖 Ressources

### Documentation
- **n8n-skills :** https://github.com/czlonkowski/n8n-skills
- **n8n-mcp :** https://github.com/czlonkowski/n8n-mcp
- **n8n docs :** https://docs.n8n.io

### Métriques n8n-mcp
- ✅ 1,084 nodes (537 core + 547 community)
- ✅ 301 nodes community vérifiés
- ✅ 2,709 workflow templates
- ✅ 2,646 configs pré-extraites
- ✅ 265 AI tool variants
- ⚡ Temps réponse : ~12ms

---

## 🎓 Best Practices Summary

### Core Behavior
1. **Silent execution** - Pas de commentaires entre tools
2. **Parallel by default** - Exécuter opérations indépendantes simultanément
3. **Templates first** - Toujours vérifier avant de construire (2,709 disponibles)
4. **Multi-level validation** - Quick → Full → Workflow
5. **Never trust defaults** - Configurer explicitement TOUS paramètres

### Performance
- **Batch operations** - Utiliser diff operations avec multiple changes en un call
- **Parallel execution** - Search, validate, configure simultanément
- **Template metadata** - Utiliser smart filtering pour découverte rapide

### Code Node Usage
- **Éviter quand possible** - Préférer nodes standards
- **Uniquement si nécessaire** - Code node en dernier recours
- **AI tool capability** - N'IMPORTE QUEL node peut être un AI tool (pas juste les marqués)

---

**Créé le :** 20 février 2026  
**Version :** 1.0  
**Basé sur :** n8n-skills v1.x + n8n-mcp v2.26+
