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


  echo "Enviando arquivos para o servidor remoto..."
  rsync -avz -e "ssh -p $REMOTE_PORT" --exclude ".git" ./ "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
  sleep 1


  REMOTE_COMMANDS="

    echo 'Salvando backup';
    rm -rf $REMOTE_DIR_BACKUP && mkdir -p $REMOTE_DIR_BACKUP && cp -r $REMOTE_DIR $REMOTE_DIR_BACKUP/*;
    sleep 2
    echo 'Apagando arquios do servidor'
    rm -rf $REMOTE_DIR/*;

    cd $REMOTE_DIR;

    echo 'Parando e removendo container antigo...';
    docker stop portfolio-central || echo 'Container portfolio-central não estava em execução.';
    docker rm portfolio-central || echo 'Container portfolio-central já foi removido.';

    sleep 3

    echo 'Construindo nova imagem...';
    cd $REMOTE_DIR && docker build -t portfolio-central:latest .;

    sleep 3



    echo 'Executando novo container...';
    docker run -d -p 8080:80 --restart=always --name portfolio-central portfolio-central:latest;

    sleep 3

    echo 'Removendo imagens e containers desnecessários...';
    docker rmi \$(docker images -f \"dangling=true\" -q) || echo 'Nenhuma imagem pendente para remover.';
    docker rm \$(docker ps -aq --filter \"status=exited\") || echo 'Nenhum container parado para remover.';

    sleep 3

    echo 'Deploy concluído com sucesso!';
  "

  if [ $? -eq 0 ]; then
    echo "Arquivos enviados com sucesso!"
    echo "----------------XXXX---------------"
    echo "Executando comandos no servidor remoto..."
    ssh -p $REMOTE_PORT "$REMOTE_USER@$REMOTE_HOST" "$REMOTE_COMMANDS"

  else
    echo "Erro ao enviar os arquivos para o servidor remoto."
  fi
else
  echo "Deploy cancelado pelo usuário."
fi


