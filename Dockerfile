### STAGE 1: Build ###

# We label our stage as 'builder'
FROM nodejs-8-rhel7 as builder

COPY package*.json ./

RUN npm set progress=false && npm config set depth 0 && npm cache clean --force

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
RUN npm i && mkdir /ng-app && cp -R ./node_modules ./ng-app

WORKDIR /ng-app

COPY . .

## Build the angular app in production mode and store the artifacts in dist folder
#RUN npm run build:static
RUN npm run build:dynamic


### STAGE 2: Setup ###

FROM nodejs-8-rhel7

## Install http-server
#RUN npm install http-server -g

## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /ng-app/dist /dist

#WORKDIR /dist/browser
#CMD ["http-server"]
CMD ["node", "/dist/server"]
