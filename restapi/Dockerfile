FROM node:10-alpine
RUN mkdir -p /opt/restapi && chown -R node:node /opt/restapi
WORKDIR /opt/restapi
COPY index.js /opt/restapi
COPY package.json /opt/restapi
RUN npm install
EXPOSE 8080
CMD [ "node", "index.js" ]
