# Use a imagem oficial do Nginx como base
FROM nginx:stable-alpine3.17-slim

WORKDIR /Meu-Portf-lio
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/nginx.conf
RUN rm -rf /usr/share/nginx/html/*

COPY . /usr/share/nginx/html/


