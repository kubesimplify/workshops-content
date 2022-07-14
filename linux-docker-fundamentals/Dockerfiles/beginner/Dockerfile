# recommended to always use the tag, even when using the official images
FROM nginx:latest

# change working directory to where index.html normally lives
WORKDIR /usr/share/nginx/html

# copies files and directories to the container
COPY index.html index.html

# I don't have to specify EXPOSE or CMD because they're in my FROM