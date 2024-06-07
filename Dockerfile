# Etapa 1: Construir a aplicação
FROM node:18 as build

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copie os arquivos package.json e package-lock.json
COPY package*.json ./

# Instale as dependências
RUN npm install

# Copie todos os arquivos do projeto para o diretório de trabalho
COPY . .

# Execute a build da aplicação
RUN npm run dev

# Etapa 2: Servir a aplicação usando Nginx
FROM nginx:stable-alpine

# Copie os arquivos estáticos da build para o diretório padrão do Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Copie o arquivo de configuração do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponha a porta 80
EXPOSE 80

# Comando para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]
