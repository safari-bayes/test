FROM node:22-alpine

# Update system packages and npm to fix vulnerabilities
RUN apk update && apk upgrade && \
    npm install -g npm@latest && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY server.js .

EXPOSE 3000

CMD ["node", "server.js"]
