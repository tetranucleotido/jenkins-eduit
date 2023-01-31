FROM node:16-alpine
WORKDIR /app
LABEL project="docker-bootcamp"
LABEL owner="grupo2"
COPY ./ /app/
RUN npm install
EXPOSE 4000
CMD ["npm","start"]