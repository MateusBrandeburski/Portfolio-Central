#!/bin/bash

# Configurações do servidor remoto
REMOTE_USER="mateusbrandeburski"
REMOTE_HOST="192.168.0.10"
REMOTE_PORT="52222"
REMOTE_DIR="/home/mateusbrandeburski/portfolio-central"

# Perguntar se o usuário quer prosseguir
read -p "Você tem certeza que deseja enviar os arquivos para o servidor? (S/n) [N]: " CONFIRMATION
CONFIRMATION=${CONFIRMATION:-N} # Define "N" como padrão

if [[ "$CONFIRMATION" =~ ^[Ss]$ ]]; then
  echo "Iniciando processo de deploy..."

  # Comandos para executar no servidor após o deploy
#   REMOTE_COMMANDS="
#     echo 'Parando e removendo container antigo...';
#     docker stop portfolio-central || echo 'Container portfolio-central não estava em execução.';
#     docker rm portfolio-central || echo 'Container portfolio-central já foi removido.';
    
#     echo 'Construindo nova imagem...';
#     cd $REMOTE_DIR && docker build -t portfolio-central:latest .;

#     echo 'Executando novo container...';
#     docker run -d -p 8080:80 --restart=always --name portfolio-central portfolio-central:latest;

#     echo 'Removendo imagens e containers desnecessários...';
#     docker rmi \$(docker images -f \"dangling=true\" -q) || echo 'Nenhuma imagem pendente para remover.';
#     docker rm \$(docker ps -aq --filter \"status=exited\") || echo 'Nenhum container parado para remover.';

#     echo 'Deploy concluído com sucesso!';
#   "

  # Sincroniza os arquivos com o servidor remoto
  echo "Enviando arquivos para o servidor remoto..."
  rsync -avz -e "ssh -p $REMOTE_PORT" --exclude ".git" ./ "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

  if [ $? -eq 0 ]; then
    echo "Arquivos enviados com sucesso!"
    
    # Executa os comandos no servidor remoto
    echo "Executando comandos no servidor remoto..."
    ssh -p $REMOTE_PORT "$REMOTE_USER@$REMOTE_HOST" "$REMOTE_COMMANDS"
  else
    echo "Erro ao enviar os arquivos para o servidor remoto."
  fi
else
  echo "Deploy cancelado pelo usuário."
fi


