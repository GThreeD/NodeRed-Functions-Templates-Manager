FROM node:20-alpine AS build

WORKDIR /app

COPY src/package.json src/package-lock.json ./

RUN npm ci --only=production

COPY src/ .

RUN npm link

FROM node:20-alpine

WORKDIR /app

COPY --from=build /app /app

ENV NODE_ENV=production

RUN npm link
CMD ["node", "functions-templates-watch"]
