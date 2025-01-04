#!/bin/bash
# Defina o caminho do repositório remoto
REMOTE_USER="mateusbrandeburski"
REMOTE_HOST="192.168.0.10"
REMOTE_PORT=""
REMOTE_DIR=""

# Sincronize os arquivos usando rsync
rsync -avz -e "ssh -p $REMOTE_PORT" --exclude ".git" ./ "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

echo "Arquivos enviados para o servidor com sucesso!"