# Część nieobowiązkowa
W części nieobowiązkowej zostało wykonane polecenie 2.


### Test podatności na zagrożenia
Testy podatności na zagrożenia zostały wykonane następującym poleceniem:

    docker scout cves

Rezultat polecenia dla obrazu z części obowiązkowej był następujący:

![Pierwszy test](Obrazy/scout_przed.png)

Wykazał on jedno zagrożenie typu HIGH. Zostało ono wyeliminowane poprzez modyfikację pliku Dockerfile. Zagrożenie wynikało z zastosowania złej wersji obrazu node-alpine. Poprawiony plik Dockerfile, wraz z komentarzami, gdzie dokonano zmian:

```
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
```

Ponownie wykonano to samo polecenie do testowania i uzyskano taki wynik:

![Drugi test](Obrazy/scout_po.png)


### Budowanie obrazu
Aby zbudować obraz kontenera zgodny z OCI zawierający aplikację opracowaną w części obowiązkowej zadania, który będzie przeznaczony na platformy sprzętowe: linux/arm64 oraz linux/amd64, zastosowano następujące polecenia:

    docker buildx create --driver docker-container --name mybuilder --use --bootstrap

    docker buildx build --platform linux/amd64,linux/arm64 -t lesze/zadanie1_2:latest --push --cache-to type=registry,ref=lesze/zadanie1_2_cache,mode=max --cache-from type=registry,ref=lesze/zadanie1_2_cache .

Pierwsze polecenie tworzy własny builder buildx, a drugie buduje i publikuje obraz kontenera stosując buildx, zgodnie z założeniami zadania.

Potwierdzenie wykorzystania danych cache w procesie budowania obrazu:
![Dane cache](Obrazy/cache.png)


Potwierdzenie deklaracji dla platform sprzętowych linux/arm64 oraz linux/amd64:
![Manifest](Obrazy/inspect.png)


## Linki do dockerhub:
https://hub.docker.com/r/lesze/zadanie1_2

https://hub.docker.com/r/lesze/zadanie1_2_cache