#!/bin/bash
# Script d'auto-synchronisation de la configuration OpenClaw vers GitHub
# À lancer après chaque modification importante

set -e

WORKSPACE="/app/workspace"
REPO_DIR="/tmp/openclaw-repo"
GH_TOKEN="${GH_TOKEN}"

echo "🔄 Synchronisation de la configuration OpenClaw..."

# Fonction de nettoyage des secrets
clean_file() {
    local source="$1"
    local dest="$2"
    
    # Copie et nettoyage basique
    sed \
        -e 's/personifly75@gmail\.com/[VOTRE_EMAIL]/g' \
        -e 's/8481398125/[VOTRE_TELEGRAM_ID]/g' \
        -e 's/@LabsMates/[VOTRE_TELEGRAM_USERNAME]/g' \
        -e 's/sk_[a-zA-Z0-9_-]*/[ELEVENLABS_API_KEY]/g' \
        -e 's/ghp_[a-zA-Z0-9]*/[GITHUB_TOKEN]/g' \
        -e 's/github_pat_[a-zA-Z0-9_]*/[GITHUB_TOKEN]/g' \
        -e 's/Paris/[VOTRE_VILLE]/g' \
        -e 's/Wilfrid/[YOUR_NAME]/g' \
        -e 's/Axel/[ASSISTANT_NAME]/g' \
        -e 's/openclaw@54\.37\.157\.8/user@10.10.10.1/g' \
        -e 's/54\.37\.157\.8/10.10.10.1/g' \
        -e 's/vps02/[VPS_HOSTNAME]/g' \
        -e 's/openclaw@10\.10\.10\.1/user@10.10.10.1/g' \
        -e 's/openclaw@[0-9.]*//g' \
        -e 's/\/home\/openclaw/[VPS_HOME]/g' \
        -e 's|node8\.connectika\.fr|[N8N_URL]|g' \
        -e 's|https://[a-zA-Z0-9.-]*connectika\.fr|https://[N8N_URL]|g' \
        -e 's/Bearer eyJ[a-zA-Z0-9_.-]*/Bearer [MCP_JWT_TOKEN]/g' \
        -e 's/eyJ[a-zA-Z0-9_.-]*\.[a-zA-Z0-9_.-]*\.[a-zA-Z0-9_.-]*/[JWT_TOKEN]/g' \
        -e 's/nvapi-[a-zA-Z0-9_-]*/[KIMI_API_KEY]/g' \
        "$source" > "$dest"
}

# Synchronisation des fichiers
echo "📝 Copie des fichiers de configuration..."

# Fichiers qui peuvent être copiés directement (pas de secrets)
cp "$WORKSPACE/AGENTS.md" "$REPO_DIR/"
cp "$WORKSPACE/SOUL.md" "$REPO_DIR/"

# Fichiers nécessitant un nettoyage
clean_file "$WORKSPACE/TOOLS.md" "$REPO_DIR/TOOLS.md"
clean_file "$WORKSPACE/USER.md" "$REPO_DIR/USER.md"
clean_file "$WORKSPACE/IDENTITY.md" "$REPO_DIR/IDENTITY.md"
clean_file "$WORKSPACE/HEARTBEAT.md" "$REPO_DIR/HEARTBEAT.md"
clean_file "$WORKSPACE/MEMORY.md" "$REPO_DIR/MEMORY.md"

# Git operations
cd "$REPO_DIR"

# Configure git si nécessaire
git config user.name "OpenClaw Bot" 2>/dev/null || true
git config user.email "bot@openclaw.local" 2>/dev/null || true

# Check for changes
if git diff --quiet && git diff --cached --quiet; then
    echo "✅ Aucune modification à synchroniser."
    exit 0
fi

# Commit et push
echo "📤 Envoi des modifications..."
git add .
git commit -m "🤖 Auto-sync: $(date '+%Y-%m-%d %H:%M')"

# Push avec le token
if [ -n "$GH_TOKEN" ]; then
    git remote set-url origin "https://${GH_TOKEN}@github.com/Labsmates/OpenClaw.git" 2>/dev/null || \
    git remote add origin "https://${GH_TOKEN}@github.com/Labsmates/OpenClaw.git"
    git push -u origin master --force
    echo "✅ Configuration synchronisée sur GitHub!"
else
    echo "❌ GH_TOKEN non défini. Utilisation du token configuré..."
    git push -u origin master --force
fi

echo "🎉 Synchronisation terminée!"
