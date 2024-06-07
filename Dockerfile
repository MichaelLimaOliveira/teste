# Estágio 1: Construção da aplicação
FROM node:18-alpine AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos de configuração e de dependências
COPY package*.json ./

# Instala as dependências do projeto
RUN npm install

# Copia todo o código-fonte para o diretório de trabalho do contêiner
COPY . .

# Compila a aplicação
RUN npm run build

# Estágio 2: Configuração do servidor web
FROM nginx:stable-alpine

# Remove o arquivo padrão de configuração do nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia o arquivo de configuração do nginx para o contêiner
COPY nginx.conf /etc/nginx/conf.d

# Copia os arquivos compilados da aplicação para o diretório de servimento do nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Expõe a porta 80 para acesso à aplicação
EXPOSE 80

# Inicia o nginx
CMD ["nginx", "-g", "daemon off;"]
