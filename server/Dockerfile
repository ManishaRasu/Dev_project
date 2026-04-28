FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache curl

COPY package*.json ./

RUN npm install && npm cache clean --force

COPY . .

RUN mkdir -p uploads

EXPOSE 5000

ENV PORT=5000
ENV NODE_ENV=production

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

CMD ["node", "index.js"]