#Poprzednio node:20-alpine
FROM node:23-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

#Poprzednio node:20-alpine
FROM node:23-alpine

LABEL org.opencontainers.image.authors="Szymon Oleszek"

WORKDIR /app

RUN apk add --update curl

COPY --from=builder /app/index.html /app/server.js ./
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=1s \
    CMD curl -f http://localhost:3000/ || exit 1

CMD ["node", "server.js"]