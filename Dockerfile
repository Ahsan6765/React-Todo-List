#================================
# Stage 1: Build
FROM node:18-alpine AS build
#===============================
# set working directory
WORKDIR /app

# install dependencies (only package*.json first to leverage docker cache)

COPY package*.json ./
#if you use yarn: COPY yarn.lock ./
RUN npm install

#Copy rest of source code
COPY . .

# Build the app (this will procude the "build" directory)
RUN npm run build

# =================================
# Stage 2: serve the build files
# =================================
FROM nginx:stable-alpine

#Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy build files from build stage 1
COPY --from=build /app/build/ usr/share/nginx/html

# Optionally, copy a custom nginx config if you have one
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port here
EXPOSE 80

# start nginx
CMD ["nginx", "-g", "daemon off;"]