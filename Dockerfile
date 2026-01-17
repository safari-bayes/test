FROM node:22-alpine

# Update system packages and remove npm (not needed for runtime) to fix vulnerabilities
RUN apk update && apk upgrade && \
    npm uninstall -g npm && \
    rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/share/man/man1/npm* && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY server.js .

EXPOSE 3000

CMD ["node", "server.js"]
