FROM node:22-slim

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts

COPY src ./src
COPY sql ./sql

ENV PORT=3000
EXPOSE 3000

VOLUME /app/data

CMD ["node", "src/app.js"]
