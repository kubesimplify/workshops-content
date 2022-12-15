# from docker getting started: https://docs.docker.com/get-started/02_our_app/
# specifies the base (parent) image. Required for every Dockerfile.
FROM node:12-alpine

# runs a command and creates an image layer. Used to install packages into containers
RUN apk add --no-cache python2 g++ make

# sets the working directory for the instructions that follow.
WORKDIR /app

# copies files and directories to the container
COPY . .

# runs a command and creates an image layer. Used to install packages into containers
RUN yarn install --production --ignore-engines

# provides a command and arguments for an executing container. Parameters can be overridden. There can be ONLY one CMD.
CMD ["node", "src/index.js"]

# exposes a port
EXPOSE 3000


#############################################################################################
############################## OTHER AVAILABLE ##############################################
#############################################################################################
# LABEL - provides metadata. Good place to include maintainer info.
# ENV - sets a persistent environment variable
# COPY - copies files and directories to the container
# ADD - copies files and directories to the container. Can unpack local .tar files
# ARG - defines a variable to pass to Docker at build-time.
# ENTRYPOINT - provides command and arguments for an executing container. Arguments persist.
# VOLUME - creates a directory mount point to access and store persistent data.
