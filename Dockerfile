FROM node:18-slim AS builder

RUN adduser --disabled-password --gecos "" appuser

WORKDIR /app

COPY package*.json tsconfig.json ./

RUN npm install --omit=dev

COPY . .

RUN npx tsc

FROM node:18-slim

RUN adduser --disabled-password --gecos "" appuser

WORKDIR /app

COPY --from=builder /app/package*.json /app/
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/tsconfig.json /app/

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["node", "app.js"]