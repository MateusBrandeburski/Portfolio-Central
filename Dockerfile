# Use a imagem oficial do Nginx como base
FROM nginx:latest

WORKDIR /Meu-Portf-lio

# Remova o arquivo padrão do Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copie o arquivo index.html para o diretório padrão do Nginx
COPY . /usr/share/nginx/html/
