#!/bin/bash

# Configurações do servidor remoto
REMOTE_USER="mateusbrandeburski"
REMOTE_HOST="192.168.0.10"
REMOTE_PORT="52222"
REMOTE_DIR="/home/mateusbrandeburski/portfolio-central"
REMOTE_DIR_BACKUP="/home/mateusbrandeburski/backups/portfolio"

# Perguntar se o usuário quer prosseguir
read -p "Você tem certeza que deseja enviar os arquivos para o servidor? (S/n) [N]: " CONFIRMATION </dev/tty
CONFIRMATION=${CONFIRMATION:-N} # Define "N" como padrão

if [[ "$CONFIRMATION" =~ ^[Ss]$ ]]; then
  echo "----------------XXXX---------------"
  echo "Executando primeiro case de comandos no Servidor-Thor!"

  ssh -p $REMOTE_PORT "$REMOTE_USER@$REMOTE_HOST" bash << EOF
    echo 'Salvando backup...';
    rm -rf $REMOTE_DIR_BACKUP && mkdir -p $REMOTE_DIR_BACKUP && cp -r $REMOTE_DIR/* $REMOTE_DIR_BACKUP/;
    echo 'Apagando arquivos do diretório principal...';
    rm -rf $REMOTE_DIR/*;
    echo 'Backup e limpeza concluídos!';
EOF

  if [ $? -eq 0 ]; then
    echo "Backup e limpeza concluídos com sucesso no servidor remoto."
  else
    echo "Erro ao executar o primeiro bloco de comandos no servidor remoto."
    exit 1
  fi

  echo "Enviando arquivos para o servidor remoto..."
  rsync -avz -e "ssh -p $REMOTE_PORT" --exclude ".git" ./ "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"

  if [ $? -eq 0 ]; then
    echo "Arquivos enviados com sucesso!"
  else
    echo "Erro ao enviar arquivos para o servidor remoto."
    exit 1
  fi

  echo "----------------XXXX---------------"
  echo "Executando segundo case de comandos no Servidor-Thor!"

  ssh -p $REMOTE_PORT "$REMOTE_USER@$REMOTE_HOST" bash << EOF
    echo 'Construindo nova imagem Docker...';
    cd $REMOTE_DIR;

    echo 'Parando e removendo container existente...';

    sudo docker stop portfolio-central;
    sudo docker rm portfolio-central;

    docker build -t portfolio-central:latest .;

    echo 'Executando novo container...';
    docker run -d -p 8080:80 --restart=always --name portfolio-central portfolio-central:latest;

    echo 'Limpando imagens e containers desnecessários...';
    docker rmi \$(docker images -f "dangling=true" -q) || echo 'Nenhuma imagem pendente para remover.';
    docker rm \$(docker ps -aq --filter "status=exited") || echo 'Nenhum container parado para remover.';

    echo 'Deploy concluído com sucesso!';
EOF

  if [ $? -eq 0 ]; then
    sleep 4
    echo "Deploy concluído com sucesso no servidor remoto!"
  else
    echo "Erro ao executar o segundo bloco de comandos no servidor remoto."
    exit 1
  fi

else
  echo "Deploy cancelado pelo usuário."
fi
