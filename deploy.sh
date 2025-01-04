#!/bin/bash

# Configurações do servidor remoto
REMOTE_USER="mateusbrandeburski"
REMOTE_HOST="192.168.0.10"
REMOTE_PORT="52222"
REMOTE_DIR="/home/mateusbrandeburski/portfolio-central"
REMOTE_DIR_BACKUP="/home/mateusbrandeburski/backups/portflio"

# Perguntar se o usuário quer prosseguir
read -p "Você tem certeza que deseja enviar os arquivos para o servidor? (S/n) [N]: " CONFIRMATION </dev/tty
CONFIRMATION=${CONFIRMATION:-N} # Define "N" como padrão

if [[ "$CONFIRMATION" =~ ^[Ss]$ ]]; then

  REMOTE_COMMANDS1="
    echo 'Salvando backup';
    rm -rf $REMOTE_DIR_BACKUP && mkdir -p $REMOTE_DIR_BACKUP && cp -r $REMOTE_DIR $REMOTE_DIR_BACKUP/*;

    sleep 3
    echo 'Apagando arquios do servidor!'
    rm -rf $REMOTE_DIR/*;

    sleep 3
    echo 'Backup feito!';
  "

  if [ $? -eq 0 ]; then
    echo "----------------XXXX---------------"
    echo "Executando primeiro case de comandos no Servidor-Thor!"
    ssh -p $REMOTE_PORT "$REMOTE_USER@$REMOTE_HOST" "$REMOTE_COMMANDS"

  else
    echo "Erro ao enviar os arquivos para o servidor remoto."
  fi

  echo "Enviando arquivos para o servidor remoto..."
  rsync -avz -e "ssh -p $REMOTE_PORT" --exclude ".git" ./ "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
  sleep 1

  REMOTE_COMMANDS2="
    echo 'Construindo nova imagem...';
    cd $REMOTE_DIR && docker build -t portfolio-central:latest .;

    echo 'Executando novo container...';
    docker run -d -p 8080:80 --restart=always --name portfolio-central portfolio-central:latest;

    echo 'Removendo imagens e containers desnecessários...';
    docker rmi \$(docker images -f \"dangling=true\" -q) || echo 'Nenhuma imagem pendente para remover.';
    docker rm \$(docker ps -aq --filter \"status=exited\") || echo 'Nenhum container parado para remover.';

    echo 'Deploy concluído com sucesso!';
  "

  if [ $? -eq 0 ]; then
    echo "----------------XXXX---------------"
    echo "Executando segundo case de comandos no Servidor-Thor!"
    sleep 3
    ssh -p $REMOTE_PORT "$REMOTE_USER@$REMOTE_HOST" "$REMOTE_COMMANDS"

  else
    echo "Erro ao enviar os arquivos para o servidor remoto."
  fi



else
  echo "Deploy cancelado pelo usuário."
fi


