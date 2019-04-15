FROM node:8
WORKDIR /opt/app
COPY package.json ./
RUN npm cache clean --force && npm install
COPY . /opt/app
ENV PORT 3000
EXPOSE 3000
CMD node index.js
